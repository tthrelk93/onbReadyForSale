//
//  ArtistCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/20/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {
    
    
    @IBOutlet weak var artistImageView: UIImageView!

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistInstrumentLabel: UILabel!
    var artistUID = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        //self.artistImageView.layer.cornerRadius = artistImageView.frame.width/2
        //self.artistImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




