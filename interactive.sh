: ${IX_NAME?"need to set docker index username IX_NAME, see README.md"}
: ${REPO_NAME?"need to set repo name REPO_NAME, see README.md"}
: ${SU_NAME?"need to set superuser name SU_NAME, see README.md"}
: ${SU_PASSWORD?"need to set superuser password SU_PASSWORD, see README.md"}

: ${ROOT=/root}
: ${IMAGE=$IX_NAME/$REPO_NAME:$PGVERSION}
: ${PGUSER=postgres}
: ${PGNAME=postgresql}
: ${PGDATA=$ROOT/$PGNAME}
: ${PGCONF=$ROOT/postgresql.conf}
: ${PGBIN=/usr/local/pgsql/bin}
: ${CMD=/bin/bash}
: ${PGPORT=5432}
: ${SUDO=""} # change to "sudo" if you aren't in docker group
: ${OPTIONS="-i -t -w $ROOT -p $PGPORT:5432 -u $PGUSER -v $(pwd):$ROOT -e ROOT=$ROOT -e PGDATA=$PGDATA -e PGNAME=$PGNAME -e SU_NAME=$SU_NAME -e SU_PASSWORD=$SU_PASSWORD"}

$SUDO docker run $OPTIONS $IMAGE $CMD

