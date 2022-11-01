#!/usr/bin/env kaoscript

extern console

import 'fs'
import 'path'
import 'output-file-sync'
import 'plist'
import 'js-yaml' => yaml

var YAML_FILE = './src/kaoscript.tmLanguage.yaml'
var PLIST_FILE = './lib/kaoscript.tmLanguage'

func replacePatternVariables(mut value, variables) {
	for var [regex, replacement] in variables {
		value = value.replace(regex, replacement)
	}

	return value
}

func transformGrammar(grammar) {
	if ?grammar.variables {
		for var value, name of grammar.variables {
			for var _, key of grammar.variables {
				grammar.variables[key] = grammar.variables[key].replace(new RegExp(`{{\(name)}}`, 'gim'), value)
			}
		}

		var variables = []
		for var value, name of grammar.variables {
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
	for var value of grammar.repository {
		transformGrammarRule(value, transformProperty)
	}
}

func transformGrammarRule(rule, transformProperty) {
	for var name in ['begin', 'end', 'match'] {
		if rule[name] is String {
			rule[name] = transformProperty(rule[name])
		}
	}

	for var rules of rule when rules is Array {
		for var rule in rules {
			transformGrammarRule(rule, transformProperty)
		}
	}

	if ?rule.captures {
		for var rule of rule.captures {
			transformGrammarRule(rule, transformProperty)
		}
	}
}

var grammar = transformGrammar(yaml.safeLoad(fs.readFileSync(YAML_FILE, 'utf8')))

outputFileSync(PLIST_FILE, plist.build(grammar))
