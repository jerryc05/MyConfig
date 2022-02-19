# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if(__INCLUDE_SANITIZER_OPTIONS__)

    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.cmake_config/sanitizer-options.cpp)

        set(__SANITIZER_OPT_LIB_NAME__ __sanopts_ignore_this__)


        add_library(${__SANITIZER_OPT_LIB_NAME__} OBJECT
                ${CMAKE_CURRENT_SOURCE_DIR}/.cmake_config/sanitizers/sanitizer-options.cpp)

        # only effective before add_executable()
        # todo use target...
        link_libraries(${__SANITIZER_OPT_LIB_NAME__})

        unset(__SANITIZER_OPT_LIB_NAME__)

    else()
        message(SEND_ERROR "\t[SANITIZER OPTIONS] FAILED TO FIND FILE CONTAINING SANITIZER OPTIONS!")
    endif()

endif()
