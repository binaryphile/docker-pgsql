ROOT=/root
IMAGE=binaryphile/pgsql:9.3.1
USER=postgres
PGDATA=$ROOT/postgresql
PGCONF=$ROOT/postgresql.conf
PGBIN=/usr/local/pgsql/bin
PGCMD="$PGBIN/postgres -c config_file=$PGCONF"
PGPORT=5432
SUDO="" # change to "sudo" if you aren't in docker group

$SUDO docker run -d -u $USER -v $(pwd):$ROOT -e PGDATA=$PGDATA $IMAGE $PGCMD

