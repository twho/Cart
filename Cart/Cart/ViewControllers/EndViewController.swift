//
//  EndViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/20/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EndViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tvRequestTitle: UILabel!
    @IBOutlet weak var tvRequestDetails: UILabel!
    @IBOutlet weak var tvRequestInfo: UILabel!
    @IBOutlet weak var edEmail: UITextField!
    @IBOutlet weak var edComment: UITextField!
    @IBOutlet weak var btnSend: BorderedButton!
    @IBOutlet weak var edStoreAddr: UITextField!
    @IBOutlet weak var edHomeAddr: UITextField!
    @IBOutlet weak var btnRefer: BorderedButton!
    @IBOutlet weak var btnSurvey: BorderedButton!
    @IBOutlet weak var ivStore: UIImageView!
    @IBOutlet weak var ivHome: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rateStar1: UIButton!
    @IBOutlet weak var rateStar2: UIButton!
    @IBOutlet weak var rateStar3: UIButton!
    @IBOutlet weak var rateStar4: UIButton!
    @IBOutlet weak var rateStar5: UIButton!
    @IBOutlet weak var ivDriver: CornerRadiusImageView!
    @IBOutlet weak var tvDriverName: UILabel!
    @IBOutlet weak var tvDriverCar: UILabel!
    @IBOutlet weak var tvDrvierLicense: UILabel!
    
    let defaults = UserDefaults.standard
    let imageResources = ImageResources()
    
    var ifKeyboardShown: Bool = false
    var time: Float = 0.0
    var timeSlow: Float = 0.0
    var timer = Timer()
    var timerSlow = Timer()
    var starRow: [UIButton] = []
    var blinking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUIViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        startCounter()
    }
    
    func initUIViews(){
        btnSend.setImage(imageResources.imgSendClicked, for: .highlighted)
        btnSend.setImage(imageResources.imgSendClicked, for: .normal)
        btnSurvey.setImage(imageResources.imgSurveyClicked, for: .highlighted)
        btnSurvey.setImage(imageResources.imgSurvey, for: .normal)
        btnRefer.setImage(imageResources.imgReferClicked, for: .highlighted)
        btnRefer.setImage(imageResources.imgRefer, for: .normal)
        edStoreAddr.leftViewMode = UITextFieldViewMode.always
        edStoreAddr.leftView = ivStore
        edStoreAddr.text = defaults.string(forKey: addressKeys.destAddressKey)
        edStoreAddr.isEnabled = false
        edHomeAddr.leftViewMode = UITextFieldViewMode.always
        edHomeAddr.leftView = ivHome
        edHomeAddr.text = defaults.string(forKey: addressKeys.myAddressKey)
        edHomeAddr.isEnabled = false
        edComment.layer.borderWidth = 0.5
        edComment.layer.borderColor = UIColor.lightGray.cgColor
        self.scrollView.contentSize.height = 1730
        self.edEmail.delegate = self
        self.edComment.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.starRow = [rateStar1, rateStar2, rateStar3, rateStar4, rateStar5]
        for star in starRow {
            star.setImage(imageResources.imgStar, for: .normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ConfirmViewController.setProgress), userInfo: nil, repeats: true)
        timerSlow = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector:#selector(ConfirmViewController.blinkingTitle), userInfo: nil, repeats: true)
    }
    
    func setProgress() {
        time += 0.1
        if time >= 10 && time < 14 {
            tvRequestTitle.alpha = 1.0
            tvRequestTitle.text = "Driver Details"
            edHomeAddr.isHidden = true
            edStoreAddr.isHidden = true
            tvRequestInfo.isHidden = true
            ivDriver.isHidden = false
            tvDriverName.isHidden = false
            tvDriverCar.isHidden = false
            tvDrvierLicense.isHidden = false
        }
    }
    
    func blinkingTitle(){
        timeSlow += 1
        if timeSlow <= 6 {
            blinkingLabel()
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setAllStarEmpty(){
        for star in starRow {
            star.setImage(imageResources.imgStar, for: .normal)
            star.setImage(imageResources.imgStar, for: .highlighted)
        }
    }
    
    @IBAction func star1Clicked(_ sender: UIButton) {
        setAllStarEmpty()
        starRow[0].setImage(imageResources.imgStarClicked, for: .normal)
        starRow[0].setImage(imageResources.imgStarClicked, for: .highlighted)
    }
    
    @IBAction func star2Clicked(_ sender: UIButton) {
        setAllStarEmpty()
        for i in 0...1 {
            starRow[i].setImage(imageResources.imgStarClicked, for: .normal)
            starRow[i].setImage(imageResources.imgStarClicked, for: .highlighted)
        }
    }
    
    @IBAction func star3Clicked(_ sender: UIButton) {
        setAllStarEmpty()
        for i in 0...2 {
            starRow[i].setImage(imageResources.imgStarClicked, for: .normal)
            starRow[i].setImage(imageResources.imgStarClicked, for: .highlighted)
        }
    }
    
    @IBAction func star4Clicked(_ sender: UIButton) {
        setAllStarEmpty()
        for i in 0...3 {
            starRow[i].setImage(imageResources.imgStarClicked, for: .normal)
            starRow[i].setImage(imageResources.imgStarClicked, for: .highlighted)
        }
    }
    
    @IBAction func star5Clicked(_ sender: UIButton) {
        for star in starRow {
            star.setImage(imageResources.imgStarClicked, for: .normal)
            star.setImage(imageResources.imgStarClicked, for: .highlighted)
        }
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
            if (!ifKeyboardShown) {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height
                ifKeyboardShown = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                if (ifKeyboardShown) {
                    self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height
                    ifKeyboardShown = false
                }
            }
        }
    }
}
