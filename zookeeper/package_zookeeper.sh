#!/bin/bash

# Configuration
RELEASE=1
ZOOKEEPER_VERSION=3.4.9
EXPECTED_MD5_SUM=3e8506075212c2d41030d874fcc9dcd2

# Prepare environment
mkdir -p zookeeper
rm -rf rpm/zookeeper-$ZOOKEEPER_VERSION-$RELEASE.* zookeeper/packaging zookeeper/zookeeper
cd zookeeper

if [ ! -f "zookeeper-$ZOOKEEPER_VERSION.tar.gz" ] ; then
    echo "File \"zookeeper-$ZOOKEEPER_VERSION.tar.gz\" not found. Downloading..."
    curl -LO http://mirrors.rackhosting.com/apache/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz
else
    echo "File \"zookeeper-$ZOOKEEPER_VERSION.tar.gz\" found. Skipping download."
fi

echo "Comparing MD5 sums..."
MD5_SUM=$(openssl dgst -md5 zookeeper-$ZOOKEEPER_VERSION.tar.gz | awk '{print $2}')
if [ "$MD5_SUM" != "$EXPECTED_MD5_SUM" ] ; then
    echo "Error: MD5 sum different from expected value. Stopping."
    exit 1
fi
echo "Extracting file..."
tar xzf zookeeper-$ZOOKEEPER_VERSION.tar.gz

echo "Creating package structure..."
mkdir -p packaging/opt
mkdir -p packaging/var/lib/zookeeper
mkdir -p packaging/var/log/zookeeper
mkdir -p packaging/etc/systemd/system
mv zookeeper-$ZOOKEEPER_VERSION packaging/opt/zookeeper
cp ../files/zookeeper.service packaging/etc/systemd/system
cd packaging
echo "Creating file..."
tar czf zookeeper-$ZOOKEEPER_VERSION.tar.gz etc opt var

echo "Creating RPM..."
mkdir -p ../../rpm
fpm --input-type tar \
    --output-type rpm \
    --package ../../rpm \
    --name zookeeper \
    --version $ZOOKEEPER_VERSION \
    --iteration $RELEASE \
    --license "Apache License 2.0" \
    --provides "zookeeper" \
    --maintainer "Afonso" \
    --description "Apache ZooKeeper server" \
    --url "http://zookeeper.apache.org" \
    --rpm-user zookeeper \
    --rpm-group zookeeper \
    --before-install ../../files/before-install.sh \
    zookeeper-$ZOOKEEPER_VERSION.tar.gz
echo "RPM created and available in rpm folder."
