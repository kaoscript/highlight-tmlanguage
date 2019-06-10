#![bin]

extern console

import 'fs'
import 'path'
import 'output-file-sync'
import 'plist'
import 'js-yaml' => yaml

const YAML_FILE = './src/kaoscript.tmLanguage.yaml'
const PLIST_FILE = './lib/kaoscript.tmLanguage'

func replacePatternVariables(value, variables) {
	for const [regex, replacement] in variables {
		value = value.replace(regex, replacement)
	}

	return value
}

func transformGrammar(grammar) {
	if grammar.variables? {
		for const value, name of grammar.variables {
			for const :key of grammar.variables {
				grammar.variables[key] = grammar.variables[key].replace(new RegExp(`{{\(name)}}`, 'gim'), value)
			}
		}

		const variables = []
		for const value, name of grammar.variables {
			variables.push([new RegExp(`{{\(name)}}`, 'gim'), value])
		}

		delete grammar.variables

		transformGrammarRepository(
			grammar
			value => replacePatternVariables(value, variables)
		)
	}

	return grammar
}

func transformGrammarRepository(grammar, transformProperty) {
	for const value of grammar.repository {
		transformGrammarRule(value, transformProperty)
	}
}

func transformGrammarRule(rule, transformProperty) {
	for const name in ['begin', 'end', 'match'] {
		if rule[name] is String {
			rule[name] = transformProperty(rule[name])
		}
	}

	for const rules of rule when rules is Array {
		for const rule in rules {
			transformGrammarRule(rule, transformProperty)
		}
	}

	if rule.captures? {
		for const rule of rule.captures {
			transformGrammarRule(rule, transformProperty)
		}
	}
}

const grammar = transformGrammar(yaml.safeLoad(fs.readFileSync(YAML_FILE, 'utf8')))

outputFileSync(PLIST_FILE, plist.build(grammar))