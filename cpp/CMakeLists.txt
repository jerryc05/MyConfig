# Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

cmake_minimum_required(VERSION 3.7)
project(MyTemplate)
message("")


# ===== BEGIN OF CMAKE ARGS TEMPLATE =====

#set(__USE_ANALYZER__                    ON)
set(__USE_LATEST_CPP_STD__              ON)
set(__REL_USE_HACKED_MATH__             ON)


# At most one of the following three can be used at the same time
set(__DBG_SANITIZE_ADDR__               ON)
#set(__DBG_SANITIZE_MEMORY__             OFF) # [SUPPORT DROPPED!] Read README first!
#set(__DBG_SANITIZE_THRD__               ON)  # [WIP]

#set(__DBG_SANITIZE_LEAK_STANDALONE__    ON)
set(__DBG_SANITIZE_UB__                 ON)


#set(__DEBUG_DEF_NAME__                  _DEBUG_BUILD)


include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/!main.cmake)


# Compatibility with Windows systems
#set(CMAKE_EXECUTABLE_SUFFIX ".exe")

# Google Benchmark
#find_package(benchmark REQUIRED)
#link_libraries(benchmark::benchmark)

# ===== END OF CMAKE ARGS TEMPLATE =====
# ===== ADD YOUR TARGETS BELOW THIS LINE =====



add_executable(${PROJECT_NAME} main.cpp)