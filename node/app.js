const fs = require('fs');
const readline = require('readline');

const startedAt = new Date();

const filePath = process.argv[2];
if (!filePath) {
	throw new Error(`Usage: ${process.argv[0]} ${process.argv[1]} [data.txt]`);
}

const rl = readline.createInterface({
	input: fs.createReadStream(filePath, 'utf8')
});

const data = {};

rl
	.on('line', (line) => {
		let [from, to, car] = line.split(' ');
		const duration = new Date(to) - new Date(from);
		data[car] = (data[car] || 0) + duration;
	})
	.on('close', () => {
		for (let car in data) {
			const duration = (data[car] / (1000 * 60)).toFixed(2);
			console.log(`${car}  ${duration} min`);
		}
		
		const elapsed = ((new Date() - startedAt) / 1000).toFixed(2);
		console.log(`Elapsed: ${elapsed} sec`);
	});

