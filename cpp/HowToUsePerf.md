# Additional compile flags

```shell
g++ <other_compile_flags> \
    -g3 -fno-omit-frame-pointer \
    [source_files.cpp ...] [-o out_program]
```

# Run program with `perf record`

```shell
perf record -a -g -F 199 -e cycles --call-graph dwarf ./out_program [args...]
#           |  |  |      |         └ [dwarf] produces most detail, but may produce huge output file
#           |  |  |      └  Only sample CPU cycle event
#           |  |  └  Sampling[F] requency, don't be multiples of 100
#           |  └ Enables call - graph recording for kernel & user space
#           └ Collect from all cpu
```

# Show report

```shell
perf report [--no-children] [-G]
#            ^~~~~~~~~~~~~   ^~
#            |               |
#            |               Show caller-based call graph (instead of callee-based)
#            Add this flag to remove call chain (display self-time instead of accumulate-time)
```

# Annotate source code*

__Try annotate source code in `perf report` instead!__

```shell
perf annotate --tui -s symbol_name
#             ^~~~~ ^~~~~~~~~~~~~~~~~
#             |     |
#             |     Symbol to annotate
#             Recommended if you have a tty; otherwise,
#                 try `--gtk` if you have GTK,
#                 or the plain old `--stdio`/`--stdio2`
```

# Download Python and Graphviz*

_Assume you __ALREADY__ have __Python3__ installed!_

- Debian-based System? Try:
  ```shell
  sudo apt install graphviz
  ```

- Mac system? Try:
  ```shell
  brew install graphviz
  ```

- Other system? Try:

  https://graphviz.org/download/

# Install `gprof2dot` from `pip`

_You know what to do!_

# One liner for graphviz*

```shell
# [perf record] goes here ...

#                             ┌ Node threshold
#                             |   ┌ Edge threshold
perf script|c++filt|gprof2dot -n3 -e3 \
--color-nodes-by-selftime --skew 0.1 \
--node-label="total-time" --node-label ="self-time" \
--node-label="total-time-percentage" --node-label="self-time-percentage" \
--show-samples -f perf|dot -Tsvg -o perf.svg
```
