#include <adf.h>
#include <aie_api/aie_adf.hpp>
#include "aie_api/utils.hpp"
#include <stdio.h>

// https://docs.amd.com/r/2022.2-English/ug1079-ai-engine-kernel-coding/Vectorized-Matrix-Multiplication
// Note that the example at the link above also has profiling code (use it later)
// there are also data shuffling kernels available as well (tiling and de-tiling). But don't need that for now.

template <int K_DIM_A, bool verbose>
void gemm_kernel(int32_t* matA, int32_t* matB, int32_t* matC) {


    const int M=4;
    const int K=2;
    const int N=4;

    //Total matrix sizes
    const int rowA=4;
    const int colA=2;
    const int colB=4;

    //mmul numbers
    const int num_rowA=rowA/M;
    const int num_colA=colA/K;
    const int num_colB=colB/N;

    const int SHIFT = 0;


    using MMUL = aie::mmul<M, K, N, int32, int32>;
    const int32_t* __restrict pA = matA;
    const int32_t* __restrict pB = matB;
    int32_t* __restrict pC = matC;

    for (unsigned i = 0; i < num_rowA; i++) {//for output row number of element matrix 
        for (unsigned j = 0; j < num_colB; j++) {//for output col number of element matrix
          const int32 * __restrict pA1 = pA + ( i * num_colA + 0) * MMUL::size_A;
          const int32 * __restrict pB1 = pB + ( 0 * num_colB + j) * MMUL::size_B;
    
          aie::vector<int32, MMUL::size_A> A0 = aie::load_v<MMUL::size_A>(pA1); pA1 += MMUL::size_A;
          aie::vector<int32, MMUL::size_B> B0 = aie::load_v<MMUL::size_B>(pB1); pB1 += MMUL::size_B * num_colB;
    
          MMUL C00;
          C00.mul(A0, B0);
    
          for (unsigned k = 0; k < num_colA-1; k++) {
            A0 = aie::load_v<MMUL::size_A>(pA1); pA1 += MMUL::size_A;
            B0 = aie::load_v<MMUL::size_B>(pB1); pB1 += MMUL::size_B * num_colB;
            C00.mac(A0, B0);
          }
    
          aie::store_v(pC, C00.template to_vector<int32>(SHIFT)); pC += MMUL::size_C;
        }
    }

}

extern "C" {
void gemm_kernel_top(adf::input_buffer<int32> & __restrict matA,
                     adf::input_buffer<int32> & __restrict matB,
                     adf::output_buffer<int32> & __restrict matC) {
    printf("Entered function!\n");
    gemm_kernel<4, false>((int32_t*)matA.data(), (int32_t*)matB.data(), (int32_t*)matC.data());
}
}

