//
//  ImageResources.swift
//  CARt
//
//  Created by Michael Ho on 3/13/17.
//  Copyright © 2017 cartrides.org. All rights reserved.
//

import UIKit

open class ImageResources {
    
    // Button next
    let imgNextClicked = UIImage(named: "ic_next_click")! as UIImage
    let imgNext = (UIImage(named: "ic_next_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    
    // Button previous
    let imgPrevClicked = UIImage(named: "ic_prev_click")! as UIImage
    let imgPrev = (UIImage(named: "ic_prev_click")?.maskWithColor(color: UIColor(red:0.47, green:0.73, blue:0.30, alpha:1.0))!)! as UIImage
    
    // Button confirm
    let imgConfirmClicked = UIImage(named: "ic_request_click")! as UIImage

    // Button finish
    let imgFinishClicked = UIImage(named: "ic_finish_click")! as UIImage
    
    // Button request
    let imgRequestClicked = UIImage(named: "ic_request_click")! as UIImage
    
    // Button send
    let imgSendClicked = UIImage(named: "ic_finish_click")
    
    // Button refer
    let imgReferClicked = UIImage(named: "ic_refer_click")! as UIImage
    let imgRefer = (UIImage(named: "ic_refer_click")?.maskWithColor(color: UIColor(red:0.47, green:0.73, blue:0.30, alpha:1.0))!)! as UIImage
    
    // Button survey
    let imgSurveyClicked = (UIImage(named: "ic_survey")?.maskWithColor(color: UIColor.white)!)! as UIImage
    let imgSurvey = (UIImage(named: "ic_survey")?.maskWithColor(color: UIColor(red:0.47, green:0.73, blue:0.30, alpha:1.0))!)! as UIImage
    
    // Button start
    let imgStar = (UIImage(named: "ic_star")?.maskWithColor(color: UIColor(red:0.47, green:0.73, blue:0.30, alpha:1.0))!)! as UIImage
    let imgStarClicked = (UIImage(named: "ic_star_click")?.maskWithColor(color: UIColor(red:0.47, green:0.73, blue:0.30, alpha:1.0))!)! as UIImage
    
    // Button verify
    let imgVerifyClicked = UIImage(named: "ic_next_click")! as UIImage
}
