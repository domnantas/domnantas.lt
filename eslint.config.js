import js from "@eslint/js";
import astro from "eslint-plugin-astro";
import solid from "eslint-plugin-solid/configs/typescript";
import globals from "globals";
import tseslint from "typescript-eslint";

export default [
	{
		ignores: ["dist/", ".astro/", "node_modules/", "src/scripts/Gradient.js"],
	},
	js.configs.recommended,
	{
		languageOptions: {
			globals: globals.browser,
		},
	},
	...astro.configs["flat/recommended"],
	...astro.configs["flat/jsx-a11y-recommended"],
	{
		files: ["**/*.tsx"],
		...solid,
		languageOptions: {
			parser: tseslint.parser,
		},
	},
	{
		files: ["**/*.cjs"],
		languageOptions: {
			globals: globals.node,
		},
	},
];
