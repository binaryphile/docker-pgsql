# General-purpose PostgreSQL Docker image

## Before you build

You can already use the PostgreSQL image I've created with these scripts
by cloning this repo and running:

    docker pull binaryphile/pgsql:9.3.1

To initialize the database, run:

    export SUDO=sudo # only if you aren't a member of the docker group
    export PG_IMAGE=binaryphile/pgsql:9.3.1
    export SU_NAME=[your database superuser username]
    export SU_PASS=[your superuser password]
    ./initialize-database.sh

To run the database server, run:

    ./daemon.sh

The database will now be available on the standard 5432 port on your
docker host.  Note it will be available to the network, so take security
steps as your organization's policies dictate.

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
themselves are kept in the `postgresql` subdirectory after you
initialize the database.

# Usage

There are four scripts you need to know about:

- `create-image.sh` - downloads the PostgreSQL source, creates a
container, installs PostgreSQL and initializes the database if you
haven't done so with a prior install
- `initialize-database.sh` - initializes the database when you've got an
image already but not a working database
- `daemon.sh` - runs PostgreSQL as a daemon container on host port 5432
- `interactive.sh` - runs an interactive session in the container, ready
to run postgres

There are two other scripts, `init.sh` and `install.sh`.  Both of these
are for the other scripts to call inside the container when it is being
built or initialized.  You shouldn't need to run them yourself, but
they're simple enough to get the gist of if you're just curious.

## Creating the image

`create-image.sh` is responsible for creating a working image, including
initializing a database for you.

When it is finished, there is a non-running container which houses the
work done by the script.  You will need to commit this container to an
image (and push to the index if you so desire).

There are a few environment variables you need to set for the script:

- **PG_VERSION** - includes major.minor.revision
  - Set to "9.3.1" for the latest as of this writing
  - Needs to be a version available at
  ftp://ftp.postgresql.org/pub/source/ (ignore the "v" in front of the
  version)
- **SU_NAME** - the name of the superuser account you'd like to create
in the PostgreSQL database, don't choose "postgres"
- **SU_PASS** - the password for the superuser account

Here's an example of how to set these variables in bash:

    export PG_VERSION=9.3.1
    export SU_USER=Me
    export SU_PASS=M3

The `create-image.sh` script has defaults for a number of other
variables such as the Ubuntu distribution the image will be based on
("ubuntu:precise" by default).  Edit them as you see fit.  You can also
override any of them just by setting that variable in your shell before
running the script.

Also, take a second to change `sources.list` to use your favorite local
Ubuntu mirror rather than ubuntu.wikimedia.org.  Leave the second line
for archive.ubuntu.com intact, it's necessary.  When software is
installed in the container using these scripts, the local `sources.list`
file will override the one in the container.  It will not be copied into
the container, however.

Run the command:

    ./create-image.sh

Now to commit the container to an image, determine the id of the
container that just finished and commit it:

    docker ps -a
    docker commit [id] [your index id]/[repo name] [optional tag]

You may want to push to the index at this point.  Remember that push
doesn't take a tag argument:

    docker push [yourname]/[repo]

## Using the image

`daemon.sh` is resonsible for running the database in the background,
exposing the default PostgreSQL port (5432) on the host.

Each time you run the script, a new container will be created from the
image.  Each time you stop the container, the old container will still
occupy your disk and the `docker ps -a` list.  Periodically you can
dispose of the stale containers with the command `docker rm $(docker ps
-a -q)`.

The database configuration files are in the current directory, so you
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

    export PG_IMAGE=[your index id]/[your repo][:[optional tag]]
    ./interactive.sh

If you want to run PostgreSQL in it, you'll need to use the command:

    /usr/local/pgsql/bin/postgres -c config_file=/root/postgresql.conf

## Initializing the Database When You've Pulled the Image

`initialize-database.sh` is responsible for initializing the database
when you already have an image.

You'll still need the scripts in this repo.  Set these variables:

- **PG_IMAGE** - the repo name, usually "pgsql"
- **SU_NAME** - the postgres superuser name you want
- **SU_PASS** - the postgres superuser password you want

Run:

    ./initialize-database.sh

When it finishes, exit and run the daemon with `daemon.sh`.

[Docker]: http://docker.io/
[PostgreSQL]: http://www.postgresql.org/
