# Immutable PostgreSQL Docker image

## Before you build

The idea behind an immutable image is that you don't build one.  The one
on the index is reuable for almost any purpose and doesn't need or allow
customization of the image.  That's because you're customization is done
_outside_ the image, and when you run a container from it, it reads and
stores all state outside the container on your local filesystem.

To use it, you clone this repo and run the scripts here.  They pull the
image and when you run it, mount the current working directory inside
the container so configuration is read from this directory, and log
files and database files are written to this directory as well.

When the container needs to be stopped, it becomes disposable since it
has no state inside it (this is the "immutable" part).  You don't
restart it, you just run a new one from the image when you need to
restart.  Since the state is kept on the local filesystem, a new
container can pick up where the old one left off.  This makes upgrades
easier as well, since you don't need to transfer any data or
configuration to a new image.

## Initializing the Database

- copy `sample.env` to `.env`
  - `.env` is in the ignore file, so any edits won't be accidentally
  checked into this repo
- if you aren't in the docker group, uncomment the line `export
SUDO=sudo`
- Edit `.env` and set:
  - **SU_NAME -** the superuser name you want to create
  - **SU_PASS -** the superuser password you want to create
- run `./initialize-database.sh`

## Running the Database Server

Run `./postgres.sh`.  This will run the database server as a daemon,
exposing port 5432 on the host.  This will be available on the local
network, so take any necessary security measures.

## Contents

My image contains PostgreSQL 9.3.1, compiled from source and installed
at /usr/local/pgsql/bin.  When using my scripts to run it, it mounts the
local directory (this repo) as /root and stores the database and log
files here for persistence.

# Intro

These scripts help you create a [Docker] image for a [PostgreSQL]
server.

The idea behind a general-purpose Docker container is to maximize its
reusability.  To that end, this image contains only the executables and
their dependencies, and none of the configuration or database files.  It
can be used to run database instances unmodified, provided you set up
the database files and run the container with the appropriate arguments.

The container loads configuration and database files by mounting the
current directory as a writable volume.  Configuration files are in this
directory and logging is done here as well.  The database files
themselves are kept in the `db` subdirectory after you
initialize the database.

# Usage

There are three scripts you need to know about:

- `initialize-database.sh` - initializes the database when you've got an
image already but not a working database
- `postgres.sh` - runs PostgreSQL as a daemon container on host port 5432
- `interactive.sh` - runs an interactive session in the container, ready
to run postgres

If you need to build a new image for any reason, for example to support
a different version of the PostgreSQL binaries, refer to
`dockerfile/README.md`.

## Using the image

`postgres.sh` is resonsible for running the database in the background,
exposing the default PostgreSQL port (5432) on the host.

Each time you run the script, a new container will be created from the
image.  Each time you stop the container, the old container will still
occupy your disk and the `docker ps -a` list.  Periodically you can
dispose of the stale containers with the command `docker rm $(docker ps
-a -q)`.  This deletes all non-running containers, however, so be
careful not to do this if you have important non-running containers.

The database configuration files are in the `conf` directory, so you
can change them whenever you need to:

- `pg_hba.conf`
- `pg_ident.conf`
- `postgresql.conf`

You'll need to restart PostgreSQL by stopping and starting the
container:

    docker ps
    docker stop [id]
    ./daemon.sh

## Debugging

If you need to debug, you may need to run interactively.  Just run:

    ./interactive.sh

If you want to run PostgreSQL in it, you'll need to use the command:

    /usr/local/pgsql/bin/postgres -c config_file=/root/postgresql.conf

[Docker]: http://docker.io/
[PostgreSQL]: http://www.postgresql.org/
