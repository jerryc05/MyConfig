#!/usr/bin/env python3

import json
import re
import subprocess as sp

# Copy .bablerc, .browserslistrc, .eslintrc.js, postcss.config.js, .prettierrc.js

sp.check_call("npx degit solidjs/templates/ts ./".split(" "))

sp.check_call("pnpm up -Lri".split(" "))
#                       ||└ interactive
#                       |└- recursive
#                       └-- update to latest version

sp.check_call(
    "pnpm i -D only-allow vite-plugin-html incstr typescript-plugin-css-modules @types/node @rollup/plugin-babel @babel/core @babel/preset-env babel-preset-solid eslint-plugin-solid".split(
        " "
    )
)


with open("package.json", "r+", encoding="utf-8") as f:
    content = json.load(f)
    content["engines"] = {"node": ">=14"}
    content["scripts"]["preinstall"] = "npx only-allow pnpm"
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
import { createHtmlPlugin } from 'vite-plugin-html'

// eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call, @typescript-eslint/restrict-template-expressions
const nextId = incstr.idGenerator({ alphabet: `${incstr.alphabet}-_` }) as ()=>string
const cssClassMap = new Map<string, string>()
const jsdelivr = 'https://cdn.jsdelivr.net'

import {
""",
    )

    PLUGINS_STR = "[solidPlugin()]"
    assert PLUGINS_STR in content
    content = content.replace(
        PLUGINS_STR,
        """
[
    solidPlugin(), babel({ babelHelpers: 'bundled' }), createHtmlPlugin({
      entry: 'src/index.tsx',
      inject: {
        tags: [
          {
            attrs: { content: 'width=device-width,initial-scale=1', name: 'viewport' },
            // eslint-disable-next-line sonarjs/no-duplicate-string
            injectTo: 'head-prepend',
            tag: 'meta',
          },
          {
            attrs: { charset: 'utf8' },
            injectTo: 'head-prepend',
            tag: 'meta',
          },
          {
            attrs: {
              content: 'max-age=9999999;includeSubDomains',
              'http-equiv': 'Strict-Transport-Security'
            },
            injectTo: 'head-prepend',
            tag: 'meta',
          },
          {
            attrs: {
              content: `upgrade-insecure-requests;default-src 'self';script-src 'self' ${jsdelivr};style-src 'self' 'unsafe-inline' ${jsdelivr}`,  // [*-elem] doesn't work in Safari/iOS, fvck Safari
              'http-equiv': 'Content-Security-Policy',
            },
            injectTo: 'head-prepend',
            tag: 'meta',
          },
          {
            attrs: {
              content: 'nosniff',
              'http-equiv': 'X-Content-Type-Options',
            },
            injectTo: 'head-prepend',
            tag: 'meta',
          },
        // {
        //   injectTo: 'head-prepend',
        //   tag: 'title',
        //   children: 'Title'
        // },
        // {
        //   injectTo: 'head-prepend',
        //   tag: 'link',
        //   attrs: {
        //     rel: 'icon',
        //     href: '/favicon.ico',
        //   },
        // },
        ]
      },
      minify: true
    })
  ]
""",
    )

    BUILD_REGEX = re.compile(r"build:\s*{\s*target:\s*'esnext'\s*}")
    assert BUILD_REGEX.search(content)
    content = BUILD_REGEX.sub(
        R"""
  build: {
    reportCompressedSize: false, // improve speed,
    target: 'esnext'
  },
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
  resolve: { alias: { '@': path.resolve(path.dirname(fileURLToPath(import.meta.url)), './src') /* check tsconfig.json => paths */ } }
""",
        content,
    )

    SERVER_REGEX = re.compile(r"server:\s*{\s*port:\s*\d+\s*}")
    assert SERVER_REGEX.search(content)
    content = SERVER_REGEX.sub(R"server: { host: true }", content)

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
    css = "import './index.css'"
    assert css in content
    content = content.replace(css, "import './index.scss'")

    content = content.replace(
        "import {",
        """
import { ErrorBoundary } from "solid-js"
import 'modern-normalize/modern-normalize.css'
import {
""",
    )
    ORIG_RENDER = "render(() => <App />, document.getElementById('root')"
    assert ORIG_RENDER in content
    content = (
        content[: content.find(ORIG_RENDER)]
        + """
const mount = document.createElement('div')
document.body.insertBefore(mount, document.body.firstChild)
render(() => (
  <ErrorBoundary fallback={(err, reset) => (
    <div style={{ 'text-align': 'center' }}>
      <div>{err}</div>
      <div>{JSON.stringify(err)}</div>
      <button type='button' onClick={reset}>Reset</button>
    </div>)}
  >
    <App />
  </ErrorBoundary>), mount)
"""
    )
    f.truncate(0)
    f.seek(0)
    f.write(content)

with open("src/index.scss", "w", encoding="utf-8") as f:
    f.write(
        """
@mixin button {
  cursor: pointer; /* But do NOT make buttons look like links */
  background-color: unset;

  border-style: none;
}

::-webkit-scrollbar {
  width: 1rem;
}

::-webkit-scrollbar-thumb {
  border: .2rem solid transparent;
  border-radius: 1rem;
  background-clip: content-box;
  background-color: #282c34;
}

@mixin flex-and-center {
  display: flex;
  justify-content: center;
  align-items: center;
}
"""
    )

from pathlib import Path

Path("src/index.css").unlink()
