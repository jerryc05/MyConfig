# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# todo not finished
message(CHECK_START "\t[MEMORY SANITIZER]")
if(__DBG_SANITIZE_MEMORY__)
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag("-fsanitize=memory" __IS_MSAN_SUPPORTED__)

    if(__IS_MSAN_SUPPORTED__)
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
    -fno-omit-frame-pointer \
    -fPIE -pie \
    -fsanitize-memory-track-origins=1 \
    -fsanitize-memory-use-after-dtor \
    -fsanitize=memory \
    ")
        message(CHECK_PASS "ON [WARNING: DO NOT USE WITH VALGRIND!]")

    else()
        message(SEND_ERROR "\t[MEMORY SANITIZER] NOT SUPPORTED BY COMPILER!")
    endif()


else()
    message(CHECK_FAIL "OFF")
endif()
message(STATUS "")
