//
//  WantedReceivedCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/18/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class WantedReceivedCell: UICollectionViewCell, UITextViewDelegate, AcceptDeclineData {
    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var artistImageView: UIImageView!

    @IBAction func declinePressed(_ sender: Any) {
        self.acceptDeclineDelegate?.declinePressedWanted(indexPathRow: self.indexPath.row, indexPath: self.indexPath as IndexPath, curCell: self)
    }
    @IBAction func viewProfilePressed(_ sender: Any) {
    }
    @IBAction func acceptPressed(_ sender: Any) {
        self.acceptDeclineDelegate?.acceptPressedWanted(indexPathRow: self.indexPath.row, indexPath: self.indexPath as IndexPath, curCell: self)
    }
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBAction func moreInfoPressed(_ sender: Any) {
        if moreInfoShowing == false{
            moreInfoView.isHidden = false
            moreInfoShowing = true
        } else {
            moreInfoView.isHidden = true
            moreInfoShowing = false
        }
    }
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var instrumentLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var moreInfoTextView2: UITextView!
    @IBOutlet weak var moreInfoTextView1: UITextView!
    
    var indexPath = IndexPath()
    weak var acceptDeclineDelegate : AcceptDeclineDelegate?
    var moreInfoShowing = false
    var artistID = String()
    var bandType = String()
    var bandID = String()
    var wantedID = String()
    var responseID = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        moreInfoTextView1.delegate = self
        moreInfoTextView2.delegate = self
        
        moreInfoView.isHidden = true
        artistImageView.layer.cornerRadius = artistImageView.frame.width/2
       // viewProfileButton.layer.cornerRadius = viewProfileButton.frame.width/2
       // moreInfoButton.layer.cornerRadius = moreInfoButton.frame.width/2
        
        // Initialization code
    }

}
