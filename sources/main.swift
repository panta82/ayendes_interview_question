import Foundation

func handleLine(_ line: String) {
	print(line)
}

func readFromStdIn(_ onLine: (String) -> Void) {
	print("Reading from STDIN:")
	var line: String?
	while true {
		line = readLine();
		if (line != nil) {
			print(".", terminator: "")
			onLine(line!)
		} else {
			print("Done")
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

if (CommandLine.arguments.count > 1) {
	readFromFile(CommandLine.arguments[1], handleLine)
} else {
	readFromStdIn(handleLine)
}