module.exports = {
	env: {
		es2022: true,
	},
	parser: "@typescript-eslint/parser",
	extends: [
		"eslint:recommended",
		"plugin:astro/recommended",
		"plugin:astro/jsx-a11y-recommended",
	],
	overrides: [
		{
			files: ["*.astro"],
			parser: "astro-eslint-parser",
			parserOptions: {
				parser: "@typescript-eslint/parser",
				extraFileExtensions: [".astro"],
			},
			rules: {
				// override/add rules settings here, such as:
				// "astro/no-set-html-directive": "error"
			},
		},
		{
			files: ["**/*.tsx"],
			plugins: ["solid"],
			extends: ["plugin:solid/typescript"],
		},
		{
			files: ["**/*.cjs"],
			env: {
				node: true,
			},
		},
	],
};
