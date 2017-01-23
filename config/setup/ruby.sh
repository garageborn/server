#!/bin/bash
echo "# ruby"

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

rbenv install 2.4.0 --skip-existing
rbenv global 2.4.0
rbenv shell 2.4.0
gem install bundler
