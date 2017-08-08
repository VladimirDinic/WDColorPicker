//
//  ShadowColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class ShadowColorPickerView: ColorPickerView {

    var currentColor:UIColor = .red
    
    override func drawColors()
    {
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        context?.saveGState()
        for relativeWidth in 0...Int(self.frame.width)
        {
            for relativeHeight in 0...Int(self.frame.height)
            {
                let color = getColor(relativeWidth: CGFloat(relativeWidth), relativeHeight: CGFloat(relativeHeight))
                context?.setFillColor(color.cgColor)
                let subrect = CGRect(x: self.frame.width * CGFloat(relativeWidth) / (self.frame.width+1.0), y: self.frame.height * CGFloat(relativeHeight) / (self.frame.height+1.0), width: 2.0, height: 2.0)
                context?.fill(subrect)
            }
        }
        context?.restoreGState()
    }
    
    func reload(newColor:UIColor)
    {
        currentColor = newColor
    }
    
    override func pickColor(gesture: UIGestureRecognizer)
    {
        pickPosition = gesture.location(in: self)
        let pickedColor = self.getColor(relativeWidth: min(self.frame.width,max(0.0,(pickPosition?.x)!)), relativeHeight: min(self.frame.height,max(0.0,(pickPosition?.y)!)))
        currentColor = UIColor(hue: pickedColor.hsba.h, saturation: pickedColor.hsba.s, brightness: currentColor.hsba.b, alpha: 1.0)
        if let delegate = self.colorDelegate
        {
            delegate.colorSelected(colorPicker: self, selectedColor: currentColor)
        }
    }
 
    func getColor(relativeWidth:CGFloat, relativeHeight:CGFloat) -> UIColor
    {
        let hue =  relativeWidth/self.frame.width
        let saturation = 1.0 - relativeHeight/self.frame.height
        return UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
    }
}
