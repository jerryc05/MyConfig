
# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(CREATE_LINK ${CMAKE_BINARY_DIR}/compile_commands.json ${CMAKE_SOURCE_DIR}/compile_commands.json
     COPY_ON_ERROR SYMBOLIC)
