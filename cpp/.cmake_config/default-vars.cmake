# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if(CMAKE_BUILD_TYPE STREQUAL "")
    message(STATUS "[CMAKE_BUILD_TYPE] not set, using default: Debug")
    set(CMAKE_BUILD_TYPE "Debug")
endif()
