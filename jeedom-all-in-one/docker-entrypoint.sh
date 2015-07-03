#!/bin/bash
set -e

if [ -n "$MYSQL_PORT_3306_TCP" ]; then
	if [ -z "$JEEDOM_DB_HOST" ]; then
		JEEDOM_DB_HOST='mysql'
	else
		echo >&2 'warning: both JEEDOM_DB_HOST and MYSQL_PORT_3306_TCP found'
		echo >&2 "  Connecting to JEEDOM_DB_HOST ($JEEDOM_DB_HOST)"
		echo >&2 '  instead of the linked mysql container'
	fi
fi

if [ -z "$JEEDOM_DB_HOST" ]; then
	echo >&2 'error: missing JEEDOM_DB_HOST and MYSQL_PORT_3306_TCP environment variables'
	echo >&2 '  Did you forget to --link some_mysql_container:mysql or set an external db'
	echo >&2 '  with -e JEEDOM_DB_HOST=hostname:port?'
	exit 1
fi

# if we're linked to MySQL, and we're using the root user, and our linked
# container has a default "root" password set up and passed through... :)
: ${JEEDOM_DB_USER:=root}
if [ "$JEEDOM_DB_USER" = 'root' ]; then
	: ${JEEDOM_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
fi
: ${JEEDOM_DB_NAME:=jeedom}

if [ -z "$JEEDOM_DB_PASSWORD" ]; then
	echo >&2 'error: missing required JEEDOM_DB_PASSWORD environment variable'
	echo >&2 '  Did you forget to -e JEEDOM_DB_PASSWORD=... ?'
	echo >&2
	echo >&2 '  (Also of interest might be JEEDOM_DB_USER and JEEDOM_DB_NAME.)'
	exit 1
fi

# on modifie le contenu avec les paramètres fixés lors de la configuration de l'utilisateur mysql dédié (cf. "Bases de données mysql")
#sed -i "s/#PASSWORD#/${JEEDOM_DB_PASSWORD}/g" /tmp/create_jeedom_db.sql

if [ "$JEEDOM_DB_HOST" = "localhost" ]
then
  /usr/bin/mysqld_safe &
  sleep 5
fi

set_config() {
	key="$1"
	value="$2"
	php_escaped_value="$(php -r 'var_export($argv[1]);' "$value")"
	sed_escaped_value="$(echo "$php_escaped_value" | sed 's/[\/&]/\\&/g')"
	sed -ri "s/((['\"])$key\2\s*=>\s*)(['\"]).*\3/\1$sed_escaped_value/" ./core/config/common.config.php
}

set_config 'host' "$JEEDOM_DB_HOST"
set_config 'username' "$JEEDOM_DB_USER"
set_config 'password' "$JEEDOM_DB_PASSWORD"
set_config 'dbname' "$JEEDOM_DB_NAME"
set_config 'port' "$MYSQL_PORT_3306_TCP"

TERM=dumb php -- "$JEEDOM_DB_HOST" "$JEEDOM_DB_USER" "$JEEDOM_DB_PASSWORD" "$JEEDOM_DB_NAME" <<'EOPHP'
<?php
// database might not exist, so let's try creating it (just to be safe)

$stderr = fopen('php://stderr', 'w');

list($host, $port) = explode(':', $argv[1], 2);

$maxTries = 10;
do {
	$mysql = new mysqli($host, $argv[2], $argv[3], '', (int)$port);
	if ($mysql->connect_error) {
		fwrite($stderr, "\n" . 'MySQL Connection Error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
		--$maxTries;
		if ($maxTries <= 0) {
			exit(1);
		}
		sleep(3);
	}
} while ($mysql->connect_error);

if (!$mysql->query('CREATE DATABASE IF NOT EXISTS `' . $mysql->real_escape_string($argv[4]) . '`')) {
	fwrite($stderr, "\n" . 'MySQL "CREATE DATABASE" Error: ' . $mysql->error . "\n");
	$mysql->close();
	exit(1);
}

$mysql->close();
EOPHP

php /usr/share/nginx/www/jeedom/install/install.php mode=force

if [ "$JEEDOM_DB_HOST" = "localhost" ]
then
  /usr/bin/mysqladmin --user=${JEEDOM_DB_USER} --password=${JEEDOM_DB_PASSWORD} shutdown
fi

exec "$@"

