/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <execinfo.h>

#include <cstring>
#include <iostream>

#include "types.h"


template <Usize NUM_TRACES = 16>
void
stackTraceSigHandler(int sig) {
  std::cerr << "\n\033[1;91m"
               "===== Error: Signal ["
            << strsignal(sig) << " (" << sig
            << ")] ====="
               "\033[0;31m\n";

#ifndef NDEBUG
  Arr<void*, NUM_TRACES> btArr;
  auto                   traceSize = backtrace(btArr.data(), btArr.size());

  // print out all the frames to stderr
  backtrace_symbols_fd(btArr.data(), traceSize, stderr);
#endif

  std::cerr << "\033[0m";
  std::_Exit(128 + sig);
}
