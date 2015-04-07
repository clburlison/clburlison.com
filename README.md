Personal Website for Clayton Burlison
===

[![Build Status](https://travis-ci.org/clburlison/clburlison.github.io.svg?branch=source)](https://travis-ci.org/clburlison/clburlison.github.io),  [![Waffle.io](https://badge.waffle.io/clburlison/clburlison.github.io.svg?label=ready&title=Ready)](http://waffle.io/clburlison/clburlison.github.io),  [![Waffle.io](https://badge.waffle.io/clburlison/clburlison.github.io.svg?label=in%20progress&title=In%20Progress)](http://waffle.io/clburlison/clburlison.github.io)

This repo contains my personal website, [clburlison.com](https://clburlison.com). The _source_ branch has my markdown files, images, and configuration settings while the _master_ branch is actually my "web share". This site is powered by Github, Travis-ci, Jekyll, and Cloudflare. With those four services, I am able to host a completely free static website with a Content Deliver Network (CDN) plus Travis takes care of building my site. All I have to do is create the content, `git push` and my site is automagically updated.

Powered by Jekyll with the [Minimal Mistakes Theme](http://mademistakes.com/minimal-mistakes/).


#Site info 
This site can be managed via [prose.io](http://prose.io/#clburlison/clburlison.github.io). Visit the website and, when prompted, authorize via GitHub.

If running locally, you can use the Octopress plugin:

*New Post & New Page*

````
$ octopress new post "Post Title"
$ octopress new page new-page/
````

##Travis integration

To get travis-ci setup check out this awesome project [jekyll-travis](https://github.com/mfenner/jekyll-travis)!

##License

	The MIT License (MIT)

	Copyright (c) 2015 Clayton Burlison

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
