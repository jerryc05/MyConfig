/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include "../types.h"

namespace jerryc05 {
  template <class T,
            std::enable_if_t<std::is_trivial_v<T> && std::is_standard_layout_v<T>, bool> = true>
  struct NoInit {
      NoInit() {};
      ~NoInit() = default;

      NoInit(const NoInit&) {

      };
      NoInit& operator=(const NoInit&) = delete;

      NoInit(NoInit&&) = delete;
      NoInit& operator=(NoInit&&) = delete;

      T val;
  };


  template <class T>
  struct NoInitRecursive {
      NoInit()  = delete;
      ~NoInit() = delete;

      NoInit(const NoInit&) = delete;
      NoInit& operator=(const NoInit&) = delete;

      NoInit(NoInit&&) = delete;
      NoInit& operator=(NoInit&&) = delete;

      T val;
  };
};  // namespace jerryc05
