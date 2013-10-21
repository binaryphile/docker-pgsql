#!/bin/bash

: ${PGVERSION?"Need to set PGVERSION, see README.md"}
: ${SU_NAME?"Need to set database superuser SU_NAME, see README.md"}
: ${SU_PASSWORD?"Need to set database superuser SU_PASSWORD, see README.md"}
: ${IX_NAME?"Need to set docker index username IX_NAME, see README.md"}

: ${ROOT=/root}
: ${DISTRO=ubuntu:precise}
: ${REPO_NAME=pgsql}
: ${PGUSER=postgres}
: ${PGNAME=postgresql}
: ${OPTIONS="-d -v $(pwd):$ROOT -w $ROOT -e ROOT=$ROOT -e PGVERSION=$PGVERSION -e PGNAME=$PGNAME -e PGUSER=$PGUSER -e SU_NAME=$SU_NAME -e SU_PASSWORD=$SU_PASSWORD"}
: ${PGURL=http://ftp.postgresql.org/pub/source/v$PGVERSION/$PGNAME-$PGVERSION.tar.gz}
: ${CMD=$ROOT/install.sh}
: ${SUDO=""} # change to "sudo" if you aren't in the docker group

if [ ! -d "$PGNAME-$PGVERSION" ]; then
  curl $PGURL | tar -zxvf -
fi
ID=$(docker run $OPTIONS $DISTRO $CMD)
$SUDO docker wait $ID
$SUDO docker commit $ID $NAME/$REPO_NAME:$PGVERSION

