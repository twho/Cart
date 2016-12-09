//
//  ViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/16/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnRequest: BorderedButton!
    @IBOutlet weak var btnRefer: BorderedButton!
    
    let imgRequest = (UIImage(named: "ic_request_click")?.maskWithColor(color: UIColor.white)!)! as UIImage
    let imgReferClicked = UIImage(named: "ic_refer_click")! as UIImage
    let imgRefer = (UIImage(named: "ic_refer_click")?.maskWithColor(color: UIColor(red:0.47, green:0.73, blue:0.30, alpha:1.0))!)! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRequest.setImage(imgRequest, for: .highlighted)
        btnRequest.setImage(imgRequest, for: .normal)
        btnRefer.setImage(imgReferClicked, for: .highlighted)
        btnRefer.setImage(imgRefer, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanButton (sender: UIButton!) {
    }
}

