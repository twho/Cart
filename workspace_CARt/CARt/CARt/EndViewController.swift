//
//  EndViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/20/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var edEmail: UITextField!
    @IBOutlet weak var btnCancel: BorderedButton!
    @IBOutlet weak var btnSend: BorderedButton!
    @IBOutlet weak var edStoreAddr: UITextField!
    @IBOutlet weak var edHomeAddr: UITextField!
    @IBOutlet weak var btnRefer: BorderedButton!
    @IBOutlet weak var btnSurvey: BorderedButton!
    @IBOutlet weak var ivStore: UIImageView!
    @IBOutlet weak var ivHome: UIImageView!
    
    let imgCancelClicked = UIImage(named: "ic_cancel_click")
    let imgCancel = (UIImage(named: "ic_cancel_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgSendClicked = UIImage(named: "ic_finish_click")
    let imgSend = (UIImage(named: "ic_finish_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
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
        btnSend.setImage(imgSend, for: .highlighted)
        edStoreAddr.leftViewMode = UITextFieldViewMode.always
        edStoreAddr.leftView = ivStore
        edStoreAddr.text = defaults.string(forKey: addressKeys.destAddressKey)
        edHomeAddr.leftViewMode = UITextFieldViewMode.always
        edHomeAddr.leftView = ivHome
        edHomeAddr.text = defaults.string(forKey: addressKeys.myAddressKey)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()    }
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
