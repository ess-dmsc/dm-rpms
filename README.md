# Data Management RPM Creation Scripts

Scripts to create RPMs from external software packages used by the Data
Management group.


## Requirements

- cyrus-sasl-devel
- gcc
- g++
- javac
- openssl-devel
- python
- rpm-build
- zlib-devel


## Creating an RPM

A Makefile is provided for running the scripts to create the RPMs. The default
target is `all`, which will generate all RPMs by running

    $ make

To generate a specific RPM, run

    $ make <package>

where `<package>` must be substituted by the appropriate package name, e.g.
*zookeeper* or *kafka*.
