#!/bin/sh

echo "Creating user \"zookeeper\" if it does not already exist..."
id -u zookeeper &>/dev/null || \
    useradd zookeeper --shell /usr/bin/false --no-create-home
