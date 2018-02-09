FROM centos:7


RUN yum install  -y cmake \
cyrus-sasl-devel \
doxygen \
gcc \
gcc-c++ \
git \
g++ \
javac \
make \
openssl-devel \
python \
rpm-build \
zlib-devel

COPY . /usr/src/app/
WORKDIR  /usr/src/app/
RUN make


