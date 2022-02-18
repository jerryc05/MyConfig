/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include "constants.h"
#include "macros.h"


// ============================================================================
#include "impls/stddef_compat.h"
#include "impls/type_traits_compat.h"


// ============================================================================
// using F32 = float;
// using F64 = double;

#include <cstdint>
// using I8    = std::int8_t;
// using I8F   = std::int_fast8_t;
// using I16   = std::int16_t;
// using I16F  = std::int_fast16_t;
// using I32   = std::int32_t;
// using I32F  = std::int_fast32_t;
// using I64   = std::int64_t;
// using I64F  = std::int_fast64_t;
// using IMax  = std::intmax_t;
// using Isize = std::ptrdiff_t;

// using U8    = std::uint8_t;
// using U8F   = std::uint_fast8_t;
// using U16   = std::uint16_t;
// using U16F  = std::uint_fast16_t;
// using U32   = std::uint32_t;
// using U32F  = std::uint_fast32_t;
// using U64   = std::uint64_t;
// using U64F  = std::uint_fast64_t;
// using UMax  = std::uintmax_t;
// using Usize = std::size_t;


// ============================================================================
// #include <deque>
// #define Deque std::deque

// #include <queue>
// #define Pq std::priority_queue

// #include <string>
// using String = std::string;

// #include <map>
// #define TreeMap std::map

// #include <set>
// #define TreeSet std::set

// #include <vector>
// #define Vec std::vector


// ============================================================================
// #if __cplusplus >= __cpp_2011
// #  include <array>
// #  define Arr std::array

// #  include <functional>
// #  define Fn std::function

// #  include <unordered_map>
// #  define HashMap std::unordered_map

// #  include <unordered_set>
// #  define HashSet std::unordered_set
// #endif


// ============================================================================
// #if __cplusplus >= __cpp_2017
// #  include <optional>
// template <class T>
// using Optional = std::optional<T>;

// #  include <string_view>
// using Str = std::string_view;

// #  include <variant>
// template <class... Ts>
// using Variant = std::variant<Ts...>;
// #endif


// ============================================================================
#if __cplusplus >= __cpp_2020
#  include <span>
#else
#  include "impls/span.h"
#endif

// #define Span std::span
