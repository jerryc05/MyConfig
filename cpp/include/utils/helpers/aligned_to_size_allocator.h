/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#ifndef NDEBUG
#  include <iostream>
#endif

#include <cstdlib>

#include "../compats/memory.h"

namespace jerryc05 {

  template <class T>
  ForceInline T* aligned_to_size_alloc(std::size_t count = 1) noexcept(
      noexcept(aligned_alloc(2ul, 0ul))) {
    constexpr std::size_t ALIGN = sizeof(T);

    std::size_t alloc_count;
    if (__builtin_mul_overflow(sizeof(T), count, &alloc_count)) {
#ifndef NDEBUG
      std::clog << "Multiplication of [" << sizeof(T) << "] * [" << count << "] caused overflow\n";
#endif
      return nullptr;
    } else
      return std::assume_aligned<ALIGN>(static_cast<T*>(aligned_alloc(ALIGN, alloc_count)));
  }
}  // namespace jerryc05
