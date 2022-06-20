import { detectAndSetDarkMode, setDarkMode } from '@/utils/dark_mode'

import { defineStore } from 'pinia'


// Declare like this:
export const useStore = defineStore('x', {
  state: () => ({ isDark: detectAndSetDarkMode(), }),
  getters: {  // Same as computed
    isLight(state) { return !state.isDark }
  },
  actions: {  // Same as methods
    toggleLightDarkMode () {
      this.isDark = !this.isDark
      setDarkMode(this.isDark)
    },
  }
})


// use like this:
/*
import { useStore } from @/stores

const store = useStore()
store.isDark  // true or false
*/
