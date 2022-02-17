/*
 * Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#include <iostream>


int
main(int argc, char* argv[]) {
  // init starter
  {
    // Do not sync with C-style stdio
#ifdef NDEBUG
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    std::cout.tie(nullptr);
#endif

    // Read `bool` as `true` and `false`
    std::cin >> std::boolalpha;
    std::cout << std::boolalpha;
  }

  // TODO Delete the following lines
  std::cout << "Hello, World!" << std::endl;
  for (decltype(argc) i = 0; i < argc; ++i) {
    std::cout << "argv[" << i << "]: " << argv[i] << std::endl;
  }

  /* This might "bypass" memory leak checks, but will also prevent calling destructors.
     Make sure to wrap all other codes in a curly bracket before calling `exit()`.  */
  // std::exit(0);

  return 0;
}
