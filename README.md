# iOS-Animated-Waveform-in-Swift
A waveform that animates to an AVAudioPlayer.

# Installation
Drag `Waveform_view.swift` into your project.

# Usage
Create a view on a storyboard or in your code manually, and set its type as `WaveformView`. 

To activate the waveform, write this code:

`myWaveformView.start(&myAudioPlayer)`

With `myWaveformView` being the view you created as the type of `WaveformView` above, and `myAudioPlayer` being the audio player you want the waveform to animate to.

# Extra
To change the color of the waveform (default is black) do this:
```
  myWaveformView.color["r"] = 0.5 // the amount of red from 0 - 1
  myWaveformView.color["g"] =  0.7 // the amount of green from 0 - 1
  myWaveformView.color["b"] =  0.2 // the amount of blue from 0 - 1
```
