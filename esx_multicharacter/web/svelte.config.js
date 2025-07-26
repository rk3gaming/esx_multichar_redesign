import adapter from '@sveltejs/adapter-auto';

/** @type {import('svelte').Config} */
const config = {
  kit: {
    adapter: adapter()
  }
};

export default config;
