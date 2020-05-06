#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -f "apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz" ] ; then
    echo "File \"apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz\" not found. Downloading..."
    curl -LO https://downloads.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz
else
    echo "File \"apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz\" found. Skipping download."
fi

echo "Comparing SHA512 sums..."
SHA512_SUM=$(openssl dgst -sha512 apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz | awk '{print $2}')
if [ "$SHA512_SUM" != "$ZOOKEEPER_SHA512_SUM" ] ; then
    echo "Error: SHA512 sum different from expected value. Stopping."
    exit 1
fi

cd ../workspace

echo "Extracting file..."
tar xf ../sources/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz

echo "Creating package structure..."
mv apache-zookeeper-$ZOOKEEPER_VERSION-bin zookeeper
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
PATH=/usr/lib/jvm/java-11-openjdk/bin:$PATH JAVA_HOME=/usr/lib/jvm/java-11-openjdk rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $ZOOKEEPER_VERSION" \
    --define "_release $ZOOKEEPER_RELEASE" \
    -bb package/SPECS/dm-zookeeper.spec
