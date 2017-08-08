//
//  WDColorPickerView.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

@objc public protocol WDColorPickerViewDelegate
{
    @objc optional func colorChanged(colorPicker:WDColorPickerView, color:UIColor)
    @objc optional func colorSelected(colorPicker:WDColorPickerView, color:UIColor)
}

open class WDColorPickerView: UIView, ColorPickerViewDelegate {

    var pickerInitialColor : UIColor = .black
    
    private static var overlay : UIView?
    private static var topView : UIView? {
        get {
            if var topVC = UIApplication.shared.keyWindow?.rootViewController
            {
                while let presentedVC = topVC.presentedViewController
                {
                    topVC = presentedVC
                }
                return topVC.view
            }
            return nil
        }
    }
    
    @IBOutlet weak private var shadowColorSliderHorizontalPosition: NSLayoutConstraint!
    @IBOutlet weak private var shadowColorSliderVerticalPosition: NSLayoutConstraint!
    @IBOutlet weak private var basicColorSliderVerticalPosition: NSLayoutConstraint!
    public var delegate:WDColorPickerViewDelegate?
    public var currentColor : UIColor {
        get {
            return UIColor(hue: shadowColorPicker.hue, saturation: shadowColorPicker.saturation, brightness: CGFloat(basicColorPicker.brightness), alpha: 1.0)
        }
        set
        {
            self.basicColorPicker.initialize(color: newValue)
            self.shadowColorPicker.initialize(color: newValue)
            self.currentColorView.backgroundColor = newValue
        }
    }
    @IBOutlet weak private var currentColorView: UIView!
    @IBOutlet weak private var basicColorPicker: BrightnessColorPickerView!
    @IBOutlet weak private var shadowColorPicker: HueSaturationColorPickerView!
    
    
    class func showOverlay()
    {
        overlay = UIView(frame: (WDColorPickerView.topView!.frame))
        overlay?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        overlay?.alpha = 0.0
        WDColorPickerView.topView?.addSubview(overlay!)
        overlay?.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: overlay!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: overlay!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: overlay!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: overlay!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        
        WDColorPickerView.topView?.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    public class func showPicker(delegate:Any? = nil, initialColor:UIColor? = nil)
    {
        self.showOverlay()
        
        let colorPicker = self.getColorPicker(withSelectButton: true)
        colorPicker.currentColor = initialColor!
        let minDim = min(UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        colorPicker.frame = CGRect(x: minDim * 0.15, y: minDim * 0.15, width: minDim * 0.7, height: minDim * 0.7)
        colorPicker.delegate = delegate as? WDColorPickerViewDelegate
        colorPicker.alpha = 0.0
        
        WDColorPickerView.topView?.addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: minDim * 0.7)
        let heightConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: minDim * 0.7)
        
        WDColorPickerView.topView?.addConstraints([horizontalConstraint2, verticalConstraint2, widthConstraint2, heightConstraint2])
        
        self.animateShowPicker(colorPicker: colorPicker)
    }
    
    class func animateShowPicker(colorPicker:WDColorPickerView)
    {
        UIView.animate(withDuration: 0.3, animations: { 
            colorPicker.alpha = 1.0
            overlay?.alpha = 1.0
        }) { (finished) in
            colorPicker.perform(#selector(setInitialCursorPositions), with: nil, afterDelay: 0.001)
        }
    }
    
    @IBAction func selectColorPressed(_ sender: Any)
    {
        self.hidePicker()
        if let colorDelegate = delegate
        {
            colorDelegate.colorSelected?(colorPicker: self, color: currentColor)
        }
    }
    
    @IBAction func closeColorPicker(_ sender: Any)
    {
        self.hidePicker()
    }
    
