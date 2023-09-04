MAKEFLAGS="$MAKEFLAGS -j $(nproc)"
export CPPFLAGS="$CPPFLAGS -DNDEBUG -Ofast -march=native -Werror=vla-parameter -w -Wfatal-errors"
export CFLAGS="$CFLAGS -std=c2x"
export CXXFLAGS="$CXXFLAGS -std=gnu++20"
