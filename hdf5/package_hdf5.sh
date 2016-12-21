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
mv $HDF5_FILE hdf5
mkdir hdf5/etc
cp ../files/CHANGES hdf5/
cp ../files/dm-hdf5-env.sh hdf5/etc/
mkdir dm-hdf5-$HDF5_VERSION
mv hdf5 dm-hdf5-$HDF5_VERSION
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
