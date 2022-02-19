# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# ========== DISABLED: Somehow conflicts with clang-tidy! ==========

# message(CHECK_START "[COMPILER STATIC ANALYSIS]")


# include(${__CFG__}/try-add-flag.cmake)

# if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
#     # https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html#Static-Analyzer-Options
#     try_add_flag(CMAKE_CXX_FLAGS
#                  -fanalyzer
#                  -fanalyzer-transitivity
#                  --param=analyzer-bb-explosion-factor=32
#                  --param=analyzer-max-recursion-depth=64)
#     message(CHECK_PASS "OK: Using GCC analyzer!")

# elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
#     message(CHECK_FAIL "INFO: [clang] uses [clang-tidy]!")
# endif()
# message(STATUS)
