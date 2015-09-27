//
//  Waveform_view.swift
//  waveform_animated
//
//  Created by Gabriel Jones on 9/22/15.
//  Copyright (c) 2015 Gabriel Jones. All rights reserved.
//

import UIKit
import AVFoundation

class WaveformView : UIView {
    var color = ["r": CGFloat(0.0), "g": CGFloat(0.0), "b": CGFloat(0.0)]
    var test = [Int]()
    var power = Float()
    var _audioPlayer = AVAudioPlayer()

    func start(inout audioPlayer: AVAudioPlayer) {
        test += [1,2,2,2,1]
        test += [2,3,4,4,4,3,2,1]
        test += [2,3,4,5,6,7,8,8,8,8,8,7,6,5,4,3,2,1]
        test += [2,3,4,4,4,3,2,1]
        test += [2,3,4,5,6,7,8,9,10,11,12,12,12,12,12,12,12,11,10,9,8,7,6,5,4,3,2,1]
        test += [2,3,4,4,4,3,2,1]
        test += [2,3,4,5,6,7,8,8,8,8,8,7,6,5,4,3,2,1]
        test += [2,3,4,4,4,3,2,1]
        test += [2,2,2,1]

        let dpLink = CADisplayLink(target: self, selector: Selector("update"))
        dpLink.frameInterval = 2
        audioPlayer.meteringEnabled = true
        dpLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        _audioPlayer = audioPlayer
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        var i = CGFloat(0.0)
        for line in test {
            var _power = power * Float(line)
            CGContextMoveToPoint(context, i, CGFloat(0))
            let rand = Float(arc4random_uniform(3))
            let _rand = Float(arc4random_uniform(3)) - 3
            let decision = Float(arc4random_uniform(1))
            let final: Float = (decision == 0) ? (rand) : (_rand)
            CGContextAddLineToPoint(context, i, CGFloat(final + (_power * 0.35)))
            i += self.frame.width / CGFloat(test.count)
        }
        CGContextSetRGBStrokeColor(context, color["r"]!, color["g"]!, color["b"]!, 1)
        CGContextSetLineWidth(context, 1)
        CGContextStrokePath(context)
    }
    
    func update() {
        _audioPlayer.updateMeters()
        var _power = Float()
        var __power = [Float]()
        for var i = 0; i < _audioPlayer.numberOfChannels; i++ {
             __power.append(_audioPlayer.averagePowerForChannel(i))
        }
        _power = __power.reduce(0.0) {
            return $0 + $1/Float(__power.count)
        }
        power = Float(pow(10, (0.05 * _power)) * 10)
        self.setNeedsDisplay()
    }
    
}
