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

# Customization
Attribute | Description | Usage
----------|-------------|--------
`color` | Chanes the color of the waveform | `waveform.color = UIColor(r: 0.6, g: 0.3, b: 0.1, a: 0.9)`<br>`waveform.color = myImage.averageColor()`
`randomColor` | Overrides `color` attribute to be a random color each frame <br> *Warning: Rapid color changes may induce seizures*| `waveform.randomColor = true`
`lineWidth` | Changes the width of the lines in the waveform | `waveform.lineWidth = 3.0`
