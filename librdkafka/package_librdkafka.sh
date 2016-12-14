#!/bin/bash

mkdir -p sources

cd sources

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
