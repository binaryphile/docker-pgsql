#!/bin/bash

SOURCE_LIST="-o Dir::Etc::SourceList=$ROOT/sources.list"
export DEBIAN_FRONTEND=noninteractive

apt-get $SOURCE_LIST update
apt-get $SOURCE_LIST install -y build-essential curl git-core libxslt1-dev libxml2-dev python-dev libreadline-dev bison flex
apt-get clean
cd $PGNAME-$PGVERSION
./configure --with-libxml --with-python --with-libxslt --with-openssl
make
make install
useradd $PGUSER
su -c "$ROOT/init.sh" -m -s /bin/bash $PGUSER

