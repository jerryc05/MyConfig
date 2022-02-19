/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <cstdint>
#include <limits>

#include "../attributes.h"

#if __cplusplus >= __cpp_2020
#  include <span>
#endif

#if not __cpp_lib_span
namespace std {
  ConstExpr std::size_t dynamic_extent = std::numeric_limits<std::size_t>::max();

  //   template <class T, std::size_t Extent = std::dynamic_extent>
  //   class span {};
}  // namespace std
#endif


// namespace Jerryc05 {


// public:
//   template <class U>
//   NoDiscard ConstExpr ForceInline const T& operator[](U i) const NoExcept {
//     ASSERT(i < N, String<>("\033[1;91mIndex [") + std::to_string(i) + "]" + " out of bound [" +
//                       std::to_string(N) + "]!\033[0;31m");
//     return mPtr[i];
//   }

//   template <class U>
//   NoDiscard ConstExpr inline T& operator[](U i) NoExcept {
//     return CCT<T&>(CCT<const decltype(*this)>(*this)[i]);
//   }

//    NoDiscard ConstExpr ForceInline Usize len() const NoExcept { return N; }

//    NoDiscard ConstExpr ForceInline Usize size() const NoExcept { return len(); }

//    NoDiscard ConstExpr ForceInline bool isEmpty() const NoExcept { return len() == 0; }

//    NoDiscard ConstExpr ForceInline bool empty() const NoExcept { return isEmpty(); }

//   NoDiscard ConstExpr ForceInline const T* cbegin() const NoExcept { return mPtr; }

//   NoDiscard ConstExpr inline T* begin() NoExcept { return CCT<T*>(this->cbegin()); }

//   NoDiscard ConstExpr ForceInline const T* cend() const NoExcept { return cbegin() + len(); }

//   NoDiscard ConstExpr inline T* end() NoExcept { return CCT<T*>(this->cend()); }

//   template <class IterT>
//   class RIter {
//       IterT* mRPtr;

//       ConstExpr explicit RIter(IterT* rPtr) NoExcept: mRPtr {rPtr} {}

//       friend class Span;

//     public:
//       RIter&
//       operator++() {
//         --mRPtr;
//         return *this;
//       }

//       NoDiscard
//       IterT&
//       operator*() {
//         return *mRPtr;
//       }

//       NoDiscard
//       IterT*
//       operator->() {
//         return mRPtr;
//       }
//   };

//    NoDiscard ConstExpr ForceInline RIter<const T> crbegin() const NoExcept {
//     return RIter<const T> {cend() - 1};
//   }

//    NoDiscard ConstExpr inline RIter<T> rbegin() NoExcept {
//     return RIter<T> {end() - 1};
//   }

//    NoDiscard ConstExpr ForceInline RIter<const T> crend() const NoExcept {
//     return RIter<const T> {cbegin() - 1};
//   }

//    NoDiscard ConstExpr inline RIter<T> rend() NoExcept {
//     return RIter<T> {begin() - 1};
//   }


//   template <class T, Usize N>
//   class Span {
//       T* mPtr;

//       Span() NoExcept = default;

//     public:
//        ConstExpr explicit Span(T (&arr)[N]) NoExcept: mPtr {arr} {}

//       template <Usize SIZE, class U>
//       friend ConstExpr Span<U, SIZE> fromPtr(U* ptr) NoExcept;

//       SpanImpl
//   };

//   template <class T>
//   class Span<T, 0> {
//       T*          mPtr;
//       const Usize N;

//     public:
//        ConstExpr Span(T* ptr, decltype(N) len) NoExcept: mPtr {ptr}, N {len} {}

//       SpanImpl
//   };

//   template <Usize SIZE, class T>
//   NoDiscard ConstExpr Span<T, SIZE>
//   fromPtr(T* ptr) NoExcept {
//     Span<T, SIZE> span;
//     span.mPtr = ptr;
//     return span;
//   }

//   template <class T>
//   Span(T, Usize) -> Span<T, 0>;

//   template <class T, Usize N>
//   Span(T (&)[N]) -> Span<T, N>;

// }  // namespace Jerryc05



// #define Span std::span
