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
)

sudo apt-get install -y ${packages[@]}
