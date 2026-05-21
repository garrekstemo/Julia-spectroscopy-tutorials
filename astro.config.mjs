import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://garrekstemo.github.io',
  base: '/Intro-to-Julia-for-spectroscopy',
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
