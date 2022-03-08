/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <cmath>

#include "attributes.h"
#include "compats/type_traits.h"

namespace jerryc05 {

  template <class T, std::enable_if_t<std::is_same_v<T, unsigned int>, bool> = true>
  constexpr ForceInline auto _clz(T x) {
    return __builtin_clz(x);
  }

  template <class T, std::enable_if_t<std::is_same_v<T, unsigned long>, bool> = true>
  constexpr ForceInline auto _clz(T x) {
    return __builtin_clzl(x);
  }

  template <class T, std::enable_if_t<std::is_same_v<T, unsigned long long>, bool> = true>
  constexpr ForceInline auto _clz(T x) {
    return __builtin_clzll(x);
  }

  template <class T>
  constexpr ForceInline auto log2_floor(T x) {
    const auto& clz = _clz(x);
    return static_cast<decltype(clz)>(std::numeric_limits<decltype(x)>::digits - 1) - clz;
  }

  template <class T>
  constexpr ForceInline auto log2_ceil(T x) {
    return log2_floor(x - 1) + 1;
  }
}  // namespace jerryc05
