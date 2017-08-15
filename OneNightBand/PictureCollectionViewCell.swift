//
//  PictureCollectionViewCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 12/6/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import UIKit
//import YouTubePlayer

class PictureCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate, RemovePicData {

    weak var removePicDelegate: RemovePicDelegate?
    
    @IBAction func removePicPressed(_ sender: AnyObject) {
       // print("remove Pressed: \(self.picData)")
        //removePicDelegate?.removePic(removalPic: picData)
        
    }

    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var picImageView: UIImageView!
    var picData = UIImage()
    var cellSelected = false
    @IBAction func deletePressed(_ sender: Any) {
        print("remove Pressed: \(self.picData)")
        removePicDelegate?.removePic(removalPic: picData)

    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        //imagePicker.delegate = self
                
    }
   

    
    
    


}
