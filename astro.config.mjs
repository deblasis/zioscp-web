// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// GitHub Pages project site: served at https://deblasis.github.io/zioscp-web/
// (move to a custom domain later by setting `site` to it and `base` to '/').
export default defineConfig({
	site: 'https://deblasis.github.io',
	base: '/zioscp-web/',
	trailingSlash: 'ignore',
	integrations: [
		starlight({
			title: 'zioscp',
			logo: {
				light: './src/assets/logo-light.svg',
				dark: './src/assets/logo-dark.svg',
				replacesTitle: true,
			},
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/deblasis/zioscp' },
			],
			sidebar: [
				{
					label: 'Start',
					items: [
						{ label: 'Install', slug: 'install' },
						{ label: 'Quickstart', slug: 'quickstart' },
					],
				},
				{
					label: 'Guides',
					items: [
						{ label: 'Resume', slug: 'guides/resume' },
						{ label: 'Parallel transfers', slug: 'guides/parallel' },
						{ label: 'Transport backends', slug: 'guides/backends' },
						{ label: 'Host-key verification', slug: 'guides/host-keys' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ label: 'CLI flags', slug: 'reference/flags' },
						{ label: 'Benchmarks', slug: 'reference/benchmarks' },
					],
				},
				{
					label: 'Project',
					items: [
						{ label: 'Roadmap', slug: 'project/roadmap' },
						{ label: 'License', slug: 'project/license' },
					],
				},
			],
			customCss: ['./src/styles/custom.css'],
			favicon: '/favicon.svg',
			components: { Footer: './src/components/StarlightFooter.astro' },
		}),
	],
});
