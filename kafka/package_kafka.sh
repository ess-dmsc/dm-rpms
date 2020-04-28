#!/bin/bash

# Prepare environment
SCALA_VERSION=2.12
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -f "kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz" ] ; then
    echo "File \"kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz\" not found. Downloading..."
    curl -LO http://mirrors.rackhosting.com/apache/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz
else
    echo "File \"kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz\" found. Skipping download."
fi

echo "Comparing Kafka SHA512..."
SHA512_SUM1=$(openssl dgst -sha512 kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | awk '{print $2}')
if [ "$SHA512_SUM1" != "$KAFKA_SHA512_SUM" ] ; then
    echo "Error: Kafka SHA512 different from expected value. Stopping."
    exit 1
fi

# Get jmxtrans-agent
JMXTRANS_AGENT_TAR_FILE=jmxtrans-agent-${JMXTRANS_AGENT_VERSION}.tar.gz
JMXTRANS_AGENT_DIR=jmxtrans-agent-jmxtrans-agent-$JMXTRANS_AGENT_VERSION
if [ ! -f "$JMXTRANS_AGENT_TAR_FILE" ] ; then
    curl -LO https://github.com/jmxtrans/jmxtrans-agent/archive/$JMXTRANS_AGENT_TAR_FILE
fi

echo "Comparing jmxtrans-agent SHA512..."
SHA512_SUM2=$(openssl dgst -sha512 $JMXTRANS_AGENT_TAR_FILE | awk '{print $2}')
if [ "$SHA512_SUM2" != "$JMXTRANS_AGENT_SHA512_SUM" ] ; then
    echo "Error: jmxtrans-agent SHA512 different from expected value. Stopping."
    exit 1
fi

cd ../workspace

echo "Building jmxtrans-agent..."
cp ../sources/$JMXTRANS_AGENT_TAR_FILE .
tar xzf $JMXTRANS_AGENT_TAR_FILE
cd $JMXTRANS_AGENT_DIR
./mvnw package
if [ $? -ne 0 ] ; then
    echo "Error: 'mvnw package' returned non-zero value. Stopping."
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
cp ../files/jmxtrans-agent.xml files/
cp ${JMXTRANS_AGENT_DIR}/target/jmxtrans-agent-${JMXTRANS_AGENT_VERSION}.jar kafka/libs/
cp ${JMXTRANS_AGENT_DIR}/LICENSE kafka/LICENSE.jmxtrans-agent
cp ${JMXTRANS_AGENT_DIR}/NOTICE kafka/NOTICE.jmxtrans-agent
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
