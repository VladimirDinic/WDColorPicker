//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate
{
    func colorSelected(colorPicker:ColorPickerView, selectedColor:UIColor)
    func colorSelected(colorPicker:ColorPickerView, relativePosition:CGPoint)
}

class ColorPickerView: UIView {

    var colorDelegate : ColorPickerViewDelegate?
    
    var colorPickTapGesture:UITapGestureRecognizer?
    var colorPickPanGesture:UIPanGestureRecognizer?
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.drawColors()
        if colorPickTapGesture == nil
        {
            colorPickTapGesture = UITapGestureRecognizer(target: self, action: #selector(pickColor(gesture:)))
            self.addGestureRecognizer(colorPickTapGesture!)
        }
        if colorPickPanGesture == nil
        {
            colorPickPanGesture = UIPanGestureRecognizer(target: self, action: #selector(pickColor(gesture:)))
            self.addGestureRecognizer(colorPickPanGesture!)
        }
    }
    
    func drawColors()
    {
        
    }
 
    
    func pickColor(gesture:UIGestureRecognizer)
    {
        
    }
}

extension UIColor {
    
    func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red:fRed, green:fGreen, blue:fBlue, alpha:fAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    var hsba:(h: CGFloat, s: CGFloat,b: CGFloat,a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}
