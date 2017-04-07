---
categories:
- tech
date: 2014-07-28T00:00:00Z
description: null
keywords: bash, scripting, if then, statements
modified: 2015-02-16
aliases:
- /blog/2014/07/28/bash-if-then-cheat-sheet/
tags:
- macos
- bash
title: Bash if then cheat sheet
---

I always find myself looking for a good resource when writing if/then statements in bash scripts. It's hard to remember all the combinations when you simply do not use most of them frequently. Below is my personal cheat sheet...copied here because I was tired of having to look for a good resource.   

Examples on usage can be found in the [original article](http://tldp.org/LDP/abs/html/comparison-ops.html).

## integer comparison
```bash

	# The following are for number values only.
	-eq
		is equal to
		if [ "$a" -eq "$b" ]
	-ne
		is not equal to
		if [ "$a" -ne "$b" ]

	-gt
		is greater than
		if [ "$a" -gt "$b" ]

	-ge
		is greater than or equal to
		if [ "$a" -ge "$b" ]

	-lt
		is less than
		if [ "$a" -lt "$b" ]

	-le
		is less than or equal to
		if [ "$a" -le "$b" ]

	<
		is less than (within double parentheses)
		(("$a" < "$b"))

	<=
		is less than or equal to (within double parentheses)
		(("$a" <= "$b"))

	>
		is greater than (within double parentheses)
		(("$a" > "$b"))

	>=
		is greater than or equal to (within double parentheses)
		(("$a" >= "$b"))
```


## string comparison
```bash

	# The following are for strings of data.
	=
		is equal to
		if [ "$a" = "$b" ]

	Caution:
		Note the whitespace framing the =
		if [ "$a"="$b" ] is not equivalent to the above.

	==
		is equal to
		if [ "$a" == "$b" ]

	This is a synonym for =
	Note:
		The == comparison operator behaves differently
		within a double-brackets test than within single brackets.
		[[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
		[[ $a == "z*" ]] # True if $a is equal to z* (literal matching).
		[ $a == z* ]     # File globbing and word splitting take place.
		[ "$a" == "z*" ] # True if $a is equal to z* (literal matching).
		# Thanks, Stéphane Chazelas

	!=
		is not equal to
		if [ "$a" != "$b" ]

	This operator uses pattern matching within a [[ ... ]] construct.

	<
		is less than, in ASCII alphabetical order
		if [[ "$a" < "$b" ]]
		if [ "$a" \< "$b" ]

	Note: that the "<" needs to be escaped within a [ ] construct.

	>
		is greater than, in ASCII alphabetical order
		if [[ "$a" > "$b" ]]
		if [ "$a" \> "$b" ]

	Note that the ">" needs to be escaped within a [ ] construct.

	-z
		string is null, that is, has zero length

	String=''   # Zero-length ("null") string variable.
		if [ -z "$String" ]
		then
		  echo "\$String is null."
		else
		  echo "\$String is NOT null."
		fi     # $String is null.

	-n
		string is not null.

	Caution:
		The -n test requires that the string be quoted within the test brackets.
		Using an unquoted string with ! -z, or even just the unquoted string a
		lone within test brackets (see Example 7-6) normally works, however,
		this is an unsafe practice. Always quote a tested string. [1]
```

# Examples

To check if a directory exists in a shell script you can use the following:

```bash
if [ -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY exists.
fi
```

Or to check if a directory doesn't exist:

```bash
if [ ! -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
fi
```

# Credit
Special Thanks to the The Linux Documentation Project for outlining the information in such a usable format. They also include great examples on their website.

---

Articles:
[Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/comparison-ops.html)
