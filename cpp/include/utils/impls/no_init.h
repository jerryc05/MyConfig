/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <array>
#include <stdexcept>

#include "../helpers/cpp_type_name.h"
#include "../types.h"


namespace jerryc05 {
  template <class T>
  struct NoInitRecursive {
      NoInitRecursive() {};
      ~NoInitRecursive() {
#ifndef NDEBUG
        if (!is_constructed)
          throw std::runtime_error("Internal [" + jerryc05::cpp_type_name<T, false>() +
                                   "] must be initialized before destruction!");
#endif
        reinterpret_cast<T*>(&val)->~T();
      };

      NoInitRecursive(const NoInitRecursive&) = delete;
      NoInitRecursive& operator=(const NoInitRecursive&) = delete;

      NoInitRecursive(NoInitRecursive&&) = delete;
      NoInitRecursive& operator=(NoInitRecursive&&) = delete;

      template <class... Ts>
      void
      init(Ts&&... args) {
        new (&val) T(std::forward<Ts>(args)...);
        assume_init();
      }
      // template <class... Ts>
      // void
      // init(Ts&... args) {
      //   new (&val) T(std::forward<Ts>(args)...);
      //   assume_init();
      // }

      void
      assume_init() {
#ifndef NDEBUG
        is_constructed = true;
#endif
      }

      std::byte val[sizeof(T)];

#ifndef NDEBUG
      bool is_constructed = false;
#endif
  };
};  // namespace jerryc05
