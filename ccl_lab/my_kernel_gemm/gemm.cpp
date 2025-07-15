#include <aie_api/aie.hpp>

template <int rowA, int colA, int colB>
void matmul_simple(const int32_t* a, const int32_t* b, int32_t* c) {
  event0(); 

  for (int i = 0; i < rowA; ++i) {
    for (int j = 0; j < colB; ++j) {
      int32_t sum = 0;
      for (int k = 0; k < colA; ++k) {
        sum += a[i * colA + k] * b[k * colB + j];
      }
      c[i * colB + j] = sum;
    }
  }

  event1();
}

extern "C" {
  void kernel_mm_simple(int32_t* winA,
                        int32_t* winB,
                        int32_t* winC) {

    matmul_simple<4, 4, 4>(winA, winB, winC);
  }
}

