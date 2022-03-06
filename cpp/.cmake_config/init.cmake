# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.


if(PROJECT_BINARY_DIR STREQUAL PROJECT_SOURCE_DIR)
    message(FATAL_ERROR "[BINARY_DIR] must not be the same as [SOURCE_DIR]!")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "")
    message(STATUS "[CMAKE_BUILD_TYPE] not set, using default: Debug")
    set(CMAKE_BUILD_TYPE "Debug")
endif()
