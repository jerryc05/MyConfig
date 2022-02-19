/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <type_traits>

#include "../attributes.h"

namespace std {
#if not __cpp_lib_type_trait_variable_templates
  template <class T>
  ConstExpr bool is_const_v = is_const<T>::value;

  template <class T>
  ConstExpr bool is_lvalue_reference_v = is_lvalue_reference<T>::value;

  template <class T>
  ConstExpr bool is_rvalue_reference_v = is_rvalue_reference<T>::value;

  template <class T, class U>
  ConstExpr bool is_same_v = is_same<T, U>::value;

  template <class T>
  ConstExpr bool is_volatile_v = is_volatile<T>::value;
#endif
}  // namespace std

namespace jerryc05 {
  // c.r. https://stackoverflow.com/a/43526780/8207670

  template <std::size_t N, class T0, class... Ts>
  struct NthType {
      using value = typename NthType<N - 1U, Ts...>::value;
  };

  template <class T0, class... Ts>
  struct NthType<0U, T0, Ts...> {
      using value = T0;
  };


  template <class>
  struct FnTypes;

  template <class Ret, class... Args>
  struct FnTypes<Ret(Args...)> {
      using RetT = Ret;

      template <std::size_t N>
      using ArgT = typename NthType<N, Args...>::value;
  };
}  // namespace jerryc05
