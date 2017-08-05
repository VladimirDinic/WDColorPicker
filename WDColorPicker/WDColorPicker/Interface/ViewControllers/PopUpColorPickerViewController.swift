//
//  ViewController.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/4/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

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

