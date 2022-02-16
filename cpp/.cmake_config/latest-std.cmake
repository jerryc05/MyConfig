# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# Set latest supported standard by parsing help output.
message(CHECK_START "[USE LATEST C STD]")

include(${__CFG__}/try-add-flag.cmake)


if(NOT DEFINED CMAKE_C_STANDARD)
    if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
        execute_process(COMMAND ${CMAKE_C_COMPILER} -v --help
                OUTPUT_VARIABLE __LATEST_STD__
                ERROR_QUIET)
        string(REGEX MATCHALL "-std=c[0-7][0-9] "
                __LATEST_STD__ ${__LATEST_STD__})
        list(GET __LATEST_STD__ -1 __LATEST_STD__)

    elseif(CMAKE_C_COMPILER_ID STREQUAL "Clang")
        execute_process(COMMAND ${CMAKE_C_COMPILER} -std= -xc -
                ERROR_VARIABLE __LATEST_STD__)
        string(REGEX MATCHALL "c[^']+"
                __LATEST_STD__ ${__LATEST_STD__})
        list(GET __LATEST_STD__ -1 __LATEST_STD__)
        set(__LATEST_STD__ "-std=${__LATEST_STD__}")

    else()
        message(SEND_ERROR "ERR: Unknown latest standard for [${CMAKE_C_COMPILER}]!")
    endif()

    string(STRIP "${__LATEST_STD__}" __LATEST_STD__)
    try_add_flag(CMAKE_C_FLAGS ${__LATEST_STD__})
    message(CHECK_PASS "OK: ${__LATEST_STD__}")

else()
    message(CHECK_FAIL "SKIP: Overrode by [CMAKE_C_STANDARD = ${CMAKE_C_STANDARD}]!")
endif()
message(STATUS)



message(CHECK_START "[USE LATEST C++ STD]")


if(NOT DEFINED CMAKE_CXX_STANDARD)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -v --help
                OUTPUT_VARIABLE __LATEST_STD__
                ERROR_QUIET)
        string(REGEX MATCHALL "-std=c\\+\\+[0-7][0-9] "
                __LATEST_STD__ ${__LATEST_STD__})
        list(GET __LATEST_STD__ -1 __LATEST_STD__)

    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -std= -xc++ -
                ERROR_VARIABLE __LATEST_STD__)
        string(REGEX MATCHALL "c[^']+"
                __LATEST_STD__ ${__LATEST_STD__})
        list(GET __LATEST_STD__ -1 __LATEST_STD__)
        set(__LATEST_STD__ "-std=${__LATEST_STD__}")

    else()
        message(SEND_ERROR "ERR: Unknown latest standard for [${CMAKE_CXX_COMPILER}]!")
    endif()

    string(STRIP "${__LATEST_STD__}" __LATEST_STD__)
    try_add_flag(CMAKE_CXX_FLAGS ${__LATEST_STD__})
    message(CHECK_PASS "OK: ${__LATEST_STD__}")

else()
    message(CHECK_FAIL "SKIP: Overrode by [CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}]!")
endif()
message(STATUS)
