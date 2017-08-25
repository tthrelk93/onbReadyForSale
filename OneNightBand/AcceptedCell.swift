//
//  AcceptedCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/18/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class AcceptedCell: UICollectionViewCell, GoToBandData {
    @IBOutlet weak var noAcceptedInvitesLabel: UILabel!
    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    weak var goToBandDelegate : GoToBandDelegate?
    var bandID = String()
    var indexPath = IndexPath()
    @IBAction func dismissPressed(_ sender: Any) {
        goToBandDelegate?.dismissAccepted(indexPath: self.indexPath)
    }
    

    @IBAction func viewBandPressed(_ sender: Any) {
        goToBandDelegate?.goToBand(bandID: self.bandID)
    }
    @IBOutlet weak var bandNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
