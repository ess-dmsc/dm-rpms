#!/bin/bash

# Configuration
if [ -z "$FPM_COMMAND" ] ; then
    FPM_COMMAND=fpm
fi

# Prepare environment
mkdir -p kafka-manager
rm -rf kafka-manager/kafka-manager-$KAFKA_MANAGER_VERSION kafka-manager/packaging rpm
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

echo "Building..."
cd kafka-manager-$KAFKA_MANAGER_VERSION
./sbt clean dist
cd ..

# Extract built package and build custom package
echo "Creating package structure..."
mkdir -p packaging/opt/dm_group
mkdir -p packaging/etc/systemd/system
mv kafka-manager-$KAFKA_MANAGER_VERSION/target/universal/kafka-manager-$KAFKA_MANAGER_VERSION.zip packaging
cd packaging
unzip kafka-manager-$KAFKA_MANAGER_VERSION.zip

mv kafka-manager-$KAFKA_MANAGER_VERSION opt/dm_group/kafka-manager
cp ../../files/kafka-manager.service etc/systemd/system/
cp ../../files/start-kafka-manager-service.sh opt/dm_group/kafka-manager/
cp ../kafka-manager-$KAFKA_MANAGER_VERSION/LICENCE opt/dm_group/kafka-manager/
chmod u+x opt/dm_group/kafka-manager/start-kafka-manager-service.sh
echo "Creating file..."
tar czf kafka-manager-$KAFKA_MANAGER_VERSION.tar.gz etc opt

echo "Creating RPM..."
mkdir -p ../../rpm
$FPM_COMMAND --input-type tar \
    --output-type rpm \
    --package ../../rpm \
    --name kafka-manager \
    --version $KAFKA_MANAGER_VERSION \
    --iteration $KAFKA_MANAGER_RELEASE \
    --license "Apache License 2.0" \
    --provides "kafka-manager" \
    --maintainer "Afonso" \
    --description "Apache ZooKeeper server" \
    --url "https://github.com/yahoo/kafka-manager" \
    --rpm-user kafka-manager \
    --rpm-group kafka-manager \
    --before-install ../../files/add-user.sh \
    --after-install ../../files/daemon-reload.sh \
    --before-remove ../../files/stop-kafka-manager.sh \
    --before-upgrade ../../files/stop-kafka-manager.sh \
    --after-upgrade ../../files/daemon-reload.sh \
    kafka-manager-$KAFKA_MANAGER_VERSION.tar.gz
echo "RPM created and available in rpm folder."
