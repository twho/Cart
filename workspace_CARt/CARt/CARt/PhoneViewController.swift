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
    
    let defaults = UserDefaults.standard
    let imgVerifyClicked = UIImage(named: "ic_next_click")! as UIImage

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnVerify.setImage(imgVerifyClicked, for: .highlighted)
        btnVerify.setImage(imgVerifyClicked, for: .normal)
        btnVerify.isHidden = true
        self.edPhone.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        default:
            break
        }
        checkPhoneNumber(textField: edPhone)
    }
    
    func checkPhoneNumber(textField: UITextField){
        let phoneStr = textField.text! as String
        let numStr = phoneStr.components(separatedBy:
            NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        if(numStr.characters.count == 10){
            defaults.setValue(self.edPhone.text, forKey: "MyPhone")
            btnVerify.isHidden = false
        } else {
            btnVerify.isHidden = true
        }
    }
}
