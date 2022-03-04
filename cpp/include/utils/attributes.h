/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <bits/c++config.h>


// ============================================================================
#define RestrictPtr __restrict

#define NoDiscard _GLIBCXX_NODISCARD
#define NoReturn  _GLIBCXX_NORETURN
#define NoThrow   _GLIBCXX_NOTHROW

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

#  define NoInlineFn                     __attribute__((noinline))
//#  define NonNullFn                      __attribute__((nonnull))
#  define NonNullFn(...)                 __attribute__((nonnull, __VA_ARGS__))

// use C++11 alignas(...) keyword for variables

#  include <bits/char_traits.h>
#  define ForceInline __attribute__((always_inline)) _GLIBCXX_ALWAYS_INLINE

#else
#  define ForceInline __forceinline
#  define NoInlineFn  __declspec(noinline)
#endif


// ============================================================================
#include <memory>

#ifndef __cpp_lib_assume_aligned
#  define __cpp_lib_assume_aligned

namespace std {
  template <size_t ALIGN, size_t OFFSET, class T>
  NoDiscard ForceInline constexpr T*
  __attribute__((assume_aligned(ALIGN, OFFSET)))
  assume_aligned(T* ptr) noexcept {
    return reinterpret_cast<T*>(__builtin_assume_aligned(ptr, ALIGN));
  }
}  // namespace std
#endif
