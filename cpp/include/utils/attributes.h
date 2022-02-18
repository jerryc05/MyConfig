/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <bits/c++config.h>

#include "constants.h"


// ============================================================================
#define CONSTEXPR _GLIBCXX_CONSTEXPR
#define RESTRICT  __restrict

#define NODISCARD _GLIBCXX_NODISCARD
#define NOEXCEPT  _GLIBCXX_NOEXCEPT
#define NORETURN  _GLIBCXX_NORETURN
#define NOTHROW   _GLIBCXX_NOTHROW

#if __cplusplus >= __cpp_2017
#  define MAYBE_UNUSED [[maybe_unused]]
#else
#  define MAYBE_UNUSED
#endif


// ============================================================================
#ifndef _MSC_VER
/// Function return value depends solely on the function's arguments.
#  define CONST_ATTRIB __attribute__((const)) _GLIBCXX_CONST
/// [const] attribute + allow access global variables.
#  define PURE_ATTRIB  __attribute__((pure)) _GLIBCXX_PURE
#  define NOINLINE     __attribute__((noinline))

#  include <bits/char_traits.h>
#  define F_INLINE __attribute__((always_inline)) _GLIBCXX_ALWAYS_INLINE

#else
#  define F_INLINE __forceinline
#  define NOINLINE __declspec(noinline)
#endif


// ============================================================================
#include <memory>

#ifndef __cpp_lib_assume_aligned
#  define __cpp_lib_assume_aligned
namespace std {
  template <size_t N, class T>
  NODISCARD F_INLINE CONSTEXPR T*
  assume_aligned(T* ptr) NOEXCEPT {
    return reinterpret_cast<T*>(__builtin_assume_aligned(ptr, N));
  }
}  // namespace std
#endif
