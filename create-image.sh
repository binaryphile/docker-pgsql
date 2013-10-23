#!/bin/bash

: ${PG_VERSION?"Need to set PG_VERSION, see README.md"}
: ${SU_NAME?"Need to set database superuser SU_NAME, see README.md"}
: ${SU_PASS?"Need to set database superuser SU_PASS, see README.md"}

: ${ROOT=/root}
: ${DISTRO=ubuntu:precise}
: ${PGUSER=postgres}
: ${PGNAME=postgresql}
: ${OPTIONS="-i -t -v $(pwd):$ROOT -w $ROOT -e ROOT=$ROOT -e PG_VERSION=$PG_VERSION -e PGNAME=$PGNAME -e PGUSER=$PGUSER -e SU_NAME=$SU_NAME -e SU_PASS=$SU_PASS"}
: ${PGURL=http://ftp.postgresql.org/pub/source/v$PG_VERSION/$PGNAME-$PG_VERSION.tar.gz}
: ${CMD=$ROOT/install.sh}
: ${SUDO=""} # change to "sudo" if you aren't in the docker group

if [ ! -d "$PGNAME-$PG_VERSION" ]; then
  curl $PGURL | tar -zxvf -
fi
$SUDO docker run $OPTIONS $DISTRO $CMD

