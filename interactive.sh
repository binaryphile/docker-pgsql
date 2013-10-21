ROOT=/root
IMAGE=binaryphile/pgsql:9.3.1
USER=postgres
PGDATA=$ROOT/postgresql
PGCONF=$ROOT/postgresql.conf
PGBIN=/usr/local/pgsql/bin
PGCMD=/bin/bash
PGPORT=5432
SUDO="" # change to "sudo" if you aren't in docker group
OPTIONS="-i -t -p :$PGPORT -u $USER -v $(pwd):$ROOT -e $PGDATA"

$SUDO docker run $OPTIONS $IMAGE $PGCMD

