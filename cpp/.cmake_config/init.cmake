# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.


if(PROJECT_BINARY_DIR STREQUAL PROJECT_SOURCE_DIR)
    message(FATAL_ERROR "[BINARY_DIR] must not be the same as [SOURCE_DIR]!")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "")
    message(STATUS "[CMAKE_BUILD_TYPE] not set, using default: [Debug]")
    set(CMAKE_BUILD_TYPE "Debug")
endif()

if(CMAKE_POSITION_INDEPENDENT_CODE STREQUAL "")
    message(STATUS "[CMAKE_POSITION_INDEPENDENT_CODE] not set, using default: ON")
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()
