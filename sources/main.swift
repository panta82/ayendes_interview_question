import Foundation

let MINUTE = 60
let HOUR = MINUTE * 60

func formatInterval(_ interval: TimeInterval) -> String {
	let hr = Int(interval / Double(HOUR))
	let min = Int((interval - Double(hr * HOUR)) / Double(MINUTE))
	let sec = Int(interval - Double(hr * HOUR + min * MINUTE))
	let ms = Int((interval - Double(hr * HOUR + min * MINUTE + sec)) * 1000)
	return "\(hr):\(min):\(sec):\(ms)"
}

class Accumulator {
	private var data = [String: TimeInterval]()

	private let dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		return df
	}()

	func submitLine(_ line: String) {
		let parts = line.components(separatedBy: " ")
		if parts.count < 3 {
			// Invalid line
			return
		}
		guard let from = dateFormatter.date(from: parts[0]), let to = dateFormatter.date(from: parts[1]) else {
			// Invalid date formats
			return
		}

		let elapsed = to.timeIntervalSince(from)
		let car = parts[2]
		
		data[car] = (data[car] ?? 0) + elapsed
	}

	func printResults() {
		for (car, duration) in data {
			print("\(car)  \(formatInterval(duration))")
		}
	}
}

func handleLine(_ line: String) {
	print(line)
}

func readFromStdIn(_ onLine: (String) -> Void) {
	print("Reading from STDIN:")
	var line: String?
	while true {
		line = readLine();
		if (line != nil) {
			onLine(line!)
		} else {
			break
		}
	}
}

func readFromFile(_ rawFilename: String, _ onLine: (String) -> Void) {
	let filename = NSString(string: rawFilename).expandingTildeInPath
	print("Reading from file: \(filename)")
	if let sr = StreamReader(path: filename) {
		defer {
			sr.close()
		}

		for line in sr {
			onLine(line)
		}
	}
}

let startedAt = Date()

let accumulator = Accumulator()
if (CommandLine.arguments.count > 1) {
	readFromFile(CommandLine.arguments[1], accumulator.submitLine)
} else {
	readFromStdIn(accumulator.submitLine)
}
accumulator.printResults()

let elapsed = Date().timeIntervalSince(startedAt)
print("-------------------------")
print("Total time \(formatInterval(elapsed))")