CXX               = g++ -std=gnu++20 -D_XOPEN_SOURCE
CXX_FLAGS         = -g -Wall \
-fsanitize=undefined -fsanitize=alignment -fsanitize=bool -fsanitize=bounds -fsanitize=builtin -fsanitize=enum -fsanitize=float-cast-overflow -fsanitize=float-divide-by-zero -fsanitize=integer-divide-by-zero -fsanitize=nonnull-attribute -fsanitize=null -fsanitize=pointer-overflow -fsanitize=return -fsanitize=returns-nonnull-attribute -fsanitize=shift -fsanitize=shift-base -fsanitize=shift-exponent -fsanitize=signed-integer-overflow -fsanitize=unreachable -fsanitize=vla-bound -fsanitize=vptr \
-fsanitize=address -fno-omit-frame-pointer -fPIE -pie
CXX_FLAGS_RELEASE = -Ofast -flto

# Run in parallel
NPROCS = $(shell fgrep -c 'processor' /proc/cpuinfo || sysctl hw.ncpu | fgrep -o '[0-9]\+')
#                |                                     └ Mac
#                └ Linux
MAKEFLAGS += -j$(NPROCS)

# Source and object files
SRCS = $(wildcard *.cpp)
HDRS = $(wildcard *.h)
OBJS = ${SRCS:.cpp=.o}

# Assign default include paths
vpath %.o obj
vpath %   bin





all: format
all: $(notdir $(basename $(wildcard tests/test*.cpp)))
#    |                              └ *** Change this! ***
#    └ *** Change this! ***

release: CXX_FLAGS=${CXX_FLAGS_RELEASE}
release: all

.PHONY: clean format

clean:
	rm -rf bin/ obj/

format:
	{ find . -name '*.cpp' -o -name '*.h' | xargs -P ${NPROCS} -I {} clang-format -i -Wno-error=unknown {};}&





# Generic rules for compiling a source file to an object file
%.o: %.cpp
	@clang-format -i -Wno-error=unknown $< &
	@mkdir -p obj
	${CXX} ${CFLAGS} -c $< -o obj/$@
