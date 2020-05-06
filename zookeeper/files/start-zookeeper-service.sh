#!/bin/bash

if [ -f /etc/opt/dm_group/zookeeper/zoo.cfg ] ; then
    export ZOOCFGDIR=/etc/opt/dm_group/zookeeper
fi

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
/opt/dm_group/zookeeper/bin/zkServer.sh start
