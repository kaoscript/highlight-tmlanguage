#![bin]

extern {
	__dirname: String
	console
}

import {
	'fs'
	'klaw-sync'
	'output-file-sync'
	'path'
}

const grammarFilePath = path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage')

import '../test/generate'(grammarFilePath)

func prepare(file) {
	const root = path.dirname(file)
	const name = path.basename(file).slice(0, -3)

	const source = fs.readFileSync(file, {
		encoding: 'utf8'
	})

	const data = generate(source)

	outputFileSync(path.join(root, `\(name).hitt`), data)
}

for file in klawSync(path.join(__dirname, '..', 'test', 'fixtures'), {
	nodir: true
	traverseAll: true
	filter: item => item.path.slice(-3) == '.ks'
}) {
	prepare(file.path)
}