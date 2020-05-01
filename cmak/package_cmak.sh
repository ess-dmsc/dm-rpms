#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -f $CMAK_VERSION.tar.gz ] ; then
    echo "File \"$CMAK_VERSION.tar.gz\" not found. Downloading..."
    curl -LO https://github.com/yahoo/CMAK/archive/$CMAK_VERSION.tar.gz
else
    echo "File \"$CMAK_VERSION.tar.gz\" found. Skipping download."
fi

echo "Comparing SHA512 sums..."
SHA512_SUM=$(openssl dgst -sha512 $CMAK_VERSION.tar.gz | awk '{print $2}')
if [ "$SHA512_SUM" != "$CMAK_SHA512_SUM" ] ; then
    echo "Error: SHA512 sum different from expected value. Stopping."
    exit 1
fi

cd ../workspace

echo "Extracting file..."
tar xvf ../sources/$CMAK_VERSION.tar.gz

echo "Building..."
cd CMAK-$CMAK_VERSION
PATH=/usr/lib/jvm/java-11-openjdk/bin:$PATH JAVA_HOME=/usr/lib/jvm/java-11-openjdk ./sbt -java-home /usr/lib/jvm/java-11-openjdk clean dist
cd ..

# Extract built package and build custom package
echo "Creating package structure..."
mv CMAK-$CMAK_VERSION/target/universal/cmak-$CMAK_VERSION.zip .
rm -rf CMAK-$CMAK_VERSION
unzip cmak-$CMAK_VERSION.zip
mv cmak-$CMAK_VERSION cmak
mkdir -p files
cp ../files/start-cmak-service.sh cmak/
cp ../files/dm-cmak.service files/
mkdir dm-cmak-$CMAK_VERSION
mv cmak files dm-cmak-$CMAK_VERSION
tar czf dm-cmak-$CMAK_VERSION.tar.gz dm-cmak-$CMAK_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-cmak-$CMAK_VERSION.tar.gz package/SOURCES/
cp files/dm-cmak.spec package/SPECS/
PATH=/usr/lib/jvm/java-11-openjdk/bin:$PATH JAVA_HOME=/usr/lib/jvm/java-11-openjdk rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $CMAK_VERSION" \
    --define "_release $CMAK_RELEASE" \
    -bb package/SPECS/dm-cmak.spec
