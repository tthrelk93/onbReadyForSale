//
//  JoinBandCollectionViewCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/6/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

protocol PerformSegueInBandBoard {
    func performSegueToBandPage(bandID: String)
    func joinBand(bandID: String, wantedAd: WantedAd)
}

class JoinBandCollectionViewCell: UICollectionViewCell {
    @IBAction func moreLessInfoButtonPressed(_ sender: Any) {
        if self.moreLessInfoButton.titleLabel?.text == "More Info"{
            moreInfoView.isHidden = false
            self.moreLessInfoButton.setTitle("Less Info", for: .normal)
        } else {
            moreInfoView.isHidden = true
            self.moreLessInfoButton.setTitle("More Info", for: .normal)
        }
    }
    @IBOutlet weak var moreLessInfoButton: UIButton!
    @IBOutlet weak var moreInfoView: UIView!
    @IBAction func viewBandPagePressed(_ sender: Any) {
        delegate.performSegueToBandPage(bandID: self.bandID)
    }
    @IBAction func joinBandPressed(_ sender: Any) {
        delegate.joinBand(bandID: self.bandID, wantedAd: self.wantedAd)
        
    }
    @IBOutlet weak var bandImageView: UIImageView!
   
    var delegate: PerformSegueInBandBoard!
    
    var bandID = String()
    var wantedAd = WantedAd()

    @IBOutlet weak var bandName: UILabel!
    @IBOutlet weak var instrumentWanted: UILabel!
    @IBOutlet weak var experienceWanted: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var moreInfoTextView: UITextView!
    //var bandBoardDelegate: PerformSegueInBandBoard!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.moreLessInfoButton.setTitle("More Info", for: .normal)
        bandImageView.layer.cornerRadius = bandImageView.frame.width/2
        // Initialization code
    }

}
