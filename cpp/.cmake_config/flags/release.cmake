# Copyright (c) 2019-2022 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

include(${__CFG__}/try-add-flag.cmake)


include(ProcessorCount)
ProcessorCount(__NPROCS__)

try_add_flag(CMAKE_CXX_FLAGS_RELEASE -Ofast)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -march=native)

try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fconstexpr-cache-depth=99)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fconstexpr-depth=999)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fconstexpr-loop-limit=999999)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fconstexpr-ops-limit=99999999)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fdelete-dead-exceptions)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -ffat-lto-objects)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fgcse-las)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fgcse-sm)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fimplicit-constexpr)
#                                    -finline-limit=n  # Let compiler decide!
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fipa-pta)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fira-loop-pressure)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fisolate-erroneous-paths-attribute)

try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fivopts)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -floop-nest-optimize)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -floop-parallelize-all)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fmerge-all-constants)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fmodulo-sched)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fmodulo-sched-allow-regmoves)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -freg-struct-return)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fsched-pressure)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fsched-spec-load)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fsched-spec-load-dangerous)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fsimd-cost-model=unlimited)
#                                    -fsplit-wide-types-early  # Let compiler decide!
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fstrict-enums)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fstrict-overflow)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -ftree-parallelize-loops=${__NPROCS__})
#                                    -ftree-vectorize  # Enabled at -O2+
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -ftrivial-auto-var-init=uninitialized)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -funroll-loops)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fvariable-expansion-in-unroller --param max-variable-expansions-in-unroller=8)
try_add_flag(CMAKE_CXX_FLAGS_RELEASE -fvect-cost-model=unlimited)
