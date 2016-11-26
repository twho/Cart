//
//  ConfirmViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tvBarcodeInstr: UILabel!
    @IBOutlet weak var tvRequestTitle: UILabel!
    @IBOutlet weak var tvRequestInfo: UILabel!
    @IBOutlet weak var tvRequestDetails: UILabel!
    @IBOutlet weak var tvWarning: UILabel!
    @IBOutlet weak var btnFinished: BorderedButton!
    @IBOutlet weak var progressSpinner: UIActivityIndicatorView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var ivBarcode: UIImageView!
    @IBOutlet weak var tvEnterInstruct: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var edHome: UITextField!
    @IBOutlet weak var edDestination: UITextField!
    @IBOutlet weak var ivHome: UIImageView!
    @IBOutlet weak var ivDestination: UIImageView!
    @IBOutlet weak var edCode1: UITextField!
    @IBOutlet weak var edCode2: UITextField!
    @IBOutlet weak var edCode3: UITextField!
    @IBOutlet weak var edCode4: UITextField!
    @IBOutlet weak var edCode5: UITextField!
    @IBOutlet weak var edCode6: UITextField!
    
    let imgFinishClicked = UIImage(named: "ic_finish_click")! as UIImage
    let imgFinish = (UIImage(named: "ic_finish_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let defaults = UserDefaults.standard
    var time: Float = 0.0
    var timeSlow: Float = 0.0
    var timer = Timer()
    var timerSlow = Timer()
    var ifToEditCode1: Bool = false
    var ifKeyboardShown: Bool = false
    var blinking = false
    var edCodeList: [UITextField] = []
    
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
        btnFinished.setImage(imgFinishClicked, for: .highlighted)
        btnFinished.setImage(imgFinish, for: .normal)
        self.scrollView.contentSize.height = 930
        progressSpinner.startAnimating()
        progressBar.setProgress(0, animated: true)
        ivBarcode.alpha = 0.0
        tvEnterInstruct.alpha = 0.0
        btnFinished.alpha = 0.0
        startCounter()
        edHome.leftViewMode = UITextFieldViewMode.always
        edHome.leftView = ivHome
        edHome.text = defaults.string(forKey: addressKeys.myAddressKey)
        edHome.isEnabled = false
        edDestination.leftViewMode = UITextFieldViewMode.always
        edDestination.leftView = ivDestination
        edDestination.text = defaults.string(forKey: addressKeys.destAddressKey)
        edDestination.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        btnFinished.setImage(imgFinishClicked, for: .highlighted)
        btnFinished.setImage(imgFinish, for: .normal)
        edCodeList = [self.edCode1, self.edCode2, self.edCode3, self.edCode4, self.edCode5, self.edCode6]
        for textField in edCodeList{
            textField.delegate = self
        }
        setCodeView()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCodeView(){
        for textField in edCodeList{
            textField.isHidden = true
        }
        setAllCodeFrameColor(color: UIColor.gray)
        for textField in edCodeList{
            textField.layer.borderWidth = 1.0
        }
    }
    
    func showBarcode(){
        self.progressSpinner.isHidden = true
        self.progressBar.isHidden = true
//        tvBarcodeInstr.text = "Please scan the barcode below at checkout."
        fadeIn(imageView: ivBarcode, withDuration: 2.5)
        fadeIn(textView: tvEnterInstruct)
        fadeIn(btnView: btnFinished)
    }
    
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ConfirmViewController.setProgress), userInfo: nil, repeats: true)
        timerSlow = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector:#selector(ConfirmViewController.blinkingTitle), userInfo: nil, repeats: true)
    }
    
    func setProgress() {
        time += 0.1
        progressBar.progress = (time / 10)
        if time >= 10 {
            showBarcode()
            for textField in edCodeList {
                textField.isHidden = false
            }
        }
        if time >= 10 && time < 14 {
            tvRequestTitle.text = "Ride Requested"
            tvRequestTitle.textColor = tvBarcodeInstr.textColor
        } else if (time >= 14){
            tvRequestTitle.text = "Driver Details"
            tvRequestTitle.textColor = tvBarcodeInstr.textColor
            edHome.isHidden = true
            edDestination.isHidden = true
            tvRequestInfo.isHidden = true
            tvRequestDetails.isHidden = false
        }
    }
    
    func blinkingTitle(){
        timeSlow += 1
        if timeSlow <= 6 {
            blinkingLabel()
        }
    }
    
    func fadeIn(imageView: UIImageView, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            imageView.alpha = 1.0
        })
    }
    
    func fadeIn(textView: UILabel, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            textView.alpha = 1.0
        })
    }
    
    func fadeIn(btnView: BorderedButton, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            btnView.alpha = 1.0
        })
    }
    
    func blinkingLabel(withDuration duration: TimeInterval = 1.5){
        if !blinking{
            self.tvRequestTitle.alpha = 1.0
            UIView.animate(withDuration: duration, animations: {
                self.tvRequestTitle.alpha = 0.0
            })
            blinking = true
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.tvRequestTitle.alpha = 1.0
            })
            blinking = false
        }
    }
    
    @IBAction func edCode1Edited(_ sender: UITextField) {
        setEditingMode()
        if (edCode1.text?.characters.count)! > 0 {
            edCode2.becomeFirstResponder()
        }
    }
    
    @IBAction func edCode2Edited(_ sender: UITextField) {
        setEditingMode()
        if (edCode2.text?.characters.count)! > 0 {
            edCode3.becomeFirstResponder()
        }
    }
    
    @IBAction func edCode3Edited(_ sender: UITextField) {
        setEditingMode()
        if (edCode3.text?.characters.count)! > 0 {
            edCode4.becomeFirstResponder()
        }
    }
    
    @IBAction func edCode4Edited(_ sender: UITextField) {
        setEditingMode()
        if (edCode4.text?.characters.count)! > 0 {
            edCode5.becomeFirstResponder()
        }
    }
    
    @IBAction func edCode5Edited(_ sender: UITextField) {
        setEditingMode()
        if (edCode5.text?.characters.count)! > 0 {
            edCode6
                .becomeFirstResponder()
        }
    }
    
    @IBAction func edCode6Edited(_ sender: UITextField) {
        edCode6.endEditing(true)
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
    @IBAction func btnNextPressed(_ sender: BorderedButton) {
        if(checkCode()){
            self.performSegue(withIdentifier: "confirmToReturnIdentifier", sender: self)
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to cancel the ride?", message: "By tapping yes, you will cancel the ride and return to home page.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            //            print("Destructive")
        }
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "confirmToHomeIdentifier", sender: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkCode() -> Bool{
        if((edCode1.text?.characters.count)! > 0 && (edCode2.text?.characters.count)! > 0 && (edCode3.text?.characters.count)! > 0 && (edCode4.text?.characters.count)! > 0 && (edCode5.text?.characters.count)! > 0 && (edCode6.text?.characters.count)! > 0){
            return true
        } else {
            tvWarning.isHidden = false
            setAllCodeFrameColor(color: UIColor.red)
            return false
        }
    }
    
    func setAllCodeFrameColor(color: UIColor){
        for textField in edCodeList {
            textField.layer.borderColor = color.cgColor
        }
    }
    
    func setEditingMode(){
        tvWarning.isHidden = true
        setAllCodeFrameColor(color: UIColor.gray)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            //detect if backspace is pressed.
            switch textField {
            case edCode6:
                if(edCode6.text?.characters.count == 0){
                    edCode5.becomeFirstResponder()
                }
            case edCode5:
                if(edCode5.text?.characters.count == 0){
                    edCode4.becomeFirstResponder()
                }
            case edCode4:
                if(edCode4.text?.characters.count == 0){
                    edCode3.becomeFirstResponder()
                }
            case edCode3:
                if(edCode3.text?.characters.count == 0){
                    edCode2.becomeFirstResponder()
                }
            case edCode2:
                if(edCode2.text?.characters.count == 0){
                    edCode1.becomeFirstResponder()
                }
            default:
                edCode1.becomeFirstResponder()
            }
        }
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !ifKeyboardShown {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height - 45
                ifKeyboardShown = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                if ifKeyboardShown {
                    self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height + 45
                    ifKeyboardShown = false
                }
            }
        }
    }
}
