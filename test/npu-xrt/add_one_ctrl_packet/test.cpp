//===- test.cpp -------------------------------------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Copyright (C) 2024, Advanced Micro Devices, Inc.
//
//===----------------------------------------------------------------------===//

#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "cxxopts.hpp"
#include "test_utils.h"
#include "xrt/xrt_bo.h"
#include "xrt/xrt_device.h"
#include "xrt/xrt_kernel.h"

constexpr int OUT_SIZE = 64;

int main(int argc, const char *argv[]) {
  // Program arguments parsing
  cxxopts::Options options("add_one_ctrl_packet");
  test_utils::add_default_options(options);

  cxxopts::ParseResult vm;
  test_utils::parse_options(argc, argv, options, vm);

  std::vector<uint32_t> instr_v =
      test_utils::load_instr_binary(vm["instr"].as<std::string>());

  int verbosity = vm["verbosity"].as<int>();
  if (verbosity >= 1)
    std::cout << "Sequence instr count: " << instr_v.size() << "\n";

  // Start the XRT test code
  // Get a device handle
  unsigned int device_index = 0;
  auto device = xrt::device(device_index);

  // Load the xclbin
  if (verbosity >= 1)
    std::cout << "Loading xclbin: " << vm["xclbin"].as<std::string>() << "\n";
  auto xclbin = xrt::xclbin(vm["xclbin"].as<std::string>());

  if (verbosity >= 1)
    std::cout << "Kernel opcode: " << vm["kernel"].as<std::string>() << "\n";
  std::string Node = vm["kernel"].as<std::string>();

  // Get the kernel from the xclbin
  auto xkernels = xclbin.get_kernels();
  auto xkernel = *std::find_if(xkernels.begin(), xkernels.end(),
                               [Node](xrt::xclbin::kernel &k) {
                                 auto name = k.get_name();
                                 std::cout << "Name: " << name << std::endl;
                                 return name.rfind(Node, 0) == 0;
                               });
  auto kernelName = xkernel.get_name();

  if (verbosity >= 1)
    std::cout << "Registering xclbin: " << vm["xclbin"].as<std::string>()
              << "\n";

  device.register_xclbin(xclbin);

  // get a hardware context
  if (verbosity >= 1)
    std::cout << "Getting hardware context.\n";
  xrt::hw_context context(device, xclbin.get_uuid());

  // get a kernel handle
  if (verbosity >= 1)
    std::cout << "Getting handle to kernel:" << kernelName << "\n";
  auto kernel = xrt::kernel(context, kernelName);

  auto bo_instr = xrt::bo(device, instr_v.size() * sizeof(int),
                          XCL_BO_FLAGS_CACHEABLE, kernel.group_id(1));
  auto bo_ctrlOut = xrt::bo(device, OUT_SIZE * sizeof(int32_t),
                            XRT_BO_FLAGS_HOST_ONLY, kernel.group_id(3));
  auto bo_ctrlIn = xrt::bo(device, OUT_SIZE * sizeof(int32_t),
                           XRT_BO_FLAGS_HOST_ONLY, kernel.group_id(4));
  auto bo_out = xrt::bo(device, OUT_SIZE * sizeof(int32_t),
                        XRT_BO_FLAGS_HOST_ONLY, kernel.group_id(5));

  if (verbosity >= 1)
    std::cout << "Writing data into buffer objects.\n";

  uint32_t beats = 1 - 1;
  uint32_t operation = 0;
  uint32_t stream_id = 0;
  auto parity = [](uint32_t n) {
    uint32_t p = 0;
    while (n) {
      p += n & 1;
      n >>= 1;
    }
    return (p % 2) == 0;
  };

  // Lock0_value
  uint32_t address = 0x0001F000;
  uint32_t header0 = stream_id << 24 | operation << 22 | beats << 20 | address;
  header0 |= (0x1 & parity(header0)) << 31;

  // Lock2_value
  address += 0x20;
  uint32_t header1 = stream_id << 24 | operation << 22 | beats << 20 | address;
  header1 |= (0x1 & parity(header1)) << 31;

  // set lock values to 2
  uint32_t data = 2;
  std::vector<uint32_t> ctrlPackets = {
      header0,
      data,
      header1,
      data,
  };
  // Read 8 32-bit values from "other_buffer" at address 0x440 using two
  // control packets
  for (int i = 0; i < 2; i++) {
    address = 0x440 + i * sizeof(uint32_t) * 4;
    operation = 0x1;
    stream_id = 0x2;
    beats = 3;
    uint32_t header2 =
        stream_id << 24 | operation << 22 | beats << 20 | address;
    header2 |= (0x1 & parity(header2)) << 31;
    ctrlPackets.push_back(header2);
  }
  void *bufctrlIn = bo_ctrlIn.map<void *>();
  memcpy(bufctrlIn, ctrlPackets.data(), ctrlPackets.size() * sizeof(int));

  void *bufInstr = bo_instr.map<void *>();
  memcpy(bufInstr, instr_v.data(), instr_v.size() * sizeof(int));

  bo_instr.sync(XCL_BO_SYNC_BO_TO_DEVICE);
  bo_ctrlIn.sync(XCL_BO_SYNC_BO_TO_DEVICE);

  if (verbosity >= 1)
    std::cout << "Running Kernel.\n";
  unsigned int opcode = 3;
  auto run =
      kernel(opcode, bo_instr, instr_v.size(), bo_ctrlOut, bo_ctrlIn, bo_out);

  ert_cmd_state r = run.wait();
  if (r != ERT_CMD_STATE_COMPLETED) {
    std::cout << "Kernel did not complete. Returned status: " << r << "\n";
    return 1;
  }

  bo_out.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
  bo_ctrlOut.sync(XCL_BO_SYNC_BO_FROM_DEVICE);

  uint32_t *bufOut = bo_out.map<uint32_t *>();
  uint32_t *ctrlOut = bo_ctrlOut.map<uint32_t *>();

  int errors = 0;

  for (uint32_t i = 0; i < 8; i++) {
    uint32_t ref = 7 + i;
    if (*(bufOut + i) != ref) {
      std::cout << "Error in dma output " << *(bufOut + i) << " != " << ref
                << std::endl;
      errors++;
    } else {
      std::cout << "Correct dma output " << *(bufOut + i) << " == " << ref
                << std::endl;
    }
  }

  for (uint32_t i = 0; i < 8; i++) {
    uint32_t ref = 8 + i;
    if (*(ctrlOut + i) != ref) {
      std::cout << "Error in control output " << *(ctrlOut + i) << " != " << ref
                << std::endl;
      errors++;
    } else {
      std::cout << "Correct control output " << *(ctrlOut + i) << " == " << ref
                << std::endl;
    }
  }

  if (!errors) {
    std::cout << "\nPASS!\n\n";
    return 0;
  } else {
    std::cout << "\nfailed.\n\n";
    return 1;
  }
}
