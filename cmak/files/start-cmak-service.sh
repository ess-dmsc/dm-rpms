#!/bin/bash

CUSTOM_CONFIG_FILE=/etc/opt/dm_group/cmak/application.conf

if [ -f "$CUSTOM_CONFIG_FILE" ] ; then
    CMAK_CONFIG=$CUSTOM_CONFIG_FILE
else
    CMAK_CONFIG=/opt/dm_group/cmak/conf/application.conf
fi

/opt/dm_group/cmak/bin/cmak -Dconfig.file=$CMAK_CONFIG -Dpidfile.path=/var/opt/dm_group/cmak/cmak.pid
