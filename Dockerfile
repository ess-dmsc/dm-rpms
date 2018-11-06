
FROM centos:centos7
MAINTAINER gareth.murphy@esss.se

RUN yum install  -y cmake \
cyrus-sasl-devel \
doxygen \
gcc \
gcc-c++ \
git \
g++ \
javac \
make \
maven \
openssl \
openssl-devel \
python \
rpm-build \
zlib-devel

COPY . /usr/src/app/
WORKDIR  /usr/src/app/


RUN curl -LO http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.9/sbt-launch.jar
RUN mkdir -p   /root/.sbt/launchers/0.13.9/
RUN mv sbt-launch.jar  /root/.sbt/launchers/0.13.9/

#RUN make all
RUN make kafka
RUN make zookeeper
RUN make kafka-manager
