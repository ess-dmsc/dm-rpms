#!/bin/bash

# Configuration
KAFKA_VERSION=0.10.0.1
SCALA_VERSION=2.11
EXPECTED_MD5_SUM=702885a3f3efade1ee08435d29407474
FPM_EXECUTABLE=/usr/local/bin/fpm

# Read last release number, increase it and write to RELEASE
RELEASE=$(cat RELEASE)
RELEASE=$((RELEASE+1))
echo $RELEASE > RELEASE

# Prepare environment
mkdir -p kafka
rm -rf rpm/kafka-$KAFKA_VERSION-$RELEASE.* kafka/packaging kafka/kafka
cd kafka

if [ ! -f "kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz" ] ; then
    echo "File \"kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz\" not found. Downloading..."
    curl -LO http://mirrors.rackhosting.com/apache/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
else
    echo "File \"kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz\" found. Skipping download."
fi

echo "Comparing MD5 sums..."
MD5_SUM=$(openssl dgst -md5 kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | awk '{print $2}')
if [ "$MD5_SUM" != "$EXPECTED_MD5_SUM" ] ; then
    echo "Error: MD5 sum different from expected value. Stopping."
    exit 1
fi
echo "Extracting file..."
tar xzf kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz

echo "Creating package structure..."
mkdir -p packaging/opt/dm_group
mkdir -p packaging/var/opt/dm_group/kafka
mkdir -p packaging/var/log/kafka
mkdir -p packaging/etc/systemd/system
mv kafka_$SCALA_VERSION-$KAFKA_VERSION packaging/opt/dm_group/kafka
cp ../files/kafka.service packaging/etc/systemd/system
cd packaging
echo "Creating file..."
tar czf kafka-$KAFKA_VERSION.tar.gz etc opt var

echo "Creating RPM..."
mkdir -p ../../rpm
$FPM_EXECUTABLE --input-type tar \
    --output-type rpm \
    --package ../../rpm \
    --name kafka \
    --version $KAFKA_VERSION \
    --iteration $RELEASE \
    --license "Apache License 2.0" \
    --provides "kafka" \
    --maintainer "Afonso" \
    --description "Apache Kafka server" \
    --url "http://kafka.apache.org" \
    --rpm-user kafka \
    --rpm-group kafka \
    --before-install ../../files/add-user.sh \
    --after-install ../../files/daemon-reload.sh \
    --before-remove ../../files/stop-kafka.sh \
    --before-upgrade ../../files/stop-kafka.sh \
    --after-upgrade ../../files/daemon-reload.sh \
    kafka-$KAFKA_VERSION.tar.gz
echo "RPM created and available in rpm folder."
