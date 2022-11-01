#!/usr/bin/env kaoscript

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

// TODO
// import '../test/generate'(path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage'))
import '../test/generate'

configure(path.resolve(__dirname, '..', 'lib', 'kaoscript.tmLanguage'))

func prepare(file) {
	var root = path.dirname(file)
	var name = path.basename(file).slice(0, -3)

	var source = fs.readFileSync(file, {
		encoding: 'utf8'
	})

	var data = generate(source)

	outputFileSync(path.join(root, `\(name).hitt`), data)
}

for var file in klawSync(path.join(__dirname, '..', 'test', 'fixtures'), {
	nodir: true
	traverseAll: true
	filter: item => item.path.slice(-3) == '.ks'
}) {
	prepare(file.path)
}
