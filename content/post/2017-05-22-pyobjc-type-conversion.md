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

If you have ever worked with the PyObjC bridge on the macOS platform you might have noticed that data is often returned as a Objective-C class object (NSArray, NSDictionary, etc.) Thanks to the effort put into PyObjC, python can seamlessly use python type methods with their Objective-C class equivalents. But, what do you do when you are **required** to use a pure python object?

# Use case

I ran into this issue when using the [Boto3](https://github.com/boto/boto3) python library for my [s3Repo plugin](https://github.com/clburlison/Munki-s3Repo-Plugin) for munki. The `boto3.session.Session` method does a type check on one of the input parameters to make sure you are passing a python dictionary object. If I attempted to pass a NSDictionary object I would crash the boto3 library. So I needed to convert it. If this object was a simple dictionary, I could have used a loop with a `dict.update(my_ns_dictionary)` but my object was a nested NSDictionary.

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
Such an easy to use solution and it is built-in to the PyObjC module.

# Credits
* Thanks to [Michael Lynn](https://michaellynn.github.io) for corrections.
