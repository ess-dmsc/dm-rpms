# Data Management RPM Creation Scripts

Scripts to create RPMs from software packages used by the Data Management
group.


## Requirements

- FPM (https://github.com/jordansissel/fpm)
- mock (see Notes below)


## Instructions

To set up the requirements on the DM development machine, install required
packages with

    $ sudo yum install mock ruby-devel

Add the user who will run the scripts to the *mock* group by running

    $ sudo usermod -a -G mock <user>

substituting `<user>` with the user name. Install FPM with

    $ gem install fpm


## Creating an RPM

Enter the corresponding folder and run the packaging script from there. To
generate the Kafka RPM, for example, run

    $ cd kafka
    $ ./package_kafka.sh
