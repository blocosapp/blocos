build-dev:
	make build-elm && make build-js && make build-scss

build-elm:
	elm make ./elm/Main.elm --output ./static/js/app.js

watch-elm:
	node_modules/.bin/nodemon --exec "make build-elm" -e "elm" -i "static"

build-scss:
	./node_modules/.bin/sass scss/index.scss static/css/app.css

build-js:
	./node_modules/.bin/webpack

watch-all:
	node_modules/.bin/nodemon --exec "make build-dev" -e "js elm scss" -i "static"
