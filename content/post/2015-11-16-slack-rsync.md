---
categories:
- tech
date: 2015-11-16T00:00:00Z
excerpt: A simple script to rsync a directory and send a summary to Slack.
modified: ""
tags:
- python
- automation
title: Slack rsync
---

With a little push from [@groob](https://github.com/groob), I have created a simple python script that runs a rsync command and sends a summary of the run to [Slack](https://slack.com/). Slack was not created to be a storage vault for server logs however it does great for short sms style messages. If you are using a log collection service like [logstash](https://www.elastic.co/products/logstash) you could extend on this script to include the link to your uploaded log or if an error occurs you could automatically create a helpdesk ticket for you to investigate the issue.

My use case is simple, every day I sync my munki repo to a separate server (I also have backups don't worry). I only need to know that the task completed successfully. I have little desire to see a verbose output of every single line of an rsync run. With the rsync `--stats` flag you can see a summary of the run which is then sent to Slack. The green bar will change to red if an error has occurred, which allows anyone to know if an error has occurred at a glance.

Sample output:

![](/images/2015-10-16/sample.png)

For this to work you will need to:

* setup [ssh passwordless login](http://linuxconfig.org/passwordless-ssh)
* create a Slack "Incoming Webhook"
  * visit [https://slack.com/services/new/incoming-webhook](https://slack.com/services/new/incoming-webhook)
* modify the [sync_slack.py](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/slack/sync_slack/sync_slack.py) as needed


To see the project README and get the script visit: [sync_slack](https://github.com/clburlison/scripts/tree/master/clburlison_scripts/slack/sync_slack)
