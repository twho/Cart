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
    
    let imgCancelClicked = UIImage(named: "ic_cancel_click")
    let imgCancel = (UIImage(named: "ic_cancel_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgSendClicked = UIImage(named: "ic_finish_click")
    let imgSend = (UIImage(named: "ic_finish_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.setImage(imgCancelClicked, for: .highlighted)
        btnCancel.setImage(imgCancel, for: .normal)
        btnSend.setImage(imgSendClicked, for: .highlighted)
        btnSend.setImage(imgSend, for: .highlighted)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()    }
}
