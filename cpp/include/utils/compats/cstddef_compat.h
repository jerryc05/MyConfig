/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <cstddef>

namespace std {
#if not __cpp_lib_byte
  enum class byte : unsigned char {};
#endif
}  // namespace std

// using Byte = std::byte;
