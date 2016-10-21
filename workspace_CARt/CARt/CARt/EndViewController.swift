//
//  EndViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/20/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var btnCancel: BorderedButton!
    @IBOutlet weak var btnSend: BorderedButton!
    
    let imgCancel = UIImage(named: "ic_cancel_click")
    let imgSend = UIImage(named: "ic_finish_click")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.setImage(imgCancel, for: .highlighted)
        btnSend.setImage(imgSend, for: .highlighted)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
