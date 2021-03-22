test:
	node_modules/.bin/mocha --colors --check-leaks --require kaoscript/register --reporter spec$(if $(value g), -g "$(g)") "test/test.ks"

build:
	npx kaoscript scripts/build.ks

patch:
	npx kaoscript scripts/patch.ks

sync:
	npx kaoscript scripts/sync.ks

copy:
	cp lib/kaoscript.tmLanguage ../highlight-vscode/syntaxes
	cp lib/kaoscript.tmLanguage ../website/vscode_extensions/language-kaoscript/syntaxes

.PHONY: test build patch sync copy