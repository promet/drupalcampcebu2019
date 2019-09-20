#!/usr/bin/env bash

# Make sure this script is run from build.
set -e
path=$(dirname "$0")
true=`which true`
source $path/common.sh

echo "...Installing Drupal standard profile... waiting 30s for the database to come up."
sleep 5s # The db container won't be quite ready otherwise.
$drush site-install standard --account-name=${DRUPAL_USER} --account-pass=${DRUPAL_PASSWORD} --db-url='mysql://'${MYSQL_USER}':'${MYSQL_PASSWORD}'@'${MYSQL_HOSTNAME}'/'${MYSQL_DATABASE}'' --site-name=${PROJECT} -y

echo "...Performing update scripts."
source $path/update.sh
