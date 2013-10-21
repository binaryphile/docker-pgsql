: ${ROOT?"need to set root directory ROOT, see README.md"}
: ${SU_NAME?"need to set superuser name SU_NAME, see README.md"}
: ${SU_PASSWORD?"need to set superuser password SU_PASSWORD, see README.md"}
: ${PGNAME?"need to set postgres directory name PGNAME, see README.md"}

PGCONF=$ROOT/postgresql.conf
PGBIN=/usr/local/pgsql/bin
PGCMD=$PGBIN/postgres
ENCODING="-E UTF-8"
PGINIT="$PGBIN/initdb $ENCODING"

$PGINIT $ROOT/$PGNAME
$PGCMD --single -c config_file=$PGCONF <<< "CREATE USER $SU_NAME WITH SUPERUSER PASSWORD '$SU_PASSWORD';"
mkdir -p $ROOT/log

