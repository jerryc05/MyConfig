import path = require("path")

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
// import { minifyHtml, injectHtml } from 'vite-plugin-html'





// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    MyPostProcessorOnBuild(p => { }),
    // minifyHtml(), injectHtml({ data: { injectHead: '' } })
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  // base: ''  # Default: '/'
  //       └-> Removes leading slash from the path
  css: {
    postcss: {
      plugins: [{
        // Remove @charset warnings
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
  }
})





import { readdir, stat } from 'fs/promises'
import { Plugin, normalizePath } from 'vite'
function MyPostProcessorOnBuild(fn: (p:string) => Promise<void> | void): Plugin {
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
