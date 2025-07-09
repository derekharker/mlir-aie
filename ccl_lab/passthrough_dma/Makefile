# === Configuration ===
MLIR_AIE_DIR := /home/dwharker/mlir-aie
VITIS_SYSROOT := /tools/Xilinx/Vitis/2023.2/gnu/aarch64/lin/aarch64-linux/aarch64-xilinx-linux

# Change this line to switch test mode
TEST_FILE := test.cpp

# === Derived Paths ===
COMMON_SRC := $(MLIR_AIE_DIR)/ccl_lab/passthrough_dma
MLIR_FILE := $(COMMON_SRC)/aie.mlir
TEST_PATH := $(COMMON_SRC)/$(TEST_FILE)

# === Includes and Libraries ===
AARCH64_INCLUDES := \
  -I$(MLIR_AIE_DIR)/install/runtime_lib/aarch64/test_lib/include \
  -I$(MLIR_AIE_DIR)/install/runtime_lib/aarch64/xaiengine/include \
  -I$(VITIS_SYSROOT)/usr/include/c++/12.2.0 \
  -I$(VITIS_SYSROOT)/usr/include/c++/12.2.0/aarch64-xilinx-linux \
  -I$(VITIS_SYSROOT)/usr/include

AARCH64_LIBS := \
  -L$(MLIR_AIE_DIR)/install/runtime_lib/aarch64/test_lib/lib \
  -L$(MLIR_AIE_DIR)/install/runtime_lib/aarch64/xaiengine/lib \
  -L$(VITIS_SYSROOT)/usr/lib/aarch64-xilinx-linux/12.2.0 \
  -ltest_lib -lxaiengine

X86_INCLUDES := \
  -I$(MLIR_AIE_DIR)/install/runtime_lib/x86_64/test_lib/include \
  -I$(MLIR_AIE_DIR)/install/runtime_lib/x86_64/xaiengine/include \

X86_LIBS := \
  -L$(MLIR_AIE_DIR)/install/runtime_lib/x86_64/test_lib/lib \
  -L$(MLIR_AIE_DIR)/install/runtime_lib/x86_64/xaiengine/lib \
  -ltest_lib -lxaiengine

# === Compiler Settings ===
CXX := aarch64-linux-gnu-g++
CXXFLAGS := --sysroot=$(VITIS_SYSROOT) -static-libstdc++

# === Targets ===
elf:
	aiecc.py -j4 -v --sysroot=$(VITIS_SYSROOT) --host-target=aarch64-linux-gnu $(MLIR_FILE) \
	$(AARCH64_INCLUDES) $(AARCH64_LIBS) $(TEST_PATH) -o host.exe

sim:
	aiecc.py -j4 --xchesscc --xbridge --aiesim $(MLIR_FILE) \
	$(X86_INCLUDES) $(X86_LIBS) $(TEST_PATH)

exe:
	$(CXX) $(TEST_PATH) -o host.exe \
	-I./aie.mlir.prj $(AARCH64_INCLUDES) \
	$(AARCH64_LIBS) \
	/home/dwharker/mlir-aie/install/runtime_lib/aarch64/test_lib/lib/libmemory_allocator_ion.a \
	$(CXXFLAGS)



clean:
	rm -rf aie.mlir.prj *elf core* *log pl_sample_counts foo.vcd *exe aiesimulator_output sim .AIE_SIM_CMD_LINE_OPTIONS

all:
	clear && make clean && make elf && make sim && make exe
