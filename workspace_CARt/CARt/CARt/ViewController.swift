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
    
    let imgRequestClicked = UIImage(named: "ic_request_click")! as UIImage
    let imgRequest = (UIImage(named: "ic_request_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgReferClicked = UIImage(named: "ic_refer_click")! as UIImage
    let imgRefer = (UIImage(named: "ic_refer_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRequest.setImage(imgRequestClicked, for: .highlighted)
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

