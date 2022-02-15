/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once


// Annotations
#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
#   define MAYBE_UNUSED [[maybe_unused]]
#   define NODISCARD    [[nodiscard]]
#   define NOEXCEPT     noexcept
#   define NORETURN     [[noreturn]]
#else
#   define MAYBE_UNUSED
#   define NODISCARD
#   define NOEXCEPT
#   define NORETURN
#endif




// Asserts & Casts & Const auto
#define CAT   const auto
#define CCT   const_cast
#define DCT   dynamic_cast
#define RCT   reinterpret_cast
#define SCT   static_cast
#define SAT   static_assert

#ifndef NDEBUG
#   define ASSERT_3(cond, msg, os) \
      do {  if (!(cond)) { \
              (os) << __FILE__ << ':' << __LINE__ << '\t' \
                   << "Assertion `" #cond "` failed: " << (msg) << std::endl; \
              abort(); } \
      } while (false)
#else
#   define ASSERT_3(cond, msg, os) do {} while (false)
#endif

#define ASSERT_2(cond, msg)                   ASSERT_3(cond, msg, std::cerr)
#define ASSERT_1(cond)                        ASSERT_2(cond, "")

#define ASSERT_N(_, cond, msg, os, func, ...) func

#define ASSERT(...)                           ASSERT_N(,##__VA_ARGS__,\
                                                ASSERT_3(__VA_ARGS__),\
                                                ASSERT_2(__VA_ARGS__),\
                                                ASSERT_1(__VA_ARGS__),\
                                                ASSERT_0(__VA_ARGS__))



// Includes
#include <algorithm>
#include <array>
#include <cassert>
#include <cmath>
#include <csignal>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <deque>
#include <execinfo.h>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <map>
#include <memory>
#include <numeric>
#include <queue>
#include <set>
#include <tuple>
#include <unistd.h>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

// Workarounds
#if (__GNUC__ >= 7) || (__clang_major__ * 10 + __clang_minor__ >= 39)

#   include <optional>
#   include <string_view>
#   include <variant>

template<typename T>
using Optional MAYBE_UNUSED = std::optional<T>;
template<typename T=char>
using Str MAYBE_UNUSED = std::basic_string_view<T, std::char_traits<T>>;
SAT(std::is_same<Str<>, std::string_view>::value);
template<typename... Ts>
using Variant MAYBE_UNUSED = std::variant<Ts...>;

#   if (__GNUC__ * 10 + __GNUC_MINOR__ > 47) || (__clang_major__ * 10 + __clang_minor__ >= 34)

#       include <functional>

template<typename T>
using Fn = std::function<T>;
#   endif

#endif

// Keywords
#if __GNUC__ || __clang_major__ || _MSC_VER
#   if __GNUC__ || __clang_major__
#       define CONST_ATTRIB __attribute__((const))
#       define F_INLINE     __attribute__((always_inline))
#       define NOINLINE     __attribute__((noinline))
#       define PURE_ATTRIB  __attribute__((pure))
#   else
#       define CONST_ATTRIB
#       define F_INLINE     __forceinline
#       define NOINLINE     __declspec(noinline)
#       define PURE_ATTRIB
#   endif
#   define RESTRICT         __restrict

#else
#   define CONST_ATTRIB
#   define F_INLINE         inline
#   define NOINLINE
#   define RESTRICT
#   define PURE_ATTRIB
#endif


// f:off
using Byte  MAYBE_UNUSED = std::byte;
using F32   MAYBE_UNUSED = float;
using F64   MAYBE_UNUSED = double;
using I8    MAYBE_UNUSED = std::int8_t;
using I8F   MAYBE_UNUSED = std::int_fast8_t;
using I16   MAYBE_UNUSED = std::int16_t;
using I16F  MAYBE_UNUSED = std::int_fast16_t;
using I32   MAYBE_UNUSED = std::int32_t;
using I32F  MAYBE_UNUSED = std::int_fast32_t;
using I64   MAYBE_UNUSED = std::int64_t;
using I64F  MAYBE_UNUSED = std::int_fast64_t;
using IMax  MAYBE_UNUSED = std::intmax_t;
using Isize MAYBE_UNUSED = std::ptrdiff_t;
using U8    MAYBE_UNUSED = std::uint8_t;
using U8F   MAYBE_UNUSED = std::uint_fast8_t;
using U16   MAYBE_UNUSED = std::uint16_t;
using U16F  MAYBE_UNUSED = std::uint_fast16_t;
using U32   MAYBE_UNUSED = std::uint32_t;
using U32F  MAYBE_UNUSED = std::uint_fast32_t;
using U64   MAYBE_UNUSED = std::uint64_t;
using U64F  MAYBE_UNUSED = std::uint_fast64_t;
using UMax  MAYBE_UNUSED = std::uintmax_t;
using Usize MAYBE_UNUSED = std::size_t;
// f:on


