/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#include <cassert>
#include <ratio>

#include "../attributes.h"
#include "../compats/optional_compat.h"

namespace jerryc05 {

  /// Not thread-safe!
  /// [IS_TRIVIALLY_MOVE_DESTRUCTIBLE] shows if [T] does not need to call destructor after moved
  /// [GROWTH_RATE] defaults to the solution of [x^0+x^1+x^2+x^3<=x^5] => [x≈1.5341577449]
  template <class T,
            bool IS_TRIVIALLY_MOVE_DESTRUCTIBLE = false,
            class GROWTH_RATE                   = std::ratio<1645915, 1072846>>
  class CowVec {
   public:
    using RefCountT = std::size_t;

    CowVec() noexcept(noexcept(std::malloc(0))): m_p_ref_count {std::malloc(sizeof(RefCountT))} {
      *m_p_ref_count = 1;
    }

    ~CowVec() noexcept {
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
      o.m_p_ref_count = nullptr;
    }

    auto& operator=(const CowVec& o) noexcept(
        std::is_nothrow_copy_constructible_v<decltype(*this)>&& noexcept(swap(CowVec {o}))) {
      assert(("Must not self-assign", &m_p_ref_count != &o.m_p_ref_count));
      swap(CowVec {o});
    }

    auto& operator=(CowVec&& o) noexcept(
        std::is_nothrow_move_constructible_v<decltype(*this)>&& noexcept(swap(o))) {
      assert(("Must not self-assign", &m_p_ref_count != &o.m_p_ref_count));
      swap(o);
    }

    auto& swap(CowVec& o) noexcept(
        std::is_nothrow_swappable_v<decltype(m_data)>&& std::is_nothrow_swappable_v<
            decltype(m_size)>&& std::is_nothrow_swappable_v<decltype(m_capacity)>&&
                                std::is_nothrow_swappable_v<decltype(m_p_ref_count)>) {
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

    bool reserve(std::size_t new_capacity) noexcept(noexcept(std::realloc(nullptr, 0))) {
      if (new_capacity > m_capacity) {
        T* new_data;
        T* new_p_ref_count = m_p_ref_count;
        {
          if (m_p_ref_count == nullptr || *m_p_ref_count != 1) {
            // if read-only or not owned
            assert(("if heap allocated, ref count must > 1",
                    m_p_ref_count == nullptr || *m_p_ref_count > 1));
            new_data         = static_cast<T*>(std::malloc(new_capacity * sizeof(T)));
            new_p_ref_count  = std::malloc(sizeof(RefCountT));
            *new_p_ref_count = 1;
          } else
            new_data = static_cast<T*>(std::realloc(m_data, new_capacity * sizeof(T)));
        }

        const bool& succeeded = new_data != nullptr && new_p_ref_count != nullptr;
        if (succeeded) {
          if (m_data != new_data)
            _move_assign(new_data);
          m_capacity = new_capacity;
        }
        return succeeded;

      } else
        return true;
    }

    const T& operator[](std::size_t i) const noexcept(noexcept(m_data[i])) {
      assert(("Index must be in range", i < m_size));
      return m_data[i];
    }

    NoDiscard std::optional<T&> operator[](std::size_t i) noexcept(
        noexcept(_to_owned()) && noexcept(m_data[i])) {
      assert(("Index must be in range", i < m_size));
      return _to_owned() ? m_data[i] : ({});
    }

    const T* data() const noexcept { return m_data; }

    NoDiscard std::optional<T*> data() noexcept(noexcept(_to_owned())) {
      return _to_owned() ? m_data : ({});
    }

    NoDiscard std::size_t capacity() const noexcept { return m_capacity; }

    NoDiscard std::size_t size() const noexcept { return m_size; }

    void clear() noexcept(std::is_nothrow_destructible_v<T>) {
      if (m_p_ref_count != nullptr)  // if heap allocated
        _dec_counter_unsafe();
      else  // if read-only
        m_capacity = 0;

      m_p_ref_count = nullptr;
      m_size        = 0;
    }

    template <class... Args>
    T& emplace_back(Args&&... args) noexcept(
        noexcept(this->_grow_capacity_if_full()) && noexcept(this->m_data[0]) &&
        std::is_nothrow_constructible_v<T, Args...>) {
      _grow_capacity_if_full();

      T& t = m_data[m_size++];
      new (&t) T(std::forward<Args>(args)...);
      return t;
    }

    T pop_back() noexcept(std::is_nothrow_move_assignable_v<T>&& _move_destruct(m_data[0])) {
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
    T*                 m_data = nullptr;
    std::size_t        m_size = 0, m_capacity = 0;
    mutable RefCountT* m_p_ref_count = nullptr;  // remains [nullptr] if read-only

    /// Returns whether COW goes as expected
    NoDiscard bool _to_owned() noexcept(noexcept(std::malloc(0)) &&
                                        std::is_nothrow_copy_constructible_v<T>) {
      if (m_p_ref_count != nullptr && *m_p_ref_count == 1)  // if already owned
        return true;
      assert(("If heap allocated, ref count must > 1",
              m_p_ref_count == nullptr || *m_p_ref_count > 1));

      T*         new_data        = std::malloc(m_capacity * sizeof(T));
      RefCountT* new_p_ref_count = std::malloc(sizeof(RefCountT));
      *new_p_ref_count           = 1;
      const bool& succeeded      = new_data != nullptr && new_p_ref_count != nullptr;

      if (succeeded) {
        _copy_assign(new_data);
        if (m_p_ref_count != nullptr)  // if heap allocated
          _dec_counter_unsafe();
        m_p_ref_count = new_p_ref_count;
      }
      return succeeded;
    }

    NoDiscard bool _grow_capacity_if_full() noexcept(noexcept(reserve(0))) {
      if (m_capacity == 0) {
        return reserve(1);
      } else if (m_size >= m_capacity) {
        assert(("Size must not excceed capacity", m_size == m_capacity));
        return reserve(std::ceil(m_capacity * GROWTH_RATE()));
      } else
        return true;
    }

    void _dec_counter_unsafe() noexcept(
        noexcept(std::free(nullptr)) && noexcept(--*m_p_ref_count)) {
      assert(("Ref counter must be non-null", m_p_ref_count != nullptr));

      if (*m_p_ref_count == 1) {  // if owned
        std::free(m_p_ref_count);
        m_p_ref_count = nullptr;
        for (std::size_t i = 0; i < m_size; ++i) m_data[i].~T();
        std::free(m_data);
      } else
        --*m_p_ref_count;
    }

    void _copy_assign(T* new_data) noexcept(std::is_nothrow_copy_constructible_v<T>) {
      for (std::size_t i = 0; i < m_size; ++i) new (&new_data[i]) T(m_data[i]);
      m_data = new_data;
    }

    void _move_assign(T* new_data) noexcept(
        std::is_nothrow_move_constructible_v<T>&& _move_destruct(m_data[0])) {
      for (std::size_t i = 0; i < m_size; ++i) {
        new (&new_data[i]) T(std::move(m_data[i]));
        _move_destruct(m_data[i]);
      }
      m_data = new_data;
    }

    void _move_destruct(T& t) noexcept((IS_TRIVIALLY_MOVE_DESTRUCTIBLE ||
                                        std::is_nothrow_destructible_v<T>)) {
      if constexpr (!IS_TRIVIALLY_MOVE_DESTRUCTIBLE)
        m_data[i].~T();
    }
  };
}  // namespace jerryc05
