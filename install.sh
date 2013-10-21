#!/bin/bash

SOURCE_LIST="-o Dir::Etc::SourceList=$ROOT/sources.list"
export DEBIAN_FRONTEND=noninteractive
PGBIN=/usr/local/pgsql/bin
PGCMD=$PGBIN/postgres
PGCONF=$ROOT/postgresql.conf
ENCODING="-E UTF-8"
PGINIT="$PGBIN/initdb $ENCODING"

apt-get $SOURCE_LIST update
apt-get $SOURCE_LIST install -y build-essential curl git-core libxslt1-dev libxml2-dev python-dev libreadline-dev bison flex
apt-get clean
cd $PGNAME-$PGVERSION
./configure --with-libxml --with-python --with-libxslt --with-openssl
make
make install
useradd $PGUSER
su $PGUSER
$PGINIT $ROOT/$PGNAME
$PGCMD --single -c config_file=$PGCONF <<< "CREATE USER $USERNAME WITH SUPERUSER PASSWORD '$PASSWORD';"
mkdir -p $ROOT/log

