import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

export default defineConfig({
  site: 'https://juliaspectroscopy.org',
  devToolbar: { enabled: false },
  redirects: {
    '/': '/en/',
  },
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  integrations: [
    starlight({
      expressiveCode: {
        themes: ['min-light', 'min-dark'],
      },
      title: 'Julia for Spectroscopy',
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
      sidebar: [
        {
          label: 'Fundamentals',
          translations: { ja: '基礎' },
          items: [
            { slug: 'chapters/introduction' },
            { slug: 'chapters/variables-operators-types' },
            { slug: 'chapters/conditionals' },
            { slug: 'chapters/iteration' },
            { slug: 'chapters/functions' },
          ],
        },
        {
          label: 'Data analysis',
          translations: { ja: 'データ解析' },
          items: [
            { slug: 'chapters/arrays' },
            { slug: 'chapters/plotting' },
            { slug: 'chapters/fitting' },
            { slug: 'chapters/fourier-transform' },
          ],
        },
      ],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy' },
      ],
    }),
  ],
});
