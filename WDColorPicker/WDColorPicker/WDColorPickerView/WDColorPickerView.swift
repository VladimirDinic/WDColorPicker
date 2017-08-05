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
    open var delegate:WDColorPickerViewDelegate?
    open var currentColor : UIColor = UIColor.white {
        didSet
        {
            self.currentColorView.backgroundColor = currentColor
            self.basicColorPicker.setPosition(forColor: currentColor)
            self.shadowColorPicker.setPosition(forColor: currentColor)
        }
    }
    @IBOutlet weak private var currentColorView: UIView!
    @IBOutlet weak private var basicColorPicker: BasicColorPickerView!
    @IBOutlet weak private var shadowColorPicker: ShadowColorPickerView!
    
    
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
    
    class func showPicker(delegate:Any? = nil, initialColor:UIColor? = nil)
    {
        self.showOverlay()
        
        let colorPicker = self.getColorPicker(withSelectButton: true)
        colorPicker.currentColor = initialColor!
        colorPicker.frame = CGRect(x: ((WDColorPickerView.topView?.frame.width)! - 200.0) * 0.5, y: ((WDColorPickerView.topView?.frame.height)! - 200.0) * 0.5, width: 200.0, height: 200.0)
        colorPicker.delegate = delegate as? WDColorPickerViewDelegate
        colorPicker.colorSelected(colorPicker: colorPicker.basicColorPicker, relativePosition: colorPicker.basicColorPicker.colorPosition!)
        colorPicker.colorSelected(colorPicker: colorPicker.shadowColorPicker, relativePosition: colorPicker.shadowColorPicker.colorPosition!)
        colorPicker.alpha = 0.0
        
        WDColorPickerView.topView?.addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: WDColorPickerView.topView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200.0)
        let heightConstraint2 = NSLayoutConstraint(item: colorPicker, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200.0)
        
        WDColorPickerView.topView?.addConstraints([horizontalConstraint2, verticalConstraint2, widthConstraint2, heightConstraint2])
        
        self.animateShowPicker(colorPicker: colorPicker)
    }
    
    class func animateShowPicker(colorPicker:WDColorPickerView)
    {
        UIView.animate(withDuration: 0.3, animations: {
            colorPicker.alpha = 1.0
            overlay?.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func selectColorPressed(_ sender: Any)
    {
        self.hidePicker()
        if let colorDelegate = delegate
        {
            colorDelegate.colorSelected?(colorPicker: self, color: shadowColorPicker.currentColor)
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
     override open func draw(_ rect: CGRect) {
     // Drawing code
        if basicColorPicker != nil && shadowColorPicker != nil
        {
            basicColorPicker.colorDelegate = self
            shadowColorPicker.colorDelegate = self
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
 
    func colorSelected(colorPicker: ColorPickerView, relativePosition: CGPoint)
    {
        if colorPicker == basicColorPicker
        {
            self.basicColorSliderVerticalPosition.constant = min(max(0, relativePosition.y), basicColorPicker.frame.height-2.0)
            self.layoutIfNeeded()
        }
        else if colorPicker == shadowColorPicker
        {
            self.shadowColorSliderHorizontalPosition.constant = min(max(-2.0, relativePosition.x), shadowColorPicker.frame.width-4.0)
            self.shadowColorSliderVerticalPosition.constant = min(max(-2.0, relativePosition.y), shadowColorPicker.frame.height-4.0)
            self.layoutIfNeeded()
        }
    }
    
    func colorSelected(colorPicker: ColorPickerView, selectedColor: UIColor)
    {
        if colorPicker == basicColorPicker
        {
            currentColor = selectedColor
            self.shadowColorPicker.reload(newColor: currentColor)
        }
        else if colorPicker == shadowColorPicker
        {
            currentColor = selectedColor
            self.currentColorView.backgroundColor = selectedColor
        }
        self.currentColorView.backgroundColor = self.shadowColorPicker.currentColor
        if let colorDelegate = delegate
        {
            colorDelegate.colorChanged?(colorPicker: self, color: self.shadowColorPicker.currentColor)
        }
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
