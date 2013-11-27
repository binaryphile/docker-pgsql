#!/bin/bash

if [ -f .env ]; then
  source .env
fi

: ${PG_IMAGE?"need to set image name IMAGE, see README.md"}

: ${ROOT=/root}
: ${PGUSER=postgres}
: ${PGNAME=postgresql}
: ${PGDATA=$ROOT/db}
: ${PGCONF=$ROOT/conf/postgresql.conf}
: ${PGBIN=/usr/local/pgsql/bin}
: ${CMD=/bin/bash}
: ${PGPORT=5432}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-i -t -w $ROOT -p $PGPORT:5432 -u $PGUSER -v $(pwd):$ROOT -e ROOT=$ROOT -e PGDATA=$PGDATA -e PGNAME=$PGNAME"}

$SUDO docker run $OPTIONS $PG_IMAGE $CMD

