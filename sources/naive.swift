import Foundation

let dateFormatter: DateFormatter = {
	let df = DateFormatter()
	df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
	df.timeZone = TimeZone(secondsFromGMT: 0)
	return df
}()

func readAllFromFileAndTally(_ rawFilename: String) {
	let filename = NSString(string: rawFilename).expandingTildeInPath
	print("Reading from file: \(filename)")
	let content = try? String(contentsOfFile: filename, encoding: String.Encoding.utf8)
	if content == nil {
		print("Couldn't read input")
		return
	}

	let lines = content!.components(separatedBy: "\r\n")

	let elapsed = Date().timeIntervalSince(startedAt)
	print("Loaded data after \(formatInterval(elapsed))")

	var data = [String: TimeInterval]()
	for line in lines {
		let parts = line.components(separatedBy: " ")

		if parts.count < 3 {
			print("Invalid line: \(line)")
			continue
		}
		guard let from = dateFormatter.date(from: parts[0]), let to = dateFormatter.date(from: parts[1]) else {
			print("Invalid dates: \(parts[0]), \(parts[1])")
			continue
		}

		let car = parts[2]

		let elapsed = to.timeIntervalSince(from)
		data[car] = (data[car] ?? 0) + elapsed
	}

	print("Result count: \(data.count)")
	for (car, duration) in data {
		print("\(car)  \(formatInterval(duration))")
	}
}