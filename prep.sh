#!/bin/sh

export PGVERSION=9.3.1
export PGNAME=postgresql
export PGARCHIVE=$PGNAME-PGVERSION.tar.gz
export PGURL=http://ftp.postgresql.org/pub/source/v$PGVERSION/$PGARCHIVE

curl -o $PGARCHIVE $PGURL
tar xvf $PGARCHIVE

