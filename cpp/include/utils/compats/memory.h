/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <memory>

#include "../attributes.h"

namespace jerryc05 {

  template <size_t ALIGN, class T, std::size_t OFFSET = 0>
  NoDiscard ForceInline constexpr T* __attribute__((assume_aligned(ALIGN, OFFSET)))
  assume_aligned(T* ptr) noexcept {
    return static_cast<T*>(__builtin_assume_aligned(ptr, ALIGN, OFFSET));
  }
}  // namespace jerryc05


#ifndef __cpp_lib_assume_aligned
#  define __cpp_lib_assume_aligned

namespace std {

  template <size_t ALIGN, class T>
  auto assume_aligned = jerryc05::assume_aligned<ALIGN, T>;
}  // namespace std

#endif
