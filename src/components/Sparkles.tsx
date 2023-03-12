import styles from "./Sparkles.module.css";
import {
	children,
	createEffect,
	createSignal,
	For,
	ParentProps,
} from "solid-js";

const random = (min: number, max: number) =>
	Math.floor(Math.random() * (max - min)) + min;

const range = (length: number) => [...Array(length)].map((_, index) => index);

const DEFAULT_COLOR = "hsl(50deg, 100%, 50%)";
const generateSparkle = (color = DEFAULT_COLOR) => ({
	id: String(random(10000, 99999)),
	createdAt: Date.now(),
	color,
	size: random(10, 20),
	style: {
		top: random(0, 100) + "%",
		left: random(0, 100) + "%",
		"z-index": random(-1, 1),
	},
});

const setRandomInterval = (
	callback: any,
	minDelay: number,
	maxDelay: number
) => {
	createEffect(() => {
		const tick = () => {
			setTimeout(() => {
				callback();
				tick();
			}, random(minDelay, maxDelay));
		};
		tick();
	});
};

const Sparkles = (props: ParentProps) => {
	const slot = children(() => props.children);

	const [sparkles, setSparkles] = createSignal(
		range(3).map(() => generateSparkle())
	);

	setRandomInterval(
		() => {
			const now = Date.now();

			const validSparkles = sparkles().filter((sparkle) => {
				const delta = now - sparkle.createdAt;
				return delta < 700;
			});

			setSparkles([...validSparkles, generateSparkle()]);
		},
		50,
		500
	);
	return (
		<span class={styles.wrapper}>
			<For each={sparkles()}>
				{(sparkle) => (
					<div style={sparkle.style} class={styles.sparkleWrapper}>
						<svg
							width={sparkle.size}
							height={sparkle.size}
							class={styles.sparkle}
							viewBox="0 0 160 160"
							fill="none"
							xmlns="http://www.w3.org/2000/svg"
						>
							<path
								d="M80 0C80 0 84.2846 41.2925 101.496 58.504C118.707 75.7154 160 80 160 80C160 80 118.707 84.2846 101.496 101.496C84.2846 118.707 80 160 80 160C80 160 75.7154 118.707 58.504 101.496C41.2925 84.2846 0 80 0 80C0 80 41.2925 75.7154 58.504 58.504C75.7154 41.2925 80 0 80 0Z"
								fill={sparkle.color}
							/>
						</svg>
					</div>
				)}
			</For>
			{slot()}
		</span>
	);
};

export default Sparkles;
