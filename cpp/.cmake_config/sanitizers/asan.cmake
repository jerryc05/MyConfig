# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "\t[ADDRESS SANITIZER]")
if(__DBG_SANITIZE_ADDR__)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fno-common \
-fno-omit-frame-pointer \
-fno-optimize-sibling-calls \
-fsanitize-address-use-after-scope \
-fsanitize=address \
-fsanitize=pointer-compare \
-fsanitize=pointer-subtract \
\
-g3 \
")

# todo define _GLIBCXX_SANITIZE_VECTOR macro






    # any optimization level will fail leak check

    set(__INCLUDE_SANITIZER_OPTIONS__ ON)

    #[[


    ]]

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fsanitize-address-globals-dead-stripping \
-fsanitize-address-poison-custom-array-cookie \
-fsanitize-address-use-odr-indicator \
")
    endif()

    # "ASAN_SYMBOLIZER_PATH" seems unnecessary if compiled with "-g"

    message(CHECK_PASS "ON [WARNING: DO NOT USE WITH VALGRIND!]")
else()
    message(CHECK_FAIL "OFF")
endif()
message(STATUS "")

# [DEL] "-fsanitize-coverage=trace-pc" needs kernel support
