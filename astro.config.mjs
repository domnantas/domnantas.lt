import { defineConfig } from "astro/config";

// https://astro.build/config
import solidJs from "@astrojs/solid-js";

// https://astro.build/config
export default defineConfig({
	site: "https://domnantas.lt",
	integrations: [solidJs()],
});
