# https://github.com/bep/docuapi/blob/master/ci-install-hugo.sh
HUGO_VERSION=0.18.1

set -x
set -e

# Install Hugo if not already cached or upgrade an old version.
if [ ! -e $TRAVIS_BUILD_DIR/bin/hugo ] || ! [[ `hugo version` =~ v${HUGO_VERSION} ]]; then
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
  tar xvzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
  cp hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 $TRAVIS_BUILD_DIR/bin/hugo
fi
