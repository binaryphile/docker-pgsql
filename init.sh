#!/bin/bash

ROOT=/root
PGDATA=$ROOT/postgresql
PGBIN=/usr/local/pgsql/bin
PGCONF=$ROOT/postgresql.conf
PGCMD=$PGBIN/postgres
PGINIT=$PGBIN/initdb
USERNAME=docker
PASSWORD=d0cker

$PGINIT $PGDATA
$PGCMD --single -c config_file=$PGCONF <<< "CREATE USER $USERNAME WITH SUPERUSER PASSWORD '$PASSWORD';"

