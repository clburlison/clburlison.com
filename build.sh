#/bin/bash
# enable error reporting to the console
set -e

# make sure the URL is set to the remote
#sed -i .bak 's,http://localhost:4000,https://clburlison.com,g' ./_config.yml; rm ./_config.yml.bak

# build site with jekyll, by default to `_site' folder
jekyll build

# cleanup
rm -rf ../clburlison.github.io.master

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/clburlison/clburlison.github.io.git ../clburlison.github.io.master

# copy generated HTML site to `master' branch
cp -R _site/* ../clburlison.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../clburlison.github.io.master
git config user.email "clburlison@gmail.com"
git config user.name "Clayton Burlison"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push origin master