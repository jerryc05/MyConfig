import { defineStore } from 'pinia'

// useX could be anything like useUser, useCart
// the first argument is a unique id of the store across your application
export const useX = defineStore('x', {
  state: () => <{ x: string | null }>{},
  getters: {
    // Same as computed
    isEmpty: (d) => !d.x
  },
  actions: {
    // Same as methods
  }
})
