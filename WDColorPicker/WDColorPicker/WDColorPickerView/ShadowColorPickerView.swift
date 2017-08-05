//
//  ShadowColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class ShadowColorPickerView: ColorPickerView {

    var basicColor:UIColor?
    var currentColor:UIColor = .white
    var colorPosition : CGPoint? 
    
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
        basicColor = newColor
        currentColor = self.getColor(relativeWidth: min(self.frame.width,max(0,(colorPosition?.x)!)), relativeHeight: min(self.frame.width,max(0,(colorPosition?.y)!)))
        self.setNeedsDisplay()
    }
    
    func setPosition(forColor color:UIColor)
    {
        if basicColor == nil
        {
            basicColor = color
            currentColor = color
        }
        if colorPosition == nil
        {
            colorPosition = CGPoint(x: color.hsba.s * self.frame.width - 2.0, y: (1.0 - color.hsba.b) * self.frame.height - 2.0)
        }
        
    }
    
    override func pickColor(gesture: UIGestureRecognizer)
    {
        let colorPickPosition = gesture.location(in: self)
        colorPosition = colorPickPosition
        let pickedColor = self.getColor(relativeWidth: min(self.frame.width,max(0,colorPickPosition.x)), relativeHeight: min(self.frame.height,max(0,colorPickPosition.y)))
        currentColor = pickedColor
        if let delegate = self.colorDelegate
        {
            delegate.colorSelected(colorPicker: self, selectedColor: pickedColor)
            delegate.colorSelected(colorPicker: self, relativePosition: colorPickPosition)
        }
    }
 
    func getColor(relativeWidth:CGFloat, relativeHeight:CGFloat) -> UIColor
    {
        if basicColor == nil
        {
            basicColor = .red
        }
        let hue = basicColor!.hsba.h
        let brightness = (self.frame.height - relativeHeight)/self.frame.height
        let saturation = relativeWidth/self.frame.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
