#!/bin/bash

if [ -f /etc/opt/dm_group/kafka/server.properties ] ; then
    KAFKA_CONFIG=/etc/opt/dm_group/kafka/server.properties
else
    KAFKA_CONFIG=/opt/dm_group/kafka/config/server.properties
fi

/opt/dm_group/kafka/bin/kafka-server-start.sh $KAFKA_CONFIG
