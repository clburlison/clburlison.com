---
categories:
- tech
date: 2017-05-22
draft: false
modified:
tags:
- python
title: PyObjC Type Conversion
toc: false
---

# Introduction

If you have ever worked with the PyObjC bridge on the macOS platform you might have noticed that data is often returned as a NS type object (NSArray, NSDictionary, etc.) Since python is not a strongly typed language most programmers do not have to worry about this. However what do you do when you are **required** to use a pure python object?

# Use case

I ran into this issue when using the [Boto3](https://github.com/boto/boto3) python library for my [s3Repo plugin](https://github.com/clburlison/Munki-s3Repo-Plugin) for munki. The `boto3.session.Session` method does a type check on one of the input parameters to make sure you are passing a dictionary object. I was attempting to pass a NSDictionary object which crashed the code.

After a bit of searching online I found the proper solution. However, it is a bit hidden inside the pyobjc code and my search results were less than helpful.

# Conversion process

To see the conversion you will need a few NS objects:

```python
from Foundation import NSDictionary, NSArray
d = NSDictionary.dictionaryWithDictionary_({"foo": "bar", "more": {"level1": 10, "level2": 20}})
type(d)
print(d)

a = NSArray.alloc().initWithObjects_(1,2,3,4)
type(a)
print(a)
```

Now we have verified the type and content, lets convert:

```python
from PyObjCTools import Conversion
new_d = Conversion.pythonCollectionFromPropertyList(d)
type(new_d)
print(new_d)

new_a = Conversion.pythonCollectionFromPropertyList(a)
type(new_a)
print(new_a)
```

# Fin
Such an easy to use solution and is is built-in to the PyObjC module.
