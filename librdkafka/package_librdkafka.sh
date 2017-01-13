#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -d librdkafka ] ; then
    git clone https://github.com/edenhill/librdkafka.git
else
    cd librdkafka
    git pull origin master
    cd ..
fi

cd librdkafka
git checkout v$LIBRDKAFKA_VERSION
cd ..

cd ../workspace

cp -r ../sources/librdkafka dm-librdkafka-$LIBRDKAFKA_VERSION
cp ../files/CHANGES dm-librdkafka-$LIBRDKAFKA_VERSION/
tar czf dm-librdkafka-$LIBRDKAFKA_VERSION.tar.gz dm-librdkafka-$LIBRDKAFKA_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-librdkafka-$LIBRDKAFKA_VERSION.tar.gz package/SOURCES/
cp files/dm-librdkafka.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $LIBRDKAFKA_VERSION" \
    --define "_release $LIBRDKAFKA_RELEASE" \
    -bb package/SPECS/dm-librdkafka.spec
