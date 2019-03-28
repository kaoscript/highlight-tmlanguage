const macros = {}

func addMacro(name, macro) {
	if macros[name] is Array {
		if macro.isFlag() {
		}

		macros[name].push(macro)

	}
	else {
		macros[name] = [macro]
	}
}

func getMacro(name, arguments) {
	if macros[name] is Array {
		for macro in macros[name] {
			if macro.matchArguments(data.arguments) {
				return macro
			}
		}
	}
}