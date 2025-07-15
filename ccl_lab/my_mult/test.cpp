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
#include <Eigen/Dense>
using namespace Eigen;

#include "aie_inc.cpp"

int main(int argc, char *argv[]) {
  printf("Matrix Multiply 2 test start.\n");

  int errors = 0;

  aie_libxaie_ctx_t *_xaie = mlir_aie_init_libxaie();
  mlir_aie_init_device(_xaie);
  mlir_aie_configure_cores(_xaie);
  mlir_aie_configure_switchboxes(_xaie);
  mlir_aie_configure_dmas(_xaie);
  mlir_aie_initialize_locks(_xaie);

  // Clear buffer data memory
  for (int i = 0; i < 1024; i++) {
    mlir_aie_write_buffer_A(_xaie, i, 1);
    mlir_aie_write_buffer_B(_xaie, i, i);
    mlir_aie_write_buffer_C(_xaie, i, 0);
  }

  // Helper function to enable all AIE cores
  printf("Start cores\n");
  mlir_aie_start_cores(_xaie);

  // Wait for lock14_0 to indicate tile(1,4) is done
  if (mlir_aie_acquire_lock(_xaie, 1, 3000) == XAIE_OK)
    printf("Acquired lock\n");
  else
    printf("Timed out while trying to acquire lock.\n");

  // Parameters
  constexpr int dim = 32;

  // Reconstruct A, B, acc from initial values
  int32_t B_host[dim * dim];
  int32_t A_host[dim * dim];
  int32_t C_expected[dim * dim];

  for (int i = 0; i < dim * dim; i++) {
    A_host[i] = 1;
    B_host[i] = i;
    C_expected[i] = 0;
  }

  // Use Eigen to compute: C_expected = A × B + acc
  using Mat = Matrix<int32_t, dim, dim, ColMajor>;

  Map<Mat> A_mat(A_host);
  Map<Mat> B_mat(B_host);
  Map<Mat> C_exp_mat(C_expected);

  C_exp_mat = A_mat * B_mat;


  // Read output from AIE buffer and compare
  for (int i = 0; i < dim * dim; i++) {
    int32_t val = mlir_aie_read_buffer_C(_xaie, i);
    if (val != C_expected[i]) {
      printf("Mismatch at index %d: expected %d, got %d\n",
             i, C_expected[i], val);
      errors++;
    }
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

  printf("Matrix Multiply 2 test done.\n");
  return res;
}
