# Data Management RPM Creation Scripts

Scripts to create RPMs from external software packages used by the Data
Management group.


## Requirements

- rpm-build
- mock (see Instructions below)
- javac


## Instructions

Add the user who will run the scripts to the *mock* group by running

    $ sudo usermod -a -G mock <user>

substituting `<user>` with the user name.


## Creating an RPM

A Makefile is provided for running the scripts to create the RPMs. The default
target is `all`, which will generate all RPMs by running

    $ make

To generate a specific RPM, run

    $ make <package>

where `<package>` must be substituted by the appropriate package name, e.g.
*zookeeper* or *kafka*.
