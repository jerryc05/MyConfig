import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path = require("path")

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
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
