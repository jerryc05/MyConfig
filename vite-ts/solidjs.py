#!/usr/bin/env python3

import subprocess as sp
import json

sp.check_call("npx degit solidjs/templates/ts ./".split(" "))


sp.check_call("pnpm up -Lri".split(" "))
#                       ||└ interactive
#                       |└- recursive
#                       └-- update to latest version

sp.check_call("pnpm i @babel/core @babel/preset-env babel-preset-solid -D".split(" "))

with open(".bablerc", "w", encoding="utf-8") as f:
    f.write(
        json.dumps({"presets": ["solid", ["@babel/preset-env", {"bugfixes": True}]]})
    )

with open(".browserslistrc", "w", encoding="utf-8") as f:
    f.write(
        """
last 2 chrome version
last 2 firefox version
last 2 and_chr version
last 1 and_ff version
last 1 ios_saf version
"""
    )

with open("src/index.tsx", "r+", encoding="utf-8") as f:
    content = f.read()
    content = (
        content[: content.find("render(() => <App />, document.getElementById('root')")]
        + """
const mount = document.createElement('div')
document.body.insertBefore(mount, document.body.firstChild)
render(() => <App />, mount)
"""
    )
    f.truncate(0)
    f.seek(0)
    f.write(content)


with open("index.html", "r+", encoding="utf-8") as f:
    content = f.read()
    content = content.replace('<div id="root"></div>\n','')
    f.truncate(0)
    f.seek(0)
    f.write(content)
