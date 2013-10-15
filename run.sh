docker run -v $(pwd):/root -d -p :5432 -e PGDATA=/root/postgresql binaryphile/pgsql:9.3.1 su postgres sh -c "/usr/local/pgsql/bin/pg_ctl start -l $PGDATA/postgresql.log"