    func hidePicker()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            WDColorPickerView.overlay?.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
            WDColorPickerView.overlay?.removeFromSuperview()
        }
    }
    
    
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     open override func draw(_ rect: CGRect) {
     // Drawing code
        if basicColorPicker != nil && shadowColorPicker != nil
        {
            basicColorPicker.colorDelegate = self
            shadowColorPicker.colorDelegate = self
            basicColorPicker.initialize(color: pickerInitialColor)
            shadowColorPicker.initialize(color: pickerInitialColor)
            if currentColorView != nil
            {
                self.currentColorView.backgroundColor = UIColor(hue: shadowColorPicker.hue, saturation: shadowColorPicker.saturation, brightness: CGFloat(basicColorPicker.brightness), alpha: 1.0)
            }
            self.perform(#selector(setInitialCursorPositions), with: nil, afterDelay: 0.001)
        }
        else
        {
            let viewFromNib = WDColorPickerView.getColorPicker(withSelectButton: false)
            viewFromNib.frame = rect
            viewFromNib.frame.origin = .zero
            self.addSubview(viewFromNib)
            viewFromNib.delegate = self.delegate
        }
     }
    
    func colorSelected(colorPicker: ColorPickerView, hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        currentColor = UIColor(hue: shadowColorPicker.hue, saturation: shadowColorPicker.saturation, brightness: basicColorPicker.brightness, alpha: 1.0)
        if colorPicker == basicColorPicker
        {
            self.shadowColorPicker.reload(brightness: brightness)
            self.currentColorView.backgroundColor = currentColor
        }
        else if colorPicker == shadowColorPicker
        {
            self.basicColorPicker.reload(hue: hue, saturation: saturation)
            self.currentColorView.backgroundColor = currentColor
        }
        if let colorDelegate = delegate
        {
            colorDelegate.colorChanged?(colorPicker: self, color: currentColor)
        }
        self.setCursorPositions()
    }
    
    func setCursorPositions()
    {
        if basicColorPicker.pickPosition != nil
        {
            self.basicColorSliderVerticalPosition.constant = min(max(0, (basicColorPicker.pickPosition?.y)! - 1.0), basicColorPicker.frame.height-2.0)
        }
        else
        {
            self.basicColorSliderVerticalPosition.constant = min(max(0, (1.0 - currentColor.hsba.b) * basicColorPicker.frame.height - 1.0), basicColorPicker.frame.height-2.0)
        }
        if shadowColorPicker.pickPosition != nil
        {
            self.shadowColorSliderHorizontalPosition.constant = min(max(-2.0, (shadowColorPicker.pickPosition?.x)! - 2.0), shadowColorPicker.frame.width-4.0)
            self.shadowColorSliderVerticalPosition.constant = min(max(-2.0, (shadowColorPicker.pickPosition?.y)! - 2.0), shadowColorPicker.frame.height-4.0)
        }
        else
        {
            self.shadowColorSliderHorizontalPosition.constant = min(max(-2.0, currentColor.hsba.h * shadowColorPicker.frame.width - 2.0), shadowColorPicker.frame.width-4.0)
            self.shadowColorSliderVerticalPosition.constant = min(max(-2.0, (1.0 - currentColor.hsba.s) * shadowColorPicker.frame.height - 2.0), shadowColorPicker.frame.height-4.0)
        }
        self.layoutIfNeeded()
    }
    
    func setInitialCursorPositions()
    {
        self.basicColorSliderVerticalPosition.constant = min(max(0, (1.0 - currentColor.hsba.b) * basicColorPicker.frame.height - 1.0), basicColorPicker.frame.height-2.0)
        self.shadowColorSliderHorizontalPosition.constant = min(max(-2.0, currentColor.hsba.h * shadowColorPicker.frame.width - 2.0), shadowColorPicker.frame.width-4.0)
        self.shadowColorSliderVerticalPosition.constant = min(max(-2.0, (1.0 - currentColor.hsba.s) * shadowColorPicker.frame.height - 2.0), shadowColorPicker.frame.height-4.0)
        self.layoutIfNeeded()
    }
    
    class func getColorPicker(withSelectButton:Bool) -> WDColorPickerView
    {
        let colorPickerView = self.instantiateFromXib(nibIndex: withSelectButton ? 0 : 1)
        return colorPickerView 
    }
}

protocol XibDesignable : class {}

extension XibDesignable where Self : UIView {
    
    static func instantiateFromXib(nibIndex:Int) -> Self {
        
        let dynamicMetatype = Self.self
        let bundle = Bundle(for: dynamicMetatype)
        let nib = UINib(nibName: "\(dynamicMetatype)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil)[nibIndex] as? Self else {
            
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}

extension UIView : XibDesignable {}
