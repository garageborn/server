#!/bin/bash
echo "# apt"

# Update and upgrade
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y

# Install packages
packages=(
  # system packages
  build-essential
  gcc
  libicu-dev
  libpcre3
  libpcre3-dev
  libssl-dev
  locales
  make
  zlib1g-dev

  # system tools
  cron
  curl
  git-core
  htop
  screen
  vim
  wget
)

sudo apt-get install -y ${packages[@]}
sudo apt-get autoremove && sudo apt-get autoclean
