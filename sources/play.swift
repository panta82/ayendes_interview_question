struct Address {
	var street = ""
	var city = ""
	var country = ""
}

class Person: CustomStringConvertible {
	var name = ""
	var surname = ""
	var address = Address()

	var fullName: String {
		return name + " " + surname
	}

	var description: String {
		return "\(fullName) lives in \(address.city)";
	}

	init(name: String, surname: String) {
		self.name = name
		self.surname = surname
	}
}

protocol Talker {
	var saying: String {get set}
	func talk()
}

class SimpsonsCharacter: Person, Talker {
	var saying = ""
	
	init(name: String, surname: String, saying: String) {
		super.init(name: name, surname: surname)
		self.saying = saying
	}
	
	func talk() {
		print("\(fullName) says \(saying)")
	}
}

func play() {
	let homer = SimpsonsCharacter(
		name: "Homer",
		surname: "Simpson",
		saying: "Doh!"
	)
	homer.talk() //> Homer Simpson says Doh!
}
