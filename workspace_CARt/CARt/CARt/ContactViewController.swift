//
//  ContactViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnNext: BorderedButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    @IBOutlet weak var edFirstName: UITextField!
    @IBOutlet weak var edLastName: UITextField!
    @IBOutlet weak var edPhone: UITextField!
    
    //load image
    let imgNext = UIImage(named: "ic_next_click")! as UIImage
    let imgPrev = UIImage(named: "ic_prev_click")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.setImage(imgNext, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .highlighted)
        self.edFirstName.delegate = self
        self.edLastName.delegate = self
        edFirstName.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneTextWatcher(_ sender: UITextField) {
        phoneTextEditor(textField: sender)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.edFirstName {
            self.edLastName.becomeFirstResponder()
        } else if textField == self.edLastName{
            self.edPhone.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }
        return true
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
    }
}
