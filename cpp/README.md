# MyTemplate

This is a personal template/starter-files/starter-repo for `C++` development.

Use at your **OWN** risk.

## Table of Contents

1. [First things first](#first-things-first)
2. [Recommended tools](#recommended-tools)
    - [Ccache](#ccache)
    - [Ninja](#ninja)
    - [LLVM Clang](#llvm-clang)
    - [Clang-Tidy](#clang-tidy)
3. [High-level *"switches"*](#high-level-"switches")
    - [Non-sanitizer flags](#non-sanitizer-flags)
    - [Sanitizer flags](#sanitizer-flags)
        - [The "Big-Three" sanitizers](#the-big-three-sanitizers)
            - [Address sanitizer (`ASAN`)](#address-sanitizer-asan)
            - [~~Memory sanitizer (`MSAN`)~~](#memory-sanitizer-msan)
            - [Thread sanitizer (`TSAN`)](#thread-sanitizer-tsan)
        - [Other sanitizers](#other-sanitizers)
            - [Undefined-Behavior sanitizer (`UBSAN`)](#undefined-behavior-sanitizer-ubsan)
4. [Misc](#misc)
    - [Why I quitted `MSAN`](#why-i-quitted-msan)
    - [Sanitizers vs Valgrind](#sanitizers-vs-valgrind)
    - [Common FAQ](#common-faq)

## First things first

- *Pro tip*: Clone this repo to your computer first will make your life much easier:
    - If you have already cloned before, update it using `sh ./update.sh`
    - To clone, run: `git clone --depth=1 --single-branch --branch cpp https://github.com/jerryc05/MyTemplate`

0. Copy *everything* in this `.cmake_config` folder (including the folder itself) to your project root accordingly.

0. Copy *everything* from `CMakeLists.txt` file between the line:

   `# ===== BEGIN OF CMAKE ARGS TEMPLATE =====`

   and the line:

   `# ===== ADD YOUR TARGETS BELOW THIS LINE =====`

   to your `CMakeLists.txt`.

0. As suggested by the comment, make sure all `add_executable()` calls are placed below this line:

   `# ===== ADD YOUR TARGETS BELOW THIS LINE =====`

    or your `CMakeLists.txt` will not work properly.

0. *Optional:* You might also want to copy (and use) `.gitignore`, `main.cpp` and `Misc.h`.

## Recommended tools

### [Ccache](https://ccache.dev/)

#### Download & Install

- [Windows](https://ccache.dev/download.html)
- Linux(`apt`): `apt install ccache`
- MacOS(`brew`): `brew install ccache`

#### How to enable **Ccache**

- *No action needed if you followed [First things first](#first-things-first).*

### [Ninja](https://ninja-build.org/)

#### Download & Install

- Linux(`apt`): `apt install ninja-build`
- MacOS(`brew`): `brew install ninja`
- [Other pre-built packages](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages)
- [Zipped binary](https://github.com/ninja-build/ninja/releases)

#### How to enable **Ninja** in *CLion*

- *CLion*:
    - `File` (or `CLion` in MacOS)
        - `Settings` (or `Preferences` in MacOS)
        - `Build, Execution, Deployment`
        - `CMake`
        - `Profiles` (right panel)
        - If only "Debug" profile exists, click the plus icon above once to add "Release" profile.
        - Append `-GNinja` to `CMake options` of every profile (notice spaces between args)
    - `File`
      - `New Project Settings`
      - `Settings(Preferences) for New Projects...` - *(Repeat same actions above)*

### [LLVM Clang](https://llvm.org/)

*Pro tip:* LLVM Clang is different from Apple Clang (comes with XCode in MacOS) in many ways
- e.g. Apple Clang has no sanitizers.

#### Download & Install

- Linux(`apt`): `apt install clang`
- MacOS(`brew`): `brew install llvm`
- [Zipped binary](https://releases.llvm.org/download.html)

#### How to setup **Clang** in *CLion*

- *CLion*:
    - Follow [this link](https://www.jetbrains.com/help/clion/how-to-create-toolchain-in-clion.html)
    - *Pro tip*: You might want to set **C/C++ Compiler** to `clang/clang++` respectively to use Clang.
    - *Pro tip*: Make sure you are using Clang **from LLVM**, not Apple.
    - *Pro tip*: If you followed [First things first](#first-things-first), CMake will print `USING COMPILER [<compiler_name>]` to stdout.
        - Check that out. Shall be very useful.

### [Clang-Tidy](https://clang.llvm.org/extra/clang-tidy/)

#### Download & Install

*Pro tip*: Clang-tidy usually comes with Clang altogether and no additional installation is required.

- How do I know if Clang-Tidy can be used in *CLion*?
    - Follow [First things first](#first-things-first) to setup your CMake environment.
    - Follow [How to setup Clang in CLion](#how-to-setup-clang-in-clion) to setup your **LLVM** Clang compiler.
    - Enable static analyzer by uncommenting this line (remove the preceding `#`) in `CMakeLists.txt`:
        ```text
        #set(__USE_ANALYZER__                    ON)
        ```
    - If *CLion* prompt for reloading CMake changes, click `Reload changes` (or `Enable Auto-Reload`).
    - CMake will print these lines to stdout:
        - If succeeful:
            ```
            -- USING COMPILER [LLVM Clang]
            --
            -- 	[STATIC ANALYZER]
            -- 	[STATIC ANALYZER] - ON
            ```
        - If not:
            ```
            -- USING COMPILER [LLVM Clang]
            --
            -- 	[STATIC ANALYZER]
            CMake Error at .cmake_config/static-analyzer.cmake:* (message):
                [STATIC ANALYZER] clang-tidy NOT FOUND!
            ```
            - You might want to resolve this issue if you want to use this powerful tool.
    - *\[OPTIONAL\]* Re-comment out the line that you just modified at your wish, since Clang-Tidy might slow down your build time.
        - However, it will produce helpful insights when it is enabled.

In case you really need to install it manually:

- Linux(`apt`): `apt install clang-tidy`

#### How to enable **Clang-Tidy**

- *No action needed if you followed [First things first](#first-things-first).*


## High-level *"switches"*

- *Pro tip*: How to turn on any of the following *"switches"*?
    - Open `CMakeLists.txt`
    - Uncomment that line (remove the preceding `#`) like you did before!
- *Pro tip*: You can safely ignore those explanations about pros and cons.

### Non-sanitizer flags

- `__USE_ANALYZER__`: Use compiler-builtin static analyzer.
    - `Default: OFF`.
    - Pros:
        - Catch known mistakes at compile time.
        - Warns about bad practices/styles. \[Clang-Tidy only\]
    - Cons:
        - Might **SIGNIFICANTLY** slow down compilation time,
        - Might not work for *too complicated* projects.

- `__USE_LATEST_CPP_STD__`: Compile with the latest `C++` std available.
    - `Default: ON`.
    - Pros: Compile with the latest std automatically.
    - Cons: *Refer to incompatibilities between `C++` standards online.*

- `__REL_USE_HACKED_MATH__`: Compile with aggressive/hacky/dirty math optimizations in **RELEASE** mode.
    - `Default: ON`.
    - Pros: Might speed up arithmetic calculation.
    - Cons: Might break IEEE 754 floating-point implementation standard.

### Sanitizer flags

*Pro tip*: Sanitizers will be effective in **DEBUG** mode only.

#### The "Big-Three" sanitizers

*Pro tip*: If you turned any of the "Big-THree" on, **DO NOT** (**DO NOT**! **DO NOT**!) run the program with `Valgrind`.

##### Address sanitizer (`ASAN`)

- `__DBG_SANITIZE_ADDR__`: Compile with **Address Sanitizer**.
    - `Default: ON`.
    - Pros:
        - Catch memory errors in runtime without sacrificing much performance.
        - Works with IDE debuggers.
    - Cons:
        - Not compatible with `Valgrind`.
        - Not compatible with either `Memory` or `Thread` sanitizer.


<details><summary>Memory sanitizer is deliberately collapsed (you can safely ignore this)</summary><p>

##### ~~Memory sanitizer (`MSAN`)~~

- ~~`__DBG_SANITIZE_MEMORY__`: Compile with **Memory Sanitizer**.~~
    - **DO NOT USE THIS** unless you know what you are doing.
    -  See below: [why I quitted `MSAN`](#why-i-quitted-msan).
    - `Default: OFF | Support: DROPPED`.
        - Pros:
            - Catch uninitialized memory reads in runtime without sacrificing much performance.
            - Works with IDE debuggers.
        - Cons:
            - Not compatible with `Valgrind`.
            - Not compatible with either `Memory` or `Thread` sanitizer.
            - Only supported on `Linux` and `*BSD`.
            - Produces false positives if **ANY** part of the code isn't built with `MSAN` (e.g. `C++ Std Lib`).

</p></details>

##### Thread sanitizer (`TSAN`)

- `__DBG_SANITIZE_THRD__`: Compile with **Thread Sanitizer**.
    - `Default: OFF | Support: WIP`.
    - Pros:
        - Catch data races in runtime without sacrificing much performance.
        - Works with IDE debuggers.
    - Cons:
        - Not compatible with `Valgrind`.
        - Not compatible with either `Address` or `Memory` sanitizer.


#### Other sanitizers

##### Undefined-Behavior sanitizer (`UBSAN`)

- `__DBG_SANITIZE_UB__`: Compile with **Undefined-Behavior Sanitizer**.
    - `Default: ON`.
    - todo ..

- todo ...

<!-- todo

__DBG_SANITIZE_LEAK_STANDALONE__
__DBG_SANITIZE_UB__


clang tidy/d args in clion
-->


## Misc

### Why I quitted `MSAN`

**TL; DR**:
- `MSAN` will produce false positives unless all parts of code are compiled with `MSAN`.
- However, 99.9% of chance are that you are using compiler-builtin `C++ standard library`, which is not compiled with `MSAN`.

For more info, check these:
- [Handling external code](https://clang.llvm.org/docs/MemorySanitizer.html#id10).
- [Using instrumented libraries](https://github.com/google/sanitizers/wiki/MemorySanitizer#using-instrumented-libraries).


### Sanitizers vs `Valgrind`

Reference: [Memory/Address Sanitizer vs Valgrind](https://stackoverflow.com/questions/47251533/memory-address-sanitizer-vs-valgrind)

#### Sanitizers

- Much faster.
- Much smaller memory overhead.
- Can detect more errors (e.g. non-heap overflows in `ASAN`), but cannot run all sanitizers at the same time.
- Works with IDE debuggers.

#### `Valgrind`

- Detects most of what `ASAN` & `MSAN` & `TSAN` can do at the same time.
- Runs the programi inside a VM (super slow but super accurate).
- *Currently* might still need `Valgrind` to do what `MSAN` can do, since `MSAN` is unsupported.


### Common FAQ

#### 1. Misuse with `Valgrind`

Q: When I run the compiled program with `Valgrind`, I am stuck at something like:
```
Warning: set address range perms: ...
```

A: Kill `Valgrind` (or `memcheck`) immediately , or it will (*likely*) use up **all** system resources and run **forever**.
- A useful command for `*ix` systems is: `ps | grep -F valgrind | grep -v grep | awk '{print "kill -9 " $1}'`. You need to pipe its output to `sh`.
- \[*WARNING AGAIN* !!!\] Any sanitizer that hacks program's memory is incompatible with `Valgrind`.
    - e.g. `ASAN`, `MSAN`, `LSAN`, (*haven't tested`TSAN`*).
    - `UBSAN` is fine.

#### 2. Leak check option in `ASAN`

Q: `ASAN`/`LSAN` does not catch memory leak on MacOS.

~~A: You have 2 options:~~
- ~~\[RECOMMENDED\] Follow `ASAN` runtime flags settings above.~~
- ~~\[NOT RECOMMENDED\] Disable `ASAN` and run with LSAN instead (other `ASAN` checks will also be disabled).~~

A: This shall not happen now.
