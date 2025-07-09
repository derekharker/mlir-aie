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
  printf("Vector Scalar mult test start.\n");

  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  int errors = 0;

  // Clear buffer data memory
  for (int i = 0; i < 64; i++) {
    mlir_aie_write_buffer_in_cons_buff_0(_xaie, i, i);
    mlir_aie_write_buffer_out_buff_0(_xaie, i, 5);
  }
  mlir_aie_write_buffer_factor_cons_buff_0(_xaie, 0, 2);

  // Helper function to enable all AIE cores
  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

	// Check initial buffers
  for (int i = 0; i < 64; i++) {
    mlir_aie_check("in buffer: ", mlir_aie_read_buffer_in_cons_buff_0(_xaie, i), i, errors);
  }
  mlir_aie_check("factor buffer: ", mlir_aie_read_buffer_factor_cons_buff_0(_xaie, 0), 2, errors)

  if (mlir_aie_acquire_out_lock_0(_xaie, 0, 3000) == XAIE_OK)
    printf("Acquired lock\n");
  else
    printf("Didn't acquire lock\n");

  for (int i = 0; i < 64; i++) {
		mlir_aie_check("Out buffer: ", mlir_aie_read_buffer_out_buff_0(_xaie, i), 10, errors);
	}


  
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

  printf("Vector Scalar mult test done.\n");
  return res;
}
