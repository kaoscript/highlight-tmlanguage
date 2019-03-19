extern console

require grammarFilePath

import {
	'@zokugun/lang'
	'path'
	'vscode-textmate' => vt
}

const register = new vt.Registry()

const grammar = register.loadGrammarFromPathSync(grammarFilePath)

func tokenizeLine(line, context) { // {{{
    const {tokens, ruleStack} = context.grammar.tokenizeLine(line, context.ruleStack)

    context.ruleStack = ruleStack

    return tokens
} // }}}

func writeTokenLine(line, token, preTextForToken, output) { // {{{
	const startingSpaces = ' '.repeat(token.startIndex + 1)
	const locatingString = '^'.repeat(token.endIndex - token.startIndex)

	output.push(startingSpaces + line.substring(token.startIndex, token.endIndex))
    output.push(startingSpaces + locatingString)
    output.push(startingSpaces + preTextForToken + token.scopes.join(' '))
} // }}}

export func generate(content: String, indentSize: Number = 4): String { // {{{
	const lines = content.replace(/\t/g, ' '.repeat(indentSize)).lines()

	const output = [
		'original file'
		'-----------------------------------'
		...lines
		'-----------------------------------'
		''
		`grammar: \(path.basename(grammarFilePath))`
		'-----------------------------------'
	]

	const context = {
		grammar
	}

	for const line, index in lines {
		/* {tokens, ruleStack} = grammar.tokenizeLine(line, ruleStack) */

		const tokens = tokenizeLine(line, context)

		output.push(`>`, `>\(line)`)

		for const token in tokens {
			writeTokenLine(line, token, '', output)
		}
	}

	return output.join('\n')
} // }}}