#!/bin/bash

CUSTOM_CONFIG_FILE=/etc/opt/dm_group/kafka-manager/conf/application.conf

if [ -f "$CUSTOM_CONFIG_FILE" ] ; then
    KAFKA_MANAGER_CONFIG=$CUSTOM_CONFIG_FILE
else
    KAFKA_MANAGER_CONFIG=/opt/dm_group/kafka-manager/conf/application.conf
fi

/opt/dm_group/kafka-manager/bin/kafka-manager -Dconfig.file=$KAFKA_MANAGER_CONFIG -Dpidfile.path=/var/opt/dm_group/kafka-manager/kafka-manager.pid
