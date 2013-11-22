#!/bin/bash

if [ -f ".env" ]; then
  source .env
fi

: ${PG_IMAGE?"need to set image name PG_IMAGE, see README.md"}
: ${SU_USER?"need to set superuser name SU_USER, see README.md"}
: ${SU_PASS?"need to set superuser password SU_PASS, see README.md"}

: ${ROOT=/root}
: ${PGUSER=postgres}
: ${PGNAME=postgresql}
: ${PGDATA=$ROOT/db}
: ${PGBIN=/usr/local/pgsql/bin}
: ${CMD=$ROOT/scripts/init.sh}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-i -t -w $ROOT -p $PGPORT:5432 -u $PGUSER -v $(pwd):$ROOT -e ROOT=$ROOT -e PGDATA=$PGDATA -e PGNAME=$PGNAME -e PGBIN=$PGBIN -e SU_USER=$SU_USER -e SU_PASS=$SU_PASS"}

$SUDO docker run $OPTIONS $PG_IMAGE $CMD

