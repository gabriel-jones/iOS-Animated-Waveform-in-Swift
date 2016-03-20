//
//  WaveformView.swift
//
//  Created by Gabriel Jones on 9/22/15.
//  Copyright (c) 2015 Gabriel Jones. All rights reserved.
//

import UIKit
import AVFoundation

extension UIColor {
    
    /**
     Get the RGB of a UIColor as a custom class
     
     - returns: Dictionary with keys `r`, `g`, `b`, `a` according to UIColor it originated from
     */
    func rgb() -> [String:CGFloat] {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = CGFloat(fRed * 255.0)
            let iGreen = CGFloat(fGreen * 255.0)
            let iBlue = CGFloat(fBlue * 255.0)
            let iAlpha = CGFloat(fAlpha)
            let rgb = ["r": iRed, "g": iGreen, "b": iBlue, "a": iAlpha]
            return rgb
        } else {
            return ["r": 0, "g": 0, "b": 0, "a": 0]
        }
    }
    
}

extension UIImage {
    
    /**
     Get the average color in a UIImage
     
     - returns: A UIColor that is the average color in the image
     */
    func averageColor() -> UIColor {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let info = CGImageAlphaInfo.PremultipliedLast.rawValue
        let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info)!
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
        
        if rgba[3] > 0 {
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
        } else {
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }

}

class WaveformView : UIView {
    
    var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    var structure = [Int]()
    var power = Float()
    var _audioPlayer = AVAudioPlayer()
    var randomColor = false

    func start(inout audioPlayer: AVAudioPlayer) {
        structure += [1,2,2,2,1]
        structure += [2,3,4,4,4,3,2,1]
        structure += [2,3,4,5,6,7,8,8,8,8,8,7,6,5,4,3,2,1]
        structure += [2,3,4,4,4,3,2,1]
        structure += [2,3,4,5,6,7,8,9,10,11,12,12,12,12,12,12,12,11,10,9,8,7,6,5,4,3,2,1]
        structure += [2,3,4,4,4,3,2,1]
        structure += [2,3,4,5,6,7,8,8,8,8,8,7,6,5,4,3,2,1]
        structure += [2,3,4,4,4,3,2,1]
        structure += [2,2,2]

        let dpLink = CADisplayLink(target: self, selector: Selector("update"))
        dpLink.frameInterval = 2
        audioPlayer.meteringEnabled = true
        dpLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        _audioPlayer = audioPlayer
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        
        var i = CGFloat(0.0)
        for line in structure {
            let _power = power * Float(line)
            CGContextMoveToPoint(context, CGFloat(1+i), CGFloat(0))
            let rand = Float(arc4random_uniform(3))
            let _rand = Float(arc4random_uniform(3)) - 3
            let decision = Float(arc4random_uniform(1))
            let final: Float = (decision == 0) ? (rand) : (_rand)
            CGContextAddLineToPoint(context, CGFloat(1+i), CGFloat(final + (_power * 0.35)))
            i += self.frame.width / CGFloat(structure.count)
        }
        
        var r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        var g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        var b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        var a = CGFloat(1.0)

        if !randomColor {
            r = self.color.rgb()["r"]!/255
            g = self.color.rgb()["g"]!/255
            b = self.color.rgb()["b"]!/255
            a = self.color.rgb()["a"]!
        }
        
        CGContextSetRGBStrokeColor(context, r, g, b, a)
        CGContextSetLineWidth(context, 1)
        CGContextStrokePath(context)
    }
    
    func update() {
        //Get new meter values
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
