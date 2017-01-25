#!/bin/bash
echo "# user"

sudo useradd garageborn -s /bin/bash --create-home --user-group
sudo passwd -d garageborn

sudo sh -c 'echo "garageborn ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/garageborn'
