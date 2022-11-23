#!/usr/bin/env python3

import subprocess as sp
import json

# Copy .bablerc, .browserslistrc, .eslintrc.js, postcss.config.js

sp.check_call("npx degit solidjs/templates/ts ./".split(" "))

sp.check_call("pnpm up -Lri".split(" "))
#                       ||└ interactive
#                       |└- recursive
#                       └-- update to latest version

sp.check_call(
    "pnpm i -D incstr typescript-plugin-css-modules @types/node @rollup/plugin-babel @babel/core @babel/preset-env babel-preset-solid eslint-plugin-solid".split(
        " "
    )
)


with open("package.json", "r+", encoding="utf-8") as f:
    content = json.load(f)
    content["engines"] = {"node": ">=14"}
    build: str = content["scripts"]["build"]
    if not build.startswith("tsc"):
        content["scripts"]["build"] = f"tsc && {build}"
    f.seek(0)
    f.truncate(0)
    f.write(json.dumps(content, indent=2))

with open("tsconfig.json", "r+", encoding="utf-8") as f:
    content = json.load(f)

    opt = content["compilerOptions"]
    opt["lib"] = ["ESNext", "DOM", "DOM.Iterable"]
    opt["forceConsistentCasingInFileNames"] = True
    opt["plugins"] = opt.get("plugins", []) + [
        {
            "name": "typescript-plugin-css-modules",
            "options": {
                "classnameTransform": "asIs",
                "customMatcher": "\\.module\\.(c|le|sa|sc|pc)ss$",
                "jumpToDefinition": True,
            },
        }
    ]
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
        "import {",
        R"""
import * as path from 'node:path'
import { fileURLToPath } from 'node:url'
// @ts-expect-error: no type declaration file
import incstr from 'incstr'
import { babel } from '@rollup/plugin-babel'

// eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call, @typescript-eslint/restrict-template-expressions
const nextId = incstr.idGenerator({ alphabet: `${incstr.alphabet}-_` }) as ()=>string
const cssClassMap = new Map<string, string>()

import {
""",
    )

    PLUGINS_STR = "[solidPlugin()]"
    assert PLUGINS_STR in content
    content = content.replace(
        PLUGINS_STR, '[solidPlugin(), babel({ babelHelpers: "bundled" })]'
    )

    BUILD_STR = "build: { target: 'esnext' },"
    assert BUILD_STR in content
    content = content.replace(
        BUILD_STR,
        R"""
  build: { target: 'esnext' },
  css: {
    modules: {
      generateScopedName: process.env.NODE_ENV === 'production'
        ? (name, filename/* , css */) => {
          const key = `${name}@${filename}`
          if (!cssClassMap.get(key)) {
            let id = ''
            while (!/(?:-?[A-Z_a-z]+|--)[\w-]*/u.test(id))
              id = nextId()
            cssClassMap.set(key, id)
          }
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          return cssClassMap.get(key)!
        }
        : undefined,
    }
  },
  resolve: { alias: { '@': path.resolve(path.dirname(fileURLToPath(import.meta.url)), './src') /* check tsconfig.json => paths */ } },
""",
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
