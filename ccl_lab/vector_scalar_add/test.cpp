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
  printf("Vector scalar add test start.\n");

  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  int errors = 0;

  for (int i = 0; i < 256; i++) {
    mlir_aie_write_buffer_in0_buff_0(_xaie, i, 0);
  }

  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

  if (mlir_aie_acquire_in0_lock_0(_xaie, 1, 1000) == XAIE_OK)
    printf("Lock done.\n");
  else
    printf("Timed out (1000) waiting for lock.\n");


  printf("Checking out buf[3] = 1.\n");
  mlir_aie_check("After start cores:", mlir_aie_read_buffer_in0_buff_0(_xaie, 3), 1,
                 errors);

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

  printf("Vector scalar add test done.\n");
  return res;
}