# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "[cppcheck]")


find_program(__CPPCHECK__ cppcheck)

if(__CPPCHECK__)
    include(ProcessorCount)
    ProcessorCount(NPROCS)

    set(__CPPCHECK_ARGS__
        -j${NPROCS}
        --force
        --enable=warning,style,performance,portability,information,missingInclude,missingInclude
        --inconclusive
        --max-ctu-depth=32
        )

    # only effective before add_executable()
    set(CMAKE_C_CPPCHECK   ${__CPPCHECK__} ${__CPPCHECK_ARGS__})
    set(CMAKE_CXX_CPPCHECK ${__CPPCHECK__} ${__CPPCHECK_ARGS__})
    message(CHECK_PASS "OK: [cppcheck] @ ${__CPPCHECK__}")

else()
    message(CHECK_FAIL "ERR: Not found!")
endif()
message(STATUS)
