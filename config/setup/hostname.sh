#!/bin/bash
echo "# Hostname"
name=$1

sudo hostnamectl --static set-hostname $name
sudo /etc/init.d/hostname restart
