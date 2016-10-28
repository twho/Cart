//
//  ContactViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

//https://github.com/Marxon13/M13Checkbox

import UIKit
import M13Checkbox

class ContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnNext: BorderedButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    @IBOutlet weak var edFirstName: UITextField!
    @IBOutlet weak var edLastName: UITextField!
    @IBOutlet weak var checkbox: M13Checkbox!
    @IBOutlet weak var edBdYear: UITextField!
    @IBOutlet weak var edBdMonth: UITextField!
    @IBOutlet weak var edBdDay: UITextField!
    @IBOutlet weak var tvAgeMsg: UILabel!
    @IBOutlet weak var tvTitle: UILabel!
    
    //load image
    let imgNext = UIImage(named: "ic_next_click")! as UIImage
    let imgPrev = UIImage(named: "ic_prev_click")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.setImage(imgNext, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .highlighted)
        self.edFirstName.delegate = self
        self.edLastName.delegate = self
        self.edBdYear.delegate = self
        self.edBdMonth.delegate = self
        self.edBdDay.delegate = self
        btnNext.isEnabled = false
        self.edFirstName.becomeFirstResponder()
//        self.checkbox.stateChangeAnimation = M13Checkbox.Animation.fill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yearTextWatcher(_ sender: UITextField) {
        let bdYearStr = sender.text! as String
        let bdYear = Int(sender.text!)
        if bdYearStr.characters.count == 4 {
            if bdYear! < 1997 {
                tvAgeMsg.textColor = btnNext.tintColor
                tvAgeMsg.text = "Yes, I am 18 yrs old or older."
                checkbox.tintColor = btnNext.tintColor
                checkbox.setCheckState(M13Checkbox.CheckState.checked, animated: true)
                 edBdMonth.becomeFirstResponder()
            } else {
                tvAgeMsg.textColor = UIColor.red
                checkbox.tintColor = UIColor.red
                checkbox.setCheckState(M13Checkbox.CheckState.mixed, animated: true)
            }
        } else {
            tvAgeMsg.textColor = tvTitle.textColor
            tvAgeMsg.text = "You must be at least 18 yrs old to ride."
            checkbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
        }
    }
    
    @IBAction func monthTextWatcher(_ sender: UITextField) {
        let bdMonthStr = sender.text! as String
        let bdMonth = Int(sender.text!)
        if bdMonthStr.characters.count == 2 {
            if bdMonth! > 0 && bdMonth! < 13 {
                self.edBdDay.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func dayTextWatcher(_ sender: UITextField) {
        let bdMonthStr = sender.text! as String
        let bdMonth = Int(sender.text!)
        if bdMonthStr.characters.count == 2 {
            if bdMonth! > 0 && bdMonth! < 32 {
                btnNext.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.edFirstName {
            self.edLastName.becomeFirstResponder()
        } else if textField == self.edLastName{
            self.edBdYear.becomeFirstResponder()
        } else if textField == self.edBdYear{
            self.edBdMonth.becomeFirstResponder()
        } else if textField == self.edBdMonth{
            self.edBdDay.becomeFirstResponder()
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
}
