#!/bin/sh

echo "Creating user \"kafka-manager\" if it does not already exist..."
id -u kafka-manager &>/dev/null || \
    useradd kafka-manager --shell /usr/bin/false --no-create-home
