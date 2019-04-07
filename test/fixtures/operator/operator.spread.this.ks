class Greetings {
	private {
		_messages: Array<String>
	}

	constructor(@messages)

	print() {
		console.log(...this._messages)
	}
}