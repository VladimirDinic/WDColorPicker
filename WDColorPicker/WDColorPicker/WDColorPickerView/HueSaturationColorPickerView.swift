//
//  ShadowColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class HueSaturationColorPickerView: ColorPickerView {
    
    override func drawColors()
    {
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        context?.saveGState()
        for relativeWidth in 0...Int(self.frame.width)
        {
            for relativeHeight in 0...Int(self.frame.height)
            {
                let color = getColor(relativeWidth: CGFloat(relativeWidth), relativeHeight: CGFloat(relativeHeight), final: false)
                context?.setFillColor(color.cgColor)
                let subrect = CGRect(x: self.frame.width * CGFloat(relativeWidth) / (self.frame.width+1.0), y: self.frame.height * CGFloat(relativeHeight) / (self.frame.height+1.0), width: 2.0, height: 2.0)
                context?.fill(subrect)
            }
        }
        context?.restoreGState()
    }
    
    func initialize(color:UIColor)
    {
        if !initialized
        {
            hue = color.hsba.h
            saturation = color.hsba.s
        }
        initialized = true
    }
    
    func reload(brightness:CGFloat)
    {
        self.brightness = brightness
    }
    
    override func pickColor(gesture: UIGestureRecognizer)
    {
        pickPosition = gesture.location(in: self)
        hue = min(self.frame.width,max(0.0,(pickPosition?.x)!))/self.frame.width
        saturation = 1.0 - min(self.frame.height,max(0.0,(pickPosition?.y)!))/self.frame.height
        _ = self.getColor(relativeWidth: min(self.frame.width,max(0.0,(pickPosition?.x)!)), relativeHeight: min(self.frame.height,max(0.0,(pickPosition?.y)!)), final: true)
        if let delegate = self.colorDelegate
        {
            delegate.colorSelected(colorPicker: self, hue: hue, saturation: saturation, brightness: brightness)
        }
    }
 
    func getColor(relativeWidth:CGFloat, relativeHeight:CGFloat, final:Bool) -> UIColor
    {
        if final
        {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
        else
        {
            let tempHue = relativeWidth / self.frame.width
            let tempSaturation = (self.frame.height - relativeHeight) / self.frame.height
            return UIColor(hue: tempHue, saturation: tempSaturation, brightness: 1.0, alpha: 1.0)
        }
    }
}
