/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <bits/c++config.h>


// ============================================================================
#define RestrictPtr __restrict

#if __cplusplus >= 201603
#  define NoDiscard [[nodiscard]]
#elif !defined(_MSC_VER)
#  define NoDiscard __attribute__((warn_unused_result)) __attribute_warn_unused_result__
#else
#  define NoDiscard _Check_return_
#endif

#define NoReturn _GLIBCXX_NORETURN
#define NoThrow  _GLIBCXX_NOTHROW

#if __cplusplus >= 201603
#  define MaybeUnused [[maybe_unused]]
#else
#  define MaybeUnused __attribute__((unused))
#endif


// ============================================================================
#ifndef _MSC_VER
/// Function return value depends solely on the function's arguments.
#  define ConstFn          __attribute__((const)) _GLIBCXX_CONST
/// [const] attribute + allow access global variables.
#  define PureFn           __attribute__((pure)) _GLIBCXX_PURE
#  define ReturnsNonNullFn __attribute__((returns_nonnull))

#  define NoInlineFn     __attribute__((noinline))
//#  define NonNullFn                      __attribute__((nonnull))
#  define NonNullFn(...) __attribute__((nonnull __VA_ARGS__))

// use C++11 alignas(...) keyword for variables

#  include <bits/char_traits.h>
#  define ForceInline __attribute__((always_inline)) _GLIBCXX_ALWAYS_INLINE

#else
#  define ForceInline __forceinline
#  define NoInlineFn  __declspec(noinline)
#endif
