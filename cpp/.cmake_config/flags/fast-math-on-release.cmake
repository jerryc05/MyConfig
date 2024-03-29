# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.


message(CHECK_START "[UNSAFE MATH]")


include(${__CFG__}/try-add-flag.cmake)

if(CMAKE_BUILD_TYPE STRGREATER_EQUAL "Rel")
    try_add_flag(CMAKE_CXX_FLAGS_RELEASE
                 -ffast-math

                 -ffp-model=fast
                 )
    message(CHECK_PASS "OK")

else()
    message(CHECK_FAIL "SKIP: Not enabled for [${CMAKE_BUILD_TYPE}]; use [Release]-like build instead!")

endif()
message(STATUS)
