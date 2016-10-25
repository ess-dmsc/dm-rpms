#!/bin/bash

rm -rf rpm
if [ ! -d librdkafka ] ; then
    git clone https://github.com/edenhill/librdkafka.git
else
    cd librdkafka
    git pull origin master
    cd ..
fi
cd librdkafka
git checkout $LIBRDKAFKA_VERSION
make rpm BUILD_NUMBER=$LIBRDKAFKA_RELEASE
cd ..
mkdir rpm
cp librdkafka/packaging/rpm/pkgs-$LIBRDKAFKA_VERSION-$LIBRDKAFKA_RELEASE-default/*.rpm rpm/
