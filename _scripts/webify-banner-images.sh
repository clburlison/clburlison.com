#!/bin/bash

mogrify -resize 900 -quality 5 -crop 420x400+365+25 -format png '*.jpeg'