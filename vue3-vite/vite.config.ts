import * as path from 'path'

import { access, open, readdir, readFile, stat } from 'fs/promises'
import { defineConfig, HtmlTagDescriptor, normalizePath, Plugin } from 'vite'

import { brotliCompress } from 'zlib'
import { constants } from 'fs'
import { createHtmlPlugin } from 'vite-plugin-html'
import removeConsole from 'vite-plugin-remove-console'
import { viteExternalsPlugin } from 'vite-plugin-externals'
import vue from '@vitejs/plugin-vue'
// import windiCSS from 'vite-plugin-windicss'


const target = 'esnext',
  jsdelivr = 'https://cdn.jsdelivr.net',
  tags: HtmlTagDescriptor[] = [
    {
      injectTo: 'head-prepend',
      tag: 'meta',
      attrs: {
        'http-equiv': 'Content-Security-Policy',
        // [*-elem] doesn't work in Safari/iOS, fvck Safari
        content: `default-src 'self';script-src 'self' ${jsdelivr};` +
          `style-src 'self' 'unsafe-inline' ${jsdelivr}`,
      },
    },
    {
      injectTo: 'head-prepend',
      tag: 'meta',
      attrs: {
        'http-equiv': 'X-Content-Type-Options',
        content: 'nosniff',
      },
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
    {
      injectTo: 'head-prepend',
      tag: 'meta',
      attrs: {
        name: 'viewport',
        content: 'width=device-width,initial-scale=1.0',
      },
    },
    {
      injectTo: 'head-prepend',
      tag: 'meta',
      attrs: {
        charset: 'UTF-8',
      },
    },
  ],
  extPlugs: Plugin[] = []

if (process.env.NODE_ENV === 'production') {
  tags.push(
    {
      injectTo: 'head',
      tag: 'script',
      attrs: {
        defer: true,
        src: 'https://cdn.jsdelivr.net/npm/vue@3/dist/vue.runtime.global.prod.js',
      },
    }, {
      injectTo: 'head',
      tag: 'script',
      attrs: {
        defer: true,
        src: 'https://cdn.jsdelivr.net/npm/vue-demi',
      },
    }, {
      injectTo: 'head',
      tag: 'script',
      attrs: {
        defer: true,
        src: 'https://cdn.jsdelivr.net/npm/pinia',
      },
    },
    // {
    //   injectTo: 'head',
    //   tag: 'script',
    //   attrs: {
    //     defer: true,
    //     src: 'https://cdn.jsdelivr.net/npm/@vueuse/core',
    //   },
    // }
  )
  extPlugs.push(viteExternalsPlugin({
    vue: 'Vue',
    pinia: 'Pinia',
    // '@vueuse/core': 'VueUse'
  }))
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-argument
  extPlugs.push(removeConsole())
}

function buildPostProcessor (fn: (p: string) => Promise<void> | void): Plugin {
  let outRoot = ''
  async function iterDir (dir: string) {
    await readdir(dir).then(xs => Promise.all(xs.map(
      async x_ => {
        const x = path.resolve(dir, x_)
        await stat(x).then(async s => (s.isDirectory() ? iterDir(x) : fn(x)))
      }
    )))
  }
  return {
    name: buildPostProcessor.name,
    enforce: 'post',
    apply: 'build',
    configResolved (conf) {
      outRoot = normalizePath(path.resolve(conf.root, conf.build.outDir))
    },
    async closeBundle () {
      await access(outRoot, constants.F_OK).then(() => iterDir(outRoot))
    }
  }
}


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
              htmlLang: '"en-US"', // '"zh-cmn-Hans"',
            },
            tags,
          },
        }
      ]
    }),
    // WindiCSS(),
    ...extPlugs,
    buildPostProcessor(async p => {
      if ((/\.(?:\w?js|css)$/u).test(p)) {
        let content = (await readFile(p)).toString()
        const commentRegex = /\/\*[\s\S]*?\*\//ug
        if (commentRegex.test(content)) {
          content = content.replace(commentRegex, '')
          await open(p, 'w').then(async f => f.write(content))
        }
      }
    }),
    buildPostProcessor(async p => {
      // p = p.split(path.sep).join(path.posix.sep)
      /* if (/\.(\w?js|css|\w?html)$/.test(p)) { */
      const newFileName = `${p}.br`,
        orig = await readFile(p),
        compressed: Buffer = await new Promise((acc, rej) => {
          brotliCompress(orig, (e, b) => (e ? rej(e) : acc(b)))
        }),
        newSz = compressed.byteLength,
        origSz = await stat(p).then(s => s.size),
        willSave = newSz < origSz * 0.95
      if (willSave) {
        await open(newFileName, 'wx').then(async f => f.write(compressed))
      } // if alredy exist then err out
      console.log(`${p}\n\t${origSz} \t-> ${newSz} bytes \t` +
        `${(newSz / origSz).toFixed(4)}x ${willSave ? '✅' : '❌'}`)

      /* } */
    })
  ],
  build: {
    reportCompressedSize: false, // improve speed
    target
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'), // check tsconfig.json => paths
    },
  },
  // base: ''  # Default: '/'
  //       └-> Removes leading slash from the path
  css: {
    modules: {
      localsConvention: 'camelCase',
    },
    // postcss: {
    //   plugins: [
    //     {  // Remove @charset warnings
    //       postcssPlugin: 'internal:charset-removal',
    //       AtRule: {
    //         charset: (atRule) => {
    //           if (atRule.name === 'charset') {
    //             atRule.remove()
    //           }
    //         }
    //       }
    //     }]
    // }
  },
  optimizeDeps: {
    esbuildOptions: {
      target
    }
  },
  server: {
    host: true,
    port: 5000,
    strictPort: false,
    // https: {
    //   minVersion: 'TLSv1.3',
    //   cert: 'server.crt',
    //   key: 'server.key',
    // }
  }
})
