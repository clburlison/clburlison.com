# Intro 
It seems like a ton of people are having issues with Ruby, Jekyll, and Bundler after upgrading to El Capitan. The reason why is because many users were simply installing ruby gems as root. I shamefully had been doing this as well simply because it was easy but how do you fix it? Use a ruby gem manager; RVM, rbenv, chruby, etc. That is fine if you're an actual ruby developer and need to test against multiple versions of ruby for for someone who just uses ruby for Jekyll?

Easiest solution below:


{% gist https://github.com/clburlison/clburlison.github.io/blob/source/Rakefile#L128-L170 %}



# Conclusion

Resources: [gem install jekyll failed on Mac OS X 10.11](https://github.com/jekyll/jekyll/issues/3984#issuecomment-142416330),  
[Post Upgrade to El Capitan, with Homebrew & Ruby.md](https://gist.github.com/pboling/c2bb179e73f8a6ca94e4)