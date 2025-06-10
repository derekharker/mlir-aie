//===- test.cpp -------------------------------------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Copyright (C) 2022, Advanced Micro Devices, Inc.
//
//===----------------------------------------------------------------------===//

#include "test_library.h"
#include <cassert>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <thread>
#include <unistd.h>
#include <xaiengine.h>

#include "aie_inc.cpp"

int main(int argc, char *argv[]) {
  printf("Tutorial-3 test start.\n");

  // Standard helper function for initializing and configuring AIE array.
  // The host is used to initialize/ configure/ program the AIE array.
  // ------------------------------------------------------------------------
  // aie_libxaie_ctx_t - AIE config struct
  // mlir_aie_init_device - Alloc AIE config struct
  // mlir_aie_configure_cores - Reset cores and locks. Load elfs.
  // mlir_aie_configure_switchboxes - Switchboxes not used in this example.
  // mlir_aie_configure_dmas - TileDMAs not used in this example.
  // mlir_aie_initialize_locks - placeholder
  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  int errors = 0;

  // Clear buffer data memory
  for (int i = 0; i < 256; i++) {
    mlir_aie_write_buffer_of_buff_0(_xaie, i, 0);
  }

  mlir_aie_check("Before start cores:",
                 mlir_aie_read_buffer_of_buff_0(_xaie, 3), 0, errors);
  mlir_aie_check("Before start cores:",
                 mlir_aie_read_buffer_of_buff_0(_xaie, 5), 0, errors);

  // Helper function to enable all AIE cores
  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

  //Checks after starting cores
  if (mlir_aie_acquire_of_cons_lock_0(_xaie, 0, 1000) == XAIE_OK)
    printf("Acquired objectFifo buff 0 from tile(5, 4)\n");
  else
    printf("Timed out (1000) waiting for objectFifo buff 0 from tile(5, 4)\n");

  if (mlir_aie_acquire_of_cons_lock_1(_xaie, 0, 1000) == XAIE_OK)
    printf("Acquired objectFifo buff 1 from tile(5, 4)\n");
  else
    printf("Timed out (1000) waiting for objectFifo buff 1 from tile(5, 4)\n");
  
  mlir_aie_check("Checking buff_0[5] = 19", mlir_aie_read_buffer_of_cons_buff_0(_xaie, 5), 19, errors);

  mlir_aie_check("Checking buff_1[2] = 6", mlir_aie_read_buffer_of_cons_buff_1(_xaie, 2), 6, errors);

  // Print Pass/Fail result of our test
  int res = 0;
  if (!errors) {
    printf("PASS!\n");
    res = 0;
  } else {
    printf("Fail!\n");
    res = -1;
  }

  // Teardown and cleanup of AIE array
  mlir_aie_deinit_libxaie(_xaie);

  printf("Tutorial-3 test done.\n");
  return res;
}
