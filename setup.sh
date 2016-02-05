#!/bin/bash
setup () {
  echo "## Setup your development environment" 
  echo "## Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "## Install rvm"
  curl -sSL https://get.rvm.io | bash -s stable --ruby=
  echo "## Source rvm so it works in this session"
  source $HOME/.rvm/scripts/rvm
  echo "## Install Ruby 2.1.0 with rvm"
  rvm install ruby-2.1.0
  echo "## Default use Ruby 2.1.0 from rvm"
  rvm --default use 2.1.0
  echo "## Install Bundler"
  gem install bundler
  echo "## Install repo requirements with Bundler"
  bundle install --binstubs=$GEM_HOME/bin/
  echo "## Setup complete"
}

clean () {
  echo "## Clean (Uninstall) up your development environment"
  echo "## Uninstall Homebrew"
  echo "## Most of the time you should select _NO_"  
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
  echo "## Set Ruby to System"
  rvm --default system
  echo "## Uninstall rvm"
  rvm implode
}

# WIP
# update () {
#   echo "## Update Bundle config to match current $USER"
#   print "---
# BUNDLE_BIN: "/Users/${USER}/.rvm/gems/ruby-2.1.0/bin/" > ./bundle/config
# }

case "$1" in
  setup)
      setup
      ;; 
  clean)
      clean
      ;;
  *)
    echo $"Usage: $0 {setup|clean}"
    exit 1
esac