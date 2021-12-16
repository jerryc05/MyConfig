# Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if (__INCLUDE_SANITIZER_OPTIONS__)

    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/sanitizer-options.cpp)

        set(__SANITIZER_OPT_LIB_NAME__ __sanopts_ignore_this__)

        # must be executed before add_executable()
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/check-targets.cmake)

        add_library(${__SANITIZER_OPT_LIB_NAME__} OBJECT
                ${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/sanitizer-options.cpp)

        # only effective before add_executable()
        link_libraries(${__SANITIZER_OPT_LIB_NAME__})

        unset(__SANITIZER_OPT_LIB_NAME__)

    else ()
        message(SEND_ERROR "\t[SANITIZER OPTIONS] FAILED TO FIND FILE CONTAINING SANITIZER OPTIONS!")
    endif ()

endif ()