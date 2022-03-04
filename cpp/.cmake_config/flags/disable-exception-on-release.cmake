# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if(CMAKE_BUILD_TYPE STRGREATER_EQUAL "Rel")
  include(${__CFG__}/try-add-flag.cmake)

  try_add_flag(CMAKE_CXX_FLAGS -fno-exceptions)

  message(STATUS "[DISABLE EXCEPTIONS] - OK")
endif()
