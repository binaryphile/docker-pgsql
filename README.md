# General-purpose PostgreSQL Docker image

## Before you build

You can already use the PostgreSQL image I've created with these scripts
by cloning this repo and running:

    docker pull binaryphile/pgsql:9.3.1

To initialize the database, run:

    ./interactive.sh
    $ ./init.sh
    $ exit

To run the database server, run:

    ./daemon.sh

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
- `daemon.sh` - runs PostgreSQL as a daemon container on host port 5432
- `interactive.sh` - runs an interactive session in the container, ready
to run postgres
- `init.sh` - used with `interactive.sh` to run database initialization
from inside the container

## Creating the image

There are a few environment variables you need to set for the script:

- **PGVERSION** - includes major.minor.revision.
  - Set to "9.3.1" for the latest as of this writing
  - Needs to be a version available at
  ftp://ftp.postgresql.org/pub/source/ (ignore the "v" in front of the
  version)
- **SU_NAME** - the name of the superuser account you'd like to create
in the PostgreSQL database, don't choose "postgres"
- **SU_PASSWORD** - the password for the superuser account
- **IX_NAME** - your id on the Docker index
  - if you don't have one, go set one up at http://index.docker.io/

Here's an example of how to set these variables in bash:

    $ export PGVERSION=9.3.1
    $ export USERNAME=Me
    $ export PASSWORD=M3
    $ export IX_NAME=mynameontheindex

The `create-image.sh` script has defaults for a number of other
variables, such as the repo name that will be created ("pgsql" by
default) and the Ubuntu distribution the image will be based on
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

    $ ./create-image.sh

The final product will be an image which is committed locally on your
machine (but not pushed).  Run `docker images` to see the name. By
default, it will be your index id followed by the repo name and the
version as a tag, like "mynameontheindex/pgsql:9.3.1".

You may want to push to the index at this point.  Remember that push
doesn't take a tag argument:

    docker push [yourname]/[repo]

## Using the image

If you need to debug, you may need to run interactively.  Just run
`interactive.sh` to get a command prompt in a new copy of the image.  If
you want to run PostgreSQL in it, you'll need to use the command:

    /usr/local/pgsql/bin/postgres -c config_file=/root/postgresql.conf

`daemon.sh` will run PostgreSQL in daemon mode.

Both scripts expose port 5432 on the host.  This is configurable in the
scripts and only configures the exposed port, so you don't need to edit
`postgresql.conf`.

The database configuration files are in the current directory, so you
can change them whenever you need to:

- `pg_hba.conf`
- `pg_ident.conf`
- `postgresql.conf`

You'll need to restart PostgreSQL by stopping and starting the
container:

    $ docker ps
    $ docker stop [id]
    $ ./daemon.sh

Each time you run the script, a new container will be created from the
image.  Each time you stop the container, the old container will still
occupy your disk and the `docker ps -a` list.  Periodically you can
dispose of the stale containers with the command `docker rm $(docker ps
-a -q)`.

## Initializing the Database When You've Pulled the Image

If you are pulling the image to a new system rather than building it,
you'll still need the scripts in this repo.  The easy way to do this is
to set use the `interactive.sh` script and let it pull the image.  Make
sure you've set these variables:

- **IX_NAME** - your docker index username, or the username of the repo
owner
- **REPO_NAME** - the repo name, usually "pgsql"
- **PGVERSION** - set to the tag name
- **SU_NAME** - the postgres superuser name you want
- **SU_PASSWORD** - the postgres superuser password you want


When you get the command prompt, run `init.sh`:

    $ ./init.sh

When it finishes, exit and run the daemon with `daemon.sh`.

[Docker]: http://docker.io/
[PostgreSQL]: http://www.postgresql.org/
