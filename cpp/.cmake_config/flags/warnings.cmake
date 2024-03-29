# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

# GCC 11
# Clang 15

include(${__CFG__}/try-add-flag.cmake)

try_add_flag(CMAKE_CXX_FLAGS -fdiagnostics-color=always)
try_add_flag(CMAKE_CXX_FLAGS -Wall)
try_add_flag(CMAKE_CXX_FLAGS -Wextra)
try_add_flag(CMAKE_CXX_FLAGS -Wpedantic)

#                            -Wabi  # Not useful
try_add_flag(CMAKE_CXX_FLAGS -Waggregate-return)
try_add_flag(CMAKE_CXX_FLAGS -Walloc-zero)
try_add_flag(CMAKE_CXX_FLAGS -Walloca)
try_add_flag(CMAKE_CXX_FLAGS -Warray-bounds=2)
try_add_flag(CMAKE_CXX_FLAGS -Wbad-function-cast)
try_add_flag(CMAKE_CXX_FLAGS -Wbidi-chars=any,ucn)
try_add_flag(CMAKE_CXX_FLAGS -Wcast-align)
try_add_flag(CMAKE_CXX_FLAGS -Wcast-function-type)
try_add_flag(CMAKE_CXX_FLAGS -Wcast-qual)
try_add_flag(CMAKE_CXX_FLAGS -Wcatch-value=3)
try_add_flag(CMAKE_CXX_FLAGS -Wconversion)
try_add_flag(CMAKE_CXX_FLAGS -Wctad-maybe-unsupported)
try_add_flag(CMAKE_CXX_FLAGS -Wctor-dtor-privacy)
try_add_flag(CMAKE_CXX_FLAGS -Wdelete-non-virtual-dtor)
try_add_flag(CMAKE_CXX_FLAGS -Wdeprecated-copy-dtor)
try_add_flag(CMAKE_CXX_FLAGS -Wdisabled-optimization)
try_add_flag(CMAKE_CXX_FLAGS -Wdouble-promotion)
try_add_flag(CMAKE_CXX_FLAGS -Wduplicated-branches)
try_add_flag(CMAKE_CXX_FLAGS -Wduplicated-cond)
try_add_flag(CMAKE_CXX_FLAGS -Weffc++)
try_add_flag(CMAKE_CXX_FLAGS -Wenum-compare)
try_add_flag(CMAKE_CXX_FLAGS -Wenum-conversion)
try_add_flag(CMAKE_CXX_FLAGS -Werror=comma-subscript)
try_add_flag(CMAKE_CXX_FLAGS -Werror=old-style-cast)
try_add_flag(CMAKE_CXX_FLAGS -Werror=pessimizing-move)
try_add_flag(CMAKE_CXX_FLAGS -Werror=redundant-move)
try_add_flag(CMAKE_CXX_FLAGS -Werror=register)
try_add_flag(CMAKE_CXX_FLAGS -Werror=return-type)
try_add_flag(CMAKE_CXX_FLAGS -Wextra-semi)
try_add_flag(CMAKE_CXX_FLAGS -Wfloat-equal)
try_add_flag(CMAKE_CXX_FLAGS -Wformat-nonliteral)
try_add_flag(CMAKE_CXX_FLAGS -Wformat-overflow=2)
try_add_flag(CMAKE_CXX_FLAGS -Wformat-security)
try_add_flag(CMAKE_CXX_FLAGS -Wformat-signedness)
try_add_flag(CMAKE_CXX_FLAGS -Wformat-truncation=2)
try_add_flag(CMAKE_CXX_FLAGS -Wformat-y2k)
try_add_flag(CMAKE_CXX_FLAGS -Wformat=2)
try_add_flag(CMAKE_CXX_FLAGS -Wimplicit-fallthrough=2)
try_add_flag(CMAKE_CXX_FLAGS -Winit-list-lifetime)
try_add_flag(CMAKE_CXX_FLAGS -Winline)
try_add_flag(CMAKE_CXX_FLAGS -Winterference-size)
try_add_flag(CMAKE_CXX_FLAGS -Winvalid-imported-macros)
try_add_flag(CMAKE_CXX_FLAGS -Winvalid-offsetof)
try_add_flag(CMAKE_CXX_FLAGS -Winvalid-pch)
try_add_flag(CMAKE_CXX_FLAGS -Wjump-misses-init)
try_add_flag(CMAKE_CXX_FLAGS -Wliteral-suffix)
try_add_flag(CMAKE_CXX_FLAGS -Wlogical-op)
try_add_flag(CMAKE_CXX_FLAGS -Wmismatched-tags)
try_add_flag(CMAKE_CXX_FLAGS -Wmissing-declarations)
try_add_flag(CMAKE_CXX_FLAGS -Wmissing-field-initializers)
try_add_flag(CMAKE_CXX_FLAGS -Wmissing-format-attribute)
try_add_flag(CMAKE_CXX_FLAGS -Wmissing-include-dirs)
try_add_flag(CMAKE_CXX_FLAGS -Wmissing-parameter-type)
try_add_flag(CMAKE_CXX_FLAGS -Wmissing-prototypes)
try_add_flag(CMAKE_CXX_FLAGS -Wmultichar)
try_add_flag(CMAKE_CXX_FLAGS -Wnested-externs)
try_add_flag(CMAKE_CXX_FLAGS -Wno-padded)
try_add_flag(CMAKE_CXX_FLAGS -Wno-system-headers)
try_add_flag(CMAKE_CXX_FLAGS -Wnoexcept)
try_add_flag(CMAKE_CXX_FLAGS -Wnoexcept-type)
try_add_flag(CMAKE_CXX_FLAGS -Wnon-virtual-dtor)
try_add_flag(CMAKE_CXX_FLAGS -Wnull-dereference)
try_add_flag(CMAKE_CXX_FLAGS -Wold-style-declaration)
try_add_flag(CMAKE_CXX_FLAGS -Wold-style-definition)
try_add_flag(CMAKE_CXX_FLAGS -Wopenacc-parallelism)
try_add_flag(CMAKE_CXX_FLAGS -Wopenmp-simd)
try_add_flag(CMAKE_CXX_FLAGS -Woverlength-strings)
try_add_flag(CMAKE_CXX_FLAGS -Woverloaded-virtual)
try_add_flag(CMAKE_CXX_FLAGS -Wpacked)
try_add_flag(CMAKE_CXX_FLAGS -Wparentheses)
try_add_flag(CMAKE_CXX_FLAGS -Wplacement-new=2)
try_add_flag(CMAKE_CXX_FLAGS -Wpointer-arith)
try_add_flag(CMAKE_CXX_FLAGS -Wpointer-sign)
try_add_flag(CMAKE_CXX_FLAGS -Wredundant-decls)
try_add_flag(CMAKE_CXX_FLAGS -Wredundant-tags)
try_add_flag(CMAKE_CXX_FLAGS -Wreorder)
try_add_flag(CMAKE_CXX_FLAGS -Wscalar-storage-order)
try_add_flag(CMAKE_CXX_FLAGS -Wshadow)
try_add_flag(CMAKE_CXX_FLAGS -Wshift-overflow=2)
try_add_flag(CMAKE_CXX_FLAGS -Wsign-conversion)
try_add_flag(CMAKE_CXX_FLAGS -Wsign-promo)
#                            -Wstrict-aliasing=n  # uses default value is ok
try_add_flag(CMAKE_CXX_FLAGS -Wstrict-null-sentinel)
try_add_flag(CMAKE_CXX_FLAGS -Wstrict-overflow=5)
try_add_flag(CMAKE_CXX_FLAGS -Wstrict-prototypes)
try_add_flag(CMAKE_CXX_FLAGS -Wstring-compare)
try_add_flag(CMAKE_CXX_FLAGS -Wstringop-overflow=4)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-attribute=cold)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-attribute=const)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-attribute=format)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-attribute=malloc)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-attribute=noreturn)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-attribute=pure)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-final-methods)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-final-types)
try_add_flag(CMAKE_CXX_FLAGS -Wsuggest-override)
try_add_flag(CMAKE_CXX_FLAGS -Wswitch-default)
try_add_flag(CMAKE_CXX_FLAGS -Wswitch-enum)
try_add_flag(CMAKE_CXX_FLAGS -Wtrampolines)
try_add_flag(CMAKE_CXX_FLAGS -Wundef)
try_add_flag(CMAKE_CXX_FLAGS -Wunknown-pragmas)
try_add_flag(CMAKE_CXX_FLAGS -Wunsafe-loop-optimizations)
try_add_flag(CMAKE_CXX_FLAGS -Wunsuffixed-float-constants)
try_add_flag(CMAKE_CXX_FLAGS -Wunused-macros)
try_add_flag(CMAKE_CXX_FLAGS -Wuse-after-free=3)
try_add_flag(CMAKE_CXX_FLAGS -Wuseless-cast)
try_add_flag(CMAKE_CXX_FLAGS -Wvector-operation-performance)
#                            -Wvla  # OK
try_add_flag(CMAKE_CXX_FLAGS -Wwrite-strings)
try_add_flag(CMAKE_CXX_FLAGS -Wzero-as-null-pointer-constant)