template<typename T, Usize S>
using Arr MAYBE_UNUSED = std::array<T, S>;
template<typename T>
using Deque MAYBE_UNUSED = std::deque<T>;
template<
        typename Key,
        typename Val,
        typename Hash = std::hash<Key>,
        typename KeyEq = std::equal_to<Key>,
        typename Alloc = std::allocator<std::pair<const Key, Val> >
>
using HashMap MAYBE_UNUSED = std::unordered_map<Key, Val, Hash, KeyEq, Alloc>;
SAT(std::is_same<HashMap<int, char>, std::unordered_map<int, char>>::value);
template<
        typename Val,
        typename Hash = std::hash<Val>,
        typename KeyEq = std::equal_to<Val>,
        typename Alloc = std::allocator<Val>
>
using HashSet MAYBE_UNUSED = std::unordered_set<Val, Hash, KeyEq, Alloc>;
SAT(std::is_same<HashSet<int>, std::unordered_set<int> >::value);
template<typename T1, typename T2>
using Pair MAYBE_UNUSED = std::pair<T1, T2>;
using PcwsCstrt = std::piecewise_construct_t;
constexpr const static PcwsCstrt &pcwsCstrt MAYBE_UNUSED = std::piecewise_construct;
template<
        typename T,
        typename Cont=std::vector<T>,
        typename Cmp=std::less<typename Cont::value_type>
>
using Pq MAYBE_UNUSED = std::priority_queue<T, Cont, Cmp>;
SAT(std::is_same<Pq<int>, std::priority_queue<int>>::value);
template<
        typename T=char,
        typename Alloc=std::allocator<T>
>
using String MAYBE_UNUSED = std::basic_string<T, std::char_traits<T>, Alloc>;
SAT(std::is_same<String<>, std::string>::value);
template<
        typename Key,
        typename Val,
        typename Cmp = std::less<Key>,
        typename Alloc = std::allocator<std::pair<const Key, Val> >
>
using TreeMap MAYBE_UNUSED = std::map<Key, Val, Cmp, Alloc>;
SAT(std::is_same<TreeMap<int, char>, std::map<int, char>>::value);
template<
        typename Val,
        typename Cmp = std::less<Val>,
        typename Alloc = std::allocator<Val>
>
using TreeSet MAYBE_UNUSED = std::set<Val, Cmp, Alloc>;
SAT(std::is_same<TreeSet<int>, std::set<int> >::value);
template<typename... Ts>
using Tuple MAYBE_UNUSED = std::tuple<Ts...>;
template<typename T, typename Alloc = std::allocator<T>>
using Vec MAYBE_UNUSED = std::vector<T, Alloc>;
SAT(std::is_same<Vec<int>, std::vector<int>>::value);


template<typename Char>
MAYBE_UNUSED F_INLINE void
skipCurrentLine(
        std::basic_istream<Char> &is,
        typename std::basic_istream<Char>::int_type delim = '\n',
        std::streamsize maxLen = std::numeric_limits<std::streamsize>::max()) {
  is.ignore(maxLen, delim);
}

template<typename T>
MAYBE_UNUSED F_INLINE Arr<Byte, sizeof(T)>
allocUninit() {
  Arr<Byte, sizeof(T)> arr;
  return arr;
}

template<typename T, typename... Args>
MAYBE_UNUSED F_INLINE T *
initInPlace(void *RESTRICT addr, Args &&... args) {
  return new(addr) T(args ...);
}

