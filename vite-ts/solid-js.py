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
                "customMatcher": "\\.module\\.(c|le|sa|sc|pc)ss$",
                # "goToDefinition": True,
                # "postcssOptions": { "useConfig": True }
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

    VITE_IMPORT = re.compile(R'import { *defineConfig *} from [\'"]vite[\'"]')
    assert VITE_IMPORT.search(content)
    content = VITE_IMPORT.sub("import { PluginOption, defineConfig, normalizePath } from 'vite'", content)

    content = R"""
import * as path from 'node:path'
import { fileURLToPath } from 'node:url'
// @ts-expect-error: no type declaration file
import incstr from 'incstr'
import { babel } from '@rollup/plugin-babel'
import { createHtmlPlugin } from 'vite-plugin-html'
import { constants } from 'node:fs'
import { access, open, readFile, readdir, stat } from 'node:fs/promises'
import * as path from 'node:path'
import { fileURLToPath } from 'node:url'
import { brotliCompress } from 'node:zlib'

// eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
const nextId = incstr.idGenerator({
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call, @typescript-eslint/restrict-template-expressions
  alphabet: `${incstr.alphabet}-_`,
}) as () => string
const cssClassMap = new Map<string, string>()
const jsdelivr = 'https://cdn.jsdelivr.net'


function buildPostProcessor(
  fn: (p: string) => Promise<void> | void
): PluginOption {
  let outRoot = ''
  async function iterDir(dir: string) {
    await readdir(dir).then(xs =>
      Promise.all(
        xs.map(async x_ => {
          const x = path.resolve(dir, x_)
          const statRes = await stat(x)
          await (statRes.isDirectory() ? iterDir(x) : fn(x))
        })
      )
    )
  }
  return {
    apply: 'build',
    async closeBundle() {
      await access(outRoot, constants.F_OK).then(() => iterDir(outRoot))
    },
    configResolved(conf) {
      outRoot = normalizePath(path.resolve(conf.root, conf.build.outDir))
    },
    enforce: 'post',
    name: buildPostProcessor.name,
  }
}

""" + content

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
    }), buildPostProcessor(async p => {
      // p = p.split(path.sep).join(path.posix.sep)
      if (/\.(?:js|css|html|svg)$/u.test(p)) return
      const newFileName = `${p}.br`,
        orig = await readFile(p),
        compressed: Buffer = await new Promise((resolve, reject) => {
          brotliCompress(orig, (e, b) => (e ? reject(e) : resolve(b)))
        }),
        newSz = compressed.byteLength,
        origSz = await stat(p).then(s => s.size),
        willSave = newSz < origSz * 0.95
      if (willSave)
        await open(newFileName, 'wx').then(async f => f.write(compressed))
      // if alredy exist then err out
      // eslint-disable-next-line no-console
      console.log(
        `${p}\n\t${origSz} \t-> ${newSz} bytes \t` +
          `${(newSz / origSz).toFixed(4)}x ${willSave ? '✅' : '❌'}`
      )
    }),
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
    content = content.replace(
        "import {",
        """
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
render(() => <App />, mount)
"""
    )
    f.truncate(0)
    f.seek(0)
    f.write(content)

with open("src/index.css", "w", encoding="utf-8") as f:
    f.write(
        """
html {
  scroll-behavior: smooth;
}

::-webkit-scrollbar {
  width: 1rem;
}

::-webkit-scrollbar-thumb {
  border: 0.2rem solid transparent;
  border-radius: 1rem;
  background-clip: content-box;
  background-color: #282c34;
}
"""
    )

with open("src/mixins.scss", "w", encoding="utf-8") as f:
    f.write(
        """
@mixin button {
  cursor: pointer; /* But do NOT make buttons look like links */
  background-color: unset;

  border-style: none;
}

@mixin flex-and-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

@mixin timing-fast-in-slow-out {
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

$phone: 768px;
$tablet: 1280px;
$pc: 1600px;

@mixin tablet {
  @media screen and (min-width: #{$phone}) and (max-width: #{$tablet}) {
    @content;
  }
}

@mixin pc {
  @media screen and (min-width: #{$tablet}) and (max-width: #{$pc}) {
    @content;
  }
}

@mixin pc-wide {
  @media screen and (min-width: #{$pc}) {
    @content;
  }
}
"""
    )
