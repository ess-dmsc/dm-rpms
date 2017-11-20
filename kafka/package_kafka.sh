#!/bin/bash

# Prepare environment
SCALA_VERSION=2.11
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -f "kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz" ] ; then
    echo "File \"kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz\" not found. Downloading..."
    curl -LO http://mirrors.rackhosting.com/apache/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
else
    echo "File \"kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz\" found. Skipping download."
fi

echo "Comparing SHA512..."
SHA512_SUM=$(openssl dgst -sha512 kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | awk '{print $2}')
if [ "$SHA512_SUM" != "$KAFKA_SHA512_SUM" ] ; then
    echo "Error: SHA512 different from expected value. Stopping."
    exit 1
fi

# Get kafka-graphite
if [ ! -d kafka-graphite ] ; then
    git clone https://github.com/damienclaveau/kafka-graphite.git
else
    cd kafka-graphite
    git pull origin master
    cd ..
fi

cd ../workspace

echo "Building kafka-graphite..."
cp -r ../sources/kafka-graphite kafka-graphite
cd kafka-graphite
mvn package
if [ $? -ne 0 ] ; then
    echo "Error: 'mvn package' returned non-zero value. Stopping."
    exit 1
fi
cd ..

echo "Extracting file..."
tar xzf ../sources/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz

echo "Creating package source..."
mv kafka_$SCALA_VERSION-$KAFKA_VERSION kafka
mkdir -p files
cp ../files/start-kafka-service.sh kafka/
cp ../files/dm-kafka.service files/
cp ../files/server.properties files/
cp kafka-graphite/target/kafka-graphite-1.0.5.jar kafka/libs/
cp kafka-graphite/LICENSE kafka/LICENSE.kafka-graphite
mkdir dm-kafka-$KAFKA_VERSION
mv kafka files dm-kafka-$KAFKA_VERSION/
tar czf dm-kafka-$KAFKA_VERSION.tar.gz dm-kafka-$KAFKA_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-kafka-$KAFKA_VERSION.tar.gz package/SOURCES/
cp files/dm-kafka.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $KAFKA_VERSION" \
    --define "_release $KAFKA_RELEASE" \
    -bb package/SPECS/dm-kafka.spec
