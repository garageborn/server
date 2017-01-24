#!/bin/bash
echo "# node"

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y nodejs

# yarn
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"

yarn global add pm2 --prefix=~/.config/yarn/global/node_modules/.bin
