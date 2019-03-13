build-client:
	node_modules/.bin/webpack --config client.webpack.config.js

build-client-watch:
	node_modules/.bin/webpack-dev-server --config client.webpack.config.js

build-server:
	node_modules/.bin/webpack --config server.webpack.config.js && chmod +x server/bin/www

build-server-watch:
	node_modules/.bin/webpack-dev-server --config server.webpack.config.js

generate-port-types:
	node_modules/.bin/elm-typescript-interop

lint:
	make lint-client && make lint-server

lint-client:
	node_modules/.bin/tslint -p tslint.json ./client/ts/**/*.ts

lint-server:
	node_modules/.bin/tslint -p tslint.json ./server/ts/**/*.ts

test:
	make test-client && make test-server && make lint

test-client:
	make test-elm && make test-ts-client

test-server:
	make test-ts-server

test-elm:
	node_modules/.bin/elm-test client/elm/

test-ts-client:
	node_modules/.bin/jest --config jest.config.client.js --testRegex client\/ts\/[^/]+/*Test.ts

test-ts-server:
	node_modules/.bin/jest --config jest.config.server.js --testRegex server\/[^/]+/*Test.ts

test-ts-watch-client:
	node_modules/.bin/jest --config jest.config.client.js --watch --testRegex client\/ts\/[^/]+/*Test.ts

test-ts-watch-server:
	node_modules/.bin/jest --config jest.config.server.js --watch --testRegex server\/[^/]+/*Test.ts
