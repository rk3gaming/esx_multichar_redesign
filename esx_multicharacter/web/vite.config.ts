import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// https://vite.dev/config/
export default defineConfig({
  base: './',
  plugins: [svelte()],
  build: {
    outDir: 'build/dist',
    assetsDir: 'assets',
    emptyOutDir: true
  },
})
