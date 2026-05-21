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
    shikiConfig: {
      themes: {
        light: 'min-light',
        dark: 'min-dark',
      },
    },
  },
  integrations: [
    starlight({
      title: 'Intro to Julia for Spectroscopy',
      defaultLocale: 'en',
      locales: {
        en: { label: 'English' },
        ja: { label: '日本語' },
      },
      customCss: ['./src/styles/custom.css'],
      components: {
        SiteTitle: './src/components/SiteTitle.astro',
        PageTitle: './src/components/PageTitle.astro',
      },
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy' },
      ],
    }),
  ],
});
