import { defineConfig } from "astro/config";
import vercel from '@astrojs/vercel/static';

// https://astro.build/config
import solidJs from "@astrojs/solid-js";

// https://astro.build/config
export default defineConfig({
	site: "https://domnantas.lt",
	integrations: [solidJs()],
	adapter: vercel({
    analytics: true
  })
});
