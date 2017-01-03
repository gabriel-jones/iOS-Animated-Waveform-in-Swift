//
//  WaveformView.swift
//
//  Created by Gabriel Jones on 9/22/15.
//  Updated to Swift 3: 3/1/17
//  Copyright (c) 2015 Gabriel Jones. All rights reserved.
//

import UIKit
import AVFoundation

extension UIColor {
    
    /**
     Get the RGB of a UIColor
     
     - returns: `Color` class contains variables `r`, `g`, `b`, `a` according to UIColor it originated from
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
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGImageAlphaInfo.premultipliedLast.rawValue
        let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info)!
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
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

    func start(_ audioPlayer: inout AVAudioPlayer) {
        var i = 1
        var up = true
        var max = 2
        var _i = 0
        let nextmax = [2,4,2,4,8,12,8,2,4,2]
        while true {
            if _i == nextmax.count-1 { structure+=[3,2,1,2,2,2,2,2,1];break; }
            if max == i && up == true {
                _i += 1
                structure += [max, max, max, max]
                max = nextmax[_i]
                up = false
            }
            if i == 1 { up = true }
            structure.append(i)
            i += up ? 1 : -1
        }

        let dpLink = CADisplayLink(target: self, selector: #selector(WaveformView.update))
        dpLink.frameInterval = 2
        audioPlayer.isMeteringEnabled = true
        dpLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        _audioPlayer = audioPlayer
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        
        var i = CGFloat(0.0)
        for line in structure {
            let _power = power * Float(line)
            context?.move(to: CGPoint(x: CGFloat(1+i), y: CGFloat(0)))
            let rand = Float(arc4random_uniform(2))
            let _rand = Float(arc4random_uniform(2)) - 2
            let decision = Float(arc4random_uniform(1))
            let final: Float = (decision == 0) ? (rand) : (_rand)
            context?.addLine(to: CGPoint(x: CGFloat(1+i), y: CGFloat(final + (_power * 0.35))))
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
        
        context?.setStrokeColor(red: r, green: g, blue: b, alpha: a)
        context?.setLineWidth(1)
        context?.strokePath()
    }

    func update() {
        //Get new meter values
        _audioPlayer.updateMeters()
        
        
        var _power = Float()
        var __power = [Float]()
        
        for i in 0 ..< _audioPlayer.numberOfChannels {
             __power.append(_audioPlayer.averagePower(forChannel: i))
        }
        _power = __power.reduce(0.0) {
            return $0 + $1/Float(__power.count)
        }
        
        power = Float(pow(10, (0.05 * _power)) * 10)
        self.setNeedsDisplay()
    }
    
}