MAYBE_UNUSED void
lateInitExample() {
  using T = Vec<int>;
  auto rawBytesOfT = allocUninit<T>();
  auto &useThisAsTRef = *initInPlace<T>(
          &rawBytesOfT, std::initializer_list<T::value_type>{1, 2, 3});
  SAT(std::is_same<decltype(useThisAsTRef), T &>::value);

  // do anything here

  // you must manually destruct `T` reference to prevent memory leak
  useThisAsTRef.~T();
}


template<Usize MAX_SIZE = 128, typename CharT = char>
inline void
debugBytes(void *RESTRICT ptr, Usize size) {
  auto charTPtr = RCT<CharT *>(ptr);

  const auto hexWidth        = 2 * sizeof(CharT);
  const auto sizeToPrint     = std::min(size, MAX_SIZE);
  const auto printCharMargin = [sizeToPrint]() {
    std::cout << '|'
              << std::setfill('-') << std::setw(SCT<I32>(hexWidth * sizeToPrint)) << ""
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
        std::cout << "\033[0;9" << (i & 1 ? '5' : '6') << 'm'
                  << std::setw(hexWidth) << std::hex << +charTPtr[i] << std::dec;
      }
    }
    std::cout << "\033[1;94m|\033[0m\n" << std::setfill('0');
  }

  std::cout << "\033[1;94m";
  printCharMargin();
  std::cerr << "\033[0m";
}


template<Usize NUM_TRACES = 16>
void
stackTraceSigHandler(int sig) {
  std::cerr << "\n\033[1;91m===== "
            << "Error: Signal [" << strsignal(sig) << " (" << sig << ")]"
            << " =====\033[0;31m\n";

#ifndef NDEBUG
  Arr<void *, NUM_TRACES> btArr;
  auto                    traceSize = backtrace(btArr.data(), btArr.size());

  // print out all the frames to stderr
  backtrace_symbols_fd(btArr.data(), traceSize, STDERR_FILENO);
#endif

  std::cerr << "\033[0m";
  std::exit(128 + sig);
}



// Memory Resource
#if (__GNUC__ >= 9) || (__clang_major__ >= 9)

#   include <memory_resource>

using MonoBufRes = std::pmr::monotonic_buffer_resource;
template<typename T>
using PmrAlloc = std::pmr::polymorphic_allocator<T>;


class MyNewDelResExample : public std::pmr::memory_resource {
private:
  void *do_allocate(Usize size, Usize alignment) override;

  void do_deallocate(void *ptr, Usize size, Usize alignment) override;

  NODISCARD bool do_is_equal(const std::pmr::memory_resource &other) const NOEXCEPT override;
};

void *
MyNewDelResExample::do_allocate(Usize size, Usize alignment) {
  std::cout << "Al--locating " << size << '\n';
  return std::pmr::new_delete_resource()->allocate(size, alignment);
}

void
MyNewDelResExample::do_deallocate(void *ptr, Usize size, Usize alignment) {
  std::cout << "Deallocating " << size << ":\n";
  debugBytes<>(ptr, size);

  return std::pmr::new_delete_resource()->deallocate(ptr, size, alignment);
}

NODISCARD bool
MyNewDelResExample::do_is_equal(const std::pmr::memory_resource &other) const NOEXCEPT {
  return std::pmr::new_delete_resource()->is_equal(other);
}


template<Usize CAPACITY>
MAYBE_UNUSED void
pmrContainerExample() {
  MyNewDelResExample mem;
  std::pmr::set_default_resource(&mem);

  Byte       buf[CAPACITY];
  MonoBufRes res(std::data(buf), std::size(buf));

  using PmrStr = String<char, PmrAlloc<char>>;
  Vec<PmrStr, PmrAlloc<PmrStr>> v(4, &res);  // Do this!
  Vec<PmrStr, PmrAlloc<PmrStr>> v2({"This will be heap-allocated!"}, &res);  // Don't do this!

  v.emplace_back("This will be stack-allocated!");  // Do this!
  v.push_back("This will be heap-allocated!");  // Don't do this!

  PmrStr s1("This will be stack-allocated!", &res);  // Do this!
  PmrStr s2("This will be heap-allocated!");  // Don't do this!
}

