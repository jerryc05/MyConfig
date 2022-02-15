# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# https://cmake.org/cmake/help/git-master/command/message.html#reporting-checks
cmake_minimum_required(VERSION 3.17)

project(MyTemplate)
message(STATUS)


message(STATUS "==================== BEGIN OF CMAKE CONFIG ====================")


include(${CMAKE_CURRENT_SOURCE_DIR}/.cmake_config/ccache.cmake)

#set(__USE_ANALYZER__                    ON)
set(__USE_LATEST_CPP_STD__              ON)
set(__REL_USE_HACKED_MATH__             ON)


# At most one of the following three can be used at the same time
set(__DBG_SANITIZE_ADDR__               ON)
#set(__DBG_SANITIZE_MEMORY__             OFF) # [SUPPORT DROPPED!] Read README first!
#set(__DBG_SANITIZE_THRD__               ON)  # [WIP]

#set(__DBG_SANITIZE_LEAK_STANDALONE__    ON)
set(__DBG_SANITIZE_UB__                 ON)


include(${CMAKE_CURRENT_SOURCE_DIR}/.cmake_config/!main.cmake)


# Compatibility with Windows systems
#set(CMAKE_EXECUTABLE_SUFFIX ".exe")

# Google Benchmark
#find_package(benchmark REQUIRED)
#link_libraries(benchmark::benchmark)


message(STATUS "==================== END OF CMAKE CONFIG ====================")
# ===== ADD YOUR TARGETS BELOW THIS LINE =====



add_executable(${PROJECT_NAME} src/main.cpp)
