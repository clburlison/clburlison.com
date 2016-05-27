#!/bin/bash
setup () {
  BUNDLER=`gem list | grep "bundler"`
  if [ -z "$BUNDLER" ]; then
    echo '## Install bundler locally'
    gem install --user-install bundler rake
  fi
  # These checks aren't working right now
  # if [ -e "/usr/local/bin/resume" ]; then
  #   echo '## Install resume command line locally'
  #   sudo npm install -g resume-cli
  # fi
  # if [ -e "/usr/local/bin/html-pdf" ]; then
  #   echo '## Install html to pdf locally'
  #   sudo npm install -g html-pdf
  # fi
  echo '## Install gems to an isolated path'
  bundle install --path .gem
}

update () {
  echo '## Update gems'
  bundle update
}

clean () {
  echo '## Clean old gems'
  bundle clean
}

clean () {
  echo "## Clean up your ruby gems"
  bundle clean
}

# setup_old () {
#   echo "## Setup your development environment"
#   echo "## Install Homebrew"
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#   echo "## Install rvm"
#   curl -sSL https://get.rvm.io | bash -s stable --ruby=
#   echo "## Source rvm so it works in this session"
#   source $HOME/.rvm/scripts/rvm
#   echo "## Install Ruby 2.1.0 with rvm"
#   rvm install ruby-2.1.0
#   echo "## Default use Ruby 2.1.0 from rvm"
#   rvm --default use 2.1.0
#   echo "## Install Bundler"
#   gem install bundler
#   echo "## Install repo requirements with Bundler"
#   bundle install --binstubs=$GEM_HOME/bin/
#   echo "## Setup complete"
# }

# clean_old () {
#   echo "## Clean (Uninstall) up your development environment"
#   echo "## Uninstall Homebrew"
#   echo "## Most of the time you should select _NO_"
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
#   echo "## Set Ruby to System"
#   rvm --default system
#   echo "## Uninstall rvm"
#   rvm implode
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