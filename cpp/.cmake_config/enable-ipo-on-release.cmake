# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "[INTERPROCEDURAL OPTIMIZATION]")


if(CMAKE_BUILD_TYPE STRGREATER_EQUAL "Rel")
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result)

    if(result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
        message(CHECK_PASS "OK")
    else()
        message(CHECK_FAIL "ERR: IPO not supported!")
    endif()


else()
    message(CHECK_FAIL "SKIP: Not enabled for [${CMAKE_BUILD_TYPE}]; use [Release]-like build instead!")
endif()
