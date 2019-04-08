test:
ifeq ($(g),)
	node_modules/.bin/mocha --colors --check-leaks --require kaoscript/register --reporter spec "test/test.ks"
else
	node_modules/.bin/mocha --colors --check-leaks --require kaoscript/register --reporter spec -g "$(g)" "test/test.ks"
endif

build:
	npx kaoscript build.ks

patch:
	npx kaoscript patch.ks

sync:
	npx kaoscript sync.ks

.PHONY: test build patch sync