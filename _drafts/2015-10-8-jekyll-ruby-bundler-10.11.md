# Intro 
It seems like a ton of people are having issues with Ruby, Jekyll, and Bundler after upgrading to El Capitan. The reason why is because many users were simply installing ruby gems as root. I shamefully had been doing this as well simply because it was easy but how do you fix it? Use a ruby gem manager; RVM, rbenv, chruby, etc. That is fine if you're an actual ruby developer and need to test against multiple versions of ruby for for someone who just uses ruby for Jekyll?

Easiest solution below:


{% highlight rake %}

#############################################################################
#
# Setup development environment
#
#############################################################################

desc "Setup your development environment for this repo"
task :setup => [:clean] do
  puts "\n## Install Homebrew"
  status = system('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
  puts "\n## Install ruby for Homebrew"
  status = system("brew install ruby")
  puts status ? "Success" : "Failed"
  puts "\n## Overrite ruby links for Homebrew"
  status = system("brew link --overwrite ruby")
  puts status ? "Success" : "Failed"
  puts "\n## Install Bundler"
  status = system("gem install bundler -v 1.9.7 --user-install -n /usr/local/bin")
  puts status ? "Success" : "Failed"
  puts "\n## Install repo requirements with Bundler"
  status = system("bundle install --path /usr/local/Cellar")
  puts status ? "Success" : "Failed"
end

desc "Clean up your development environment (uninstall)"
task :clean do
  puts "\n## Unlink ruby from Homebrew"  
  status = system("brew unlink ruby")
  puts status ? "Success" : "Failed"
  puts "\n## Uninstall Homebrew"
  puts "\n## Most of the time you should select No"  
  status = system('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"')
  puts status ? "Success" : "Failed"
  puts "\n## Uninstall gpg"
  status = system("brew uninstall gpg")
  puts status ? "Success" : "Failed"
  puts "\n## Uninstall rvm"
  status = system("rvm implode")
  puts status ? "Success" : "Failed"
  puts "\n## Uninstall Bundler"
  status = system("gem uninstall bundler")  
  puts status ? "Success" : "Failed"
end



# Conclusion

Resources: [gem install jekyll failed on Mac OS X 10.11](https://github.com/jekyll/jekyll/issues/3984#issuecomment-142416330),  
[Post Upgrade to El Capitan, with Homebrew & Ruby.md](https://gist.github.com/pboling/c2bb179e73f8a6ca94e4)