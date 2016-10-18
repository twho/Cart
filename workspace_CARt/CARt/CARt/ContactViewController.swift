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
    @IBOutlet weak var edPhone1: UITextField!
    @IBOutlet weak var edPhone2: UITextField!
    @IBOutlet weak var edPhone3: UITextField!
    
    //load image
    let imgNext = UIImage(named: "ic_next_click")! as UIImage
    let imgPrev = UIImage(named: "ic_prev_click")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.setImage(imgNext, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .highlighted)
        self.edPhone1.delegate = self
        edPhone2.delegate = self
        edPhone3.delegate = self
        edPhone1.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textWatcher(_ sender: UITextField) {
        switchFields(textField: edPhone1)
    }
    
    private func switchFields(textField: UITextField) {
        switch textField {
        case edPhone1:
            edPhone2.becomeFirstResponder()
        case edPhone2:
            edPhone3.becomeFirstResponder()
        default:
            break
        }
    }
}
