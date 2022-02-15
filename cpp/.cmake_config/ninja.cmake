# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# Set latest supported standard by parsing help output.
message(CHECK_START "[ninja-build]")


find_program(__NINJA__ ninja)

if (__NINJA__)
    set(CMAKE_GENERATOR "Ninja")

    execute_process(COMMAND ${__NINJA__} --version
            OUTPUT_VARIABLE __CCACHE_VER__)
    string(REGEX MATCH "[^\r\n]+"
            __CCACHE_VER__ ${__CCACHE_VER__})
    message(CHECK_PASS "OK: ninja version ${__CCACHE_VER__}")

else ()
    message(CHECK_FAIL "ERR: Not found!")
endif ()
message(STATUS)
