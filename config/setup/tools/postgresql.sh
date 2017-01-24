#!/bin/bash
echo "# postgresql"

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get update

packages=(
  postgresql-client-9.6
  postgresql-common
  libpq-dev
)

sudo apt-get install -y ${packages[@]}
