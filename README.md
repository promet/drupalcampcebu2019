# Drupalcamp Cebu 2019
This is the source code for the official website of Drupalcamp Cebu 2019 based on Drupal 8.
## Requirements
* [Docker](https://docs.docker.com/engine/installation/)

## Local Site Installation

1. Download and rename the database file into `./build/ref_db/dcc.sql.gz`.

2. Run `make initialize` to start the local environment setup. You will only need to run this command on your initial site setup.

## Development lifecycle commands
1. This project utilizes a Makefile for the main development lifecycle. Run `make help` to check the available commands or check the Makefile itself.
2. After the initial setup, use `make up` to start and `make stop` to stop your project environment.

## Run Drush commands
```
docker-compose run -rm drush -l <command>
```