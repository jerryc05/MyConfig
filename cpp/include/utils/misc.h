/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <iostream>

#include "macros.h"
#include "types.h"


template <Usize MAX_SIZE = 128, class CharT = char>
inline void
debugBytes(void* ptr, Usize size) {
  auto charTPtr = RCT<CharT*>(ptr);

  const auto hexWidth        = 2 * sizeof(CharT);
  const auto sizeToPrint     = std::min(size, MAX_SIZE);
  const auto printCharMargin = [sizeToPrint]() {
    std::cout << '|' << std::setfill('-') << std::setw(SCT<I32>(hexWidth * sizeToPrint)) << ""
              << "|\n";
    std::cout.copyfmt(std::ios(nullptr));
  };

  std::cout << "\033[1;94m";
  printCharMargin();

  for (U8 j = 0; j < 2; ++j) {
    std::cout << "\033[1;94m|\033[0m";
    for (Usize i = 0; i < sizeToPrint; ++i) {
      if (j == 0) {
        std::cout << std::setw(hexWidth) << charTPtr[i];
      } else {
        std::cout << "\033[0;9" << (i & 1 ? '5' : '6') << 'm' << std::setw(hexWidth) << std::hex
                  << +charTPtr[i] << std::dec;
      }
    }
    std::cout << "\033[1;94m|\033[0m\n" << std::setfill('0');
  }

  std::cout << "\033[1;94m";
  printCharMargin();
  std::cerr << "\033[0m";
}
