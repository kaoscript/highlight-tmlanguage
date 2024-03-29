test:
	node_modules/.bin/mocha --colors --check-leaks --require kaoscript/register --reporter spec --no-diff$(if $(value g), -g "$(g)") "test/test.ks"

build:
	./scripts/build.ks

patch:
	npx kaoscript scripts/patch.ks

sync:
	./scripts/sync.ks

copy:
	cp lib/kaoscript.tmLanguage ../highlight-vscode/syntaxes
	cp lib/kaoscript.tmLanguage ../website/vscode_extensions/language-kaoscript/syntaxes

update:
	rm -rf node_modules package-lock.json
	nrm use local
	npm i

.PHONY: test build patch sync copy
