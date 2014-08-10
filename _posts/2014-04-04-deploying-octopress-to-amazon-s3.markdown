---
layout: post
title: "Deploying Octopress to Amazon S3"
date: 2014-04-04 15:08:15 -0500
modified: 2014-05-06
comments: true
published: true
keywords: octopress, amazon s3, amazon aws, website, s3cmd
description: Deploy octopress with s3cmd command.
categories: [octopress]
---
This post will go over how I upload my octopress site from my computer to Amazon s3 cloud service using s3cmd.  

Firstly, you will need to sign up for an [Amazon AWS account](http://aws.amazon.com/s3/) if you do not have one already. It is quite cheap and you only pay for what you use.

## Installing s3tools
This is available in most Linux distributions, via Homebrew, directly from [s3tools.org](http://s3tools.org/download), or the source directory on [github](https://github.com/s3tools/s3cmd/releases). Run the following commands on the tar ball. (use at least version 1.0.X)

{% highlight bash %}
tar xzvf s3cmd-1.5.0-alpha1.tar.gz
cd s3cmd-1.5.0-alpha1
python setup.py install
{% endhighlight %} 

You will need to copy & paste `access_key` and `secret_key` from the *Security Credentials* page of Amazon AWS into s3cmd’s configuration wizard. Use this [article](http://www.cloudberrylab.com/blog/how-to-find-your-aws-access-key-id-and-secret-access-key-and-register-with-cloudberry-s3-explorer/) if you need help looking for keys. Then you will need to configure the c3cmd command with the following:

{% highlight bash %}
s3cmd --configure         # Begin interactive configuration
{% endhighlight %}

When finished, your ~/.s3cfg file should end up looking something like this.
{% highlight bash%}
[default]
# ...snip...
access_key = ALRJCALDDZUDEGNSSIPE 
secret_key = 9DJWHga1Y+uBAFXntDM1Ujd6FrnnUZb/9dLMOqzn
# ...snip...
{% endhighlight %} 

## Creating your s3 bucket
You will have to create your s3 bucket with in the [Amazon AWS console](https://console.aws.amazon.com/s3/home). Create a bucket using the fully-qualified domain name of your blog `(e.g., www.example.com)`. Open the Properties pane for your bucket, and then enable "Static web hosting". Make note of the “endpoint”, something like `example.com.s3-website-us-east-1.amazonaws.com`. You can use this directly, but most people will create a DNS CNAME pointing to it instead.

![Amazon AWS]({{ site.url }}/images/posts/2014-04-04/amazon_aws.png)

## Modifying your Rakefile
Inside your octopress directory, you have a file `Rakefile` that we need to make a few modifications to so that we can upload to Amazon s3. Start by editing the `deploy_default` variable to be `s3`. Next establish a new variable by adding this line into the file `s3_bucket = "www.mywebsite.com"` modifying the website name. 

{% highlight bash %}
## -- Rsync Deploy config -- ##
# Be sure your public key is listed in your server's ~/.ssh/authorized_keys file
ssh_user       = "user@domain.com"
ssh_port       = "22"
document_root  = "~/website.com/"
rsync_delete   = false
rsync_args     = ""  # Any extra arguments to pass to rsync
deploy_default = "s3"
s3_bucket = "www.clburlison.com"
{% endhighlight %}

Lastly, you need to make a new task in the `Rakefile`. Add the following text lines to the end of your file.
{% highlight bash %}
desc "Deploy website via s3cmd"
task :s3 do
  puts "## Deploying website via s3cmd"
  ok_failed system("s3cmd sync --acl-public --reduced-redundancy public/* s3://#{s3_bucket}/")
end
{% endhighlight %}

Deployment is now only a matter of running the usual command: 
{% highlight bash %}
rake deploy
{% endhighlight %} 

---

Articles: [Jacob Elder](http://blog.jacobelder.com/2012/03/deploying-octopress-to-amazon-s3/), [Jerome Bernard](http://www.jerome-bernard.com/blog/2011/08/20/quick-tip-for-easily-deploying-octopress-blog-on-amazon-s3/)