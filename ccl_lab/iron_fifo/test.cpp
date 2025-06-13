
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
  printf("IRON fifo test start.\n");

  int errors = 0;
  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  // Clear buffer data memory
  for (int i = 0; i < 256; i++) {
    mlir_aie_write_buffer_in_buff_0(_xaie, i, 0);
  }

  mlir_aie_check("Before start cores:", mlir_aie_read_buffer_in_buff_0(_xaie, 0), 0,
                 errors);

  // Helper function to enable all AIE cores
  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

  // Wait for lock14_0 to indicate tile(1,4) is done
  if (mlir_aie_acquire_in_lock_0(_xaie, 1, 1000) == XAIE_OK)
    printf("Acquired lock24_0. Done.\n");
  else
    printf("Timed out (1000) while trying to acquire lock24_0.\n");

  for(uint16_t i = 0; i < 195; i++)
    mlir_aie_check("First core:", mlir_aie_read_buffer_in_buff_0(_xaie, i), 5, errors);

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

  printf("IRON fifo test done.\n");
  return res;
}
