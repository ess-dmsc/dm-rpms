# Data Management RPM Creation Scripts

Scripts to create RPMs from external software packages used by the Data
Management group.


## Requirements

- rpm-build
- FPM (https://github.com/jordansissel/fpm)
- mock (see Notes below)


## Instructions

To set up the requirements on the DM development machine, install required
packages with

    $ sudo yum install rpm-build mock ruby-devel

Add the user who will run the scripts to the *mock* group by running

    $ sudo usermod -a -G mock <user>

substituting `<user>` with the user name. Install FPM with

    $ gem install fpm


## Creating an RPM

A Makefile is provided for running the scripts to create the RPMs. The default
target is `all`, which will generate all RPMs by running

    $ make

To generate a specific RPM, run

    $ make <package>

where `<package>` must be substituted by the appropriate package name, e.g.
*zookeeper* or *kafka*.
