/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#include <cassert>
#include <cmath>
#include <cstring>
#include <new>
#include <ostream>
#include <ratio>

#include "../attributes.h"

namespace jerryc05 {

  /// Not thread-safe!
  /// [IS_TRIVIALLY_RELOCATABLE] shows if [T] can be moved BY MEMCPY() without calling dtor
  /// [IS_TRIVIALLY_DESTRUCTIBLE_AFTER_MOVE] shows if [T] can be moved WITHOUT calling dtor
  /// [GROWTH_RATE] defaults to the solution of [x^0+x^1+x^2+x^3<=x^5] =>
  /// [x≈1.5341577449]
  template <class T,
            bool IS_TRIVIALLY_RELOCATABLE             = false,
            bool IS_TRIVIALLY_DESTRUCTIBLE_AFTER_MOVE = IS_TRIVIALLY_RELOCATABLE,
            class GROWTH_RATE                         = std::ratio<1645915, 1072846>>
  class CowVec {
   public:
    using RefCountT = std::size_t;

    CowVec() noexcept(noexcept(std::malloc(sizeof(RefCountT)))):
        m_p_ref_count {static_cast<RefCountT*>(std::malloc(sizeof(RefCountT)))} {
      *m_p_ref_count = 1;
    }

    ~CowVec() noexcept(noexcept(this->_dec_counter_unsafe())) {
      if (m_p_ref_count != nullptr)  // if heap allocated
        _dec_counter_unsafe();
    }

    CowVec(const CowVec& o) noexcept(
        std::is_nothrow_copy_constructible_v<decltype(m_data)>&&
                    std::is_nothrow_copy_constructible_v<decltype(m_size)>&&
                    std::is_nothrow_copy_constructible_v<decltype(m_capacity)>&&
                    std::is_nothrow_copy_constructible_v<decltype(m_p_ref_count)>):
        m_data {o.m_data},
        m_capacity {o.m_capacity},
        m_size {o.m_size},
        m_p_ref_count {o.m_p_ref_count} {
      assert(("Must not self-construct", &m_p_ref_count != &o.m_p_ref_count));
      if (m_p_ref_count != nullptr)  // if heap allocated
        ++*m_p_ref_count;
    }

    CowVec(CowVec&& o) noexcept(
        std::is_nothrow_move_constructible_v<decltype(m_data)>&&
                    std::is_nothrow_move_constructible_v<decltype(m_size)>&&
                    std::is_nothrow_move_constructible_v<decltype(m_capacity)>&&
                    std::is_nothrow_move_constructible_v<decltype(m_p_ref_count)>):
        m_data {std::move(o.m_data)},
        m_capacity {std::move(o.m_capacity)},
        m_size {std::move(o.m_size)},
        m_p_ref_count {std::move(o.m_p_ref_count)} {
      assert(("Must not self-construct", &m_p_ref_count != &o.m_p_ref_count));
      o.m_p_ref_count = {};
    }

    auto& operator=(const CowVec& o) noexcept(
        std::is_nothrow_copy_constructible_v<decltype(*this)>&& noexcept(swap(CowVec {o}))) {
      assert(("Must not self-assign", &m_p_ref_count != &o.m_p_ref_count));
      return swap(CowVec {o});
    }

    auto& operator=(CowVec&& o) noexcept(
        std::is_nothrow_move_constructible_v<decltype(*this)>&& noexcept(swap(o))) {
      assert(("Must not self-assign", &m_p_ref_count != &o.m_p_ref_count));
      return swap(o);
    }

    auto& swap(CowVec& o) noexcept(
        std::is_nothrow_swappable_v<decltype(this->m_data)>&& std::is_nothrow_swappable_v<
            decltype(this->m_size)>&& std::is_nothrow_swappable_v<decltype(this->m_capacity)>&&
                                      std::is_nothrow_swappable_v<decltype(this->m_p_ref_count)>) {
      assert(("Must not self-swap", &m_p_ref_count != &o.m_p_ref_count));
      {
        using std::swap;  // ADL
        swap(m_data, o.m_data);
        swap(m_size, o.m_size);
        swap(m_capacity, o.m_capacity);
        swap(m_p_ref_count, o.m_p_ref_count);
      }
      return *this;
    }

