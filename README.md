# WDColorPicker
WDColorPicker is a simple lightweight component for displaying color picker inside iOS apps.

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WDColorPicker.svg)](http://cocoapods.org/pods/WDColorPicker)
[![License](https://img.shields.io/cocoapods/l/WDColorPicker.svg?style=flat)](http://cocoapods.org/pods/WDColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/WDColorPicker.svg?style=flat)](http://cocoapods.org/pods/WDColorPicker)

# Installation:

## Manual
Download example project and add WDColorPickerView folder inside your project

## CocoaPods:
```Ruby
target '<TargetName>' do
    use_frameworks!
    pod 'WDColorPicker', ' ~> 1.0.1'
end
```

# Usage

## Add color picker as interface component
![GitHub Logo](/Images/PickerInInterface.png)
1. Add UIView in storyboard / xib file and subclass it with WDColorPickerView class from WDColorPicker module
2. Implement WDColorPickerViewDelegate method func colorChanged(colorPicker: WDColorPickerView, color: UIColor) to handle color changes:

```Swift
//Example of usage
import UIKit
import WDColorPicker    //If you are using CocoaPods

class InterfaceColorPickerViewController: UIViewController, WDColorPickerViewDelegate
{
    @IBOutlet weak var colorPicker: WDColorPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.colorPicker.delegate = self
    }
    
    func colorChanged(colorPicker: WDColorPickerView, color: UIColor) {
        self.view.backgroundColor = color
    }
}
```

## Show color picker as pop up
![GitHub Logo](/Images/PickerAsPopup.png)
1. Implement WDColorPickerViewDelegate method func colorSelected(colorPicker: WDColorPickerView, color: UIColor) to handle color selection:

```Swift
//Example of usage
import UIKit
import WDColorPicker    //If you are using CocoaPods

class PopUpColorPickerViewController: UIViewController, WDColorPickerViewDelegate
{
    
    @IBOutlet weak var colorButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func shwColorPicker(_ sender: Any) {
        WDColorPickerView.showPicker(delegate: self, initialColor: self.colorButton.backgroundColor)
    }
    
    func colorSelected(colorPicker: WDColorPickerView, color: UIColor) {
        self.colorButton.backgroundColor = color
    }
}
```


# Note:
Documentation is still in preparation and the code will be updated regularly
<br>If you find any bug, please report it, and I will try to fix it ASAP.
