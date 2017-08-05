# WDColorPicker
WDColorPicker is a simple lightweight component for displaying color picker inside iOS apps.

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WDColorPicker.svg)](http://cocoapods.org/pods/WDColorPicker)
[![License](https://img.shields.io/cocoapods/l/WDColorPicker.svg?style=flat)](http://cocoapods.org/pods/WDColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/WDColorPicker.svg?style=flat)](http://cocoapods.org/pods/WDColorPicker)

![GitHub Logo](/Images/PickerInInterface.png)

![GitHub Logo](/Images/PickerAsPopup.png)

# Installation:
## CocoaPods:
```Ruby
target '<TargetName>' do
    use_frameworks!
    pod 'WDColorPicker', ' ~> 0.0.6'
end
```

# Usage

## Add color picker as interface component
1. Add UIView in storyboard / xib file and subclass it with WDColorPickerView class from WDColorPicker module
2. Implement WDColorPickerViewDelegate method func colorChanged(colorPicker: WDColorPickerView, color: UIColor) to handle color changes:

```Swift
import UIKit
import WDColorPicker

class InterfaceColorPickerViewController: UIViewController, WDColorPickerViewDelegate
{
    @IBOutlet weak var colorPicker: WDColorPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.colorPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorChanged(colorPicker: WDColorPickerView, color: UIColor) {
        self.view.backgroundColor = color
    }
}
```

## Show color picker as pop up
1. Implement WDColorPickerViewDelegate method func colorSelected(colorPicker: WDColorPickerView, color: UIColor) to handle color selection:

```Swift
import UIKit
import WDColorPicker

class PopUpColorPickerViewController: UIViewController, WDColorPickerViewDelegate
{
    
    @IBOutlet weak var colorButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
