cmake_minimum_required(VERSION 2.4)
project(MyTemplate C)
message("")

add_executable(MyTemplate main.c)

if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    message("Adding GCC Flags...")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
-std=gnu2x \
-ftrapv \
-Waggregate-return \
-Wall \
-Wcast-align \
-Wconversion \
-Wextra \
-Wfloat-equal \
-Winit-self \
-Wpointer-arith \
-Wshadow \
-Wstrict-prototypes \
-Wundef \
-Wwrite-strings")
endif ()
message("")

if (CMAKE_BUILD_TYPE MATCHES "Debug")
    message("CMAKE IN DEBUG MODE")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0")
elseif (CMAKE_BUILD_TYPE MATCHES "Release")
    message("CMAKE IN RELEASE MODE")
    if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -s")
    endif ()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Ofast -fexpensive-optimizations")
endif ()
message("")

message("[${CMAKE_C_FLAGS}]")
message("")
