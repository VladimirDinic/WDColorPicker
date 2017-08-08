//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class BrightnessColorPickerView: ColorPickerView {
    
    override func drawColors()
    {
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        context?.saveGState()
        for relativeHeight in 0...Int(self.frame.height)
        {
            let color = getColor(relativeHeight: CGFloat(relativeHeight), final: false)
            context?.setFillColor(color.cgColor)
            let subrect = CGRect(x: 0.0, y: self.frame.height * CGFloat(relativeHeight) / (self.frame.height+1.0), width: self.frame.width, height: 2.0)
            context?.fill(subrect)
        }
        context?.restoreGState()
    }
    
    override func pickColor(gesture: UIGestureRecognizer)
    {
        pickPosition = gesture.location(in: self)
        brightness = 1.0 - (pickPosition?.y)! / self.frame.height
        _ = self.getColor(relativeHeight: (pickPosition?.y)!, final: true)
        if let delegate = self.colorDelegate
        {
            delegate.colorSelected(colorPicker: self, hue: hue, saturation: saturation, brightness: brightness)
        }
    }
    
    func initialize(color:UIColor)
    {
        if !initialized
        {
            hue = color.hsba.h
            saturation = color.hsba.s
            brightness = color.hsba.b
            self.setNeedsDisplay()
        }
        initialized = true
    }
    
    func reload(hue:CGFloat, saturation:CGFloat)
    {
        self.hue = hue
        self.saturation = saturation
        self.setNeedsDisplay()
    }
 
    func getColor(relativeHeight:CGFloat, final:Bool) -> UIColor
    {
        if final
        {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
        else
        {
            let tempBrightness = 1.0 - relativeHeight / self.frame.height
            return UIColor(hue: hue, saturation: saturation, brightness: tempBrightness, alpha: 1.0)
        }
    }
}
