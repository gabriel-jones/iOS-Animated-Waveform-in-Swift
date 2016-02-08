# iOS-Animated-Waveform-in-Swift
A waveform that animates to an AVAudioPlayer.

<img src="http://i.imgur.com/lXYiGjq.gif" width=500>

# Installation
Drag `WaveformView.swift` into your project.

# Usage
Create a view on a storyboard or in your code manually, and set its type as `WaveformView`. 

To activate the waveform, write this code:

`myWaveformView.start(&myAudioPlayer)`

With `myWaveformView` being the view you created as the type of `WaveformView` above, and `myAudioPlayer` being the audio player you want the waveform to animate to.

# Color
To change the color of the waveform (default is black) do this:
```
 myWaveformView.color = UIColor(r: 0.6, g: 0.3, b: 0.1, a: 0.9)
```

Or, to change the color to the average color of a UIImage, use this:

```
 myWaveformView.color = myImage.averageColor()
```

Finally, you can have a little fun and use this:
(WARNING: May induce seizures)
```
 myWaveformView.randomColor = true
```
