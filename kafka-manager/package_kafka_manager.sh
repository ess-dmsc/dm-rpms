#!/bin/bash

mkdir kafka-manager
rm -rf kafka-manager/kafka-manager-$KAFKA_MANAGER_VERSION rpm
cd kafka-manager

if [ ! -f $KAFKA_MANAGER_VERSION.tar.gz ] ; then
    echo "File \"$KAFKA_MANAGER_VERSION.tar.gz\" not found. Downloading..."
    curl -LO https://github.com/yahoo/kafka-manager/archive/$KAFKA_MANAGER_VERSION.tar.gz
else
    echo "File \"$KAFKA_MANAGER_VERSION.tar.gz\" found. Skipping download."
fi

echo "Comparing MD5 sums..."
MD5_SUM=$(openssl dgst -md5 $KAFKA_MANAGER_VERSION.tar.gz | awk '{print $2}')
if [ "$MD5_SUM" != "$KAFKA_MANAGER_MD5_SUM" ] ; then
    echo "Error: MD5 sum different from expected value. Stopping."
    exit 1
fi
echo "Extracting file..."
tar xvf $KAFKA_MANAGER_VERSION.tar.gz

cd kafka-manager-$KAFKA_MANAGER_VERSION
./sbt rpm:packageBin
cd ../..

mkdir rpm
cp kafka-manager/kafka-manager-$KAFKA_MANAGER_VERSION/target/rpm/RPMS/noarch/kafka-manager-$KAFKA_MANAGER_VERSION-1.noarch.rpm rpm/
