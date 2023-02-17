# Compile with `-pg` flag

For example, compile with:
```shell
gcc -pg [CFLAGS] [source_file.c ...] [-o out_program]
```

# Run normally

```shell
./out_program [--args ...] [< redirect] [> redirect]
```

Program compiled with `-pg` will generate `gmon.out` under its directory.

# Run `gprof` tool

```shell
gprof -b ./out_program gmon.out > analysis.txt
#     ^~ ^~~~~~~~~~~~~ ^~~~~~~~   ^~~~~~~~~~~~
#     |  |             |          |
#     |  |             |          Result interpreted by `gprof`
#     |  |             The `gmon.out` you just generated
#     |  The program you just run
#     Do not write bullsh*t to result
```

Now you have the profiling result in text style.

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

# Render result

```shell
gprof2dot -f prof analysis.txt -n3 -e3 \
--color-nodes-by-selftime --skew 0.1 \
--node-label="total-time" --node-label="self-time" \
--node-label="total-time-percentage" --node-label="self-time-percentage" \
--show-samples | dot -Tsvg -o perf.svg
```
