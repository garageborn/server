#!/bin/bash
echo "# apt"

# Update and upgrade
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y

# Install packages
packages=(
  # system packages
  build-essential
  gcc
  libpcre3
  libpcre3-dev
  libssl-dev
  locales
  make
  zlib1g-dev

  # system tools
  curl
  git-core
  htop
  vim
  wget

  # letsencrypt
  letsencrypt

  # geolocalization
  libmaxminddb-dev
  libmaxminddb0
  mmdb-bin
)

sudo apt-get install -y ${packages[@]}

# postgresql
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
apt-get update && apt-get install -y postgresql-client-9.6

# nodejs
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
