# ----------------
# Make help script
# ----------------

# Usage:
# Add help text after target name starting with '\#\#'
# A category can be added with @category. Team defaults:
# 	dev-environment
# 	docker
# 	test

# Output colors
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

DRUSH = docker-compose run --rm drush
COMPOSER = docker run --rm -v ${PWD}/.composer-tmp:/tmp -v ${PWD}:/app llt104/composer:1.8-php7.3

# Script
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help:
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

initialize: composer-install ## Initialize local environment.
	@echo "> Setting up the Drupal site. Any existing database data will be removed."
	@if [ ! -f "docroot/sites/default/settings.local.php" ]; then \
		echo "> Copying settings.local.php into ./docroot/sites/default/."; \
		cp ./build/settings.local.php ./web/sites/default/settings.local.php; \
	fi
	@echo "> Starting containers."
	@docker-compose up -d --build
	@echo "Waiting for database connection to be established."
	@while ! docker-compose exec db mysqladmin -hlocalhost ping --silent &> /dev/null ; do \
		echo "> ..."; \
		sleep 2; \
	done
	@if [ ! -f "build/ref_db/dcc.sql.gz" ]; then \
		echo "> [WARNING] Database dump not found. You might want to import an existing database."; \
	else \
		make db-import; \
	fi
	@echo "> Successfully finished setting up!"

up: ## Start containers.
	@echo "> Starting containers."
	@docker-compose up -d

stop: ## Stop containers.
	@echo "> Stopping containers."
	@docker-compose stop

db-import: db-drop ## Import the database.
	@echo "> Importing the database."
	@sleep 3
	@if command -v pv >/dev/null; then \
		pv ./build/ref_db/dcc.sql.gz | zcat | $(DRUSH) sqlc; \
	else \
		zcat ./build/ref_db/dcc.sql.gz | $(DRUSH) sqlc; \
	fi

db-drop: ## Drop the database.
	@echo "> Dropping the database in 3 seconds. Use Control+C to abort."
	@sleep 3
	@$(DRUSH) sql-drop -y
	@echo "> Successfully dropped the database."

composer-install: ## Runs `composer install`
	@echo "> Running \"composer install\"."
	@$(COMPOSER) install;
