# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "\t[STATIC ANALYZER]")
if (__USE_ANALYZER__)

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
--param=analyzer-bb-explosion-factor=20 \
--param=analyzer-max-recursion-depth=10 \
-fanalyzer \
-Wanalyzer-too-complex \
")

    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        unset(__CLANG_TIDY__ CACHE)
        find_program(__CLANG_TIDY__ clang-tidy)

        if (NOT __CLANG_TIDY__)
            file(READ_SYMLINK ${CMAKE_CXX_COMPILER} __ABS_COMPILER_PATH__)
            if (NOT IS_ABSOLUTE "${__ABS_COMPILER_PATH__}")
                get_filename_component(__COMPILER_DIR__ ${CMAKE_CXX_COMPILER} DIRECTORY)
                set(__ABS_COMPILER_PATH__ "${__COMPILER_DIR__}/${__ABS_COMPILER_PATH__}")
            endif ()
            get_filename_component(__ABS_COMPILER_DIR__ ${__ABS_COMPILER_PATH__} DIRECTORY)

            find_program(__CLANG_TIDY__ clang-tidy
                    PATHS ${__ABS_COMPILER_DIR__})
        endif ()

        if (__CLANG_TIDY__)
            # must be executed before add_executable()
            include(${CMAKE_CURRENT_SOURCE_DIR}/.cmake_config/check-targets.cmake)

            set(__CLANG_TIDY_ARGS__
                    --allow-enabling-analyzer-alpha-checkers
                    --checks=*,-android-*,-altera-*,-clang-analyzer-alpha.fuchsia.*,-clang-analyzer-alpha.llvm.*,-clang-analyzer-alpha.nondeterminism.PointerIteration,-clang-analyzer-alpha.webkit.*,-cppcoreguidelines-pro-bounds-pointer-arithmetic,-cppcoreguidelines-pro-type-vararg,-cppcoreguidelines-init-variables,-darwin-*,-fuchsia-*,-hicpp-vararg,-google-readability-todo,-google-runtime-references,-llvm-*,-llvmlibc-*,-modernize-use-trailing-return-type,-objc-*,-readability-function-cognitive-complexity,-readability-isolate-declaration,-zircon-*
                    --format-style=google
                    --use-color

                    --extra-arg=-Xclang
                    --extra-arg=-analyzer-config
                    --extra-arg=-Xclang
                    --extra-arg=aggressive-binary-operation-simplification=true,c++-shared_ptr-inlining=true,unroll-loops=true,widen-loops=true
                    )

            # only effective before add_executable()
            set(CMAKE_CXX_CLANG_TIDY ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__})

        else ()
            message(SEND_ERROR "\t[STATIC ANALYZER] clang-tidy NOT FOUND!")
        endif ()

    else ()
        message(SEND_ERROR "\t[STATIC ANALYZER] SWITCH UNIMPLEMENTED FOR THIS COMPILER CURRENTLY!")
    endif ()

    message(CHECK_PASS "ON")

else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS " ")
