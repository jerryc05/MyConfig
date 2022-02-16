# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# Use [ccache] if possible.
message(CHECK_START "[ccache]")


find_program(__CCACHE__ ccache)

if(__CCACHE__)
    set(CMAKE_C_COMPILER_LAUNCHER   ${CMAKE_C_COMPILER_LAUNCHER}   ${__CCACHE__})
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CMAKE_CXX_COMPILER_LAUNCHER} ${__CCACHE__})

    execute_process(COMMAND ${__CCACHE__} --version
            OUTPUT_VARIABLE __CCACHE_VER__)
    string(REGEX MATCH "[^\r\n]+"
            __CCACHE_VER__ ${__CCACHE_VER__})
    message(CHECK_PASS "OK: ${__CCACHE_VER__}")

else()
    message(CHECK_FAIL "ERR: Not found!")
endif()
message(STATUS)
