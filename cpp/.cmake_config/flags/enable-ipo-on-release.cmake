# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "[INTERPROCEDURAL OPTIMIZATION]")

include(${__CFG__}/try-add-flag.cmake)


if(CMAKE_BUILD_TYPE STRGREATER_EQUAL "Rel")
    try_add_flag(CMAKE_CXX_FLAGS_RELEASE -flto -ffat-lto-objects)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -flto")

    include(CheckIPOSupported)
    check_ipo_supported(RESULT result)

    if(result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
        message(CHECK_PASS "OK")
    else()
        message(CHECK_FAIL "ERR: IPO not supported by CMake, but LTO is enabled!")
    endif()


else()
    message(CHECK_FAIL "SKIP: Not enabled for [${CMAKE_BUILD_TYPE}]; use [Release]-like build instead!")
endif()
message(STATUS)
