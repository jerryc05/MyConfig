# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

include(${__CFG__}/try-add-flag.cmake)


try_add_flag(CMAKE_CXX_FLAGS_DEBUG -Og)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -g3)

try_add_flag(CMAKE_CXX_FLAGS_DEBUG -D_FORTIFY_SOURCE=2)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -D_GLIBCXX_DEBUG)

try_add_flag(CMAKE_CXX_FLAGS_DEBUG -fcf-protection=full)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -fharden-compares)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -fharden-conditional-branches)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -fstack-check)
#                                  -fstack-clash-protection  # Conflicts with -fstack-check
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -fstack-protector-all)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -ftrapv)
try_add_flag(CMAKE_CXX_FLAGS_DEBUG -ftrivial-auto-var-init=pattern)


if(CMAKE_BUILD_TYPE STRGREATER_EQUAL "Debug")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} \
-rdynamic \
")
endif()
