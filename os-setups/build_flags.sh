MAKEFLAGS="$MAKEFLAGS -j $(($(nproc) * 2))"
FLAGS='-DNDEBUG -Ofast -march=native -Werror=vla-parameter -w -Wfatal-errors'
export CFLAGS="$CFLAGS $FLAGS -std=c2x"
export CXXFLAGS="$CXXFLAGS $FLAGS -std=gnu++20"
