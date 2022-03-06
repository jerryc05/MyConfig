
# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_BINARY_DIR STREQUAL PROJECT_SOURCE_DIR)
    message(FATAL_ERROR "[BINARY_DIR] = [SOURCE_DIR]! Make sure you are running cmake from the build directory!")
endif()

file(CREATE_LINK ${CMAKE_BINARY_DIR}/compile_commands.json ${PROJECT_SOURCE_DIR}/compile_commands.json
     COPY_ON_ERROR SYMBOLIC)
