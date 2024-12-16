#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

#Stop panini.service
systemctl stop panini.service

#Delete User
userdel panini

#Delete home directory and run.sh script
rm -rf /home/panini
rm /usr/local/bin/run.sh

#Remove panini.service
systemctl disable panini.service
rm /etc/systemd/system/panini.service

echo "Uninstallation Successful! Hope you will be back soon!"
