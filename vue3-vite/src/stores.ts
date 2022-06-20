/*
import { defineStore } from 'pinia'
*/


// Declare like this:
/*
export const useStore = defineStore('x', {
  state: () => ({ x: 'example' }),
  getters: {  // Same as computed
    isEmpty(state) { return !state.x }
  },
  actions: {  // Same as methods
    clear() { this.x = '' }
  }
})
*/


// use like this:
/*
import { useStore } from @/stores

const store = useStore()
store.x == 'example'
*/
