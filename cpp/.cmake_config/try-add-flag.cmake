# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

function(try_add_flag __DEST__)

string(REGEX MATCH "CMAKE_C[^_]*"
       __LANG__ ${__DEST__})

if(NOT "${__LANG__}" STREQUAL "")
    execute_process(COMMAND ${${__LANG__}_COMPILER} "-fsyntax-only" "${__CFG__}/empty.h" ${ARGN}
                    RESULT_VARIABLE __EXIT_CODE__)
    list(JOIN ARGN " " __FLAGS__)
    if(__EXIT_CODE__ EQUAL "0")
        set(${__DEST__} "${${__DEST__}} ${__FLAGS__}")
    endif()

else()
    message(FATAL_ERROR "Unknown flag destination [${__DEST__}]")
endif()

endfunction()
