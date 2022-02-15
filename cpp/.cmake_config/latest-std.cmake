# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "\t[USE LATEST C++ STD]")
if (__USE_LATEST_CPP_STD__)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -v --help
                OUTPUT_VARIABLE __LATEST_CPP_STD__
                ERROR_QUIET)
        string(REGEX MATCHALL "-std=gnu\\+\\+[0-8][0-9] "
                __LATEST_CPP_STD__ ${__LATEST_CPP_STD__})
        list(GET __LATEST_CPP_STD__ -1 __LATEST_CPP_STD__)

    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -std= -xc++ -
                ERROR_VARIABLE __LATEST_CPP_STD__)
        string(REGEX MATCHALL "gnu[^']+"
                __LATEST_CPP_STD__ ${__LATEST_CPP_STD__})
        list(GET __LATEST_CPP_STD__ -1 __LATEST_CPP_STD__)
        set(__LATEST_CPP_STD__ "-std=${__LATEST_CPP_STD__}")

    else ()
        message(SEND_ERROR "\t[USE LATEST C++ STD] SWITCH UNIMPLEMENTED FOR THIS COMPILER CURRENTLY!")
    endif ()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${__LATEST_CPP_STD__}")
    message(CHECK_PASS "ON: [${__LATEST_CPP_STD__}]")
else ()
    message(CHECK_FAIL "OFF")
endif ()
