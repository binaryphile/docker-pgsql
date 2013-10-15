# General-purpose Postgresql Docker image

## Before you build

You can already use the Postgresql image I've created with these scripts
by running:

    docker pull binaryphile/pgsql:9.3.1

See the instructions on initializing the database and running the server
below.

# Intro

These scripts help you create a [Docker] image for a [Postgresql]
server.

# Usage

There are four scripts, two for creating the image and two for running
it:

- `prep.sh` - downloads and unzips the sources for Postgresql
- `install.sh` - for use inside the image, installs Postgresql
- `init.sh` - for use inside a container based on the image, initializes
a database
- `run.sh` - runs an instance of Postgresql and exposes it on port 5432
by default

The idea behind a general-purpose Docker container is to maximize its
reusability.  To that end, this image contains only the executables and
their dependencies, and none of the configuration or database files.  It
can be used to run database instances unmodified, provided you set up
the database files and run the container with the appropriate arguments.
The container is meant to load configuration and database files by
mounting the current directory as a writable volume.  Configuration
files are in this directory and database files are in the `postgresql`
subdirectory (made when you make the database).  Logging is done to
a file in the database directory as well.

## Creating the image

### Prepping the source

Edit `prep.sh` to specify the Postgresql version you want.  The source
for your version must be available on the Postgresql ftp server.  You
can find the url in the file.

Run `./prep.sh`, which will download the sources and untar them.

### Installing Postgresql

Decide which version of ubuntu you want to install from.  Precise is
recommended.  If you use quantal, edit `sources.list` to change the
distribution name.

Run the command:

    docker run -v $(pwd):/root -i -t ubuntu:precise /bin/bash

Substitute quantal if desired.  Once at the command line, run
`install.sh`:

    $ cd root
    $ ./install.sh

Wait.  Once finished, exit the command line.

Create the image from the container by determing the container id from
`docker ps -a`.  Then `docker commit [id] [yourname]/[repo] [optional
tag]`.  This will create your image.  You can get rid of the existing
container afterward with `docker rm [id]`.

You may also want to push to the index at this point.  Remember that
push doesn't take a tag argument:

    docker push [yourname]/[repo]

## Using the image

### Initializing the database

Run a container:

    docker run -v $(pwd):/root -i -t [yourname]/[repo][:[tag]] /bin/bash

Inside the container run:

    $ cd root
    $ ./init.sh

Currently, the script creates the database files but you'll have to run
the second command manually in order to create a user.  Technically you
can do this later from a pgsql client, but you'll have to figure out the
command from the script if you want to create a user now.

Exit when you're done and delete the container:

    docker ps -a
    docker rm [id]

Remember, the container is generic, all of the data is on your local
filesystem.

### Running the database server

To run the server:

    ./run.sh

This will run a new container based on the image using the local files.
The database configuration files are in the current directory, so you
can change them at any time (you'll just have to kill the old instance
and start a new one):

- `pg_hba.conf`
- `pg_ident.conf`
- `postgresql.conf`

The port is mapped to your host at 5432 by default, so be aware it will
be available on your network.  You can edit that out of the file easily
if you want.

[Docker]: http://docker.io/
[Postgresql]: http://www.postgresql.org/
