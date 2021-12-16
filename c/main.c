#include <stdio.h>

int main(int argc, char *argv[]) {
#ifndef NDEBUG
  // debug mode
#else
  // non-debug mode
#endif
  printf("Hello, World!\n");
  printf("%d,%p\n", argc, argv);
  return 0;
}
