#!/bin/bash

if [ -f ".env" ]; then
  source .env
fi

: ${PG_IMAGE?"need to set image name PG_IMAGE, see README.md"}

: ${ROOT=/root}
: ${PGUSER=postgres}
: ${PGDATA=$ROOT/db}
: ${PGCONF=$ROOT/conf/postgresql.conf}
: ${PGBIN=/usr/local/pgsql/bin}
: ${PGCMD="$PGBIN/postgres -c config_file=$PGCONF"}
: ${PGPORT=5432}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-d -w $ROOT -p $PGPORT:5432 -u $PGUSER -v $(pwd):$ROOT -e ROOT=$ROOT -e PGDATA=$PGDATA"}

$SUDO docker run $OPTIONS $PG_IMAGE $PGCMD

