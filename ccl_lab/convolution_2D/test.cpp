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

int main(int argc, const char *argv[]) {
  printf("Convolution test start.\n");

  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  for (int i = 0; i < 4; i++) {
    mlir_aie_write_buffer_buff1(_xaie, i, 2);
    mlir_aie_write_buffer_buff1(_xaie, i+4, 0);
    mlir_aie_write_buffer_buff1(_xaie, i+8, 2);
    mlir_aie_write_buffer_buff1(_xaie, i+12, 2);
  }

  mlir_aie_write_buffer_buff2(_xaie, 0, 1);
  mlir_aie_write_buffer_buff2(_xaie, 1, 1);
  mlir_aie_write_buffer_buff2(_xaie, 2, 0);
  mlir_aie_write_buffer_buff2(_xaie, 3, 1);

  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

  int errors = 0;

  int output[4];

  if (mlir_aie_acquire_lock1(_xaie, 1, 1000) == XAIE_OK)
    printf("Acquired lock1. Done.\n");

  for (int i = 0; i < 9; i++) {
    output[i] = mlir_aie_read_buffer_buff_out(_xaie, i);
    printf("Output[%d] = %d \n", i, output[i]);
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

  printf("Convolution test done.\n");
  return res;
}