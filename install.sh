#!/bin/bash

: ${PG_VERSION?"need to set PostgreSQL version PG_VERSION, see README.md"}

: ${ROOT=/root}
: ${PGNAME=postgresql}
: ${PGUSER=postgres}
: ${SOURCE_LIST="-o Dir::Etc::SourceList=$ROOT/sources.list"}
: ${PREREQS="build-essential curl git-core libxslt1-dev libxml2-dev python-dev libreadline-dev bison flex"}
export DEBIAN_FRONTEND=noninteractive

apt-get $SOURCE_LIST update
apt-get $SOURCE_LIST install -y $PREREQS
apt-get clean
cd $ROOT/$PGNAME-$PG_VERSION
./configure --with-libxml --with-python --with-libxslt --with-openssl
make
make install
useradd $PGUSER
su -c "$ROOT/init.sh" -m -s /bin/bash $PGUSER

