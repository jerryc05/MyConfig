/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <iomanip>
#include <ostream>

#include "../attributes.h"
#include "../macros.h"
#include "../types.h"


template <Usize MAX_SIZE                                        = 128,
          class CharT                                           = char,
          std::basic_ostream<CharT, std::char_traits<CharT>> OS = std::cout>
void
debugBytes(void* ptr, Usize size) {
  auto charTPtr = RCT<CharT*>(ptr);

  CONSTEXPR auto hexWidth        = 2 * sizeof(CharT);
  const auto     sizeToPrint     = std::min(size, MAX_SIZE);
  const auto     printCharMargin = [sizeToPrint]() {
    OS << '|' << std::setfill('-') << std::setw(SCT<I32>(hexWidth * sizeToPrint)) << ""
       << "|\n";
    OS.copyfmt(std::ios(nullptr));
  };

  OS << "\033[1;94m";
  printCharMargin();

  for (U8 j = 0; j < 2; ++j) {
    OS << "\033[1;94m|\033[0m";
    for (Usize i = 0; i < sizeToPrint; ++i) {
      if (j == 0) {
        OS << std::setw(hexWidth) << charTPtr[i];
      } else {
        OS << "\033[0;9" << (i & 1 ? '5' : '6') << 'm' << std::setw(hexWidth) << std::hex
           << +charTPtr[i] << std::dec;
      }
    }
    OS << "\033[1;94m|\033[0m\n" << std::setfill('0');
  }

  OS << "\033[1;94m";
  printCharMargin();
  std::cerr << "\033[0m";
}
