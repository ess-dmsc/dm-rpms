#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -d flatbuffers ] ; then
    git clone https://github.com/google/flatbuffers.git
else
    cd flatbuffers
    git pull origin master
    cd ..
fi

cd flatbuffers
git checkout v$FLATBUFFERS_VERSION
cd ..

cd ../workspace

cp -r ../sources/flatbuffers dm-flatbuffers-$FLATBUFFERS_VERSION
cp ../files/CHANGES dm-flatbuffers-$FLATBUFFERS_VERSION/
tar czf dm-flatbuffers-$FLATBUFFERS_VERSION.tar.gz dm-flatbuffers-$FLATBUFFERS_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-flatbuffers-$FLATBUFFERS_VERSION.tar.gz package/SOURCES/
cp files/dm-flatbuffers.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $FLATBUFFERS_VERSION" \
    --define "_release $FLATBUFFERS_RELEASE" \
    -bb package/SPECS/dm-flatbuffers.spec
