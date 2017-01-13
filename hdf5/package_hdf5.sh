#!/bin/bash

# Prepare environment
rm -rf package/* workspace/*
mkdir -p sources package/{BUILD,RPMS,SOURCES,SPECS,SRPMS} workspace

cd sources

if [ ! -f "$HDF5_FILE.tar.gz" ] ; then
    echo "File \"$HDF5_FILE.tar.gz\" not found. Downloading..."
    curl -LO https://support.hdfgroup.org/ftp/HDF5/current18/bin/linux-centos7-x86_64-gcc485-noszip/$HDF5_FILE.tar.gz
else
    echo "File \"$HDF5_FILE.tar.gz\" found. Skipping download."
fi

echo "Comparing MD5 sums..."
MD5_SUM=$(openssl dgst -md5 $HDF5_FILE.tar.gz | awk '{print $2}')
if [ "$MD5_SUM" != "$HDF5_MD5_SUM" ] ; then
    echo "Error: MD5 sum different from expected value. Stopping."
    exit 1
fi

cd ../workspace

echo "Extracting file..."
tar xf ../sources/$HDF5_FILE.tar.gz

echo "Creating package structure..."
mkdir dm-hdf5-$HDF5_VERSION
mv $HDF5_FILE/* dm-hdf5-$HDF5_VERSION/
mkdir -p dm-hdf5-$HDF5_VERSION/share/hdf5
cp ../files/CHANGES dm-hdf5-$HDF5_VERSION/share/hdf5/
mv dm-hdf5-$HDF5_VERSION/{COPYING,README,RELEASE.txt} dm-hdf5-$HDF5_VERSION/share/hdf5/
tar czf dm-hdf5-$HDF5_VERSION.tar.gz dm-hdf5-$HDF5_VERSION

cd ..

echo "Creating RPM..."
cp workspace/dm-hdf5-$HDF5_VERSION.tar.gz package/SOURCES/
cp files/dm-hdf5.spec package/SPECS/
rpmbuild \
    --define "_topdir $(pwd)/package" \
    --define "_version $HDF5_VERSION" \
    --define "_release $HDF5_RELEASE" \
    -bb package/SPECS/dm-hdf5.spec
