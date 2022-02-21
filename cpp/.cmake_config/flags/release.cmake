
        include(ProcessorCount)
        ProcessorCount(__NPROCS__)



-Ofast -march=native


-fconstexpr-cache-depth=99
-fconstexpr-depth=999
-fconstexpr-loop-limit=999999
-fconstexpr-ops-limit=99999999
-ffat-lto-objects


-fimplicit-constexpr
-fivopts

-floop-parallelize-all \
-fmerge-all-constants
-fmodulo-sched
-fmodulo-sched-allow-regmoves

-freg-struct-return

-fsched-spec-load
-fsched-spec-load-dangerous


-fsimd-cost-model=unlimited
-fstrict-enums
-fstrict-overflow

-ftree-parallelize-loops=${__NPROCS__}

-ftrivial-auto-var-init=uninitialized
-fvect-cost-model=unlimited























-fdata-sections \
-fdelete-dead-exceptions \
-ffinite-loops \
-ffunction-sections \
-fgcse-las -fgcse-sm \
-fipa-pta -fira-loop-pressure \
-fisolate-erroneous-paths-attribute \
-floop-nest-optimize \
-flto \
-fmodulo-sched -fmodulo-sched-allow-regmoves \
-fno-exceptions \
-fsched-pressure \
-fsched-spec-load -fsched-spec-load-dangerous \
-fsched-stalled-insns=0 -fsched-stalled-insns-dep \
-fsched2-use-superblocks \
-fschedule-insns \
-fsel-sched-pipelining -fsel-sched-pipelining-outer-loops \
-fselective-scheduling -fselective-scheduling2 \
-fsplit-wide-types-early \
-ftree-lrs  -ftree-vectorize \
-funroll-loops \
-fvariable-expansion-in-unroller \


# -finline-limit=n  # Let compiler decide!
# -fsplit-wide-types-early  # Let compiler decide!
