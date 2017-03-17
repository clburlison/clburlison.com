---
title: Git merge error
draft: true
modified:
excerpt:
tags:
  - git
toc: false
---

[clburlison] clburlison-recipes on master ± g push
To https://github.com/autopkg/clburlison-recipes.git
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'https://github.com/autopkg/clburlison-recipes.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.


[clburlison] clburlison-recipes on master ± git pull
remote: Counting objects: 4, done.
remote: Total 4 (delta 2), reused 2 (delta 2), pack-reused 2
Unpacking objects: 100% (4/4), done.
From https://github.com/autopkg/clburlison-recipes
   5630b78..f9446f2  master     -> origin/master
Merge made by the 'recursive' strategy.
 AutoImagrNBI/README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

[clburlison] clburlison-recipes on master ± git rebase origin/master
First, rewinding head to replay your work on top of it...
Applying: Add PancakeBot recipes

[clburlison] clburlison-recipes on master ± g push
Counting objects: 7, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (7/7), done.
Writing objects: 100% (7/7), 2.60 KiB | 0 bytes/s, done.
Total 7 (delta 4), reused 0 (delta 0)
remote: Resolving deltas: 100% (4/4), completed with 1 local objects.
To https://github.com/autopkg/clburlison-recipes.git
   f9446f2..34b7c3b  master -> master



https://twitter.com/wikiwalk/status/793913603950776320

See the example below. This was a single file fix that was pretty simple. However this pull request has *_eight_* commits! Nothing against