#endif


namespace Jerryc05 {

#define SpanImpl \
public: \
template<typename U> \
NODISCARD constexpr F_INLINE \
const T &operator[](U i) const NOEXCEPT {\
  ASSERT(i < N,\
         String<>("\033[1;91mIndex [") + std::to_string(i) + "]"\
                 + " out of bound [" + std::to_string(N) + "]!\033[0;31m");\
  return mPtr[i];\
}\
\
template<typename U>\
NODISCARD constexpr inline \
T &operator[](U i) NOEXCEPT {\
  return CCT<T &>(CCT<const decltype(*this)>(*this)[i]);\
}\
\
MAYBE_UNUSED NODISCARD constexpr F_INLINE \
Usize len() const NOEXCEPT {\
  return N;\
}\
\
MAYBE_UNUSED NODISCARD constexpr F_INLINE \
Usize size() const NOEXCEPT {\
  return len();\
}\
\
MAYBE_UNUSED NODISCARD constexpr F_INLINE \
bool isEmpty() const NOEXCEPT {\
  return len() == 0;\
}\
\
MAYBE_UNUSED NODISCARD constexpr F_INLINE \
bool empty() const NOEXCEPT {\
  return isEmpty();\
}\
\
NODISCARD constexpr F_INLINE \
const T *cbegin() const NOEXCEPT {\
  return mPtr;\
}\
\
NODISCARD constexpr inline \
T *begin() NOEXCEPT {\
  return CCT<T *>(this->cbegin());\
}\
\
NODISCARD constexpr F_INLINE \
const T *cend() const NOEXCEPT {\
  return cbegin() + len();\
}\
\
NODISCARD constexpr inline \
T *end() NOEXCEPT {\
  return CCT<T *>(this->cend());\
}\
\
template<typename IterT>\
class RIter {\
  IterT *mRPtr;\
\
  constexpr explicit\
  RIter(IterT *rPtr) NOEXCEPT: mRPtr{rPtr} {}\
\
  friend class Span;\
\
public:\
  RIter &operator++() {\
    --mRPtr;\
    return *this;\
  }\
\
  NODISCARD\
  IterT &operator*() {\
    return *mRPtr;\
  }\
\
  NODISCARD\
  IterT *operator->() {\
    return mRPtr;\
  }\
};\
\
MAYBE_UNUSED NODISCARD constexpr F_INLINE \
RIter<const T> crbegin() const NOEXCEPT {\
  return RIter<const T>{cend() - 1};\
}\
\
MAYBE_UNUSED NODISCARD constexpr inline \
RIter<T> rbegin() NOEXCEPT {\
  return RIter<T>{end() - 1};\
}\
\
MAYBE_UNUSED NODISCARD constexpr F_INLINE \
RIter<const T> crend() const NOEXCEPT {\
  return RIter<const T>{cbegin() - 1};\
}\
\
MAYBE_UNUSED NODISCARD constexpr inline \
RIter<T> rend() NOEXCEPT {\
  return RIter<T>{begin() - 1};\
}


  template<typename T, Usize N>
  class Span {
    T *mPtr;

    Span() NOEXCEPT = default;

  public:
    MAYBE_UNUSED constexpr
    explicit Span(T (&arr)[N]) NOEXCEPT: mPtr{arr} {}

    template<Usize SIZE, typename U>
    friend constexpr
    Span<U, SIZE> fromPtr(U *ptr) NOEXCEPT;

  SpanImpl
  };

  template<typename T>
  class Span<T, 0> {
    T           *mPtr;
    const Usize N;

  public:
    MAYBE_UNUSED constexpr
    Span(T *ptr, decltype(N) len) NOEXCEPT: mPtr{ptr}, N{len} {}

  SpanImpl
  };

  template<Usize SIZE, typename T>
  NODISCARD constexpr
  Span<T, SIZE> fromPtr(T *ptr) NOEXCEPT {
    Span<T, SIZE> span;
    span.mPtr = ptr;
    return span;
  }

  template<typename T>
  Span(T, Usize) -> Span<T, 0>;

  template<typename T, Usize N>
  Span(T (&)[N]) -> Span<T, N>;

}  // namespace Jerryc05
