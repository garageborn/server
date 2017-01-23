#!/bin/bash
echo "# apt"

# Update and upgrade
sudo apt-get update -y && sudo apt-get upgrade -y

# Install packages
packages=(
  # system packages
  build-essential
  libpcre3
  libpcre3-dev
  libssl-dev
  locales

  # system tools
  curl
  git-core
  htop
  vim
  wget

  # letsencrypt
  certbot -t jessie-backports

  # geolocalization
  libmaxminddb-dev
  libmaxminddb0
  mmdb-bin
)

sudo apt-get install -y ${packages[@]}
