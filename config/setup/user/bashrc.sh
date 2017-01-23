#!/bin/bash
echo "# .bashrc"

cat >~/.bashrc <<EOL
export PS1="\[\\033]0;\h\\007\]\u@\h [\w]#"
export EDITOR="vim"
export LS_OPTIONS="--color=auto"
alias ls="ls $LS_OPTIONS"
alias ll="ls $LS_OPTIONS -l"
alias l="ls $LS_OPTIONS -lA"

# ENV
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8
if [ -f /etc/profile.d/garageborn.sh ]; then . /etc/profile.d/garageborn.sh; fi
EOL
