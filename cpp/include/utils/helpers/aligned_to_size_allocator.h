/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#ifndef NDEBUG
#  include <iostream>
#endif

#include <cstdlib>
#include <limits>
#include <new>

#include "../attributes.h"
#include "../compats/memory.h"
#include "../compats/type_traits.h"
#include "../math.h"

namespace jerryc05 {

  /// Maximum effective alignment is 2^16 bytes. Might have unaligned accesses.
  template <class T,
            std::size_t ALIGN                                        = sizeof(T),
            class AlignT                                             = uint16_t,
            std::enable_if_t<jerryc05::is_power_of_two(ALIGN), bool> = true>
  struct AlignedNoInitAllocator {
    NoDiscard static constexpr T* malloc(std::size_t count) {
      return realloc<ALIGN, AlignT>(nullptr, count);
    }

    NoDiscard static constexpr T* realloc(T* ptr, std::size_t count) {
      constexpr auto& align = effective_align(ALIGN);

      std::size_t alloc_count;
      if (__builtin_mul_overflow(align_calc, count, &alloc_count)) {
#ifndef NDEBUG
        std::clog << "[" << align_calc << "] * [" << count << "] caused overflow\n";
#endif
        return nullptr;

      } else if (__builtin_add_overflow(alloc_count, sizeof(AlignT) - 1, &alloc_count)) {
#ifndef NDEBUG
        std::clog << "[" << alloc_count << "] + [" << sizeof(AlignT) - 1 << "] caused overflow\n";
#endif
        return nullptr;

      } else {
        if (ptr == nullptr)
          ptr = std::malloc(alloc_count);
        else
          ptr = std::realloc(_get_start_addr(ptr), alloc_count);
        return _set_start_addr_info<align>(ptr);
      }
    }

    NoDiscard static constexpr void free(T* p) { std::free(_get_start_addr(p)); }

   private:
    NoDiscard static constexpr auto effective_align(std::size_t align) {
      return std::max(align, std::numeric_limits<AlignT>::max() + 1);
    }

    NoDiscard static constexpr T* _set_start_addr_info(void* ptr) {
      constexpr auto& align     = effective_align(ALIGN);
      const auto&     remainder = (static_cast<std::uintptr_t>(ptr) + sizeof(AlignT) - 1) % align;
      const auto&     offset    = static_cast<AlignT>(align - remainder);
      const auto&     ret       = std::assume_aligned<align>(static_cast<T*>(ptr + offset));

      assert("[offset] must be larger than [sizeof(AlignT)]" && offset >= sizeof(AlignT));

      *(static_cast<AlignT*>(ret) - sizeof(AlignT)) = offset;
      return ret;
    }

    NoDiscard static constexpr void* _get_start_addr(T* ptr) {
      const auto& offset = *static_cast<AlignT*>(static_cast<char*>(ptr) - sizeof(AlignT));
      return static_cast<char*>(ptr) - offset;
    }
  };
};  // namespace jerryc05
