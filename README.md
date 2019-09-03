# Blocos
[![CircleCI](https://circleci.com/gh/blocosapp/blocos/tree/master.svg?style=svg)](https://circleci.com/gh/blocosapp/blocos/tree/master) [![JavaScript Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://standardjs.com)

Blocos is a decentralized crowdfunding application. It is built on top of the [Blockstack](https://blockstack.org/) infrastructure, and it's enabled financially by the bitcoin blockchain. Its goal is to allow independent peer-to-peer financial arrangements in an all-or-nothing funding manner.

## Build

### To develop:

1. Start webpack-dev-server:

```shell
make build-client-watch
```

2. Build server:
```shell
make build-server
```

3. Run server:
```shell
cd server && bin/www
```

### To run the project:

1. Build client-side assets:

```shell
NODE_ENV=production make build-client
```

2. Build server:
```shell
NODE_ENV=production make build-server
```

3. Run server:
```shell
cd server && HOST=http://localhost:8000 bin/www
```

### Warning

This project is under intense discovery process. Don't mind the mess. Soon everything will make sense. :)

### Contributions

I'm looking for a partner in this project. If for any reason you'd be interested, drop me a line! :)
