# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "[STATIC ANALYZER]")


find_program(__CLANG_TIDY__ clang-tidy)

if(NOT __CLANG_TIDY__)
    file(READ_SYMLINK ${CMAKE_CXX_COMPILER} __ABS_COMPILER_PATH__)
    if(NOT IS_ABSOLUTE "${__ABS_COMPILER_PATH__}")
        get_filename_component(__COMPILER_DIR__ ${CMAKE_CXX_COMPILER} DIRECTORY)
        set(__ABS_COMPILER_PATH__ "${__COMPILER_DIR__}/${__ABS_COMPILER_PATH__}")
    endif()
    get_filename_component(__ABS_COMPILER_DIR__ ${__ABS_COMPILER_PATH__} DIRECTORY)
    find_program(__CLANG_TIDY__ clang-tidy
                 PATHS ${__ABS_COMPILER_DIR__})
endif()

if(__CLANG_TIDY__)
    set(__CLANG_TIDY_ARGS__
        --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy
        --allow-enabling-analyzer-alpha-checkers
        --extra-arg=-Xclang
        --extra-arg=-analyzer-config
        --extra-arg=-Xclang
        --extra-arg=aggressive-binary-operation-simplification=true
        # ,c++-shared_ptr-inlining=true,unroll-loops=true,widen-loops=true
        )

    # only effective before add_executable()
    set(CMAKE_CXX_CLANG_TIDY ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__})
    message(CHECK_PASS "OK: [clang-tidy] @ ${__CLANG_TIDY__}")

else()
    message(WARNING "[clang-tidy] Not found!")
endif()


include(${__CFG__}/try-add-flag.cmake)

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html#Static-Analyzer-Options
    try_add_flag(CMAKE_CXX_FLAGS
                 -fanalyzer
                 -fanalyzer-transitivity
                 --param=analyzer-bb-explosion-factor=32
                 --param=analyzer-max-recursion-depth=64)

    if(NOT __CLANG_TIDY__)
        message(CHECK_PASS "OK: Using GCC analyzer!")
    else()
        message(STATUS "[STATIC ANALYZER] - OK: Also uses GCC analyzer!")
    endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # Just use clang-tidy
    if(NOT __CLANG_TIDY__)
        message(CHECK_FAIL "ERR: Clang uses clang-tidy, but not found!")
    endif()

endif()
message(STATUS)
