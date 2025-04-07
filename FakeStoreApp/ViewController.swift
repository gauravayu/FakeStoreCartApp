//
//  ViewController.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

import UIKit
@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    // Optional: Make the button perfectly circular if width == height
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius == -1 { // special case: -1 = circle
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
