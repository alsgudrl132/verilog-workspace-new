# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/min/fpga/soc/platform_hc05_test/microblaze_riscv_0/standalone_microblaze_riscv_0/bsp/include/sleep.h"
  "/home/min/fpga/soc/platform_hc05_test/microblaze_riscv_0/standalone_microblaze_riscv_0/bsp/include/xiltimer.h"
  "/home/min/fpga/soc/platform_hc05_test/microblaze_riscv_0/standalone_microblaze_riscv_0/bsp/include/xtimer_config.h"
  "/home/min/fpga/soc/platform_hc05_test/microblaze_riscv_0/standalone_microblaze_riscv_0/bsp/lib/libxiltimer.a"
  )
endif()
