#!/bin/sh

echo "Creating user \"kafka\" if it does not already exist..."
id -u kafka &>/dev/null || \
    useradd kafka --shell /usr/bin/false --no-create-home
