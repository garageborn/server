#!/bin/bash
echo "# user"

sudo useradd garageborn -s /bin/bash --create-home --user-group
sudo passwd -d garageborn

sudo cat >/etc/sudoers.d/garageborn <<EOL
garageborn ALL=(ALL) NOPASSWD:ALL
EOL
