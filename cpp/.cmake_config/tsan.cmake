# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

#[[ "-fsanitize=thread" not compatible with neither
            "-fsanitize=address" nor "-fsanitize=pointer-*" ]]
message(CHECK_START "\t[THREAD SANITIZER]")
if(__DBG_SANITIZE_THRD__)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fsanitize=thread \
")
    message(CHECK_PASS "ON")
else()
    message(CHECK_FAIL "OFF")
endif()
message(STATUS "")

# todo Clang
#[[
  -fsanitize-thread-atomics
  -fsanitize-thread-func-entry-exit
  -fsanitize-thread-memory-access
]]
