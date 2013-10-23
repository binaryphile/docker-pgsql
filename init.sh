#!/bin/bash

: ${SU_NAME?"need to set superuser name SU_NAME, see README.md"}
: ${SU_PASS?"need to set superuser password SU_PASS, see README.md"}

: ${ROOT=/root}
: ${PGCONF=$ROOT/postgresql.conf}
: ${PGBIN=/usr/local/pgsql/bin}
: ${PGCMD=$PGBIN/postgres}
: ${ENCODING="-E UTF-8"}
: ${PGINIT="$PGBIN/initdb $ENCODING"}
: ${PGNAME=postgresql}
: ${PGDIR=$ROOT/$PGNAME}

if [ ! -d $PGDIR ]; then
  $PGINIT $PGDIR
  $PGCMD --single -c config_file=$PGCONF <<< "CREATE USER $SU_NAME WITH SUPERUSER PASSWORD '$SU_PASS';"
fi
mkdir -p $ROOT/log

