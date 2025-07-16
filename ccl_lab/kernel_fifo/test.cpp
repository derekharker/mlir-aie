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
  printf("Passthrough 2 test start.\n");

  int errors = 0;

  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  // Clear buffer data memory
  for (int i = 0; i < 16; i++) {
    mlir_aie_write_buffer_A_buff_0(_xaie, i, i);
    mlir_aie_write_buffer_B(_xaie, i, 3);
  }

  // Helper function to enable all AIE cores
  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

  if (mlir_aie_acquire_lock(_xaie, 1, 2000) == XAIE_OK)
    printf("Acquired lock\n");
  else
    printf("Timed out while trying to acquire lock.\n");

  if (mlir_aie_acquire_A_cons_lock_0(_xaie, 0, 2000) == XAIE_OK)
    printf("Acquired lock 2\n");
  else
    printf("Timed out while trying to acquire lock 2.\n");  
    

  for (int i = 0; i < 16; i++) {
    mlir_aie_check("After start cores: ", mlir_aie_read_buffer_B(_xaie, i), i, errors);
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

  printf("Passthrough 2 test done.\n");
  return res;
}
