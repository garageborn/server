#!/bin/bash
echo "# Hostname"
name=$1

sudo bash -c "cat >>/etc/hosts <<EOL
127.0.0.1 $name
"

sudo hostnamectl --static set-hostname $name
sudo /etc/init.d/hostname.sh restart
