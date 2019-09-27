<?php

$settings['hash_salt'] = 'wcuwk6h7BlsLkTdMFN8jA9h-eJbxeM7V-aOr5EzyARYXqbsaBR0eWTQ0HA1PoaPOzd9GJxUF7A';

$databases['default']['default'] = [
  'database' => getenv('MYSQL_DATABASE'),
  'username' => getenv('MYSQL_USER'),
  'password' => getenv('MYSQL_PASSWORD'),
  'prefix' => '',
  'host' => getenv('MYSQL_HOSTNAME'),
  'port' => getenv('MYSQL_PORT'),
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
];

$config_directories['sync'] = getenv('SYNC_DIRECTORY');
