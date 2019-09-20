#!/usr/bin/env bash

source ../.env

set -e
path=$(dirname "$0")
base=$(cd $path/.. && pwd)
drush="../vendor/drush/drush/drush $flags -y -r $base/web"
cd $base/web
