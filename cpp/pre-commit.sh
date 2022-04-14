#!/usr/bin/env sh

find src test -type f \( -name '*.h' -o -name '*.cpp' \) -exec clang-format -Wno-error=unknown -i '{}' \;

git diff --name-only --cached | xargs git add 2>/dev/null || true
