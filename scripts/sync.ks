#!/usr/bin/env kaoscript

import 'fs'
import 'klaw-sync' => klaw
import 'output-file-sync'
import 'path'

extern __dirname, console

var srcRoot = path.join(__dirname, '..', '..', 'parser', 'test', 'fixtures')
var destRoot = path.join(__dirname, '..', 'test', 'fixtures')

var fixtures = fs.readFileSync(path.join(__dirname, 'sync-local.txt'), 'utf8').split(/\n/g)

// 1. update existing files
func update(srcPath) { # {{{
	return unless fs.existsSync(srcPath.slice(0, -3) + '.json')

	var dirname = path.basename(path.dirname(srcPath).substr(srcRoot.length))
	var filename = path.basename(srcPath)

	try {
		fs.readFileSync(path.join(destRoot, dirname, filename), {
			encoding: 'utf8'
		})

		write(dirname, filename, filename)
	}
	catch {
		try {
			fs.readFileSync(path.join(destRoot, dirname, filename + '.no'), {
				encoding: 'utf8'
			})

			console.log(`- no: \(path.join(dirname, filename))`)

			write(dirname, filename, `\(filename).no`)
		}
		catch {
			console.log(`- new: \(path.join(dirname, filename))`)

			write(dirname, filename, filename)
		}
	}
} # }}}

func write(dirname, srcFilename, destFilename) { # {{{
	var data = fs.readFileSync(path.join(srcRoot, dirname, srcFilename), {
		encoding: 'utf8'
	})

	outputFileSync(path.join(destRoot, dirname, destFilename), data)
} # }}}

for file in klaw(srcRoot, {
	nodir: true,
	traverseAll: true,
	filter: item => item.path.slice(-3) == '.ks'
}) {
	update(file.path)
}

// 2. remove old files
func check(destPath) { # {{{
	var dirname = path.basename(path.dirname(destPath).substr(destRoot.length))
	var filename = path.basename(destPath)

	try {
		fs.readFileSync(path.join(srcRoot, dirname, filename), {
			encoding: 'utf8'
		})
	}
	catch {
		// delete
		var name = filename.slice(0, -3)

		if !fixtures.some((fixture, ...) => fixture == name) {
			console.log(`- deleting: \(path.join(dirname, name)).ks`)

			try {
				fs.unlinkSync(path.join(destRoot, dirname, `\(name).hitt`))
			}

			fs.unlinkSync(path.join(destRoot, dirname, filename))
		}
	}
} # }}}

for file in klaw(destRoot, {
	nodir: true,
	traverseAll: true,
	filter: item => item.path.slice(-3) == '.ks'
}) {
	check(file.path)
}
