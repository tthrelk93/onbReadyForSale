//
//  TagCell.swift
//  TagFlowLayout
//
//  Created by Diep Nguyen Hoang on 7/30/15.
//  Copyright (c) 2015 CodenTrick. All rights reserved.
//

import UIKit



class TagCell: UICollectionViewCell {
    
    
    @IBOutlet weak var tagNameMaxWidthConstraint: NSLayoutConstraint!
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    @IBOutlet weak var tagName: UILabel!
    var changed = false
    override func awakeFromNib() {
        self.backgroundColor = UIColor.white
        self.tagName.textColor = ONBPink
        self.layer.cornerRadius = 4
        
        
        
    }
}
