extern console

// TODO
// require var grammarFilePath: String

var mut grammarFilePath: String = ''
export func configure(file: String) {
	grammarFilePath = file
	
	grammar = register.loadGrammarFromPathSync(grammarFilePath)
}

import {
	'@zokugun/lang'
	'path'
	'vscode-textmate' => vt
}

var register = new vt.Registry()

var mut grammar? = null

func writeTokenLine(line, token, preTextForToken, output) { # {{{
	var startingSpaces = ' '.repeat(token.startIndex:Number + 1)
	var locatingString = '^'.repeat(token.endIndex:Number - token.startIndex:Number)

	output.push(startingSpaces + line.substring(token.startIndex, token.endIndex))
    output.push(startingSpaces + locatingString)
    output.push(startingSpaces + preTextForToken + token.scopes.join(' '))
} # }}}

export func generate(content: String, indentSize: Number = 4): String { # {{{
	var lines = content.replace(/\t/g, ' '.repeat(indentSize)).lines(true)

	var output = [
		'original file'
		'-----------------------------------'
		...lines
		'-----------------------------------'
		''
		`grammar: \(path.basename(grammarFilePath))`
		'-----------------------------------'
	]

	var mut tokens: Array? = null
	var mut ruleStack = null

	for var line, index in lines {
		{tokens, ruleStack} = grammar?.tokenizeLine(line, ruleStack)

		output.push(`>`, `>\(line)`)

		for var token in tokens {
			writeTokenLine(line, token, '', output)
		}
	}

	return output.join('\n')
} # }}}