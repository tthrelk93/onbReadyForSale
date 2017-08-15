//
//  AddMediaToProfile.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 12/1/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SwiftOverlays
//import Firebase

protocol RemoveVideoDelegate : class
{
    func removeVideo(removalVid: NSURL, isYoutube: Bool)
    
}
protocol RemoveVideoData : class
{
    weak var removeVideoDelegate : RemoveVideoDelegate? { get set }
}
protocol RemovePicDelegate : class
{
    func removePic(removalPic: UIImage)
    
}
protocol RemovePicData : class
{
    weak var removePicDelegate : RemovePicDelegate? { get set }
}



class AddMediaToSession: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, RemoveVideoDelegate, RemovePicDelegate{
    
    var bandID: String?
    var sessionID: String?
    var curIndexPath = [IndexPath]()
    var curCount = Int()
    var count1 = Int()
    var artistID = String()
    let picker = UIImagePickerController()
    
    var movieURLFromPicker: NSURL?
    var curCell: VideoCollectionViewCell?
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMediaToMain"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.userID = self.userID!
                vc.artistID = self.userID!
            }
        }
        
        if segue.identifier == "SaveMediaToONB"{
            if let vc = segue.destination as? OneNightBandViewController {
                vc.onbID = self.onbID
                //vc.BandID = self.bandID
                
            }
        }

        
        if segue.identifier == "SaveMediaToSession"{
        if let vc = segue.destination as? MP3PlayerViewController{
            vc.sessionID = self.sessionID
            vc.BandID = self.bandID
            vc.viewerInBand = true
            vc.artistID = self.artistID
            
            }
        }
            
    }
    
    @IBAction func addPicTouched(_ sender: AnyObject) {
        currentPicker = "photo"
        imagePicker.allowsEditing = true
        //imagePicker.mediaTypes = ["kUTTypeImage"] //[.kUTTypeImage as String]
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    
    @IBAction func chooseVidFromPhoneSelected(_ sender: AnyObject) {
        currentPicker = "vid"
        picker.mediaTypes = ["public.movie"]
        
        present(picker, animated: true, completion: nil)
    }
    var senderView = String()
    @IBOutlet weak var vidFromPhoneCollectionView: UICollectionView!
    @IBOutlet weak var youtubeCollectionView: UICollectionView!
    //var tempArray1 = [String]()
    //var tempArray = [String]()
    var lastIndexPath: IndexPath?
    @IBOutlet weak var shadeView: UIView!
    
    
    @IBAction func addYoutubeVideoButtonPressed(_ sender: AnyObject) {
        var tempArray = [String]()
        if senderView == "main"{
            if youtubeLinkField.text == nil || youtubeLinkField.text == ""{
                print("youtube field empty")
            } else {
                self.currentYoutubeLink = NSURL(string: self.youtubeLinkField.text!)
                ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
                    for snap in snapshots {
                        tempArray.append(snap.key)
                    }
            
                    for snap in snapshots{
                        if snap.key == "media"{
                            let mediaKids = snap.children.allObjects as! [DataSnapshot]
                        
                            for mediaKid in mediaKids{
                                tempArray.append(mediaKid.key )
                            }
                        }
                    }
                })
                
                if tempArray.count != 0{
                    
                    self.currentCollectID = "youtube"
                    
                    //self.youtubeLinkArray.append(self.currentYoutubeLink)
                    youtubeLinkArray.append(currentYoutubeLink)
                    //self.youtubeLinkArray.insert(currentYoutubeLink, at: 0)
                    //self.vidFromPhoneArray.append(movieURL)
                    youtubeCollectionView.performBatchUpdates({let insertionIndexPath = IndexPath(row: self.youtubeLinkArray.count - 1, section: 0)
                    self.youtubeCollectionView.insertItems(at: [insertionIndexPath])}, completion: nil)
                    
                    
                    
                }else{
                    self.currentCollectID = "youtube"
                    
                    self.youtubeLinkArray.append(self.currentYoutubeLink)
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.youtubeCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    
                    self.sizingCell4 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.youtubeCollectionView.backgroundColor = UIColor.clear
                    self.youtubeCollectionView.dataSource = self
                    self.youtubeCollectionView.delegate = self
                    
                    
                }
                
                /*self.tempLink = self.currentYoutubeLink
                self.currentCollectID = "youtube"
                youtubeLinkArray.append(self.currentYoutubeLink)
                print(youtubeLinkArray)
                let insertionIndexPath = IndexPath(row: self.youtubeLinkArray.count - 1, section: 0)
                DispatchQueue.main.async{
                    self.youtubeCollectionView.insertItems(at: [insertionIndexPath])
                            
                }*/
            }
            self.youtubeLinkField.text = ""
            
        } else if senderView == "session"{
            print("sessYout")
            if youtubeLinkField == nil{
                print("youtube field empty")
            }else{
                self.currentYoutubeLink = NSURL(string: self.youtubeLinkField.text!)
                ref.child("sessions").child(self.sessionID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    
                    for snap in snapshots{
                        tempArray.append(snap.key)
                    }
                    
                    for snap in snapshots{
                        if snap.key == "sessionMedia"{
                            let mediaKids = snap.children.allObjects as! [DataSnapshot]
                            
                            for mediaKid in mediaKids{
                                tempArray.append(mediaKid.value as! String)
                            }
                        }
                    }
                    
                })
                if tempArray.count != 0{
                    self.currentCollectID = "youtube"
                    self.youtubeLinkArray.append(self.currentYoutubeLink)//insert(self.currentYoutubeLink, at: 0)
                    //self.youtubeLinkArray.append(self.currentYoutubeLink)
                    let insertionIndexPath = IndexPath(row: youtubeLinkArray.count - 1, section: 0)
                    youtubeCollectionView.performBatchUpdates({ self.youtubeCollectionView.insertItems(at: [insertionIndexPath])}, completion: nil)
                   
                }else{
                    self.currentCollectID = "youtube"
                    self.youtubeLinkArray.append(self.currentYoutubeLink)
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.youtubeCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell4 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.youtubeCollectionView.backgroundColor = UIColor.clear
                    self.youtubeCollectionView.dataSource = self
                    self.youtubeCollectionView.delegate = self
                }
            }
            self.youtubeLinkField.text = ""

        } else {
            if youtubeLinkField == nil{
                print("youtube field empty")
            }else{
                self.currentYoutubeLink = NSURL(string: self.youtubeLinkField.text!)
                ref.child("oneNightBands").child(self.onbID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    
                    for snap in snapshots{
                        tempArray.append(snap.key)
                    }
                    
                    for snap in snapshots{
                        if snap.key == "onbMedia"{
                            let mediaKids = snap.children.allObjects as! [DataSnapshot]
                            
                            for mediaKid in mediaKids{
                                tempArray.append(mediaKid.value as! String)
                            }
                        }
                    }
                    
                })
                if tempArray.count != 0{
                    self.currentCollectID = "youtube"
                   self.youtubeLinkArray.append(self.currentYoutubeLink)//insert(self.currentYoutubeLink, at: 0)
                    let insertionIndexPath = IndexPath(row: youtubeLinkArray.count - 1, section: 0)
                    youtubeCollectionView.performBatchUpdates({ self.youtubeCollectionView.insertItems(at: [insertionIndexPath])}, completion: nil)
                }else{
                    self.currentCollectID = "youtube"
                    self.youtubeLinkArray.append(self.currentYoutubeLink)
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.youtubeCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell4 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.youtubeCollectionView.backgroundColor = UIColor.clear
                    self.youtubeCollectionView.dataSource = self
                    self.youtubeCollectionView.delegate = self
                }
            }
            self.youtubeLinkField.text = ""

        }

    
        }
    
    
    
    var mediaArray: [[String:Any]]?
    let userID = Auth.auth().currentUser?.uid
    //var newestYoutubeVid: String?
    
    var currentYoutubeTitle: String?
    var vidFromPhoneArray = [NSURL]()
    var youtubeDataArray = [String]()
    var recentlyAddedVidArray = [String]()
    var recentlyAddedPicArray = [UIImage]()
    var allVidURLs = [String]()
    var vidsDone = false
    var picsDone = false
    //var youtubeDone = false
    //uploads appropriate media to database
    @IBAction func saveTouched(_ sender: AnyObject) {
    
        SwiftOverlays.showBlockingWaitOverlayWithText("changes may take a few minutes to appear")
        print(senderView)
        if senderView == "main"{
            if (vidFromPhoneCollectionView.visibleCells.count == 0 && currentYoutubeLink == nil && needToUpdatePics == false && needToRemove == false){
                let alert = UIAlertController(title: "No new media", message: "It appears that you have not chosen any media to upload.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)  }
                
                //****else no errors
            else{

                _ = Dictionary<String, Any>(); var values2 = Dictionary<String, Any>(); let recipient = self.ref.child("users").child(userID!)
                for link in youtubeLinkArray{self.allVidURLs.append(String(describing: link))}
                for link in self.totalVidArray{
                    if String(describing: link).contains("tmp"){
                        totalVidArray.remove(at: totalVidArray.index(of: link)!)
                    }
                }
                for link in self.totalVidArray{self.allVidURLs.append(String(describing: link)) }
                
                //****if you did add any video from phone
                if self.addedVidDataArray.count != 0{
                    count1 = 1
                    for data in self.addedVidDataArray {let videoName = NSUUID().uuidString; let storageRef = Storage.storage().reference().child("artist_videos").child("\(videoName).mov"); var videoRef = storageRef.fullPath; let uploadMetadata = StorageMetadata();  uploadMetadata.contentType = "video/quicktime"
                            _ = storageRef.putData(data, metadata: uploadMetadata){(metadata, error) in
                                if(error != nil){
                                    print("got an error: \(error)") }
                                print("metaData: \(metadata)")
                                print("metaDataURL: \((metadata?.downloadURL()?.absoluteString)!)")
                                self.allVidURLs.append((metadata?.downloadURL()?.absoluteString)!)
                                print("avs:\(self.allVidURLs)")
                                if self.count1 == self.addedVidDataArray.count{
                                    //DispatchQueue.main.async{
                                    values2["media"] = self.allVidURLs
                                    print("allVids: \(self.allVidURLs)")
                                    recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                                        if err != nil {
                                            print(err!)
                                            return  }
                                        if self.needToUpdatePics == true{
                                            print("profPicArray: \(self.profPicArray)")
                                            var count = 0
                                            for pic in self.profPicArray{
                                                let imageName = NSUUID().uuidString
                                                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                                                if let uploadData = UIImageJPEGRepresentation(pic, 0.1) {
                                                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                                        if error != nil {
                                                            print(error!)
                                                            return  }; self.picArray.append((metadata?.downloadURL()?.absoluteString)!); var values3 = Dictionary<String, Any>()
                                                        values3["profileImageUrl"] = self.picArray; self.ref.child("users").child(self.userID!).updateChildValues(values3, withCompletionBlock: {(err, ref) in if err != nil {print(err!); return  }; self.picsDone = true }) }) } } }
                                        else { }
                                    })
                                }
                                self.count1 += 1
                        }
                    }
                }
                    //****else if you didn't add any vid from phoen
                else { values2["media"] = self.allVidURLs; print("allVidssssssssss: \(self.allVidURLs)");
                    //****if need to update pics is true
                    if self.needToUpdatePics == true{ print("profPicArray: \(self.profPicArray)"); var count = 0
                        for pic in self.profPicArray{ let imageName = NSUUID().uuidString; let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg"); if let uploadData = UIImageJPEGRepresentation(pic, 0.1) { storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in if error != nil { print(error!); return}; self.picArray.append((metadata?.downloadURL()?.absoluteString)!); var values3 = Dictionary<String, Any>(); print(self.picArray); values3["profileImageUrl"] = self.picArray; self.ref.child("users").child(self.userID!).updateChildValues(values3, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return }; recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return } }) }) }) } } } else { recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return } }) }}}; DispatchQueue.main.async{ sleep(3); self.handleCancel() } }
            
            
        else if senderView == "session" {
            if (vidFromPhoneCollectionView.visibleCells.count == 0 && currentYoutubeLink == nil && needToUpdatePics == false && needToRemove == false){
                //SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "No new media", message: "It appears that you have not chosen any media to upload.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                //SwiftOverlays.showBlockingWaitOverlayWithText("Updating Media")
                
                _ = Dictionary<String, Any>()
                var values2 = Dictionary<String, Any>()
                let recipient = self.ref.child("sessions").child(self.sessionID!)
                
                //print(youtubeLinkArray)
                for link in youtubeLinkArray{self.allVidURLs.append(String(describing: link))}
                for link in self.totalVidArray{
                    if String(describing: link).contains("tmp"){
                        totalVidArray.remove(at: totalVidArray.index(of: link)!)
                    }
                }
                for link in self.totalVidArray{self.allVidURLs.append(String(describing: link)) }
                
                //****if you did add any video from phone
                if self.addedVidDataArray.count != 0{
                    count1 = 1
                    for data in self.addedVidDataArray {let videoName = NSUUID().uuidString; let storageRef = Storage.storage().reference().child("session_videos").child("\(videoName).mov"); var videoRef = storageRef.fullPath; let uploadMetadata = StorageMetadata();  uploadMetadata.contentType = "video/quicktime"
                        _ = storageRef.putData(data, metadata: uploadMetadata){(metadata, error) in
                            if(error != nil){
                                print("got an error: \(error)") }
                            print("metaData: \(metadata)")
                            print("metaDataURL: \((metadata?.downloadURL()?.absoluteString)!)")
                            self.allVidURLs.append((metadata?.downloadURL()?.absoluteString)!)
                            print("avs:\(self.allVidURLs)")
                            if self.count1 == self.addedVidDataArray.count{
                                //DispatchQueue.main.async{
                                values2["sessionMedia"] = self.allVidURLs
                                print("allVids: \(self.allVidURLs)")
                                recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                                    if err != nil {
                                        print(err!)
                                        return  }
                                    if self.needToUpdatePics == true{
                                        print("profPicArray: \(self.profPicArray)")
                                        var count = 0
                                        for pic in self.profPicArray{
                                            let imageName = NSUUID().uuidString
                                            let storageRef = Storage.storage().reference().child("session_images").child("\(imageName).jpg")
                                            if let uploadData = UIImageJPEGRepresentation(pic, 0.1) {
                                                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                                    if error != nil {
                                                        print(error!)
                                                        return  }; self.picArray.append((metadata?.downloadURL()?.absoluteString)!); var values3 = Dictionary<String, Any>()
                
                                                    values3["sessionPictureURL"] = self.picArray
                                                    self.ref.child("sessions").child(self.sessionID!).updateChildValues(values3, withCompletionBlock: {(err, ref) in if err != nil {print(err!); return  }; self.picsDone = true }) }) } } }
                                    else { }
                                })
                            }
                            self.count1 += 1
                        }
                    }
                }
                else {
                    values2["sessionMedia"] = self.allVidURLs; print("allVidssssssssss: \(self.allVidURLs)");
                    //****if need to update pics is true
                    if self.needToUpdatePics == true{ print("profPicArray: \(self.profPicArray)"); var count = 0
                        for pic in self.profPicArray{ let imageName = NSUUID().uuidString; let storageRef = Storage.storage().reference().child("session_images").child("\(imageName).jpg"); if let uploadData = UIImageJPEGRepresentation(pic, 0.1) { storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in if error != nil { print(error!); return}; self.picArray.append((metadata?.downloadURL()?.absoluteString)!); var values3 = Dictionary<String, Any>(); print(self.picArray); values3["sessionPictureURL"] = self.picArray; self.ref.child("sessions").child(self.sessionID!).updateChildValues(values3, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return }; recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return } }) }) }) } } } else { recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return } }) }}}; DispatchQueue.main.async{ sleep(3); self.performSegue(withIdentifier: "SaveMediaToSession", sender: self) } }
                   else {
            if (vidFromPhoneCollectionView.visibleCells.count == 0 && currentYoutubeLink == nil && needToUpdatePics == false && needToRemove == false){
               // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "No new media", message: "It appears that you have not chosen any media to upload.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                //SwiftOverlays.showBlockingWaitOverlayWithText("Updating Media")
                
                _ = Dictionary<String, Any>()
                var values2 = Dictionary<String, Any>()
                let recipient = self.ref.child("oneNightBands").child(self.onbID)
                
                for link in youtubeLinkArray{self.allVidURLs.append(String(describing: link))}
                for link in self.totalVidArray{
                    if String(describing: link).contains("tmp"){
                        totalVidArray.remove(at: totalVidArray.index(of: link)!)
                    }
                }
                for link in self.totalVidArray{self.allVidURLs.append(String(describing: link)) }
                
                //****if you did add any video from phone
                if self.addedVidDataArray.count != 0{
                    count1 = 1
                    for data in self.addedVidDataArray {let videoName = NSUUID().uuidString
                        let storageRef = Storage.storage().reference().child("onb_videos").child("\(videoName).mov")
                        var videoRef = storageRef.fullPath; let uploadMetadata = StorageMetadata();  uploadMetadata.contentType = "video/quicktime"
                        _ = storageRef.putData(data, metadata: uploadMetadata){(metadata, error) in
                            if(error != nil){
                                print("got an error: \(error)") }
                            print("metaData: \(metadata)")
                            print("metaDataURL: \((metadata?.downloadURL()?.absoluteString)!)")
                            self.allVidURLs.append((metadata?.downloadURL()?.absoluteString)!)
                            print("avs:\(self.allVidURLs)")
                            if self.count1 == self.addedVidDataArray.count{
                                //DispatchQueue.main.async{
                                values2["onbMedia"] = self.allVidURLs
                                print("allVids: \(self.allVidURLs)")
                                recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                                    if err != nil {
                                        print(err!)
                                        return  }
                                    if self.needToUpdatePics == true{
                                        print("profPicArray: \(self.profPicArray)")
                                        var count = 0
                                        for pic in self.profPicArray{
                                            let imageName = NSUUID().uuidString
                                            let storageRef = Storage.storage().reference().child("onb_images").child("\(imageName).jpg")
                                            if let uploadData = UIImageJPEGRepresentation(pic, 0.1) {
                                                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                                    if error != nil {
                                                        print(error!)
                                                        return  }; self.picArray.append((metadata?.downloadURL()?.absoluteString)!); var values3 = Dictionary<String, Any>()
                                                    
                                                    values3["onbPictureURL"] = self.picArray
                                                    self.ref.child("oneNightBands").child(self.onbID).updateChildValues(values3, withCompletionBlock: {(err, ref) in if err != nil {print(err!); return  }; self.picsDone = true }) }) } } }
                                    else { }
                                })
                            }
                            self.count1 += 1
                        }
                    }
                }
                else {
                    values2["onbMedia"] = self.allVidURLs; print("allVidssssssssss: \(self.allVidURLs)");
                    //****if need to update pics is true
                    if self.needToUpdatePics == true{ print("profPicArray: \(self.profPicArray)"); var count = 0
                        for pic in self.profPicArray{ let imageName = NSUUID().uuidString;  let storageRef = Storage.storage().reference().child("onb_images").child("\(imageName).mov"); if let uploadData = UIImageJPEGRepresentation(pic, 0.1) { storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in if error != nil { print(error!); return}; self.picArray.append((metadata?.downloadURL()?.absoluteString)!); var values3 = Dictionary<String, Any>(); print(self.picArray); values3["onbPictureURL"] = self.picArray; self.ref.child("oneNightBands").child(self.onbID).updateChildValues(values3, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return }; recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return } }) }) }) } } } else { recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in if err != nil { print(err!); return } }) }}}; DispatchQueue.main.async{ sleep(3); self.performSegue(withIdentifier: "SaveMediaToONB", sender: self) } }
                
                /*
                //print(youtubeLinkArray)
                for link in youtubeLinkArray{
                    self.allVidURLs.append(String(describing: link))
                }
                for link in vidFromPhoneArray{
                    self.allVidURLs.append(String(describing: link))
                }
                //values2["youtube"] = self.youtubeDataArray
                
                
                if self.addedVidDataArray.count != 0{
                    count1 = 1
                    
                    for data in self.addedVidDataArray {
                        let videoName = NSUUID().uuidString
                        let storageRef = Storage.storage().reference().child("onb_videos").child("\(videoName).mov")
                        var videoRef = storageRef.fullPath
                        
                        //var downloadLink = storageRef.
                        let uploadMetadata = StorageMetadata()
                        uploadMetadata.contentType = "video/quicktime"
                        
                        _ = storageRef.putData(data, metadata: uploadMetadata){(metadata, error) in
                            if(error != nil){
                                print("got an error: \(error)")
                            }
                            print("metaData: \(metadata)")
                            print("metaDataURL: \((metadata?.downloadURL()?.absoluteString)!)")
                            self.allVidURLs.append((metadata?.downloadURL()?.absoluteString)!)
                            print("avs:\(self.allVidURLs)")
                            if self.count1 == self.addedVidDataArray.count{
                                //DispatchQueue.main.async{
                                values2["onbMedia"] = self.allVidURLs
                                
                                print("allVids: \(self.allVidURLs)")
                                recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                                    if err != nil {
                                        print(err!)
                                        return
                                    }
                                    if self.needToUpdatePics == true{
                                        print("profPicArray: \(self.profPicArray)")
                                        var count = 0
                                        for pic in self.profPicArray{
                                            
                                            let imageName = NSUUID().uuidString
                                            let storageRef = Storage.storage().reference().child("onb_images").child("\(imageName).jpg")
                                            if let uploadData = UIImageJPEGRepresentation(pic, 0.1) {
                                                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                                    if error != nil {
                                                        print(error!)
                                                        return
                                                    }
                                                    self.picArray.append((metadata?.downloadURL()?.absoluteString)!)
                                                    var values3 = Dictionary<String, Any>()
                                                    print(self.picArray)
                                                    values3["onbPictureURL"] = self.picArray
                                                    self.ref.child("oneNightBands").child(self.onbID).updateChildValues(values3, withCompletionBlock: {(err, ref) in
                                                        if err != nil {
                                                            print(err!)
                                                            return
                                                        }
                                                      //  self.performSegue(withIdentifier: "SaveMediaToONB", sender: self)

                                                    })
                                                })
                                            }
                                        }
                                        
                                    } else {
                                        //self.performSegue(withIdentifier: "SaveMediaToONB", sender: self)

                                    }

                                })
                                //}
                                
                            }
                            self.count1 += 1
                        }
                    }
                } else {
                    
                    values2["onbMedia"] = self.allVidURLs
                    
                    print("allVidsssss: \(self.allVidURLs)")
                    recipient.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                        if err != nil {
                            print(err!)
                            return
                        }
                        if self.needToUpdatePics == true{
                            print("profPicArray: \(self.profPicArray)")
                            var count = 0
                            for pic in self.profPicArray{
                                
                                let imageName = NSUUID().uuidString
                                let storageRef = Storage.storage().reference().child("onb_images").child("\(imageName).jpg")
                                if let uploadData = UIImageJPEGRepresentation(pic, 0.1) {
                                    
                                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                        if error != nil {
                                            print(error!)
                                            return
                                        }
                                        
                                        
                                        
                                        self.picArray.append((metadata?.downloadURL()?.absoluteString)!)
                                        //self.picArray.append((metadata?.downloadURL()?.absoluteString)!)
                                        
                                        
                                        
                                        
                                        var values3 = Dictionary<String, Any>()
                                        print(self.picArray)
                                        values3["onbPictureURL"] = self.picArray
                                        self.ref.child("oneNightBands").child(self.onbID).updateChildValues(values3, withCompletionBlock: {(err, ref) in
                                            if err != nil {
                                                print(err!)
                                                return
                                            }
                                          //  self.performSegue(withIdentifier: "SaveMediaToONB", sender: self)

                                        })
                                    })
                                }
                            }
                            
                        } else {
                            //self.performSegue(withIdentifier: "SaveMediaToONB", sender: self)

                        }

                    })
                    
                }
            }
            
            DispatchQueue.main.async{
                sleep(3)
                self.performSegue(withIdentifier: "SaveMediaToONB", sender: self)
            }
        }*/

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //SwiftOverlays.removeAllBlockingOverlays()
    }
    //**I'm removing the first element everytime rather than at the correct index path. Also might be adding to begginning but appending to array thus creating data inconsistency
    var needToUpdatePics = Bool()
    @IBOutlet weak var picCollectionView: UICollectionView!
    var needToRemovePic = Bool()
    internal func removePic(removalPic: UIImage){
        if profPicArray.count == 1{
            let alert = UIAlertController(title: "Too Few Pictures Error", message: "Must have at least one picture at all times.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else{
        self.currentCollectID = "picsFromPhone"
        needToRemovePic = true
        needToUpdatePics = true
        print("removePic")
        for pic in 0...profPicArray.count-1{
            if removalPic == profPicArray[pic]{
                profPicArray.remove(at: pic)
                DispatchQueue.main.async{
                    self.picCollectionView.deleteItems(at: [IndexPath(row: pic, section: 0)])
                    print("PiccollectionViewCells: \(self.picCollectionView.visibleCells.count)")
                }
                break
            }
        }
        }
        
    }
    
    func handleCancel(){
        /*
        if senderView == "main"{
            self.performSegue(withIdentifier: "AddMediaToMain", sender: self)
        }else{
            performSegue(withIdentifier: "SaveMediaToSession", sender: self)
        }*/if self.senderView == "main"{
        self.performSegue(withIdentifier: "AddMediaToMain", sender: self)
        } else if self.senderView == "session"{
            self.performSegue(withIdentifier: "SaveMediaToSession", sender: self)
        } else {
            self.performSegue(withIdentifier: "SaveMediaToONB", sender: self)
        }

    }
    
   
    var needToRemove = Bool()
    internal func removeVideo(removalVid: NSURL, isYoutube: Bool) {
        print("inRemove")
        if String(describing: removalVid).contains("yout") || String(describing: removalVid).contains("youtu.be") || String(describing: removalVid).contains("You"){
            self.currentCollectID = "youtube"
            self.vidRemovalPressed = true
            needToRemove = true
        
            for vid in 0...youtubeLinkArray.count{
                if removalVid == youtubeLinkArray[vid]{
                    youtubeLinkArray.remove(at: vid)
                    youtubeCollectionView.performBatchUpdates({
                        self.youtubeCollectionView.deleteItems(at:[IndexPath(row: vid, section: 0)])}
                        , completion: nil)
                    break
                }
            }
        }
        else {
            
            self.currentCollectID = "vidFromPhone"
            needToRemove = true
            
            for vid in 0...totalVidArray.count{
                if removalVid == totalVidArray[vid]{
                    totalVidArray.remove(at: vid)
                    vidFromPhoneCollectionView.performBatchUpdates({
                        self.vidFromPhoneCollectionView.deleteItems(at:[IndexPath(row: vid, section: 0)])}
                    , completion: nil)
                    
                    
                    break
                }
            }
        }
        

    }
    
    var picArray = [String]()
    var currentPicker: String?
    @IBOutlet weak var youtubeLinkField: UITextField!
    
    
    weak var dismissalDelegate: DismissalDelegate?
    var ref = Database.database().reference()
    

    var sizingCell = VideoCollectionViewCell()
    var sizingCell2 = PictureCollectionViewCell()
    var currentCollectID = "youtube"
    var currentYoutubeLink: NSURL!
    var youtubeLinkArray = [NSURL]()
    var tempLink: NSURL?
    var sizingCell4: VideoCollectionViewCell?
    let imagePicker = UIImagePickerController()
    var videoCollectEmpty: Bool?
    var recentlyAddedPhoneVid = [String]()
    var profPicArray = [UIImage]()
    var viewDidAppearBool = false
    var onbID = String()
    //var sessionID = String()
    var addedVidDataArray = [Data]()
    var totalVidArray = [NSURL]()
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    @IBOutlet weak var cancelButton: UIButton!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        print(senderView)
        cancelButton.layer.cornerRadius = 15
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel" , style: .plain, target: self, action: #selector(handleCancel))
        //navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.normal)
        print("VDL")
        if senderView == "main"{
            self.vidRemovalPressed = false
            needToRemove = false
            needToRemovePic = false
            imagePicker.delegate = self
            picker.delegate = self
            curCount = 0
            ref.child("users").child(self.userID!).child("profileImageUrl").observeSingleEvent(of: .value, with: { (snapshot) in
                self.ref.child("users").child(self.userID!).child("media").observeSingleEvent(of: .value, with: { (snapshot) in
                    //if self.youtubeLinkArray.count == 0{
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if (snap.value as! String).contains("you") || (snap.value as! String).contains("You"){
                                self.youtubeLinkArray.append(NSURL(string: snap.value as! String)!)
                            } else {
                                self.vidFromPhoneArray.append(NSURL(string: (snap.value as? String)!)!)
                                self.totalVidArray.append(NSURL(string: (snap.value as? String)!)!)
                                // self.totalVidArray.insert(NSURL(string: (snap.value as? String)!)!, at: 0)
                            }
                        }
                        if self.youtubeLinkArray.count == 0{
                           
                            
                        }else{
                            self.videoCollectEmpty = false
                            //for vid in self.youtubeLinkArray{
                                self.currentCollectID = "youtube"
                               // self.tempLink = vid
                                let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                                self.youtubeCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                                
                                self.sizingCell4 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                                self.youtubeCollectionView.backgroundColor = UIColor.clear
                                self.youtubeCollectionView.dataSource = self
                                self.youtubeCollectionView.delegate = self
                                self.curCount += 1
                           // }
                        }
                        print("vvPhone: \(self.vidFromPhoneArray)")
                        if self.totalVidArray.count == 0{
                            print("empty")
                            
                        }else{
                            self.videoCollectEmpty = false
                            
                            //for vid in self.totalVidArray{
                                self.currentCollectID = "vidFromPhone"
                                //self.tempLink = vid
                                //print(self.tempLink)
                                let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                                self.vidFromPhoneCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                                self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                                self.vidFromPhoneCollectionView.backgroundColor = UIColor.clear
                                self.vidFromPhoneCollectionView.dataSource = self
                                self.vidFromPhoneCollectionView.delegate = self
                                self.curCount += 1
                           // }
                        }
                    }
                })
                if self.profPicArray.count == 0{
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if let url = NSURL(string: snap.value as! String){
                                if let data = NSData(contentsOf: url as URL){
                                    self.profPicArray.append(UIImage(data: data as Data)!)
                                }
                            }
                        }
                        
                        //for snap in snapshots{
                            self.currentCollectID = "picsFromPhone"
                            //self.tempLink = NSURL(string: (snap.value as? String)!)
                            let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                            self.picCollectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                            self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                            self.picCollectionView.backgroundColor = UIColor.clear
                            self.picCollectionView.dataSource = self
                            self.picCollectionView.delegate = self
                       // }
                    }
                }
            })
        } else if self.senderView == "session" {
            self.vidRemovalPressed = false
            needToRemove = false
            needToRemovePic = false
            imagePicker.delegate = self
            picker.delegate = self
            curCount = 0
            ref.child("sessions").child(sessionID!).child("sessionPictureURL").observeSingleEvent(of: .value, with: { (snapshot) in
                self.ref.child("sessions").child(self.sessionID!).child("sessionMedia").observeSingleEvent(of: .value, with: { (snapshot) in
                    //if self.youtubeLinkArray.count == 0{
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if (snap.value as! String).contains("you") || (snap.value as! String).contains("You"){
                                self.youtubeLinkArray.append(NSURL(string: snap.value as! String)!)
                            } else {
                                self.vidFromPhoneArray.append(NSURL(string: (snap.value as? String)!)!)
                                self.totalVidArray.append(NSURL(string: (snap.value as? String)!)!)
                                // self.totalVidArray.insert(NSURL(string: (snap.value as? String)!)!, at: 0)
                            }
                        }
                        if self.youtubeLinkArray.count == 0{
                            
                            
                        }else{
                            self.videoCollectEmpty = false
                            //for vid in self.youtubeLinkArray{
                            self.currentCollectID = "youtube"
                            // self.tempLink = vid
                            let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                            self.youtubeCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                            
                            self.sizingCell4 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                            self.youtubeCollectionView.backgroundColor = UIColor.clear
                            self.youtubeCollectionView.dataSource = self
                            self.youtubeCollectionView.delegate = self
                            self.curCount += 1
                            // }
                        }
                        print("vvPhone: \(self.vidFromPhoneArray)")
                        if self.totalVidArray.count == 0{
                            print("empty")
                            
                        }else{
                            self.videoCollectEmpty = false
                            
                            //for vid in self.totalVidArray{
                            self.currentCollectID = "vidFromPhone"
                            //self.tempLink = vid
                            //print(self.tempLink)
                            let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                            self.vidFromPhoneCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                            self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                            self.vidFromPhoneCollectionView.backgroundColor = UIColor.clear
                            self.vidFromPhoneCollectionView.dataSource = self
                            self.vidFromPhoneCollectionView.delegate = self
                            self.curCount += 1
                            // }
                        }
                    }
                })
                if self.profPicArray.count == 0{
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if let url = NSURL(string: snap.value as! String){
                                if let data = NSData(contentsOf: url as URL){
                                    self.profPicArray.append(UIImage(data: data as Data)!)
                                }
                            }
                        }
                        
                        //for snap in snapshots{
                        self.currentCollectID = "picsFromPhone"
                        //self.tempLink = NSURL(string: (snap.value as? String)!)
                        let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                        self.picCollectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                        self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                        self.picCollectionView.backgroundColor = UIColor.clear
                        self.picCollectionView.dataSource = self
                        self.picCollectionView.delegate = self
                        // }
                    }
                }
            })
            } else {
            self.vidRemovalPressed = false
            needToRemove = false
            needToRemovePic = false
            imagePicker.delegate = self
            picker.delegate = self
            curCount = 0
            
                ref.child("oneNightBands").child(onbID).child("onbPictureURL").observeSingleEvent(of: .value, with: { (snapshot) in
                self.ref.child("oneNightBands").child(self.onbID).child("onbMedia").observeSingleEvent(of: .value, with: { (snapshot) in
                    //if self.youtubeLinkArray.count == 0{
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if (snap.value as! String).contains("you") || (snap.value as! String).contains("You"){
                                self.youtubeLinkArray.append(NSURL(string: snap.value as! String)!)
                            } else {
                                self.vidFromPhoneArray.append(NSURL(string: (snap.value as? String)!)!)
                                self.totalVidArray.append(NSURL(string: (snap.value as? String)!)!)
                                // self.totalVidArray.insert(NSURL(string: (snap.value as? String)!)!, at: 0)
                            }
                        }
                        if self.youtubeLinkArray.count == 0{
                            
                            
                        }else{
                            self.videoCollectEmpty = false
                            //for vid in self.youtubeLinkArray{
                            self.currentCollectID = "youtube"
                            // self.tempLink = vid
                            let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                            self.youtubeCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                            
                            self.sizingCell4 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                            self.youtubeCollectionView.backgroundColor = UIColor.clear
                            self.youtubeCollectionView.dataSource = self
                            self.youtubeCollectionView.delegate = self
                            self.curCount += 1
                            // }
                        }
                        print("vvPhone: \(self.vidFromPhoneArray)")
                        if self.totalVidArray.count == 0{
                            print("empty")
                            
                        }else{
                            self.videoCollectEmpty = false
                            
                            //for vid in self.totalVidArray{
                            self.currentCollectID = "vidFromPhone"
                            //self.tempLink = vid
                            //print(self.tempLink)
                            let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                            self.vidFromPhoneCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                            self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                            self.vidFromPhoneCollectionView.backgroundColor = UIColor.clear
                            self.vidFromPhoneCollectionView.dataSource = self
                            self.vidFromPhoneCollectionView.delegate = self
                            self.curCount += 1
                            // }
                        }
                    }
                })
                if self.profPicArray.count == 0{
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if let url = NSURL(string: snap.value as! String){
                                if let data = NSData(contentsOf: url as URL){
                                    self.profPicArray.append(UIImage(data: data as Data)!)
                                }
                            }
                        }
                        
                        //for snap in snapshots{
                        self.currentCollectID = "picsFromPhone"
                        //self.tempLink = NSURL(string: (snap.value as? String)!)
                        let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                        self.picCollectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                        self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                        self.picCollectionView.backgroundColor = UIColor.clear
                        self.picCollectionView.dataSource = self
                        self.picCollectionView.delegate = self
                        // }
                    }
                }
            })
            
            
            
        }

        
    }
    
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.navigationController?.popViewController(animated: false)
                }
        });
    }
    var pickerVidArray = [NSURL]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == youtubeCollectionView{
            
                return youtubeLinkArray.count
    } else if collectionView == vidFromPhoneCollectionView {
            return totalVidArray.count    }
        else {
            return profPicArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView != picCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath as IndexPath) as! VideoCollectionViewCell
            self.configureCell(cell, collectionView: collectionView, forIndexPath: indexPath as NSIndexPath)
            cell.indexPath = indexPath
            
            //self.curIndexPath.append(indexPath)
            self.curCell = cell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath as IndexPath) as! PictureCollectionViewCell
            self.configurePictureCell(cell, forIndexPath: indexPath as NSIndexPath)
            
            
            //self.curIndexPath.append(indexPath)
            
            return cell
        }
        
        
    }
    var vidRemovalPressed: Bool?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if collectionView == vidFromPhoneCollectionView && self.vidRemovalPressed == false {
        if (self.vidFromPhoneCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playbackState == .playing {
            (self.vidFromPhoneCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.stop()
            
        }else{
            (self.vidFromPhoneCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playFromBeginning()
        }

        }
        
    }
    
    func configurePictureCell(_ cell: PictureCollectionViewCell, forIndexPath indexPath: NSIndexPath){
        if self.profPicArray.count != 0{
            print(indexPath.row)
            cell.picImageView.image = self.profPicArray[indexPath.row]//loadImageUsingCacheWithUrlString(String(describing: self.profPicArray[indexPath.row]))
            cell.picData = self.profPicArray[indexPath.row]
            cell.removePicDelegate = self
            cell.deleteButton.isHidden = false
        }
    }
    
    func configureCell(_ cell: VideoCollectionViewCell, collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath) {
        print("configVid")
        print(currentCollectID)
        if collectionView == youtubeCollectionView{
            if self.youtubeLinkArray.count == 0{
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.removeVideoButton.isHidden = true
                cell.videoURL = nil
                cell.player?.view.isHidden = true
                cell.youtubePlayerView.isHidden = true
                //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
                cell.removeVideoButton.isHidden = true
                cell.noVideosLabel.isHidden = false
            } else {
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
                cell.removeVideoButton.isHidden = false
                cell.removeVideoDelegate = self
                cell.youtubePlayerView.isHidden = false
                cell.player?.view.isHidden = true
                
                cell.isYoutube = true
                cell.videoURL = self.youtubeLinkArray[indexPath.row] //NSURL(string: self.youtubeArray[indexPath.row])
                cell.youtubePlayerView.loadVideoURL(self.youtubeLinkArray[indexPath.row] as URL)//NSURL(string: self.recentlyAddedVidArray[indexPath.row])!)
                
                cell.noVideosLabel.isHidden = true
            }
        } else {
            if self.totalVidArray.count == 0 {
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.removeVideoButton.isHidden = true
                cell.videoURL = nil
                cell.player?.view.isHidden = true
                cell.youtubePlayerView.isHidden = true
                //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
                cell.removeVideoButton.isHidden = true
                cell.noVideosLabel.isHidden = false
                
            } else {
      
                cell.youtubePlayerView.isHidden = true
                cell.removeVideoButton.isHidden = false
                cell.noVideosLabel.isHidden = true
                cell.isYoutube = false
                cell.player?.view.isHidden = false
                cell.removeVideoDelegate = self
                //var tempArray = [NSURL]()
                
                //if vidFromPhoneArray.contains(self.recentlyAddedPhoneVidArray[indexPath.row])
                cell.videoURL =  totalVidArray[indexPath.row]
                cell.player?.setUrl(totalVidArray[indexPath.row] as URL)
                //print(self.vidArray[indexPath.row])
                //cell.youtubePlayerView.loadVideoURL(self.vidArray[indexPath.row] as URL)
            }
        }
        
    }


    var recentlyAddedPhoneVidArray = [NSURL]()
    @IBOutlet weak var newImage: UIImageView!
    var isYoutubeCell: Bool?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if currentPicker == "photo"{
            var selectedImageFromPicker: UIImage?
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImageFromPicker = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImageFromPicker = originalImage
            }
            if let selectedImage = selectedImageFromPicker {
                self.recentlyAddedPicArray.append(selectedImage)
                self.profPicArray.append(selectedImage)
                self.needToUpdatePics = true
            }
            self.dismiss(animated: true, completion: nil)
            self.currentCollectID = "picsFromPhone"
            let insertionIndexPath = IndexPath(row: self.profPicArray.count - 1, section: 0)
            picCollectionView.performBatchUpdates({self.picCollectionView.insertItems(at: [insertionIndexPath])}, completion: nil)
        } else {
            //if senderView == "main"{
            if let movieURL = info[UIImagePickerControllerMediaURL] as? NSURL{
                print("MOVURL: \(movieURL)")
                //print("MOVPath: \(moviePath)")
                if let data = NSData(contentsOf: movieURL as! URL){
                    self.addedVidDataArray.append(data as Data) }
                movieURLFromPicker = movieURL
                dismiss(animated: true, completion: nil)
                var tempArray1 = [String]()
                if totalVidArray.count != 0{
                    self.currentCollectID = "vidFromPhone"
                        //self.isYoutubeCell = false
                    self.totalVidArray.append(movieURL)
                    self.vidFromPhoneCollectionView.performBatchUpdates({
                    let insertionIndexPath = IndexPath(row: self.totalVidArray.count - 1, section: 0)
                    self.vidFromPhoneCollectionView.insertItems(at: [insertionIndexPath])}, completion: nil)
                }else{
                    self.currentCollectID = "vidFromPhone"
                    self.totalVidArray.insert(movieURL, at: 0)
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.vidFromPhoneCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.vidFromPhoneCollectionView.backgroundColor = UIColor.clear
                    self.vidFromPhoneCollectionView.dataSource = self
                    self.vidFromPhoneCollectionView.delegate = self
                }
            }
        }
        
           /* }
            else if senderView == "session"{
                
                
                if let movieURL = info[UIImagePickerControllerMediaURL] as? NSURL{
                    print("MOVURL: \(movieURL)")
                    
                    if let data = NSData(contentsOf: movieURL as! URL){
                        self.addedVidDataArray.append(data as Data)
                        
                    }
                    movieURLFromPicker = movieURL
                    dismiss(animated: true, completion: nil)
                    //self.vidFromPhoneArray.append(movieURL)
                                    if totalVidArray.count != 0{
                                        self.currentCollectID = "vidFromPhone"
                                       //self.pickerVidArray.append(movieURL)
                                        self.totalVidArray.insert(movieURL, at: 0)
                                        //self.vidFromPhoneArray.append(movieURL)
                                        
                                        let insertionIndexPath = IndexPath(row: self.totalVidArray.count - 1, section: 0)
                                        self.vidFromPhoneCollectionView.insertItems(at: [insertionIndexPath])
                            
                                    }else{
                                        self.currentCollectID = "vidFromPhone"
                                      
                                      //  self.vidFromPhoneArray.append(movieURL)
                                         //self.pickerVidArray.append(movieURL)
                                       self.totalVidArray.insert(movieURL, at: 0)
                                        let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                                        self.vidFromPhoneCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                                        
                                        self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                                        self.vidFromPhoneCollectionView.backgroundColor = UIColor.clear
                                        self.vidFromPhoneCollectionView.dataSource = self
                                        self.vidFromPhoneCollectionView.delegate = self
                    }
                }
            } else {
                if let movieURL = info[UIImagePickerControllerMediaURL] as? NSURL{
                    print("MOVURL: \(movieURL)")
                    
                    if let data = NSData(contentsOf: movieURL as! URL){
                        self.addedVidDataArray.append(data as Data)
                        
                    }
                    movieURLFromPicker = movieURL
                    dismiss(animated: true, completion: nil)
                    //vidFromPhoneArray.append(movieURL)
                    if totalVidArray.count != 0{
                                        
                                        self.currentCollectID = "vidFromPhone"
                                         self.totalVidArray.append(movieURL)
                                       //self.pickerVidArray.append(movieURL)
                                        //self.vidFromPhoneArray.append(movieURL)
                                        
                                        let insertionIndexPath = IndexPath(row: self.totalVidArray.count - 1, section: 0)
                                        self.vidFromPhoneCollectionView.insertItems(at: [insertionIndexPath])
                        
                                    } else {
                                        self.currentCollectID = "vidFromPhone"
                                        
                                        //self.vidFromPhoneArray.append(movieURL)
                                       //self.pickerVidArray.append(movieURL)
                                         self.totalVidArray.append(movieURL)
                                        let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                                        self.vidFromPhoneCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                                        
                                        self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                                        self.vidFromPhoneCollectionView.backgroundColor = UIColor.clear
                                        self.vidFromPhoneCollectionView.dataSource = self
                                        self.vidFromPhoneCollectionView.delegate = self
                        
                    }
                }
            }*/
    }
    
    
    



    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
        }
    


    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
        
    
}
//crashes when you click remove video button before view fully loads
