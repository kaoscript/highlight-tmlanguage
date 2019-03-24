#![bin]

extern {
	__dirname: String
	console
	describe: Function
	it: Function
}

import {
	'@zokugun/lang'
	'chai'				for expect
	'fs'
	'klaw-sync'			=> klaw
	'path'
}

/* import './tokenize'(path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage')) */
const grammarFilePath = path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage')

import './generate'(grammarFilePath)

describe('highlight', func() {
	func prepare(file) {
		const root = path.dirname(file)
		const name = path.basename(file).slice(0, -3)

		it(name, func() {
			const source = fs.readFileSync(file, {
				encoding: 'utf8'
			})

			const data = generate(source)
			// console.log(data)

			const tokens: String = fs.readFileSync(path.join(root, name + '.hitt'), {
				encoding: 'utf8'
			})

			expect(data.lines()).to.eql(tokens.lines())
		})
	}

	const options = {
		nodir: true
		traverseAll: true
		filter: item => item.path.slice(-3) == '.ks'
	}

	for file in klaw(path.join(__dirname, 'fixtures'), options) {
		prepare(file.path)
	}
})