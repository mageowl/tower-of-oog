const sleep = (ms) => new Promise((res) => setTimeout(res, ms))
const results = () => result.innerText.split("\n").filter(t => t)
const generate = async (n) => {
	let output = new Set();
	let i = 0;
	while (output.size < n && i < n * 10) {
		nameGen(2);
		results().forEach((i) => output.add(i));
		await sleep(100);
		i++;
	}
	return [...output];
}

// generate(1000).then(console.log)
