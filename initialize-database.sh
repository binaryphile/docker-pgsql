#!/bin/bash

: ${PG_IMAGE?"need to set image name PG_IMAGE, see README.md"}
: ${SU_NAME?"need to set superuser name SU_NAME, see README.md"}
: ${SU_PASS?"need to set superuser password SU_PASS, see README.md"}

: ${ROOT=/root}
: ${PGUSER=postgres}
: ${PGNAME=postgresql}
: ${PGDATA=$ROOT/$PGNAME}
: ${PGBIN=/usr/local/pgsql/bin}
: ${CMD=$ROOT/init.sh}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-i -t -w $ROOT -p $PGPORT:5432 -u $PGUSER -v $(pwd):$ROOT -e ROOT=$ROOT -e PGDATA=$PGDATA -e PGNAME=$PGNAME -e PGBIN=$PGBIN -e SU_NAME=$SU_NAME -e SU_PASS=$SU_PASS"}

$SUDO docker run $OPTIONS $PG_IMAGE $CMD