    auto& swap(CowVec&& o) noexcept(noexcept(swap(o))){
      return swap(o);
    }

    friend auto swap(CowVec& l, CowVec& r) noexcept(noexcept(l.swap(r))) {
      assert(("Must not self-swap", &l.m_p_ref_count != &r.m_p_ref_count));
      l.swap(r);
    }

    /// Create from C++ array reference (read-only)
    template <std::size_t N>
    explicit CowVec(T (&slice)[N]): m_data {slice}, m_size {N}, m_capacity {N} {}

    /// Create from raw pointer (read-only)
    template <std::size_t N>
    explicit CowVec(T* ptr): m_data {ptr}, m_size {N}, m_capacity {N} {}

    NoDiscard bool reserve(std::size_t new_capacity) noexcept(
        noexcept(this->_reserve_unsafe(new_capacity))) {
      return new_capacity > m_capacity ? _reserve_unsafe(new_capacity) : true;
    }

    const T& operator[](std::size_t i) const noexcept(noexcept(this->m_data[i])) {
      assert(("Index must be in range", i < m_size));
      return m_data[i];
    }

    NoDiscard T* operator[](std::size_t i) noexcept(
        noexcept(this->_to_owned()) && noexcept(this->m_data[i])) {
      assert(("Index must be in range", i < m_size));
      return _to_owned() ? &m_data[i] : ({});
    }

    const T* data() const noexcept { return m_data; }

    NoDiscard T* data() noexcept(noexcept(this->_to_owned())) {
      return _to_owned() ? m_data : ({});
    }

    NoDiscard std::size_t capacity() const noexcept { return m_capacity; }

    NoDiscard std::size_t size() const noexcept { return m_size; }

    void clear() noexcept(noexcept(_dec_counter_unsafe())) {
      if (m_p_ref_count != nullptr)  // if heap allocated
        _dec_counter_unsafe();
      else  // if read-only
        m_capacity = 0;

      m_p_ref_count = {};
      m_size        = 0;
    }

    template <class... Args>
    NoDiscard T* emplace_back(Args&&... args) noexcept(
        noexcept(this->_grow_capacity_if_full()) && noexcept(this->m_data[this->m_size]) &&
        std::is_nothrow_constructible_v<T, Args...>) {
      if (_grow_capacity_if_full()) {
        T& t = m_data[m_size++];
        new (&t) T(std::forward<Args>(args)...);
        return &t;

      } else
        return {};
    }

    T pop_back() noexcept(
        std::is_nothrow_move_assignable_v<T>&& _move_destruct(m_data[this->m_size])) {
      assert(("Container must be non-empty", m_size > 0));
      auto x = std::move(m_data[--m_size]);
      _move_destruct(m_data[m_size]);
      return x;
    }

    friend std::ostream& operator<<(std::ostream& os, const CowVec& v) {
      const auto& size = v.size();
      os << '[';
      for (std::size_t i = 0; i < size - 1; ++i) os << v[i] << ", ";
      if (size > 0)
        os << v[size - 1];
      os << ']';
      return os;
    }

   private:
    T*                 m_data {};
    std::size_t        m_size {}, m_capacity {};
    mutable RefCountT* m_p_ref_count {};  // remains [nullptr] if read-only

    /// Returns whether COW goes as expected
    NoDiscard bool _to_owned() noexcept(noexcept(std::malloc(0)) &&
                                        std::is_nothrow_copy_constructible_v<T>) {
      if (m_p_ref_count != nullptr && *m_p_ref_count == 1)  // if already owned
        return true;
      assert(("If heap allocated, ref count must > 1",
              m_p_ref_count == nullptr || *m_p_ref_count > 1));

      auto new_data         = static_cast<T*>(std::malloc(m_capacity * sizeof(T)));
      auto new_p_ref_count  = static_cast<RefCountT*>(std::malloc(sizeof(RefCountT)));
      *new_p_ref_count      = 1;
      const bool& succeeded = new_data != nullptr && new_p_ref_count != nullptr;

      if (succeeded) {
        _copy_assign(new_data);
        m_data = new_data;
        if (m_p_ref_count != nullptr)  // if heap allocated
          _dec_counter_unsafe();
        m_p_ref_count = new_p_ref_count;
      }
      return succeeded;
    }

