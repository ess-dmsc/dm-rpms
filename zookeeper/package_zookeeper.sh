#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -f "zookeeper-$ZOOKEEPER_VERSION.tar.gz" ] ; then
    echo "File \"zookeeper-$ZOOKEEPER_VERSION.tar.gz\" not found. Downloading..."
    curl -LO http://mirrors.rackhosting.com/apache/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz
else
    echo "File \"zookeeper-$ZOOKEEPER_VERSION.tar.gz\" found. Skipping download."
fi

echo "Comparing MD5 sums..."
MD5_SUM=$(openssl dgst -md5 zookeeper-$ZOOKEEPER_VERSION.tar.gz | awk '{print $2}')
if [ "$MD5_SUM" != "$ZOOKEEPER_MD5_SUM" ] ; then
    echo "Error: MD5 sum different from expected value. Stopping."
    exit 1
fi

cd ../workspace

echo "Extracting file..."
tar xf ../sources/zookeeper-$ZOOKEEPER_VERSION.tar.gz

echo "Creating package structure..."
mv zookeeper-$ZOOKEEPER_VERSION zookeeper
rm -f zookeeper/*.xml
rm -f zookeeper/zookeeper-*.jar.*
rm -rf zookeeper/dist-maven
rm -rf zookeeper/src
rm -rf zookeeper/zookeeper-client
rm -rf zookeeper/zookeeper-contrib
rm -rf zookeeper/zookeeper-it
rm -rf zookeeper/zookeeper-jute
rm -rf zookeeper/zookeeper-recipes
rm -rf zookeeper/zookeeper-server
mv zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg
mkdir -p files
cp ../files/start-zookeeper-service.sh zookeeper/
cp ../files/dm-zookeeper.service files/
mkdir dm-zookeeper-$ZOOKEEPER_VERSION
mv zookeeper files dm-zookeeper-$ZOOKEEPER_VERSION/
tar czf dm-zookeeper-$ZOOKEEPER_VERSION.tar.gz dm-zookeeper-$ZOOKEEPER_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-zookeeper-$ZOOKEEPER_VERSION.tar.gz package/SOURCES/
cp files/dm-zookeeper.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $ZOOKEEPER_VERSION" \
    --define "_release $ZOOKEEPER_RELEASE" \
    -bb package/SPECS/dm-zookeeper.spec
