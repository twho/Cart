//
//  EntercodeViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EntercodeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnNext: BorderedButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    
    @IBOutlet weak var edCode1: UITextField!
    @IBOutlet weak var edCode2: UITextField!
    @IBOutlet weak var edCode3: UITextField!
    @IBOutlet weak var edCode4: UITextField!
    @IBOutlet weak var edCode5: UITextField!
    @IBOutlet weak var edCode6: UITextField!
    @IBOutlet weak var tvWarning: UILabel!
    
    var edCodeList: [UITextField] = []
    
    let imageResources = ImageResources()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIViews()
        setCodeView()
        self.hideKeyboardWhenTappedAround()
    }
    
    func initUIViews(){
        btnNext.setImage(imageResources.imgNextClicked, for: .highlighted)
        btnPrev.setImage(imageResources.imgPrevClicked, for: .highlighted)
        btnNext.setImage(imageResources.imgNextClicked, for: .normal)
        btnPrev.setImage(imageResources.imgPrev, for: .normal)
        edCode1.becomeFirstResponder()

    }
    
    func setCodeView(){
        edCodeList = [self.edCode1, self.edCode2, self.edCode3, self.edCode4, self.edCode5, self.edCode6]
        
        for textField in edCodeList{
            textField.delegate = self
            textField.layer.borderWidth = 1.0
        }
        setAllCodeFrameColor(color: UIColor.gray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    }
    
    @IBAction func btnNextPressed(_ sender: BorderedButton) {
        if(checkCode()){
            performSegue(withIdentifier: "EntercodeToReturnIdentifier", sender: self)
        } else {
            setAllCodeFrameColor(color: UIColor.red)
        }
    }
    
    func setEditingMode(){
        tvWarning.isHidden = true
        setAllCodeFrameColor(color: UIColor.gray)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
