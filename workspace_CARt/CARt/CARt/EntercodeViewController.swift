//
//  EntercodeViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EntercodeViewController: UIViewController {
    
    
    @IBOutlet weak var btnFinish: BorderedButton!
    
    @IBOutlet weak var edCode1: UITextField!
    @IBOutlet weak var edCode2: UITextField!
    @IBOutlet weak var edCode3: UITextField!
    @IBOutlet weak var edCode4: UITextField!
    
    let imgFinish = UIImage(named: "ic_finish_click")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFinish.setImage(imgFinish, for: .highlighted)
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
    
}
