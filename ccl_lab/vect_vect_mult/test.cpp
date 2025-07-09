#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cassert>

#include "test_library.h"
#include "aie_inc.cpp"

#define SIZE 256

int main() {
  printf("Vector-Vector multiply test start.\n");

  aie_libxaie_ctx_t* _xaie = mlir_aie_init_libxaie();
  assert(_xaie && "Failed to initialize libxaie");

  mlir_aie_init_device(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_initialize_locks(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_start_cores(_xaie);

  // Fill inputs
  for (int i = 0; i < SIZE; i++) {
    mlir_aie_write_buffer_in1_cons_buff_0(_xaie, i, i);
    mlir_aie_write_buffer_in2_cons_buff_0(_xaie, i, i);
  }

  // Release 4 frames of 64 elements to match 256 total input needed
  for (int i = 0; i < 4; i++) {
      mlir_aie_release_in1_cons_lock_0(_xaie, 0, 10000);
      mlir_aie_release_in2_cons_lock_0(_xaie, 0, 10000);
  }


  // Wait for output lock to indicate result is ready
  if (mlir_aie_acquire_out_lock_0(_xaie, 0, 10000) == XAIE_OK) {
    printf("Output lock acquired.\n");
  } else {
    printf("Timed out waiting for output lock.\n");
    mlir_aie_deinit_libxaie(_xaie);
    return -1;
  }

  // Check output
  int errors = 0;
  for (int i = 0; i < 256; i++) {
    int expected = i * i;
    uint32_t actual = mlir_aie_read_buffer_out_cons_buff_0(_xaie, i);
    if (actual != expected) {
      printf("Mismatch at %d: got %d, expected %d\n", i, actual, expected);
      errors++;
    }
  }


  mlir_aie_deinit_libxaie(_xaie);

  if (errors == 0) {
    printf("PASS!\n");
    return 0;
  } else {
    printf("FAIL (%d mismatches)\n", errors);
    return -1;
  }
}
