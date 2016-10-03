#!/bin/bash

LIBRDKAFKA_VERSION=0.9.1

rm -rf rpm
git clone https://github.com/edenhill/librdkafka.git
cd librdkafka
git checkout $LIBRDKAFKA_VERSION
make rpm
cd ..
mkdir rpm
cp librdkafka/packaging/rpm/pkgs-$LIBRDKAFKA_VERSION-1-default/*.rpm rpm/
