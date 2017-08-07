//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

class BasicColorPickerView: ColorPickerView {
    
    var basicColor : UIColor = .red {
        didSet {
            pickPosition = CGPoint(x: 0.0, y: (1.0 - basicColor.hsba.b) * self.frame.height)
        }
    }
    
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
        pickPosition = gesture.location(in: self)
        let pickedColor = self.getColor(relativeHeight: pickPosition.y)
        if let delegate = self.colorDelegate
        {
            delegate.colorSelected(colorPicker: self, selectedColor: pickedColor)
        }
    }
    
    func reload(newColor:UIColor)
    {
        basicColor = newColor
        self.setNeedsDisplay()
    }
 
    func getColor(relativeHeight:CGFloat) -> UIColor
    {
        let brightness = 1.0 - relativeHeight / self.frame.height
        return UIColor(hue: basicColor.hsba.h, saturation: basicColor.hsba.s, brightness: brightness, alpha: 1.0)
    }
}
