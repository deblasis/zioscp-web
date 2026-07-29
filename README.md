# zioscp-web

Marketing + docs site for [zioscp](https://github.com/deblasis/zioscp), built with
[Astro](https://astro.build) + [Starlight](https://starlight.astro.build). Hosted
free on GitHub Pages at **<https://deblasis.github.io/zioscp-web/>**.

- A custom landing page at `/` (`src/pages/index.astro`).
- Starlight docs under `/install`, `/quickstart`, `/guides/*`, `/reference/*`,
  `/project/*` (Markdown in `src/content/docs/`).
- A shared stuntapi-style footer (`src/components/SiteFooter.astro`) used on the
  landing and (compact) on doc pages.

The codebase is private; the site is public-ready and works either way.

## Develop

```sh
npm install
npm run dev          # http://localhost:4321/zioscp-web/
npm run build        # -> ./dist
npm run preview      # preview the production build
```

The `/zioscp-web/` base path is set in `astro.config.mjs` (project Pages URL).
To use a custom domain, set `site` to it and `base` to `'/'`.

## Imagery (optional)

Link-preview (`og.png`) and a hero texture are generated via
[cursor-cli-imagen](https://github.com/deblasis/cursor-cli-imagen) (Cursor's
Nano Banana + sharp). The manifest is `assets/images.mjs`. Generating spends
your Cursor image-gen quota:

```sh
node /path/to/cursor-cli-imagen/index.mjs \
     --manifest ./assets/images.mjs --out ./public
```

Commit the generated files in `public/` so the Pages build includes them.

## Deploy

Pushing to `main` runs `.github/workflows/deploy.yml`, which builds and publishes
to GitHub Pages. In the repo settings, set **Pages → Source → GitHub Actions**.
