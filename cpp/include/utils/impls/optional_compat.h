/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <cstddef>

#if __cplusplus >= 201606
#  include <optional>
#elif __cplusplus >= 201411
#  include <experimental/optional>
#else
namespace std {
  template <class T>
  class optional;
}  // namespace std
#endif
