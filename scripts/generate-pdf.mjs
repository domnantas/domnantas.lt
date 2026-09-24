import { build, preview } from "astro";
import { chromium } from "playwright-core";

const OUTPUT_PATH = new URL(
	"../public/Resume-Domantas-Vasiliauskas.pdf",
	import.meta.url,
).pathname;

await build({ logLevel: "warn" });

const server = await preview({ logLevel: "warn" });
const browser = await chromium.launch({ channel: "chrome" });

try {
	const page = await browser.newPage({
		colorScheme: "light",
		reducedMotion: "reduce",
	});
	await page.goto(`http://localhost:${server.port}/`, {
		waitUntil: "networkidle",
	});
	await page.evaluate(() => document.fonts.ready);

	await page.pdf({
		path: OUTPUT_PATH,
		format: "A4",
		printBackground: true,
		// Keeps the desktop layout (>768px) and fits everything on one page
		scale: 0.75,
		margin: { top: "1cm", right: "1cm", bottom: "1cm", left: "1cm" },
	});

	console.log(`PDF saved to ${OUTPUT_PATH}`);
} finally {
	await browser.close();
	await server.stop();
}
