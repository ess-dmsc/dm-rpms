#!/bin/bash

LIBRDKAFKA_VERSION=0.9.1
RELEASE=$(cat RELEASE)

rm -rf rpm
if [ ! -d librdkafka ] ; then
    git clone https://github.com/edenhill/librdkafka.git
else
    cd librdkafka
    git pull
    cd ..
fi
cd librdkafka
git checkout $LIBRDKAFKA_VERSION
make rpm BUILD_NUMBER=$RELEASE
cd ..
mkdir rpm
cp librdkafka/packaging/rpm/pkgs-$LIBRDKAFKA_VERSION-$RELEASE-default/*.rpm rpm/
