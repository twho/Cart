//
//  WebViewController.swift
//  CARt
//
//  Created by Michael Ho on 12/5/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//
//  This view is created for Cart team to conduct user testing

import UIKit

class WebViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var edWebUrl: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edWebUrl.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            self.performSegue(withIdentifier: "WebToHomeIdentifier", sender: self)
        }
        return true
    }
    
    @IBAction func startTyping(_ sender: UITextField) {
        self.edWebUrl.placeholder = ""
    }
    
    @IBAction func edFocused(_ sender: UITextField) {
        btnSearch.isHidden = true
        self.edWebUrl.placeholder = "Search or enter website name"
    }
    
}
