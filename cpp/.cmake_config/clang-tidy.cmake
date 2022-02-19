# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "[clang-tidy]")


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
    set(CMAKE_C_CLANG_TIDY   ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__})
    set(CMAKE_CXX_CLANG_TIDY ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__})
    message(CHECK_PASS "OK: [clang-tidy] @ ${__CLANG_TIDY__}")

else()
    message(CHECK_FAIL "ERR: Not found!")
endif()
message(STATUS)
