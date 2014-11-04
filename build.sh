#/bin/bash
# enable error reporting to the console
set -e 

git config --global user.name '#{ENV['GIT_NAME']}'
git config --global user.email '#{ENV['GIT_EMAIL']}'
git config --global push.default simple

# build site with `jekyll', by default to `_site' folder
jekyll build

# cleanup
rm -rf ../clburlison.github.io.master

#clone `master' branch of the repository using encrypted GH_TOKEN for authentication
git clone https://#{ENV['GIT_NAME']}:#{ENV['GH_TOKEN']}@github.com/clburlison/clburlison.github.io.git ../clburlison.github.io.master

# copy generated HTML site to `master' branch
cp -R _site/* ../clburlison.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../clburlison.github.io.master
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master -f
