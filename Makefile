test:
ifeq ($(g),)
	node_modules/.bin/mocha --colors --check-leaks --require kaoscript/register --reporter spec "test/test.ks"
else
	node_modules/.bin/mocha --colors --check-leaks --require kaoscript/register --reporter spec -g "$(g)" "test/test.ks"
endif

build:
	npx kaoscript scripts/build.ks

patch:
	npx kaoscript scripts/patch.ks

sync:
	npx kaoscript scripts/sync.ks

copy:
	cp lib/kaoscript.tmLanguage ../highlight-vscode/syntaxes

.PHONY: test build patch sync copy