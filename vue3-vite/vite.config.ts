import path = require("path")

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
// import { minifyHtml, injectHtml } from 'vite-plugin-html'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
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
