//
//  AboutONBViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 9/30/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AboutONBViewController: UIViewController {

    
    @IBOutlet weak var aboutONBTextView: UITextView!
    @IBOutlet weak var aboutONBBackgroundImage: UIImageView!
    @IBOutlet weak var textViewBlur: UIVisualEffectView!
    
   
    var tutorialText: String!
    var pageIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch UIScreen.main.bounds.width{
        case 320:
            aboutONBTextView.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
                        
        case 375:
            aboutONBTextView.font = UIFont.systemFont(ofSize: 25.0, weight: UIFontWeightLight)

           
            
        case 414:
            aboutONBTextView.font = UIFont.systemFont(ofSize: 30.0, weight: UIFontWeightLight)
            
            
        default:
            aboutONBTextView.font = UIFont.systemFont(ofSize: 30.0, weight: UIFontWeightLight)
            
            
            
        }
            
            
            
        

        
        
        
        self.aboutONBTextView.text = tutorialText
        self.aboutONBTextView.layer.cornerRadius = 20
        //self.textViewBlur.layer.cornerRadius = 20
        //self.textViewBlur.clipsToBounds = true
        
        //Blur for background
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.aboutONBBackgroundImage.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.view.backgroundColor = UIColor.black
        }
        
        
        //self.aboutONBTextView.addSubview(textViewBlurEffectView)
        
        
        
        
        
     
    }
    
}




