/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <cstdint>
#include <limits>

#include "../attributes.h"

// namespace std {
//   CONSTEXPR std::size_t dynamic_extent = std::numeric_limits<std::size_t>::max();

//   template <class T, std::size_t Extent = std::dynamic_extent>
//   class span {};
// }  // namespace std

#include "../constants.h"

#define __cplusplus __cpp_2020
#include <span>



// namespace Jerryc05 {


// public:
//   template <class U>
//   NODISCARD constexpr F_INLINE const T& operator[](U i) const NOEXCEPT {
//     ASSERT(i < N, String<>("\033[1;91mIndex [") + std::to_string(i) + "]" + " out of bound [" +
//                       std::to_string(N) + "]!\033[0;31m");
//     return mPtr[i];
//   }

//   template <class U>
//   NODISCARD constexpr inline T& operator[](U i) NOEXCEPT {
//     return CCT<T&>(CCT<const decltype(*this)>(*this)[i]);
//   }

//    NODISCARD constexpr F_INLINE Usize len() const NOEXCEPT { return N; }

//    NODISCARD constexpr F_INLINE Usize size() const NOEXCEPT { return len(); }

//    NODISCARD constexpr F_INLINE bool isEmpty() const NOEXCEPT { return len() == 0; }

//    NODISCARD constexpr F_INLINE bool empty() const NOEXCEPT { return isEmpty(); }

//   NODISCARD constexpr F_INLINE const T* cbegin() const NOEXCEPT { return mPtr; }

//   NODISCARD constexpr inline T* begin() NOEXCEPT { return CCT<T*>(this->cbegin()); }

//   NODISCARD constexpr F_INLINE const T* cend() const NOEXCEPT { return cbegin() + len(); }

//   NODISCARD constexpr inline T* end() NOEXCEPT { return CCT<T*>(this->cend()); }

//   template <class IterT>
//   class RIter {
//       IterT* mRPtr;

//       constexpr explicit RIter(IterT* rPtr) NOEXCEPT: mRPtr {rPtr} {}

//       friend class Span;

//     public:
//       RIter&
//       operator++() {
//         --mRPtr;
//         return *this;
//       }

//       NODISCARD
//       IterT&
//       operator*() {
//         return *mRPtr;
//       }

//       NODISCARD
//       IterT*
//       operator->() {
//         return mRPtr;
//       }
//   };

//    NODISCARD constexpr F_INLINE RIter<const T> crbegin() const NOEXCEPT {
//     return RIter<const T> {cend() - 1};
//   }

//    NODISCARD constexpr inline RIter<T> rbegin() NOEXCEPT {
//     return RIter<T> {end() - 1};
//   }

//    NODISCARD constexpr F_INLINE RIter<const T> crend() const NOEXCEPT {
//     return RIter<const T> {cbegin() - 1};
//   }

//    NODISCARD constexpr inline RIter<T> rend() NOEXCEPT {
//     return RIter<T> {begin() - 1};
//   }


//   template <class T, Usize N>
//   class Span {
//       T* mPtr;

//       Span() NOEXCEPT = default;

//     public:
//        constexpr explicit Span(T (&arr)[N]) NOEXCEPT: mPtr {arr} {}

//       template <Usize SIZE, class U>
//       friend constexpr Span<U, SIZE> fromPtr(U* ptr) NOEXCEPT;

//       SpanImpl
//   };

//   template <class T>
//   class Span<T, 0> {
//       T*          mPtr;
//       const Usize N;

//     public:
//        constexpr Span(T* ptr, decltype(N) len) NOEXCEPT: mPtr {ptr}, N {len} {}

//       SpanImpl
//   };

//   template <Usize SIZE, class T>
//   NODISCARD constexpr Span<T, SIZE>
//   fromPtr(T* ptr) NOEXCEPT {
//     Span<T, SIZE> span;
//     span.mPtr = ptr;
//     return span;
//   }

//   template <class T>
//   Span(T, Usize) -> Span<T, 0>;

//   template <class T, Usize N>
//   Span(T (&)[N]) -> Span<T, N>;

// }  // namespace Jerryc05
