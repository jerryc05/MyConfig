/*
===============================================================================
Global:

-------------------------------------------------------------------------------
#pragma push_macro("macro_name")
#pragma pop_macro("macro_name")

```cpp
#pragma push_macro("NDEBUG")
#include ...
#pragma pop_macro("NDEBUG")
```


===============================================================================
Function:

-------------------------------------------------------------------------------
#pragma GCC push_options
#pragma GCC optimize ("string")
#pragma GCC pop_options
#pragma GCC reset_options

```cpp
#pragma GCC push_options
#pragma GCC optimize ("Ofast,fast-math,unroll-loops")
auto optimized_func() {
  ...
}
#pragma GCC pop_options
#pragma GCC reset_options
```


===============================================================================
Loop:

-------------------------------------------------------------------------------
#pragma GCC ivdep

[I]gnore [V]ector [DEP]endencies in a loop (optimize for SIMD).

```cpp
auto ignore_vec_dep(int *a, int k, int c, int m) {
  #pragma GCC ivdep
  for (int i = 0; i < m; i++)
    a[i] = a[i + k] * c;
}
```

-------------------------------------------------------------------------------
#pragma GCC unroll n

Controls how many times a loop should be unrolled.

```cpp
auto unroll_loop(int *a, int* b, int c, int m) {
  #pragma GCC unroll 8
  #pragma GCC ivdep
  for (int i = 0; i < m; i++)
    a[i] = b[i + m] * c;
}
```


===============================================================================
*/
