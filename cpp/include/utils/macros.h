/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include "attributes.h"


// ============================================================================
#define STRINGIFY_(x) #x
#define STRINGIFY(x)  STRINGIFY_(x)


// ============================================================================
// #define CAT const auto

// #define CCT const_cast
// #define DCT dynamic_cast
// #define RCT reinterpret_cast
// #define SCT static_cast

// #define SAT static_assert


// ============================================================================
#if _MSC_VER
#  define __PRETTY_FUNCTION__ __FUNCSIG__
#endif

template <class T = void>
auto
example_pretty_function() {
  // "auto example_pretty_function()"
  const char* func = __PRETTY_FUNCTION__;
}

// ============================================================================
#include <exception>

#ifndef NDEBUG
#  define ASSERT_3(cond, msg, os)                                                  \
    do {                                                                           \
      if (!(cond)) {                                                               \
        (os) << __FILE__ ":" STRINGIFY(__LINE__) ": Assertion failed [" #cond "]"; \
        const auto& _msg = static_cast<const char*>(msg);                          \
        if (_msg != nullptr && *_msg != 0)                                         \
          (os) << ": " << (_msg);                                                  \
        (os) << std::endl;                                                         \
        std::terminate();                                                          \
      }                                                                            \
    } while (false)
#else
#  define ASSERT_3(cond, msg, os) \
    do {                          \
    } while (false)
#endif

#define ASSERT_2(cond, msg) ASSERT_3(cond, msg, std::cerr)
#define ASSERT_1(cond)      ASSERT_2(cond, nullptr)

#define ASSERT_N(_, cond, msg, os, func, ...) func

#define ASSERT(...)                                                                              \
  ASSERT_N(, ##__VA_ARGS__, ASSERT_3(__VA_ARGS__), ASSERT_2(__VA_ARGS__), ASSERT_1(__VA_ARGS__), \
           ASSERT_0(__VA_ARGS__))


// Example:
//
// ASSERT(true);
// ASSERT(true, "This must be true!");
// ASSERT(true, "This must be true; if not, print to std::cerr!", std::cerr);
