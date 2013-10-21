: ${IX_NAME?"need to set docker index username IX_NAME, see README.md"}
: ${REPO_NAME?"need to set repo name REPO_NAME, see README.md"}
: ${PGVERSION?TAG=:$PG_VERSION}

: ${ROOT=/root}
: ${IMAGE=$IX_NAME/$REPO_NAME$TAG}
: ${PGUSER=postgres}
: ${PGDATA=$ROOT/postgresql}
: ${PGCONF=$ROOT/postgresql.conf}
: ${PGBIN=/usr/local/pgsql/bin}
: ${PGCMD="$PGBIN/postgres -c config_file=$PGCONF"}
: ${PGPORT=5432}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-d -w $ROOT -p $PGPORT:5432 -u $PGUSER -v $(pwd):$ROOT -e ROOT=$ROOT -e PGDATA=$PGDATA"}

$SUDO docker run $OPTIONS $IMAGE $PGCMD

