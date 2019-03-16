#![bin]

import 'fs'
import 'path'
import 'plist'
import 'js-yaml' => yaml

func readYaml(file) => yaml.safeLoad(fs.readFileSync(file, 'utf8'))

func writePlistFile(grammar, file) => fs.writeFileSync(file, plist.build(grammar), 'utf8')

writePlistFile(readYaml('./kaoscript.tmLanguage.yaml'), './kaoscript.tmLanguage')