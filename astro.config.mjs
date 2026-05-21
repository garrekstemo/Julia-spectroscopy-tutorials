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
      sidebar: [
        {
          label: 'Chapters',
          translations: { ja: '章' },
          items: [
            { slug: 'chapters/01-introduction' },
            { slug: 'chapters/02-variables-operators-types' },
            { slug: 'chapters/03-conditionals' },
            { slug: 'chapters/04-iteration' },
            { slug: 'chapters/05-functions' },
            { slug: 'chapters/06-arrays' },
            { slug: 'chapters/07-plotting' },
            { slug: 'chapters/08-fitting' },
            { slug: 'chapters/09-fourier-transform' },
            { slug: 'chapters/10-transfer-matrix' },
          ],
        },
      ],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy' },
      ],
    }),
  ],
});
