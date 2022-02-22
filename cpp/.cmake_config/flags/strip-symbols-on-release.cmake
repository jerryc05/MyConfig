# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if(CMAKE_BUILD_TYPE STRGREATER_EQUAL "Rel")
  include(${__CFG__}/try-add-flag.cmake)

  try_add_flag(CMAKE_CXX_FLAGS -fdata-sections)
  try_add_flag(CMAKE_CXX_FLAGS -ffunction-sections)

  try_add_flag(CMAKE_CXX_FLAGS -Wl,--gc-sections,--print-gc-sections,-s)

  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} \
  --gc-sections \
  --print-gc-sections \
  -s \
  ")

  message(STATUS "[STRIP SYMBOLS] - OK")
endif()
