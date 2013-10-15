#!/bin/sh

export HOST_DIR=/root
export POSTGRESQL_VERSION=9.3.1
export POSTGRESQL_SOURCE=$HOST_DIR/postgresql-$POSTGRESQL_VERSION
export POSTGRES_USER=postgres
export SOURCE_LIST="-o Dir::Etc::SourceList=$HOST_DIR/sources.list"
export DEBIAN_FRONTEND=noninteractive

apt-get $SOURCE_LIST update
apt-get $SOURCE_LIST install -y build-essential curl git-core psmisc libxslt1-dev libxml2-dev python-dev libreadline-dev bison flex

cd $POSTGRESQL_SOURCE
./configure --with-libxml --with-python --with-libxslt --with-openssl
make
make install

useradd $POSTGRES_USER

