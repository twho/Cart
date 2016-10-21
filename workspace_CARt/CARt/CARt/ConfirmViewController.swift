//
//  ConfirmViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet weak var tvRequestDetail: UILabel!
    @IBOutlet weak var tvBarcodeInstr: UILabel!
    @IBOutlet weak var tvRequestTitle: UILabel!
    @IBOutlet weak var btnEntercode: BorderedButton!
    @IBOutlet weak var progressSpinner: UIActivityIndicatorView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var ivBarcode: UIImageView!
    @IBOutlet weak var tvEnterInstruct: UILabel!
    
    let imgEntercode = UIImage(named: "ic_entercode_click")! as UIImage
    var time: Float = 0.0
    var timeSlow: Float = 0.0
    var timer = Timer()
    var timerSlow = Timer()
    var blinking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvRequestDetail.text = "Request sent, please wait. Sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text "
        btnEntercode.setImage(imgEntercode, for: .highlighted)
        progressSpinner.startAnimating()
        progressBar.setProgress(0, animated: true)
        ivBarcode.alpha = 0.0
        tvEnterInstruct.alpha = 0.0
        btnEntercode.alpha = 0.0
        startCounter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBarcode(){
        self.progressSpinner.isHidden = true
        self.progressBar.isHidden = true
        tvBarcodeInstr.text = "Please scan the barcode below at checkout."
        fadeIn(imageView: ivBarcode, withDuration: 2.5)
        fadeIn(textView: tvEnterInstruct)
        fadeIn(btnView: btnEntercode)
    }
    
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ConfirmViewController.setProgress), userInfo: nil, repeats: true)
        timerSlow = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector:#selector(ConfirmViewController.blinkingTitle), userInfo: nil, repeats: true)
    }
    
    func setProgress() {
        time += 0.1
        progressBar.progress = (time / 10)
        if time >= 10 {
            showBarcode()
            tvRequestTitle.text = "Ride Requested"
            tvRequestTitle.textColor = tvBarcodeInstr.textColor
            
        }
    }
    
    func blinkingTitle(){
        timeSlow += 1
        if timeSlow <= 6 {
            blinkingLabel()
        }
    }
    
    func fadeIn(imageView: UIImageView, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            imageView.alpha = 1.0
        })
    }
    
    func fadeIn(textView: UILabel, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            textView.alpha = 1.0
        })
    }
    
    func fadeIn(btnView: BorderedButton, withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            btnView.alpha = 1.0
        })
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
}
