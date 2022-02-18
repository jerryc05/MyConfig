
// // Memory Resource
// #if (__GNUC__ >= 9) || (__clang_major__ >= 9)

// #  include <memory_resource>

// using MonoBufRes = std::pmr::monotonic_buffer_resource;
// template <class T>
// using PmrAlloc = std::pmr::polymorphic_allocator<T>;


// class MyNewDelResExample: public std::pmr::memory_resource {
//   private:
//     void* do_allocate(Usize size, Usize alignment) override;

//     void do_deallocate(void* ptr, Usize size, Usize alignment) override;

//     NODISCARD bool do_is_equal(const std::pmr::memory_resource& other) const NOEXCEPT override;
// };

// void*
// MyNewDelResExample::do_allocate(Usize size, Usize alignment) {
//   std::cout << "Al--locating " << size << '\n';
//   return std::pmr::new_delete_resource()->allocate(size, alignment);
// }

// void
// MyNewDelResExample::do_deallocate(void* ptr, Usize size, Usize alignment) {
//   std::cout << "Deallocating " << size << ":\n";
//   debugBytes<>(ptr, size);

//   return std::pmr::new_delete_resource()->deallocate(ptr, size, alignment);
// }

// NODISCARD bool
// MyNewDelResExample::do_is_equal(const std::pmr::memory_resource& other) const NOEXCEPT {
//   return std::pmr::new_delete_resource()->is_equal(other);
// }


// template <Usize CAPACITY>
//  void
// pmrContainerExample() {
//   MyNewDelResExample mem;
//   std::pmr::set_default_resource(&mem);

//   Byte       buf[CAPACITY];
//   MonoBufRes res(std::data(buf), std::size(buf));

//   using PmrStr = String<char, PmrAlloc<char>>;
//   Vec<PmrStr, PmrAlloc<PmrStr>> v(4, &res);                                  // Do this!
//   Vec<PmrStr, PmrAlloc<PmrStr>> v2({"This will be heap-allocated!"}, &res);  // Don't do this!

//   v.emplace_back("This will be stack-allocated!");  // Do this!
//   v.push_back("This will be heap-allocated!");      // Don't do this!

//   PmrStr s1("This will be stack-allocated!", &res);  // Do this!
//   PmrStr s2("This will be heap-allocated!");         // Don't do this!
// }

// #endif
