/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <cmath>

#include "attributes.h"

namespace jerryc05 {

  constexpr ForceInline auto _clz(unsigned int x) { return __builtin_clz(x); }

  constexpr ForceInline auto _clz(unsigned long x) { return __builtin_clzl(x); }

  constexpr ForceInline auto _clz(unsigned long long x) { return __builtin_clzll(x); }

  template <class T>
  constexpr ForceInline auto log2_floor(T x) {
    constexpr auto clz = _clz(x);
    return static_cast<decltype(clz)>(std::numeric_limits<decltype(x)>::digits - 1) - clz;
  }

  template <class T>
  constexpr ForceInline T log2_ceil(T x) {
    return log2_floor(x - 1) + 1;
  }
}  // namespace jerryc05
