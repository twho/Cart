//
//  PhoneViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/25/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class PhoneViewController: UIViewController {

    @IBOutlet weak var edPhone: UITextField!
    @IBOutlet weak var btnVerify: BorderedButton!
    
    let imgVerify = UIImage(named: "ic_finish_click")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnVerify.setImage(imgVerify, for: .highlighted)
        btnVerify.isEnabled = false
        self.edPhone.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneTextWatcher(_ sender: UITextField) {
        phoneTextEditor(textField: sender)
    }
    
    private func phoneTextEditor(textField: UITextField) {
        let phoneStr = textField.text! as String
        let numStr = phoneStr.components(separatedBy:
            NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        switch numStr.characters.count {
        case 0:
            textField.text = ""
        case 1:
            let index = numStr.index(numStr.startIndex, offsetBy: 1)
            textField.text = "(" + numStr.substring(to: index)
        case 4:
            let index = numStr.index(numStr.startIndex, offsetBy: 3)
            let indexBack = numStr.index(numStr.endIndex, offsetBy: -1)
            textField.text = "(" + numStr.substring(to: index) + ") " + numStr.substring(from: indexBack)
        case 7:
            let index = numStr.index(numStr.startIndex, offsetBy: 3)
            let indexBack = numStr.index(numStr.endIndex, offsetBy: -1)
            textField.text = "(" + numStr.substring(to: index) + ") " + numStr.substring(with: index..<indexBack) + "-" + numStr.substring(from: indexBack)
        case 10:
            btnVerify.isEnabled = true
        default:
            break
        }
    }
}
