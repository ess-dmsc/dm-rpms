#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -d fmt ] ; then
    git clone https://github.com/fmtlib/fmt.git
else
    cd fmt
    git pull origin master
    cd ..
fi

cd fmt
git checkout $FMT_VERSION
cd ..

cd ../workspace

cp -r ../sources/fmt dm-fmt-$FMT_VERSION
tar czf dm-fmt-$FMT_VERSION.tar.gz dm-fmt-$FMT_VERSION

cd ..

echo "Creating RPM..."
if [ "$CMAKE3_ROOT" ] ; then
    export PATH=$CMAKE3_ROOT:$PATH
    which cmake
fi
cp workspace/dm-fmt-$FMT_VERSION.tar.gz package/SOURCES/
cp files/dm-fmt.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $FMT_VERSION" \
    --define "_release $FMT_RELEASE" \
    -bb package/SPECS/dm-fmt.spec
