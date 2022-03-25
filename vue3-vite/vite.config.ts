import { open, readdir, readFile, stat } from 'fs/promises'
import * as path from 'path'
import { brotliCompress } from 'zlib'

import vue from '@vitejs/plugin-vue'
import { defineConfig, normalizePath, Plugin } from 'vite'
import { createHtmlPlugin } from 'vite-plugin-html'
import { viteExternalsPlugin } from 'vite-plugin-externals'


// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    createHtmlPlugin({
      minify: true,
      pages: [
        {
          entry: 'src/main.ts',
          filename: 'index.html',
          template: 'index.html',
          injectOptions: {
            data: {
              htmlLang: '"en-US"',  // '"zh-cmn-Hans"',
            },
            tags: [
              {
                injectTo: 'head-prepend',
                tag: 'meta',
                attrs: {
                  'http-equiv': 'Content-Security-Policy',
                  content: "default-src 'self';script-src-elem 'self' https://cdn.jsdelivr.net",
                },
              },
              {
                injectTo: 'head',
                tag: 'script',
                attrs: {
                  src: 'https://cdn.jsdelivr.net/npm/vue@3/dist/vue.runtime.global.prod.js',
                },
              },
              {
                injectTo: 'head',
                tag: 'script',
                attrs: {
                  src: 'https://cdn.jsdelivr.net/npm/vue-demi',
                },
              },
              {
                injectTo: 'head',
                tag: 'script',
                attrs: {
                  src: 'https://cdn.jsdelivr.net/npm/pinia',
                },
              },
            ],
          },
        }
      ]
    }),
    viteExternalsPlugin({
      vue: 'Vue',
      pinia: 'Pinia'
    }),
    MyPostProcessorOnBuild(async p => {
      if (/\.(\w?js|css)$/.test(p)) {
        let content = await (await readFile(p)).toString()
        const commentRegex = /\/\*[\s\S]*?\*\//g
        if (commentRegex.test(content)) {
          content = content.replace(commentRegex, '')
          await open(p, 'w').then(async f => f.write(content))
        }
      }
    }),
    MyPostProcessorOnBuild(async p => {
      /* if (/\.(\w?js|css|\w?html)$/.test(p)) */ {
        const origSz = await stat(p).then(s => s.size)
        const newFileDir = path.join(path.dirname(p), '_br')
        await mkdir(newFileDir, { recursive: true })
        const newFileName = path.join(newFileDir, path.basename(p))
        const orig = await readFile(p)
        const compressed: Buffer = await new Promise((acc, rej) =>
          brotliCompress(orig, (e, b) => e ? rej(e) : acc(b))
        )
        const newSz = compressed.byteLength
        const willSave = newSz < origSz * 0.95
        if (willSave)
          await open(newFileName, 'wx').then(async f => f.write(compressed))
        console.log(`${p}\n\t${origSz} \t-> ${newSz} bytes \t${(newSz / origSz).toFixed(4)}x ${willSave ? '✅' : '❌'}`)
      }
    })
  ],
  build: {
    reportCompressedSize: false  // improve speed
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  // base: ''  # Default: '/'
  //       └-> Removes leading slash from the path
  css: {
    postcss: {
      plugins: [
        {  // Remove @charset warnings
          postcssPlugin: 'internal:charset-removal',
          AtRule: {
            charset: (atRule) => {
              if (atRule.name === 'charset') {
                atRule.remove()
              }
            }
          }
        }]
    }
  },
  server: {
    port: 5000,
    strictPort: false,
    // https: {
    //   minVersion: 'TLSv1.3',
    //   cert: 'server.crt',
    //   key: 'server.key',
    // }
  }
})





function MyPostProcessorOnBuild(fn: (p: string) => Promise<void> | void): Plugin {
  let outRoot: string
  async function iterDir(dir: string) {
    await readdir(dir).then(xs => xs.forEach(async x => {
      x = path.resolve(dir, x)
      await stat(x).then(async s => {
        if (!s.isDirectory()) await fn(x)
        else await iterDir(x)
      })
    }
    ))
  }
  return {
    name: MyPostProcessorOnBuild.name,
    enforce: "post",
    apply: "build",
    configResolved(conf) {
      outRoot = normalizePath(path.resolve(conf.root, conf.build.outDir))
    },
    async closeBundle() { await iterDir(outRoot) }
  }
}
