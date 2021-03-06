#!/bin/bash

if [ -f /etc/opt/dm_group/kafka/server.properties ] ; then
    KAFKA_CONFIG=/etc/opt/dm_group/kafka/server.properties
else
    KAFKA_CONFIG=/opt/dm_group/kafka/config/server.properties
fi

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
export EXTRA_ARGS="-javaagent:/opt/dm_group/kafka/libs/jmxtrans-agent-1.2.11.jar=/etc/opt/dm_group/kafka/jmxtrans-agent.xml"
/opt/dm_group/kafka/bin/kafka-server-start.sh $KAFKA_CONFIG
