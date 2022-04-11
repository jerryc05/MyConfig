/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <iostream>

template<std::ostream& os>
struct DbgPrint {
  constexpr DbgPrint() noexcept {};
  ~DbgPrint() noexcept {};
  DbgPrint(const DbgPrint&)            = delete;
  DbgPrint& operator=(const DbgPrint&) = delete;
  DbgPrint(DbgPrint&&)                 = delete;
  DbgPrint& operator=(DbgPrint&&)      = delete;

  template <class T>
  friend const auto& operator<<(const DbgPrint& x, const T& t) {
#ifdef DEBUG
    os << t;
#endif
    return x;
  }

  friend const auto& operator<<(const DbgPrint& x, std::ostream& (*f)(std::ostream&)) {
#ifdef DEBUG
    f(os);
#endif
    return x;
  }
};

using DbgCout = DbgPrint<std::cout>;
using DbgClog = DbgPrint<std::clog>;
using DbgCerr = DbgPrint<std::cerr>;
