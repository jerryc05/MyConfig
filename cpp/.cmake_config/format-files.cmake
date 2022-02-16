# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

message(CHECK_START "[clang-format]")


find_program(__FMT__ clang-format)

if(__FMT__)
    get_directory_property(__TARGETS__ BUILDSYSTEM_TARGETS)

    foreach(__TARGET__ IN LISTS __TARGETS__)
        get_target_property(__SRCS__ ${__TARGET__} SOURCES)
        list(TRANSFORM __SRCS__ PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")
        add_custom_command(TARGET ${__TARGET__}
                           PRE_BUILD
                           COMMAND ${__FMT__} "-Wno-error=unknown" "-i" ${__SRCS__}
                           VERBATIM)
    endforeach()

    list(LENGTH __SRCS__ __LEN__)
    message(CHECK_PASS "OK: Formatted ${__LEN__} files!")

else()
    message(CHECK_FAIL "ERR: Not found!")
endif()
message(STATUS)
