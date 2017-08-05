//
//  InterfaceColorPickerViewController.swift
//  ColorPicker
//
//  Created by Vladimir Dinic on 8/5/17.
//  Copyright © 2017 Vladimir Dinic. All rights reserved.
//

import UIKit

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
