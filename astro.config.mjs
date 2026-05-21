import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

export default defineConfig({
  site: 'https://garrekstemo.github.io',
  base: '/Intro-to-Julia-for-spectroscopy',
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  integrations: [
    starlight({
      title: 'Intro to Julia for Spectroscopy',
      customCss: ['./src/styles/custom.css'],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy' },
      ],
    }),
  ],
});
