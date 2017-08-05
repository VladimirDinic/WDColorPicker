//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class BasicColorPickerView: ColorPickerView {
    
    var colorPosition : CGPoint?
    
    override func drawColors()
    {
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.clear(self.frame)
        context?.saveGState()
        for relativeHeight in 0...Int(self.frame.height)
        {
            let color = getColor(relativeHeight: CGFloat(relativeHeight))
            context?.setFillColor(color.cgColor)
            let subrect = CGRect(x: 0.0, y: self.frame.height * CGFloat(relativeHeight) / (self.frame.height+1.0), width: self.frame.width, height: 2.0)
            context?.fill(subrect)
        }
        context?.restoreGState()
    }
    
    override func pickColor(gesture: UIGestureRecognizer)
    {
        colorPosition = gesture.location(in: self)
        let pickedColor = self.getColor(relativeHeight: (colorPosition?.y)!)
        if let delegate = self.colorDelegate
        {
            delegate.colorSelected(colorPicker: self, selectedColor: pickedColor)
            delegate.colorSelected(colorPicker: self, relativePosition: colorPosition!)
        }
    }
    
    func setPosition(forColor color:UIColor)
    {
        if colorPosition == nil
        {
            colorPosition = CGPoint(x: 0.0, y: color.hsba.h * self.frame.height)
        }
        
    }
 
    func getColor(relativeHeight:CGFloat) -> UIColor
    {
        let hue = relativeHeight / self.frame.height
        return UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}
