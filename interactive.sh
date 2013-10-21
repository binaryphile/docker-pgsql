: ${IX_NAME?"need to set docker index username IX_NAME, see README.md"}
: ${REPO_NAME?"need to set repo name REPO_NAME, see README.md"}
: ${PGVERSION?TAG=:$PG_VERSION}

: ${ROOT=/root}
: ${IMAGE=$IX_NAME/$REPO_NAME$TAG}
: ${USER=postgres}
: ${PGNAME=postgresql}
: ${PGDATA=$ROOT/$PGNAME}
: ${PGCONF=$ROOT/postgresql.conf}
: ${PGBIN=/usr/local/pgsql/bin}
: ${PGCMD="$PGBIN/postgres -c config_file=$PGCONF"}
: ${PGPORT=5432}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-d -p $PGPORT:5432 -u $USER -v $(pwd):$ROOT -e $PGDATA"}

$SUDO docker run $OPTIONS $IMAGE $PGCMD

