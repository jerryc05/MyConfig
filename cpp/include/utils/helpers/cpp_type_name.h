/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include "../types.h"

#if defined(__GNUC__) || defined(__clang__)
#  include <cxxabi.h>
#endif


template <class T>
auto
cpp_type_name(std::string& output) {
  const auto& name = typeid(T).name();

  output.reserve(output.size() + 64);
  if (std::is_const_v<std::remove_reference_t<T>>) {
    output += "const ";
  }
  if (std::is_volatile_v<std::remove_reference_t<T>>) {
    output += "volatie ";
  }

#if defined(__GNUC__) || defined(__clang__)
  int   status;
  auto* demangled = abi::__cxa_demangle(name, nullptr, nullptr, &status);
  if (status == 0) {
    output += demangled;
    std::free(demangled);
  }

#else
  s = name;
#endif

  if (std::is_lvalue_reference_v<T>) {
    output += '&';
  } else if (std::is_rvalue_reference_v<T>) {
    output += "&&";
  }
  return output;
}


template <class T>
auto
cpp_type_name() {
  std::string s;
  return cpp_type_name<T>(s);
}
