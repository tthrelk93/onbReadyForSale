//
//  songCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 3/20/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class songCell: UITableViewCell {

    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
