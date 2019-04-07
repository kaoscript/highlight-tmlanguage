#![bin]

import 'fs'
import 'klaw-sync' => klaw
import 'output-file-sync'
import 'path'

extern __dirname, console

const srcRoot = path.join(__dirname, '..', 'parser', 'test', 'fixtures')
const destRoot = path.join(__dirname, 'test', 'fixtures')

const fixtures = fs.readFileSync('./sync.txt', 'utf8').split(/\n/g)

// 1. update existing files
for file in klaw(srcRoot, {
	nodir: true,
	traverseAll: true,
	filter: item => item.path.slice(-3) == '.ks'
}) {
	update(file.path)
}

func update(srcPath) { // {{{
	return unless fs.existsSync(srcPath.slice(0, -3) + '.json')

	const dirname = path.basename(path.dirname(srcPath).substr(srcRoot.length))
	const filename = path.basename(srcPath)

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
} // }}}

func write(dirname, srcFilename, destFilename) { // {{{
	const data = fs.readFileSync(path.join(srcRoot, dirname, srcFilename), {
		encoding: 'utf8'
	})

	outputFileSync(path.join(destRoot, dirname, destFilename), data)
} // }}}

// 2. remove old files
for file in klaw(destRoot, {
	nodir: true,
	traverseAll: true,
	filter: item => item.path.slice(-3) == '.ks'
}) {
	check(file.path)
}

func check(destPath) { // {{{
	const dirname = path.basename(path.dirname(destPath).substr(destRoot.length))
	const filename = path.basename(destPath)

	try {
		fs.readFileSync(path.join(srcRoot, dirname, filename), {
			encoding: 'utf8'
		})
	}
	catch {
		// delete
		const name = filename.slice(0, -3)

		if !fixtures.some(fixture => fixture == name) {
			console.log(`- deleting: \(path.join(dirname, name)).ks`)

			fs.unlinkSync(path.join(destRoot, dirname, `\(name).hitt`))
			fs.unlinkSync(path.join(destRoot, dirname, filename))
		}
	}
} // }}}