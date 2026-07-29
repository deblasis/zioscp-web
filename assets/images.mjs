// zioscp image assets, generated via cursor-cli-imagen (Cursor Nano Banana + sharp).
//
// Run from the repo root (spends your Cursor image-gen quota):
//
//   node /Users/alex/claude/cursor-cli-imagen/index.mjs \
//        --manifest ./assets/images.mjs --out ./public
//
// Or, if cursor-cli-imagen is installed as a dependency:
//
//   npx cursor-cli-imagen --manifest ./assets/images.mjs --out ./public
//
// Outputs land in ./public (served at the site root) and are referenced from
// src/pages/index.astro (OG card) — re-run after editing prompts; the build
// picks up the new files automatically.

export default [
  {
    // Social / link-preview card (og:image, twitter:card). 1200x630.
    id: "og-card",
    prompt:
      "A wide 1200x630 social card background: deep navy (#0b1020) gradient, " +
      "luminous blue (#3b82f6) and cyan speed-streaks flowing left to right " +
      "suggesting fast data transfer, faint terminal/grid texture, generous " +
      "negative space on the left third. Clean, modern, technical, minimal. " +
      "No text, no words, no letters, no logos.",
    out: { file: "og.png", width: 1200, height: 630, fit: "cover", format: "png" },
  },
  {
    // Subtle dark texture for the landing hero band (used as a faint overlay).
    id: "hero-bg",
    prompt:
      "An abstract wide background texture: near-black navy with very subtle " +
      "blue (#3b82f6) horizontal light streaks and a faint dot-grid, extremely " +
      "dark and low-contrast so foreground text reads cleanly. Minimal, no " +
      "shapes, no subjects. No text, no words, no logos.",
    out: { file: "hero-bg.webp", width: 1600, height: 700, fit: "cover", format: "webp", quality: 78 },
  },
];
