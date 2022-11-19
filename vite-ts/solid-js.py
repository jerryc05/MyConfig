#!/usr/bin/env python3

import subprocess as sp
import json

# Copy .browserslistrc and .eslintrc.js

sp.check_call("npx degit solidjs/templates/ts ./".split(" "))


sp.check_call("pnpm up -Lri".split(" "))
#                       ||└ interactive
#                       |└- recursive
#                       └-- update to latest version

sp.check_call(
    "pnpm i -D @types/node @rollup/plugin-babel @babel/core @babel/preset-env babel-preset-solid eslint-plugin-solid".split(
        " "
    )
)


with open(".bablerc", "w", encoding="utf-8") as f:
    f.write(
        json.dumps({"presets": ["solid", ["@babel/preset-env", {"bugfixes": True}]]})
    )

with open("tsconfig.json", "r+", encoding="utf-8") as f:
    content = json.load(f)

    opt = content["compilerOptions"]
    opt["lib"] = ["ESNext", "DOM", "DOM.Iterable"]
    opt["forceConsistentCasingInFileNames"] = True
    opt["resolveJsonModule"] = True
    opt["skipLibCheck"] = True
    opt["useDefineForClassFields"] = True

    opt["baseUrl"] = "./"
    opt["paths"] = {
        "@/*": ["src/*"],
    }

    content["include"] = [
        "src/**/*.ts",
        "src/**/*.tsx",
        "src/**/*.d.ts",
        "src/**/*.js",
        "src/**/*.jsx",
        "src/**/*.vue",
        ".*.js",
        "*.js",
        "*.ts",
    ]
    content["exclude"] = ["node_modules", "dist", "**/*.spec.ts"]
    f.truncate(0)
    f.seek(0)
    f.write(json.dumps(content, indent=2))

with open("vite.config.ts", "r+", encoding="utf-8") as f:
    content = f.read()
    content = content.replace(
        "import {", "import { babel } from '@rollup/plugin-babel'\nimport {"
    )
    PLUGINS_STR = "[solidPlugin()]"
    assert PLUGINS_STR in content
    content = content.replace(
        PLUGINS_STR, '[solidPlugin(), babel({ babelHelpers: "bundled" })]'
    )
    f.truncate(0)
    f.seek(0)
    f.write(content)

with open("index.html", "r+", encoding="utf-8") as f:
    content = f.read()
    ROOT_DIV = '<div id="root"></div>\n'
    assert ROOT_DIV in content
    content = content.replace(ROOT_DIV, "")
    f.truncate(0)
    f.seek(0)
    f.write(content)


with open("src/index.tsx", "r+", encoding="utf-8") as f:
    content = f.read()
    content = content.replace(
        "import {", 'import { ErrorBoundary } from "solid-js"\nimport {'
    )
    ORIG_RENDER = "render(() => <App />, document.getElementById('root')"
    assert ORIG_RENDER in content
    content = (
        content[: content.find(ORIG_RENDER)]
        + """
const mount = document.createElement('div')
document.body.insertBefore(mount, document.body.firstChild)
render(() =>
  <ErrorBoundary fallback={(err, reset) =>
    <div style={{ 'text-align': 'center' }}>
      <div>{err}</div>
      <button onClick={reset}>Reset</button>
    </div>}>
    <App />
  </ErrorBoundary>, mount)
"""
    )
    f.truncate(0)
    f.seek(0)
    f.write(content)

with open("src/index.css", "w", encoding="utf-8") as f:
    f.write(
        """
body { margin: 0; }

::-webkit-scrollbar {
  width: 1rem;
}

::-webkit-scrollbar-thumb {
  border: .2rem solid transparent;
  border-radius: 1rem;
  background-clip: content-box;
  background-color: #282c34;
}
"""
    )
