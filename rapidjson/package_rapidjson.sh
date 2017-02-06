#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -d rapidjson ] ; then
    git clone https://github.com/miloyip/rapidjson.git
else
    cd rapidjson
    git pull origin master
    cd ..
fi

cd rapidjson
git checkout v$RAPIDJSON_VERSION
cd ..

cd ../workspace

cp -r ../sources/rapidjson dm-rapidjson-devel-$RAPIDJSON_VERSION
tar czf dm-rapidjson-devel-$RAPIDJSON_VERSION.tar.gz dm-rapidjson-devel-$RAPIDJSON_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-rapidjson-devel-$RAPIDJSON_VERSION.tar.gz package/SOURCES/
cp files/dm-rapidjson-devel.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $RAPIDJSON_VERSION" \
    --define "_release $RAPIDJSON_RELEASE" \
    -bb package/SPECS/dm-rapidjson-devel.spec
