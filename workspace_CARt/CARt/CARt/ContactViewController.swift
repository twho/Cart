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
    @IBOutlet weak var edBirthday: UITextField!
    @IBOutlet weak var tvAgeMsg: UILabel!
    @IBOutlet weak var tvTitle: UILabel!
    
    var popDatePicker: PopDatePicker?
    
    //load image
    let imgNextClicked = UIImage(named: "ic_next_click")! as UIImage
    let imgPrevClicked = UIImage(named: "ic_prev_click")! as UIImage
    let imgNext = (UIImage(named: "ic_next_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgPrev = (UIImage(named: "ic_prev_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popDatePicker = PopDatePicker(forTextField: edBirthday)
        btnNext.setImage(imgNextClicked, for: .highlighted)
        btnNext.setImage(imgNext, for: .normal)
        btnPrev.setImage(imgPrevClicked, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .normal)
        self.edFirstName.delegate = self
        self.edLastName.delegate = self
        self.edBirthday.delegate = self
        self.edFirstName.becomeFirstResponder()
        tvAgeMsg.textColor = tvTitle.textColor
        tvAgeMsg.text = "You must be at least 18 yrs old to ride."
        checkbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnNextPressed(_ sender: BorderedButton) {
        self.performSegue(withIdentifier: "ContactToAddressIdentifier", sender: self)
    }
        
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.edBirthday) {
            edBirthday.resignFirstResponder()
            view.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let initDate : Date? = formatter.date(from: "Jan 09, 1980")
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : Date, forTextField : UITextField) -> () in
                // here we don't use self (no retain cycle)
                let date = Date()
                forTextField.text = formatter.string(from: newDate)
                let yearDiff = Calendar.current.dateComponents([.year], from: newDate, to: date as Date).year ?? 0
                if(yearDiff >= 18){
                    self.tvAgeMsg.textColor = self.btnNext.tintColor
                    self.tvAgeMsg.text = "Yes, I am 18 yrs old or older."
                    self.checkbox.tintColor = self.btnNext.tintColor
                    self.checkbox.setCheckState(M13Checkbox.CheckState.checked, animated: true)
                } else {
                    self.checkbox.tintColor = UIColor.red
                    self.checkbox.setCheckState(M13Checkbox.CheckState.mixed, animated: true)
                    self.tvAgeMsg.text = "You must be at least 18 yrs old to ride."
                    self.tvAgeMsg.textColor = UIColor.red
                    self.checkbox.tintColor = UIColor.red
                    self.checkbox.setCheckState(M13Checkbox.CheckState.mixed, animated: true)
                }
            }
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.edFirstName {
            self.edLastName.becomeFirstResponder()
        } else if textField == self.edLastName{
            self.edBirthday.becomeFirstResponder()
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