    NoDiscard bool _grow_capacity_if_full() noexcept(noexcept(reserve(0))) {
      if (m_capacity == 0) {
        return _reserve_unsafe(1);
      } else if (m_size >= m_capacity) {
        assert(("Size must not excceed capacity", m_size == m_capacity));
        return _reserve_unsafe(std::ceil(m_capacity * (1. * GROWTH_RATE::num / GROWTH_RATE::den)));
      } else
        return true;
    }

    NoDiscard bool _reserve_unsafe(std::size_t new_capacity) noexcept(
        noexcept(std::malloc(new_capacity)) && noexcept(std::realloc(
            nullptr,
            new_capacity)) && noexcept(_move_assign(m_data)) && noexcept(std::free(nullptr))) {
      assert(new_capacity > m_capacity);
      T*         new_data;
      RefCountT* new_p_ref_count = m_p_ref_count;
      bool       use_realloc     = false;
      {
        if (m_p_ref_count == nullptr || *m_p_ref_count != 1) {
          // if read-only or not owned
          assert(("if heap allocated, ref count must > 1",
                  m_p_ref_count == nullptr || *m_p_ref_count > 1));
          new_p_ref_count  = static_cast<RefCountT*>(std::malloc(sizeof(RefCountT)));
          *new_p_ref_count = 1;
          if constexpr (IS_TRIVIALLY_RELOCATABLE)
            use_realloc = true;
        }
        new_data =
            static_cast<T*>(std::realloc(use_realloc ? m_data : nullptr, new_capacity * sizeof(T)));
      }

      const bool& succeeded = new_data != nullptr && new_p_ref_count != nullptr;
      if (succeeded) {
        if (m_data != new_data && !use_realloc) {
          _move_assign(new_data);
          std::free(m_data);
          m_data = new_data;
        }
        m_capacity = new_capacity;
      }
      return succeeded;
    }

    void _dec_counter_unsafe() noexcept(
        noexcept(std::free(nullptr)) && noexcept(--*m_p_ref_count)) {
      assert(("Ref counter must be non-null", m_p_ref_count != nullptr));

      if (*m_p_ref_count == 1) {  // if owned
        std::free(m_p_ref_count);
        m_p_ref_count = {};
        for (std::size_t i = 0; i < m_size; ++i) m_data[i].~T();
        std::free(m_data);
      } else
        --*m_p_ref_count;
    }

    void _copy_assign(T* new_data) noexcept(std::is_nothrow_copy_constructible_v<T>) {
      for (std::size_t i = 0; i < m_size; ++i) new (&new_data[i]) T(m_data[i]);
    }

    void _move_assign(T* new_data) noexcept(
        std::is_nothrow_move_constructible_v<T>&& noexcept(_move_destruct(m_data[this->m_size]))) {
      if constexpr (IS_TRIVIALLY_RELOCATABLE)
        std::memcpy(new_data, m_data, m_size * sizeof(T));

      else
        for (std::size_t i = 0; i < m_size; ++i) {
          new (&new_data[i]) T(std::move(m_data[i]));
          _move_destruct(m_data[i]);
        }
    }

    void _move_destruct(T& t) noexcept((IS_TRIVIALLY_DESTRUCTIBLE_AFTER_MOVE ||
                                        std::is_nothrow_destructible_v<T>)) {
      if constexpr (!IS_TRIVIALLY_DESTRUCTIBLE_AFTER_MOVE)
        t.~T();
    }
  };
}  // namespace jerryc05
