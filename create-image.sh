#!/bin/bash

ROOT=/root
DISTRO=ubuntu:precise
REPO_NAME=pgsql
PGUSER=postgres
PGNAME=postgresql
OPTIONS="-d -v $(pwd):$ROOT -w $ROOT -e ROOT=$ROOT -e PGVERSION=$PGVERSION -e PGNAME=$PGNAME -e PGUSER=$PGUSER"
PGURL=http://ftp.postgresql.org/pub/source/v$PGVERSION/$PGNAME-$PGVERSION.tar.gz
SUDO="" # change to "sudo" if you aren't in the docker group

if [! -d "$PGNAME-$PGVERSION"]; then
  curl $PGURL | tar -zxvf -
fi
ID=$(docker run $OPTIONS $DISTRO $ROOT/install.sh)
$SUDO docker wait $ID
$SUDO docker commit $ID $NAME/$REPO_NAME:$PGVERSION

