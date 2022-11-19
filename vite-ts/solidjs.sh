#!/usr/bin/env bash

npx degit solidjs/templates/ts ./

pnpm up -Lri
#        ||└ interactive
#        |└- recursive
#        └-- update to latest version

pnpm i @babel/core @babel/preset-env babel-preset-solid -D

cat <<eof >.babelrc
{
  "presets": [
    "solid",
    [
      "@babel/preset-env",
      {
        "bugfixes": true
      }
    ]
  ]
}
eof

cat <<eof >.browserslistrc
last 2 chrome version
last 2 firefox version
last 2 and_chr version
last 2 and_ff version
last 2 ios_saf version
eof
