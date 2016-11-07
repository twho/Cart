//
//  EntercodeViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EntercodeViewController: UIViewController {
    
    
    
    @IBOutlet weak var btnNext: BorderedButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    
    @IBOutlet weak var edCode1: UITextField!
    @IBOutlet weak var edCode2: UITextField!
    @IBOutlet weak var edCode3: UITextField!
    @IBOutlet weak var edCode4: UITextField!
    
    let imgNextClicked = UIImage(named: "ic_next_click")! as UIImage
    let imgPrevClicked = UIImage(named: "ic_prev_click")! as UIImage
    let imgNext = (UIImage(named: "ic_next_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgPrev = (UIImage(named: "ic_prev_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.setImage(imgNext, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .highlighted)
        btnNext.isEnabled = false
        edCode1.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func edCode1Edited(_ sender: UITextField) {
        edCode2.becomeFirstResponder()
    }
    @IBAction func edCode2Edited(_ sender: UITextField) {
        edCode3.becomeFirstResponder()
    }
    @IBAction func edCode3Edited(_ sender: UITextField) {
        edCode4.becomeFirstResponder()
    }
    @IBAction func edCode4Edited(_ sender: UITextField) {
        btnNext.isEnabled = true
    }
    
}
