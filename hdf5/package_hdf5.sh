#!/bin/bash

# Configuration
if [ -z "$FPM_COMMAND" ] ; then
    FPM_COMMAND=fpm
fi

# Prepare environment
mkdir -p hdf5
rm -rf rpm/hdf5-$HDF5_VERSION.* hdf5/packaging hdf5/$HDF5_FILE rpm
cd hdf5

if [ ! -f "hdf5-$HDF5_FILE.tar.gz" ] ; then
    echo "File \"hdf5-$HDF5_FILE.tar.gz\" not found. Downloading..."
    curl -LO https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_MAJOR/hdf5-$HDF5_FILE/src/hdf5-$HDF5_FILE.tar.gz
else
    echo "File \"hdf5-$HDF5_FILE.tar.gz\" found. Skipping download."
fi

echo "Comparing MD5 sums..."
MD5_SUM=$(openssl dgst -md5 hdf5-$HDF5_FILE.tar.gz | awk '{print $2}')
if [ "$MD5_SUM" != "$HDF5_MD5_SUM" ] ; then
    echo "Error: MD5 sum different from expected value. Stopping."
    exit 1
fi
echo "Extracting file..."
tar xzf hdf5-$HDF5_FILE.tar.gz

echo "Building libraries..."
mkdir packaging
cd hdf5-$HDF5_FILE
./configure \
    --enable-cxx \
    --disable-static \
    --prefix=/usr \
    --libdir=/usr/lib64
make
make install DESTDIR=$(pwd)/../packaging
cd ../packaging
echo "Creating files..."
tar czf hdf5-$HDF5_VERSION.tar.gz usr/bin usr/lib
tar czf hdf5-devel-$HDF5_VERSION.tar.gz usr/include usr/share

echo "Creating RPMs..."
mkdir -p ../../rpm
$FPM_COMMAND --input-type tar \
    --output-type rpm \
    --package ../../rpm \
    --name hdf5 \
    --version $HDF5_VERSION \
    --iteration $HDF5_RELEASE \
    --license "BSD-style" \
    --provides "hdf5" \
    --maintainer "Afonso" \
    --description "HDF5 C and C++ libraries" \
    --url "https://www.hdfgroup.org/hdf5/" \
    hdf5-$HDF5_VERSION.tar.gz
$FPM_COMMAND --input-type tar \
    --output-type rpm \
    --package ../../rpm \
    --name hdf5-devel \
    --version $HDF5_VERSION \
    --iteration $HDF5_RELEASE \
    --license "BSD-style" \
    --provides "hdf5-devel" \
    --depends "hdf5 = $HDF5_VERSION" \
    --maintainer "Afonso" \
    --description "HDF5 C and C++ libraries headers and examples" \
    --url "https://www.hdfgroup.org/hdf5/" \
    hdf5-devel-$HDF5_VERSION.tar.gz
echo "RPMs created and available in rpm folder."
