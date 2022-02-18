/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <type_traits>

namespace std {
#if __cplusplus < __cpp_2011 or __cplusplus > __cpp_2020
  template <typename T>
  struct is_pod
      : public integral_constant<bool, std::is_trivial_v<T> && std::is_standard_layout_v<T>> {};


  template <typename T>
  constexpr bool is_pod_v = is_pod<_Tp>::value = is_pod<T>::value;
#endif
}  // namespace std