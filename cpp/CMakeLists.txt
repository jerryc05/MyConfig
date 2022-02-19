# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# https://cmake.org/cmake/help/git-master/command/message.html#reporting-checks
cmake_minimum_required(VERSION 3.17)

project(MyTemplate)

# Uncomment to use specific standard
#set(CMAKE_CXX_STANDARD 20)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)

message(STATUS "==================== BEGIN OF CMAKE PRE CONFIG ====================")

set(__CFG__ ${CMAKE_CURRENT_SOURCE_DIR}/.cmake_config)

# Clang-tidy must be set before targets
include(${__CFG__}/clang-tidy.cmake)
include(${__CFG__}/cppcheck.cmake)
include(${__CFG__}/enable-ipo-on-release.cmake)
include(${__CFG__}/symlink-compile-commands.cmake)

message(STATUS "==================== END   OF CMAKE PRE CONFIG ====================")
message(STATUS)
# ===== ADD YOUR TARGETS BELOW THIS LINE =====


add_executable(${PROJECT_NAME} src/main.cpp)


# ===== ADD YOUR TARGETS ABOVE THIS LINE =====

message(STATUS "==================== BEGIN OF CMAKE POST CONFIG ====================")

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}")
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/include")

include(${__CFG__}/compiler-info.cmake)
include(${__CFG__}/latest-std.cmake)
include(${__CFG__}/ccache.cmake)

include(${__CFG__}/compiler-static-analysis.cmake)
include(${__CFG__}/use-unsafe-math-on-release.cmake)



# At most one of the following three can be used at the same time
set(__DBG_SANITIZE_ADDR__               ON)
#set(__DBG_SANITIZE_MEMORY__             OFF) # [SUPPORT DROPPED!] Read README first!
#set(__DBG_SANITIZE_THRD__               ON)  # [WIP]

#set(__DBG_SANITIZE_LEAK_STANDALONE__    ON)
set(__DBG_SANITIZE_UB__                 ON)


# include(${__CFG__}/!main.cmake)
include(${__CFG__}/clang-format.cmake)
include(${__CFG__}/report.cmake)


# Compatibility with Windows systems
if(WIN32)
    set(CMAKE_EXECUTABLE_SUFFIX ".exe")
endif()

# Google Benchmark
#find_package(benchmark REQUIRED)
#link_libraries(benchmark::benchmark)

message(STATUS "==================== END   OF CMAKE POST CONFIG ====================")
