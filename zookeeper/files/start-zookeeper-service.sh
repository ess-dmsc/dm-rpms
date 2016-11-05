#!/bin/bash

if [ -f /etc/opt/dm_group/zookeeper/zoo.cfg ] ; then
    export ZOOCFGDIR=/etc/opt/dm_group/zookeeper
fi

/opt/dm_group/zookeeper/bin/zkServer.sh start
