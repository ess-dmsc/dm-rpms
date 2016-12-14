#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

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

cd ../workspace

echo "Extracting file..."
tar xvf ../sources/$KAFKA_MANAGER_VERSION.tar.gz

echo "Building..."
cd kafka-manager-$KAFKA_MANAGER_VERSION
./sbt clean dist
cd ..

# Extract built package and build custom package
echo "Creating package structure..."
mv kafka-manager-$KAFKA_MANAGER_VERSION/target/universal/kafka-manager-$KAFKA_MANAGER_VERSION.zip .
rm -rf kafka-manager-$KAFKA_MANAGER_VERSION
unzip kafka-manager-$KAFKA_MANAGER_VERSION.zip
mv kafka-manager-$KAFKA_MANAGER_VERSION kafka-manager
mkdir -p files
cp ../files/start-kafka-manager-service.sh kafka-manager/
cp ../files/dm-kafka-manager.service files/
mkdir dm-kafka-manager-$KAFKA_MANAGER_VERSION
mv kafka-manager files dm-kafka-manager-$KAFKA_MANAGER_VERSION
tar czf dm-kafka-manager-$KAFKA_MANAGER_VERSION.tar.gz dm-kafka-manager-$KAFKA_MANAGER_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-kafka-manager-$KAFKA_MANAGER_VERSION.tar.gz package/SOURCES/
cp files/dm-kafka-manager.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $KAFKA_MANAGER_VERSION" \
    --define "_release $KAFKA_MANAGER_RELEASE" \
    -bb package/SPECS/dm-kafka-manager.spec
