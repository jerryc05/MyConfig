#pragma once

#include <avr/pgmspace.h>

/*
    This is a type-safe wrapper class for PROGMEM/Flash arrays.
Usage:
    static const char  hello[] PROGMEM = "Hello";
    static const char  world[] PROGMEM = "World";
    static const char* myArr[] PROGMEM = {hello, world};
    ProgmemArr  myProgmemArr(myArr);
    bool        isTrue = myProgmemArr.size() == 2;
*/
template <class _T, size_t LEN>
struct ProgmemArr {
  using T   = _T;
  using Len = decltype(LEN);

  ProgmemArr(const T (&progmem_arr)[LEN]): _ptr {progmem_arr} {}

  auto length() const { return LEN; }

  auto len() const { return length(); }

  auto size() const { return len(); }

  //

  T operator[](size_t i) const {
    if constexpr (sizeof(T) == sizeof(byte))
      return &reinterpret_cast<T*>(readByte(i));
    else {
      byte _arr[sizeof(T)];
      memcpy(_arr, i, sizeof(T));
      return &reinterpret_cast<T*>(_arr);
    }
  }

  auto readByte(const void* p) const { return pgm_read_byte(p); }

  auto readByte(size_t i) const { return readByte(&_ptr[i]); }

  auto readDword(const void* p) const { return pgm_read_dword(p); }

  auto readDword(size_t i) const { return readDword(&_ptr[i]); }

  auto _readDwordUnaligned(const void* p) const { return pgm_read_dword_unaligned(p); }

  auto _readDwordUnaligned(size_t i) const { return _readDwordUnaligned(&_ptr[i]); }

  auto _readDwordAligned(const void* p) const { return pgm_read_dword_aligned(p); }

  auto _readDwordAligned(size_t i) const { return _readDwordAligned(&_ptr[i]); }

  //

  auto memccpy(void* dest, size_t idx_in_str, int c, size_t count) {
    return memccpy_P(dest, &_ptr[idx_in_str], c, count);
  }

  auto memcpy(void* dest, size_t idx_in_str, size_t count) {
    return memcpy_P(dest, &_ptr[idx_in_str], count);
  }

  auto memcmp(const void* buf, size_t idx_in_str, size_t size) const {
    return memcmp_P(buf, &_ptr[idx_in_str], size);
  }

  auto memmem(const void* buf, size_t bufSize, size_t idx_in_str, size_t findPSize) {
    return memmem_P(buf, bufSize, &_ptr[idx_in_str], findPSize);
  }

  auto strncpy(char* dest, size_t idx_in_str, size_t size) {
    return strncpy_P(dest, &_ptr[idx_in_str], size);
  }

  auto strncat(char* dest, size_t idx_in_str, size_t size) {
    return strncat_P(dest, &_ptr[idx_in_str], size);
  }

  auto strncmp(const char* str1, size_t idx_in_str, size_t size) {
    return strncmp_P(str1, &_ptr[idx_in_str], size);
  }

  auto strncasecmp(const char* str1, size_t idx_in_str, size_t size) {
    return strncasecmp_P(str1, &_ptr[idx_in_str], size);
  }

  auto strnlen(size_t idx_in_str, size_t size) { return strnlen_P(&_ptr[idx_in_str], size); }

  auto strstr(const char* haystack, size_t idx_in_str) {
    return strstr_P(haystack, &_ptr[idx_in_str]);
  }

  //

  auto vsnprintf(char* str, size_t strSize, size_t idx_in_str, va_list ap) {
    return vsnprintf_P(str, strSize, &_ptr[idx_in_str], ap);
  }


 private:
  const T* _ptr;
};

#define PROGMEM_STR(s)                   \
  (__extension__({                       \
    static const char c[] PROGMEM = (s); \
    ProgmemStr        p(c);              \
    p;                                   \
  }))

/*
    This is a type-safe wrapper class for PROGMEM/dFlash strings.
Usage:
    Serial.print(PROGMEM_STR("Hello World!"));
*/
template <size_t LEN>
struct ProgmemStr: public ProgmemArr<char, LEN> {
  using FlashStrConstPtr = const __FlashStringHelper*;

  operator FlashStrConstPtr() const { return FPSTR(this->_ptr); }

  auto allocToString() const { return String(*this); }
};
