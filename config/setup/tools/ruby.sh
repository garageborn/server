#!/bin/bash
echo "# ruby"

packages=(
  autoconf
  bison
  build-essential
  cmake
  libcurl4-openssl-dev
  libffi-dev
  libgdbm-dev
  libgdbm3
  libncurses5-dev
  libreadline6
  libreadline6-dev
  libssl-dev
  libyaml-dev
  pkg-config
  zlib1g-dev
)
sudo apt-get update && sudo apt-get install -y ${packages[@]}

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv && sudo src/configure && sudo make -C src

echo 'gem: --no-rdoc --no-ri' > ~/.gemrc

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

rbenv install 2.4.0 --skip-existing
rbenv global 2.4.0
rbenv shell 2.4.0
gem install bundler
gem update --system
