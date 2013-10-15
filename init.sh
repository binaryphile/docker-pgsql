#!/bin/sh

export HOST_DIR=/root
export PGDATA=$HOST_DIR/postgresql
export POSTGRESQL_BIN=/usr/local/pgsql/bin
export POSTGRESQL_CONF=$HOST_DIR/postgresql.conf
export POSTGRES=$POSTGRESQL_BIN/postgres
export INITDB=$POSTGRESQL_BIN/initdb
export POSTGRES_USER=postgres

su $POSTGRES_USER sh -c "$INITDB $PGDATA"

# FIXME: this line gives a redirection error so I have to run it manually.  Not sure what the issue is.
#su $POSTGRES_USER sh -c "$POSTGRES --single -c config_file=$POSTGRESQL_CONF" <<< "CREATE USER $USERNAME WITH SUPERUSER PASSWORD '$PASSWORD';"

