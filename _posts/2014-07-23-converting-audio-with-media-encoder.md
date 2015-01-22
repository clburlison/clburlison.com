---
filename: 2014-07-23-converting-audio-with-media-encoder.md
layout: post
title: "Converting Audio With Media Encoder"
modified: 2014-10-18
comments: true
published: true
keywords: audio, editing, wav, windows, mac
description: Describes how to convert audio to a mono format that is suitable for phone distribution purposes.
categories: 
- editing
---

I received a unique request today from a co-worker of mine. In short, he asked me if I was able to convert an audio clip from a Tascam audio recorder to a lower quality format suitable for our phone distribution system. The real challenge...was I going to be able to do this with the software currently installed?
<!-- more -->

Fortunately, I have access to the Adobe Create Suite (CS6) at work from which I will be using Media Encoder in this tutorial. The screenshots below are from a Mac but the steps should be pretty close on a Windows computer. The added benefit of this process is if you ever need to post-process audio that was recorded ``clean`` and make it sound like it went through a phone this will produce a pretty decent ``phone sound``. 


**Goal:** Create a ``.wma`` or ``.wav`` format file with a low sample rate, low sample size, and mono channel audio. 

#Process to convert the audio

1. Open Adobe Media Encoder.  
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/1_open.png">
	</figure>

2. Create the Phone Preset by clicking on the ``+`` button in the Preset Browser window.  
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/2_add_preset.png">
	</figure>

3. Add a preset name and change the format to Waveform Audio.  
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/3_format.png">
	</figure>

4. Change the basic audio setting the values below. Click okay to save the preset.    
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/4_settings.png">
	</figure>

5. Add your audio file to be converted by clicking the ``+`` button in the Queue window.  
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/5_adding_file_2_encode.png">
	</figure>

6. Drag your phone setting preset from the Preset Browser window on top of the audio file you want to convert. It should look like the picture below. (note the .wav file extension)  
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/6_ready_2_encode.png">
	</figure>

7. Click the green encode button.  
	<figure>
		<img src="{{ site.url }}/images/2014-07-23/7_encode.png">
	</figure>

##Before/After
<div>
	<a href="{{ site.url }}/images/2014-07-23/audio-test.mp3" target="_blank"><img src="{{ site.url }}/images/speaker-30.jpg" height="30"> Before</a>
</div>

<div>
	<a href="{{ site.url }}/images/2014-07-23/audio-test_1.wav" target="_blank"><img src="{{ site.url }}/images/speaker-30.jpg" height="30">  After</a>
</div>  


The result is a Linear PCM codec audio file with 16 bit/sample rate, 8 kilohertz (kHz) in a ``.wav`` format.


#Update
Although, this method does work and creates a windows audio file, it ended up not working for the original application that I needed. Needless to say there is no point removing this guide.

Update: Oct 18, 2014 - Typo
