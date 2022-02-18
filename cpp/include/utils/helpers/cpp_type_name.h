/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include "../types.h"

#if __GNUC__ || __clang__
#  include <cxxabi.h>
#endif


namespace jerryc05 {
  template <class T, bool WITH_MODIFIER = true>
  auto
  cpp_type_name(std::string& output) {
    const auto& name = typeid(T).name();

    if (WITH_MODIFIER) {
      output.reserve(output.size() + 64);
      if (std::is_const_v<std::remove_reference_t<T>>) {
        output += "const ";
      }
      if (std::is_volatile_v<std::remove_reference_t<T>>) {
        output += "volatie ";
      }
    }

#if __GNUC__ || __clang__
    int   status;
    auto* demangled = abi::__cxa_demangle(name, nullptr, nullptr, &status);
    if (status == 0) {
      output += demangled;
      std::free(demangled);
    }
#else
    s = name;
#endif

    if (WITH_MODIFIER) {
      if (std::is_lvalue_reference_v<T>) {
        output += '&';
      } else if (std::is_rvalue_reference_v<T>) {
        output += "&&";
      }
    }
    return output;
  }


  template <class T, bool WITH_MODIFIER = true>
  auto
  cpp_type_name(std::string&& s = std::string {}) {
    cpp_type_name<T, WITH_MODIFIER>(s);
    return s;
  }
}  // namespace jerryc05
