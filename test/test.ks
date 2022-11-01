#![bin]

extern {
	class Context {
		timeout(ms: Number): Void
	}

	func describe(title: String, fn: Function): Void
	// TODO
	// func it(title: String, fn: (this: Context, #[retain] done: Function): Void || (this: Context): Void): Void
	func it(title: String, fn: (#[retain] done: Function): Void || (): Void): Void

	var __dirname: String

	namespace console {
		func log(...?)
	}
}

import {
	'@zokugun/lang'
	'chai'				for expect
	'fs'
	'klaw-sync'			=> klaw
	'path'
}

// TODO
// import './generate'(path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage'))
import './generate'

configure(path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage'))

describe('highlight', func() {
	func prepare(file) {
		var root = path.dirname(file)
		var name = path.basename(file).slice(0, -3)

		it(name, func() {
			// TODO
			// @timeout(1000)

			var source = fs.readFileSync(file, {
				encoding: 'utf8'
			})

			var data = generate(source)

			try {
				var tokens: String = fs.readFileSync(path.join(root, name + '.hitt'), {
					encoding: 'utf8'
				})

				expect(data.lines()).to.eql(tokens.lines())
			}
			catch error {
				console.log(data)

				throw error
			}
		})
	}

	var options = {
		nodir: true
		traverseAll: true
		filter: item => item.path.slice(-3) == '.ks'
	}

	for var file in klaw(path.join(__dirname, 'fixtures'), options) {
		prepare(file.path)
	}
})
