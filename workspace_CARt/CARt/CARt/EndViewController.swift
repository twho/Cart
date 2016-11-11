//
//  EndViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/20/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EndViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var edEmail: UITextField!
    @IBOutlet weak var edComment: UITextField!
    @IBOutlet weak var btnCancel: BorderedButton!
    @IBOutlet weak var btnSend: BorderedButton!
    @IBOutlet weak var edStoreAddr: UITextField!
    @IBOutlet weak var edHomeAddr: UITextField!
    @IBOutlet weak var btnRefer: BorderedButton!
    @IBOutlet weak var btnSurvey: BorderedButton!
    @IBOutlet weak var ivStore: UIImageView!
    @IBOutlet weak var ivHome: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let imgCancelClicked = UIImage(named: "ic_cancel_click")
    let imgCancel = UIImage(named: "ic_cancel")
    let imgSendClicked = UIImage(named: "ic_finish_click")
    let imgSend = UIImage(named: "ic_send")
    let imgReferClicked = UIImage(named: "ic_refer_click")! as UIImage
    let imgRefer = (UIImage(named: "ic_refer_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgSurveyClicked = (UIImage(named: "ic_survey")?.maskWithColor(color: UIColor.white)!)! as UIImage
    let imgSurvey = (UIImage(named: "ic_survey")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let defaults = UserDefaults.standard
    
    struct addressKeys {
        static let myAddressKey = "myAddress"
        static let myAddressLat = "myAddressLat"
        static let myAddressLng = "myAddressLng"
        static let destAddressKey = "destAddressKey"
        static let destAddressLat = "destAddressLat"
        static let destAddressLng = "destAddressLng"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.setImage(imgCancelClicked, for: .highlighted)
        btnCancel.setImage(imgCancel, for: .normal)
        btnSend.setImage(imgSendClicked, for: .highlighted)
        btnSend.setImage(imgSend, for: .normal)
        btnSurvey.setImage(imgSurveyClicked, for: .highlighted)
        btnSurvey.setImage(imgSurvey, for: .normal)
        btnRefer.setImage(imgReferClicked, for: .highlighted)
        btnRefer.setImage(imgRefer, for: .normal)
        edStoreAddr.leftViewMode = UITextFieldViewMode.always
        edStoreAddr.leftView = ivStore
        edStoreAddr.text = defaults.string(forKey: addressKeys.destAddressKey)
        edHomeAddr.leftViewMode = UITextFieldViewMode.always
        edHomeAddr.leftView = ivHome
        edHomeAddr.text = defaults.string(forKey: addressKeys.myAddressKey)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollView.contentSize.height = 1450
        self.edEmail.delegate = self
        self.edComment.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to cancel the ride?", message: "By tapping yes, you will cancel the ride and return to home page.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            //            print("Destructive")
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "endToHomeIdentifier", sender: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height
            }
        }
    }
}
