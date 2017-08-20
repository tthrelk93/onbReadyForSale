//
//  UploadSessionPopup.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 11/10/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SwiftOverlays
//import Firebase




class UploadSessionPopup: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FeedDismissable, UITextViewDelegate {
    weak var feedDismissalDelegate: FeedDismissalDelegate?
    
    @IBOutlet weak var soloImageView: UIImageView!
    
    @IBOutlet weak var uploadToLiveFeedButton: UIButton!
    @IBOutlet weak var addMediaButton: UIButton!
    @IBOutlet weak var feedPopupView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var sessionCollectionView: UICollectionView!
    
    var sessionArray = [Session]()

    var sessionIDArray = [String]()
    var selectedSession = Session()
    var soloPickerUsed = false
    
    
    @IBOutlet weak var b1Start: UILabel!
    
    @IBOutlet weak var b2Start: UILabel!
    
    @IBOutlet weak var b3Start: UILabel!
    
    @IBOutlet weak var b1P1: UILabel!
    
    @IBOutlet weak var b1P2: UILabel!
    
    @IBOutlet weak var b2P1: UILabel!

    @IBOutlet weak var b2P2: UILabel!
    
    @IBOutlet weak var b2P3: UILabel!
    
    @IBOutlet weak var b3P1: UILabel!
    
    @IBOutlet weak var b3P2: UILabel!
    
    
    
    
    
    @IBOutlet weak var soloSessionNameTextView: UITextField!
    @IBOutlet weak var soloSessTextView: UITextView!
    @IBOutlet weak var soloPicker: UIView!
    @IBAction func cancelSoloPickerPressed(_ sender: Any) {
        self.soloPicker.isHidden = true
        self.soloPickerUsed = false
        self.yourBandsCollect.isHidden = false
        /*self.sessionCollectionView.isHidden = true
        self.selectVideoFromSessionCollect = true*/
        self.uploadBandToFeed.isHidden = false
        //self.soloImageView.isHidden = false
        //self.currentUserNameLabel.isHidden = false
       

    }
    @IBOutlet weak var uploadBandToFeed: UIButton!
    //@IBOutlet weak var soloPicCollect: UICollectionView!
    @IBOutlet weak var soloVidCollect: UICollectionView!
    var ref = Database.database().reference()
    var sizingCell: SessionCell?
    var selectedCellCount = 0
 
    @IBOutlet weak var yourBandsCollect: UICollectionView!
    @IBOutlet weak var currentUserButton: UIButton!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBAction func currentUserButtonPressed(_ sender: Any) {
        self.soloPicker.isHidden = false
        self.soloPickerUsed = true
        self.yourBandsCollect.isHidden = true
        self.sessionCollectionView.isHidden = true
        self.selectVideoFromSessionCollect.isHidden = true
        self.uploadBandToFeed.isHidden = true
        self.soloImageView.isHidden = true
        self.currentUserNameLabel.isHidden = true
        
        
    }
       @IBOutlet weak var selectSessionLabel: UILabel!
    
    @IBOutlet weak var selectVideoLabel: UILabel!
    var onbArray = [String]()
    @IBOutlet weak var selectVideoFromSessionCollect: UICollectionView!
       func backToFeed(){
        //let vc = SessionFeedViewController()
        //present(vc, animated: true, completion: nil)
        performSegue(withIdentifier: "CancelPressed", sender: self)
    }
    var onbObjectArray = [ONB]()
    override func viewWillDisappear(_ animated: Bool) {
        SwiftOverlays.removeAllBlockingOverlays()
    }
    var bandArray = [String]()
    var bandObjectArray = [Band]()
    var bandSessionIDArray = [String]()
    var bandSessionObjectArray = [Session]()
    var bandMedia = [NSURL]()
    var userMediaArray = [String]()
    var userMediaArrayNSURL = [NSURL]()
    var soloPicArray2 = [NSURL]()
    var soloPicArray = [String]()
    var sizingCell12: VideoCollectionViewCell?
    var soloPicURLArray = [UIImage]()
    var soloVidURLArray = [NSURL]()
    
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var onbButton: UIButton!
    @IBOutlet weak var bandButton: UIButton!
    var selectedSoloVidArray = [NSURL]()
    var selectedSoloPicArray = [UIImage]()
    var selectedSoloPicURL = [NSURL]()
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
   /* UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options:
    Options, animations: {*/
    var sessVidOrigin = CGPoint()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sessVidOrigin = self.selectVideoFromSessionCollect.frame.origin
        self.selectSessionLabel.text = "Select Session:"
            //uploadBandToFeed.isHidden = true
        bandButton.bounds = b1Start.bounds
        onbButton.bounds = b2Start.bounds
        soloButton.bounds = b3Start.bounds
    
        self.originalMediaBounds = selectVideoFromSessionCollect.frame
        self.soloSessTextView.delegate = self
        self.soloPicker.isHidden = true
        self.yourBandsCollect.isHidden = true
        self.onbCollect.isHidden = true
        self.selectSessionLabel.isHidden = true
        self.selectVideoLabel.isHidden = true
        self.sessionCollectionView.isHidden = true
        self.selectVideoFromSessionCollect.isHidden = true
        
        //self.soloSessTextView
        self.soloSessTextView.text = "Give a little background on the session you are uploading."
        self.soloSessTextView.textColor = UIColor.black
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "media"{
                        let mediaSnaps = snap.value as! [String]
                        for m_snap in mediaSnaps{
                            //fill youtubeArray
                            self.soloVidURLArray.append(NSURL(string: m_snap)!)
                            self.userMediaArrayNSURL.append(NSURL(string: m_snap)!)
                                    //self.nsurlArray.append(NSURL(string: y_snap)!)
                                    //self.nsurlDict[NSURL(string: y_snap)!] = "y"
                            
                                //fill vidsFromPhone array
                           
                        }
                    }
                        //fill prof pic array
                    if snap.key == "profileImageUrl"{
                        if let tempUrl = NSURL(string: (snap.value as! [String]).first!){
                            //self.soloPicArray2.append(tempUrl)
                            if let data = NSData(contentsOf: tempUrl as URL){
                                self.selectedSoloPicArray.append(UIImage(data: data as Data)!)
                            }
                        }
                    }
    
                    if snap.key == "artistsBands"{
                        for id in (snap.value as! [String]){
                            self.bandArray.append(id)
                        }
                    }
                    if snap.key == "artistsONBs"{
                        for id in (snap.value as! [String]){
                            self.onbArray.append(id)
                        }
                    }
                }
            }
            
            self.ref.child("oneNightBands").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        let tempDict = snap.value as! [String:Any]
                        let tempONB = ONB()
                        if self.onbArray.contains(snap.key){
                            tempONB.setValuesForKeys(tempDict)
                            self.onbObjectArray.append(tempONB)
                        }
                    }
                }
                
            
            

        
        self.ref.child("bands").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let tempDict = snap.value as! [String:Any]
                    let tempBand = Band()
                    if self.bandArray.contains(snap.key){
                        tempBand.setValuesForKeys(tempDict)
                        self.bandObjectArray.append(tempBand)
                    }
                }
            }
           /* for band in self.bandObjectArray{
                for sess in band.bandSessions{
                    self.bandSessionIDArray.append(sess)
                }
            }*/
            DispatchQueue.main.async{
                
                for _ in self.onbArray{
                    self.currentCollect = "onb"
                    
                    //self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                    
                    let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                    self.onbCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                    self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                    self.onbCollect.backgroundColor = UIColor.clear
                    self.onbCollect.dataSource = self
                    self.onbCollect.delegate = self
                }
                for _ in self.bandArray{
                    self.currentCollect = "band"
                    
                    //self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                    
                    let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                    self.yourBandsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                    self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                    self.yourBandsCollect.backgroundColor = UIColor.clear
                    self.yourBandsCollect.dataSource = self
                    self.yourBandsCollect.delegate = self
                }
                //for vid in self.soloVidURLArray{
                    self.currentCollect = "soloVid"
                    
                    //self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                    
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.soloVidCollect.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell12 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.soloVidCollect.backgroundColor = UIColor.clear
                    self.soloVidCollect.dataSource = self
                    self.soloVidCollect.delegate = self
                //}
                /*for picString in self.soloPicArray{
                    if let tempUrl = NSURL(string: picString){
                        self.soloPicArray2.append(tempUrl)
                        if let data = NSData(contentsOf: tempUrl as URL){
                            self.soloPicURLArray.append(UIImage(data: data as Data)!)
                        }
                    }

                }*/
                //for pic in self.soloPicURLArray{
                    /*self.currentCollect = "soloPic"
                    
                    //self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                    
                    let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                    self.soloPicCollect.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                    self.sizingCell3 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                    self.soloPicCollect.backgroundColor = UIColor.clear
                    self.soloPicCollect.dataSource = self
                    self.soloPicCollect.delegate = self*/
               // }
            }

        })
        })
        })
       
               

        navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.60)
        //let backButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(UploadSessionPopup.backToFeed))
        
       // navigationItem.leftBarButtonItem = backButton
        
        //sessionCollectionView.allowsSelection = true
        //loadPastAndCurrentSessions()
        sessionCollectionView.visibleCells.first?.layer.borderWidth = 2
        sessionCollectionView.visibleCells.first?.layer.borderColor = ONBPink.cgColor
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(UploadSessionPopup.backToFeed))
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    var sizingCell3 = PictureCollectionViewCell()
    var currentCollect: String?
    let userID = Auth.auth().currentUser?.uid
    func loadPastAndCurrentSessions(){
          }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == yourBandsCollect{
            return bandArray.count
        }
        if collectionView == onbCollect{
            return onbArray.count
        }
        if collectionView == sessionCollectionView{
            return bandSessionObjectArray.count
        }
        if collectionView == selectVideoFromSessionCollect{
                return bandMedia.count
            }
        if collectionView == soloVidCollect{
            return soloVidURLArray.count
        }
        else {
            return soloPicURLArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == yourBandsCollect || collectionView == sessionCollectionView || collectionView == onbCollect{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for:  indexPath as IndexPath) as! SessionCell
            self.configureCell(cell, collectionView, forIndexPath: indexPath as NSIndexPath)
            return cell
        }
        else if collectionView == soloVidCollect || collectionView == selectVideoFromSessionCollect{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for:  indexPath as IndexPath) as! VideoCollectionViewCell
            self.configureVidCell(cell, collectionView: collectionView, forIndexPath: indexPath as NSIndexPath)
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for:  indexPath as IndexPath) as! PictureCollectionViewCell
            self.configurePicCell(cell, forIndexPath: indexPath as NSIndexPath)
            return cell

        }
    }
    
    
    
    @IBOutlet weak var onbCollect: UICollectionView!
    
    //**
    //DidSelect
    //**
    //var onbVideoArray = [String]()
    var originalMediaBounds = CGRect()
    var mostRecentONBSelected = ONB()
    var onbMediaArray = [String]()
    var sizingCell8: VideoCollectionViewCell?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.des
        if collectionView == yourBandsCollect{
            self.currentCollect = "band"
        }
        if collectionView == onbCollect{
            self.currentCollect = "onb"
        }
        if collectionView == sessionCollectionView{
            self.currentCollect = "session"
        }
        if collectionView == selectVideoFromSessionCollect{
            self.currentCollect = "media"
        }
        /*if collectionView == soloPicCollect{
            self.currentCollect = "soloPic"
        }*/
        if collectionView == soloVidCollect{
            self.currentCollect = "soloVid"
        }
        ref.child("sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //if band collection view cell is touched
            if collectionView == self.onbCollect{
                self.selectVideoFromSessionCollect.frame.origin = self.sessionCollectionView.frame.origin
                self.selectSessionLabel.text = "Select Video:"
               /* self.selectVideoFromSessionCollect.isHidden = true
                
                for cell in self.selectVideoFromSessionCollect.visibleCells{
                    (cell as! VideoCollectionViewCell).isSelected = false
                }*/
                
                self.sessionCollectionView.isHidden = true
                for cell in self.sessionCollectionView.visibleCells{
                    (cell as! SessionCell).isSelected = false
                    (cell as! SessionCell).cellSelected = false
                }
                
                var bandCell = collectionView.cellForItem(at: indexPath) as! SessionCell
                self.selectVideoLabel.isHidden = true
                if bandCell.cellSelected == false{
                    //self.bandSessionObjectArray.removeAll()
                    //self.bandSessionIDArray.removeAll()
                    bandCell.cellSelected = true
                    for cell in collectionView.visibleCells{
                        if cell != bandCell {
                            //collectionView.deselectItem(at: collectionView.indexPath(for: cell)! , animated: true)
                            (cell as! SessionCell).cellSelected = false
                            (cell as! SessionCell).isSelected = false
                        }
                    }
                    bandCell.layer.borderWidth = 2.0
                    bandCell.layer.borderColor = self.ONBPink.cgColor
                    //self.selectedSessionMediaArray.append(self.mostRecentSessionSelected)
                    bandCell.isSelected = true
                    
                    //self.sessionCollectionView.isHidden = false
                    //self.selectSessionLabel.isHidden = false
                    self.mostRecentONBSelected = self.onbObjectArray[indexPath.row]
                    self.bandType = "onb"
                    for vid in self.mostRecentONBSelected.onbMedia{
                        self.onbMediaArray.append(vid)
                    }
                    
                        DispatchQueue.main.async{
                        //for _ in self.onbMediaArray{
                            self.currentCollect = "media"
                            
                            let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                            self.selectVideoFromSessionCollect.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                            self.sizingCell8 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                            self.selectVideoFromSessionCollect.backgroundColor = UIColor.clear
                            self.selectVideoFromSessionCollect.dataSource = self
                            self.selectVideoFromSessionCollect.delegate = self
                            //}
                        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
                        self.onbCollect.reloadData()
                        self.selectVideoFromSessionCollect.reloadData()
                        //self.selectVideoFromSessionCollect.reloadData()
                    }
                    
                }
                else{
                    bandCell.cellSelected = false
                    self.sessionCollectionView.isHidden = true
                    self.selectSessionLabel.isHidden = true
                    self.onbMediaArray.removeAll()
                    //self.bandSessionIDArray.removeAll()
                    
                    self.selectVideoFromSessionCollect.isHidden = true
                    self.selectVideoLabel.isHidden = true
                    self.bandMedia.removeAll()
                    self.selectedSessionMediaArray.removeAll()
                    //let cell = collectionView.cellForItem(at: indexPath) as! SessionCell
                    bandCell.layer.borderColor = UIColor.clear.cgColor
                    bandCell.isSelected = false
                }
            }

            if collectionView == self.yourBandsCollect{
                self.selectVideoFromSessionCollect.frame.origin = self.sessVidOrigin
                self.selectSessionLabel.text = "Select Session:"
                self.selectVideoFromSessionCollect.isHidden = true
                
                for cell in self.selectVideoFromSessionCollect.visibleCells{
                    (cell as! VideoCollectionViewCell).isSelected = false
                }
                
                /*self.sessionCollectionView.isHidden = true
                for cell in self.sessionCollectionView{
                    (cell as! SessionCell).isSelected = false
                }*/

                self.selectVideoFromSessionCollect.frame = self.originalMediaBounds
                var bandCell = collectionView.cellForItem(at: indexPath) as! SessionCell
                self.selectVideoLabel.isHidden = true
                if bandCell.cellSelected == false{
                    self.bandSessionObjectArray.removeAll()
                    self.bandSessionIDArray.removeAll()
                    bandCell.cellSelected = true
                    for cell in collectionView.visibleCells{
                        if cell != bandCell {
                            //collectionView.deselectItem(at: collectionView.indexPath(for: cell)! , animated: true)
                            (cell as! SessionCell).cellSelected = false
                            (cell as! SessionCell).isSelected = false
                        }
                    }
                        bandCell.layer.borderWidth = 2.0
                        bandCell.layer.borderColor = self.ONBPink.cgColor
                        //self.selectedSessionMediaArray.append(self.mostRecentSessionSelected)
                        bandCell.isSelected = true

                        self.sessionCollectionView.isHidden = false
                    self.selectSessionLabel.isHidden = false
                    self.mostRecentBandSelected = self.bandObjectArray[indexPath.row]
                    self.bandType = "band"
                    for sess in self.mostRecentBandSelected.bandSessions{
                        self.bandSessionIDArray.append(sess)
                    }
                
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            print("inside ref")
                            for snap in snapshots{
                                let tempDict = snap.value as! [String:Any]
                                let tempSess = Session()
                                if self.bandSessionIDArray.contains(snap.key){
                                    tempSess.setValuesForKeys(tempDict)
                                    self.bandSessionObjectArray.append(tempSess)
                                        }
                                self.bandSessionObjectArray.reverse()
                
                
                            }
                        }
                        DispatchQueue.main.async{
                            //for _ in self.bandSessionObjectArray{
                            
                                self.currentCollect = "session"
                        
                                //self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                        
                                let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                self.sessionCollectionView.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                self.sessionCollectionView.backgroundColor = UIColor.clear
                                self.sessionCollectionView.dataSource = self
                                self.sessionCollectionView.delegate = self
                            
                            collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
                            self.yourBandsCollect.reloadData()
                            self.sessionCollectionView.reloadData()
                            //self.selectVideoFromSessionCollect.reloadData()
                    }
                
                }
                else{
                    bandCell.cellSelected = false
                    self.sessionCollectionView.isHidden = true
                    self.selectSessionLabel.isHidden = true
                    self.bandSessionObjectArray.removeAll()
                    self.bandSessionIDArray.removeAll()
                    self.selectVideoFromSessionCollect.frame = self.sessionCollectionView.frame
                    
                    self.selectVideoFromSessionCollect.isHidden = true
                    self.selectVideoLabel.isHidden = true
                    self.bandMedia.removeAll()
                    self.selectedSessionMediaArray.removeAll()
                    //let cell = collectionView.cellForItem(at: indexPath) as! SessionCell
                    bandCell.layer.borderColor = UIColor.clear.cgColor
                    bandCell.isSelected = false
                }
            }
        //if session collection view cell is touched
        if collectionView == self.sessionCollectionView{
            self.selectVideoLabel.isHidden = false
            let sessCell = collectionView.cellForItem(at: indexPath) as! SessionCell
            if sessCell.cellSelected == false{
                sessCell.cellSelected = true
                self.bandMedia.removeAll()
    
            sessCell.layer.borderWidth = 2.0
            sessCell.layer.borderColor = self.ONBPink.cgColor
            //self.selectedSessionMediaArray.append(self.mostRecentSessionSelected)
            sessCell.isSelected = true
            
            for cell in collectionView.visibleCells{
                if cell != sessCell {
                    //collectionView.deselectItem(at: collectionView.indexPath(for: cell)! , animated: true)
                    (cell as! SessionCell).cellSelected = false
                    (cell as! SessionCell).isSelected = false
                }
            }

            self.selectVideoFromSessionCollect.isHidden = false
            self.mostRecentSessionSelected = self.bandSessionObjectArray[indexPath.row]
                
                for sess in self.bandSessionObjectArray{
                    if sess.sessionUID == sessCell.sessionId {
                        if sess.sessionMedia.count != 0{
                            //if (sess.sessionMedia.keys.contains("youtube")){
                            
                                for vid in sess.sessionMedia{
                                    self.bandMedia.append(NSURL(string: vid)!)
                                }
                            }
                            /*if (sess.sessionMedia.keys.contains("vidsFromPhone")){
                            
                            let tempMediaArray2 = sess.sessionMedia["vidsFromPhone"] as! [String]
                            for vid in tempMediaArray2{
                                self.bandMedia.append(NSURL(string: vid)!)
                            }
                    }
                    }*/
                    
                    }
                }
                DispatchQueue.main.async{
                    
                        self.currentCollect = "media"
                        
                        //self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                        
                        let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                        self.selectVideoFromSessionCollect.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                        self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                        self.selectVideoFromSessionCollect.backgroundColor = UIColor.clear
                        self.selectVideoFromSessionCollect.dataSource = self
                        self.selectVideoFromSessionCollect.delegate = self
                        
                    
                    collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
                    //collectionView.visibleCells[indexPath.row] as Session = !collectionView.visibleCells[indexPath.row].selected
                    //self.yourBandsCollect.reloadData()
                    self.sessionCollectionView.reloadData()
                    self.selectVideoFromSessionCollect.reloadData()
                    
                }
            }
                
            else{
                sessCell.cellSelected = false
                self.selectVideoFromSessionCollect.isHidden = true
                self.bandMedia.removeAll()
                self.selectedSessionMediaArray.removeAll()
                //let cell = collectionView.cellForItem(at: indexPath) as! SessionCell
                sessCell.layer.borderColor = UIColor.clear.cgColor
                sessCell.isSelected = false
              
            }
        }
        //if media cell selected
        if collectionView == self.selectVideoFromSessionCollect{
            let cell = collectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell
            cell.touchBlockingView.isHidden = false
            if cell.cellSelected == false{
                cell.cellSelected = true
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = self.ONBPink.cgColor
                if self.bandType == "band"{
                    self.selectedSessionMediaArray.append(self.bandMedia[indexPath.row])
                } else {
                    self.selectedSessionMediaArray.append(NSURL(string: self.onbMediaArray[indexPath.row])!)
                }
                cell.isSelected = true
                cell.playPauseButton.isEnabled = false
            }else{
                cell.cellSelected = false
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.isSelected = false
                 cell.playPauseButton.isEnabled = false
                //could cause problems
                self.selectedSessionMediaArray.remove(at: self.selectedSessionMediaArray.index(of: self.bandMedia[indexPath.row])!)
            }
            print(self.selectedSessionMediaArray)
    
            
        
            }
        })
        /*if collectionView == soloPicCollect{
            let cell = collectionView.cellForItem(at: indexPath) as! PictureCollectionViewCell
            if cell.cellSelected == false{
                cell.cellSelected = true
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = ONBPink.cgColor
                self.selectedSoloPicArray.append(self.soloPicURLArray[indexPath.row])
                selectedSoloPicURL.append(self.soloPicArray2[indexPath.row])
                cell.isSelected = true
            } else{
                cell.cellSelected = false
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.isSelected = false
                self.selectedSoloPicArray.remove(at: indexPath.row)
                selectedSoloPicURL.remove(at: indexPath.row)

            }

            
        }*/
        if collectionView == soloVidCollect{
            let cell = collectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell
            if cell.cellSelected == false{
                cell.cellSelected = true
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = ONBPink.cgColor
                self.selectedSoloVidArray.append(self.soloVidURLArray[indexPath.row])
                cell.isSelected = true
            } else{
                cell.cellSelected = false
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.isSelected = false
                self.selectedSoloVidArray.remove(at: indexPath.row)
                
            }
            
            
        }

        
    
    //collectionView.reloadData()
        
        
    }
    
    var selectedSessionMediaArray = [NSURL]()
    var sizingCell2 = VideoCollectionViewCell()
    var mostRecentSessionSelected = Session()
    var mostRecentBandSelected = Band()
    
    func configurePicCell(_ cell: PictureCollectionViewCell, forIndexPath indexPath: NSIndexPath){
        if soloPicURLArray.count == 0{
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2
            cell.deleteButton.isHidden = true
        }else{
            cell.picImageView.image = self.soloPicURLArray[indexPath.row]
            cell.deleteButton.isHidden = true
        }
    }

    func configureVidCell(_ cell: VideoCollectionViewCell, collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath){
        //cell.player.isHidden = true
        //cell.youtubePlayerView.isHidden = true
        cell.youtubePlayerView.isUserInteractionEnabled = false
        cell.playPauseButton.isHidden = true
        cell.touchBlockingView.isHidden = false
        cell.isSelected = false
        cell.cellSelected = false
        if collectionView != soloVidCollect{
            if self.bandType == "band"{
                if bandMedia.count == 0{
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.borderWidth = 2
                    cell.removeVideoButton.isHidden = true
                    cell.videoURL = nil
                    cell.player?.view.isHidden = true
                    cell.youtubePlayerView.isHidden = true
                    //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
                    cell.removeVideoButton.isHidden = true
                    cell.noVideosLabel.isHidden = false
                }else {
                    
                    cell.touchBlockingView.isHidden = false
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.borderWidth = 0
                    
                    //cell.youtubePlayerView.isHidden = true
                    cell.removeVideoButton.isHidden = true
                    cell.noVideosLabel.isHidden = true
                    cell.videoURL =  self.bandMedia[indexPath.row] as NSURL?
                    if(String(describing: cell.videoURL).contains("youtube") || String(describing: cell.videoURL).contains("youtu.be")){
                        print("youtubeSelected")
                        cell.youtubePlayerView.loadVideoURL(cell.videoURL as! URL)
                       // cell.youtubePlayerView.isHidden = true
                        cell.player?.view.isHidden = true
                        cell.playPauseButton.isHidden = true
                        cell.isYoutube = true
                    }else{
                        print("vidFromPhoneSelected")
                        cell.player?.setUrl(cell.videoURL as! URL)
                        cell.player?.view.isHidden = false
                       // cell.youtubePlayerView.isHidden = true
                        cell.playPauseButton.isHidden = true
                        cell.isYoutube = false
                    }
                }
            } else if self.bandType == "onb"{
                if onbMediaArray.count == 0{
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.borderWidth = 2
                    cell.removeVideoButton.isHidden = true
                    cell.videoURL = nil
                    cell.player?.view.isHidden = true
                    cell.youtubePlayerView.isHidden = true
                    //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
                    cell.removeVideoButton.isHidden = true
                    cell.noVideosLabel.isHidden = false
                }else {
                    
                    cell.touchBlockingView.isHidden = false
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.borderWidth = 0
                    
                    //cell.youtubePlayerView.isHidden = true
                    cell.removeVideoButton.isHidden = true
                    cell.noVideosLabel.isHidden = true
                    cell.videoURL =  NSURL(string: self.onbMediaArray[indexPath.row])
                    if(String(describing: cell.videoURL).contains("youtube") || String(describing: cell.videoURL).contains("youtu.be")){
                        print("youtubeSelected")
                        //cell.youtubePlayerView.loadVideoURL(cell.videoURL as! URL)
                        // cell.youtubePlayerView.isHidden = true
                        cell.player?.view.isHidden = true
                        cell.playPauseButton.isHidden = true
                        cell.isYoutube = true
                    }else{
                        print("vidFromPhoneSelected")
                        cell.player?.setUrl(cell.videoURL as! URL)
                        cell.player?.view.isHidden = false
                        // cell.youtubePlayerView.isHidden = true
                        cell.playPauseButton.isHidden = true
                        cell.isYoutube = false
                    }
                }
            }
        } else {
            if soloVidURLArray.count == 0{
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.removeVideoButton.isHidden = true
                cell.videoURL = nil
                cell.player?.view.isHidden = true
                cell.youtubePlayerView.isHidden = true
                //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
                cell.removeVideoButton.isHidden = true
                cell.noVideosLabel.isHidden = false
            }else {
                
                cell.touchBlockingView.isHidden = false
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
                
                //cell.youtubePlayerView.isHidden = true
                cell.removeVideoButton.isHidden = true
                cell.noVideosLabel.isHidden = true
                
                
                
                
                cell.videoURL =  self.soloVidURLArray[indexPath.row] as NSURL?
                if(String(describing: cell.videoURL).contains("youtube") || String(describing: cell.videoURL).contains("youtu.be")){
                    print("youtubeSelected")
                    cell.youtubePlayerView.loadVideoURL(cell.videoURL as! URL)
                    // cell.youtubePlayerView.isHidden = true
                    cell.player?.view.isHidden = true
                    cell.playPauseButton.isHidden = true
                    cell.isYoutube = true
                }else{
                    print("vidFromPhoneSelected")
                    cell.player?.setUrl(cell.videoURL as! URL)
                    cell.player?.view.isHidden = false
                    // cell.youtubePlayerView.isHidden = true
                    cell.playPauseButton.isHidden = true
                    cell.isYoutube = false
                }
                //print(self.vidArray[indexPath.row])
                //cell.youtubePlayerView.loadVideoURL(self.vidArray[indexPath.row] as URL)
                //self.group.leave()
            }
        }
        

    }
    @IBAction func soloSessionPressed(_ sender: Any) {
       // self.selectVideoFromSessionCollect.frame.origin = sessionCollectionView.frame.origin
        
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options:
            animationOptions, animations: {
                self.bandButton.bounds = self.b1P2.bounds
                 self.onbButton.bounds = self.b2P3.bounds
                 self.soloButton.bounds = self.b3P1.bounds
                
                self.bandButton.frame.origin = self.b1P2.frame.origin
                self.onbButton.frame.origin = self.b2P3.frame.origin
                self.soloButton.frame.origin = self.b3P1.frame.origin
               
                
               
               
                
        })
        self.bandType = "solo"
        self.soloPicker.isHidden = false
        self.soloPickerUsed = true
        self.yourBandsCollect.isHidden = true
        self.onbCollect.isHidden = true
        self.sessionCollectionView.isHidden = true
        self.selectVideoFromSessionCollect.isHidden = true
        self.uploadBandToFeed.isHidden = true
        self.selectVideoLabel.isHidden = true
        self.yourBandsLabel.isHidden = true
        self.selectSessionLabel.isHidden = true
        self.yourONBsLabel.isHidden = true
        

    }
    @IBAction func bandTypePressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options:
            animationOptions, animations: {
                self.selectVideoFromSessionCollect.frame.origin = self.sessVidOrigin
                self.selectSessionLabel.text = "Select Session:"
                self.bandButton.bounds = self.b1P1.bounds
                self.onbButton.bounds = self.b2P2.bounds
                self.soloButton.bounds = self.b3P2.bounds

                self.bandButton.frame.origin = self.b1P1.frame.origin
                self.onbButton.frame.origin = self.b2P2.frame.origin
                self.soloButton.frame.origin = self.b3P2.frame.origin
                
                       })
        
        self.soloPicker.isHidden = true
        //self.soloPickerUsed = false
        self.onbCollect.isHidden = true
        self.yourBandsCollect.isHidden = false
        self.bandType = "band"
        self.sessionCollectionView.isHidden = true
        self.selectVideoFromSessionCollect.isHidden = true
        self.uploadBandToFeed.isHidden = false
        yourONBsLabel.isHidden = true
        yourBandsLabel.isHidden = false
        self.selectVideoLabel.isHidden = true
        self.yourBandsLabel.isHidden = false
        self.selectSessionLabel.isHidden = true
        self.yourONBsLabel.isHidden = true
       

    }
    @IBAction func oneNightBandTypePressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options:
            animationOptions, animations: {
                self.selectVideoFromSessionCollect.frame.origin = self.sessionCollectionView.frame.origin
                self.selectSessionLabel.text = "Select Video:"
                self.bandButton.bounds = self.b1P2.bounds
                self.onbButton.bounds = self.b2P1.bounds
                self.soloButton.bounds = self.b3P2.bounds
                self.bandButton.frame.origin = self.b1P2.frame.origin
                self.onbButton.frame.origin = self.b2P1.frame.origin
                self.soloButton.frame.origin = self.b3P2.frame.origin
                
               
        })
        
        self.soloPicker.isHidden = true
        //self.soloPickerUsed = false
        self.onbCollect.isHidden = false
        self.yourBandsCollect.isHidden = true
        
        self.bandType = "onb"
        self.sessionCollectionView.isHidden = true
        self.selectVideoLabel.isHidden = true
        self.yourBandsLabel.isHidden = true
        self.selectSessionLabel.isHidden = true
        self.yourONBsLabel.isHidden = false
        self.selectVideoFromSessionCollect.isHidden = true
        self.uploadBandToFeed.isHidden = false
        yourONBsLabel.isHidden = false
        yourBandsLabel.isHidden = true
    }
    @IBOutlet weak var yourONBsLabel: UILabel!
    @IBOutlet weak var yourBandsLabel: UILabel!
    func configureCell(_ cell: SessionCell,_ collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath) {
        //print(self.currentCollect)
        if collectionView == self.onbCollect{
            if self.onbObjectArray.count == 0{
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.textColor = UIColor.white
                
                cell.sessionCellLabel.text = "No ONBs"
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.white.cgColor
            } else {
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString(onbObjectArray[indexPath.row].onbPictureURL[0])
                cell.sessionCellLabel.text = onbObjectArray[indexPath.row].onbName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.layer.borderWidth = cell.cellSelected ? 2 : 0
                cell.layer.borderColor = cell.cellSelected ? ONBPink.cgColor : UIColor.clear.cgColor
                cell.sessionId = onbArray[indexPath.row]
            }
        }
        if collectionView == self.yourBandsCollect{
            print(bandObjectArray[indexPath.row].bandPictureURL[0])
            //print(bandObjectArray)
            if self.bandObjectArray.count == 0{
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.textColor = UIColor.white

                cell.sessionCellLabel.text = "No Bands"
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.white.cgColor
            } else {
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString(bandObjectArray[indexPath.row].bandPictureURL[0])
                cell.sessionCellLabel.text = bandObjectArray[indexPath.row].bandName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.layer.borderWidth = cell.cellSelected ? 2 : 0
                cell.layer.borderColor = cell.cellSelected ? ONBPink.cgColor : UIColor.clear.cgColor
                
                cell.sessionId = bandArray[indexPath.row]
            }

        }
        
        if collectionView == self.sessionCollectionView{
            if self.bandSessionObjectArray.count == 0{
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.textColor = UIColor.white
                
                cell.sessionCellLabel.text = "No Sessions"
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.white.cgColor
            } else {
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString(bandSessionObjectArray[indexPath.row].sessionPictureURL[0])
                cell.sessionCellLabel.text = bandSessionObjectArray[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.layer.borderWidth = cell.cellSelected ? 2 : 0
                cell.layer.borderColor = cell.cellSelected ? ONBPink.cgColor : UIColor.clear.cgColor

                cell.sessionId = bandSessionIDArray[indexPath.row]
            }
        }
        if collectionView == self.selectVideoFromSessionCollect{
            cell.sessionCellImageView.loadImageUsingCacheWithUrlString(bandSessionObjectArray[indexPath.row].sessionPictureURL[0])
            cell.sessionCellLabel.text = bandSessionObjectArray[indexPath.row].sessionName
            cell.sessionCellLabel.textColor = UIColor.white
            cell.layer.borderWidth = cell.cellSelected ? 2 : 0
            cell.layer.borderColor = cell.cellSelected ? ONBPink.cgColor : UIColor.clear.cgColor
            
            cell.sessionId = bandSessionIDArray[indexPath.row]
        }
        
        }
    var soloPressed = Bool()

    @IBAction func uploadSoloPressed(_ sender: Any) {
        if (self.selectedSoloVidArray.count != 0 || self.selectedSoloPicArray.count != 0) && self.soloSessTextView.text.isEmpty == false && self.soloSessionNameTextView.text?.isEmpty == false{
            soloPressed = true
            SwiftOverlays.showBlockingWaitOverlayWithText("Uploading to Feed") //showBlockingWaitTextOverlay("Uploading Session to Feed")
            
            uploadMovieToFirebaseStorage()
            
        }else{
            let alert = UIAlertController(title: "Missing Info", message: "One or more of the required fields is missing.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

    }
 
    func textViewDidBeginEditing(_ textView: UITextView) {
        if soloSessTextView.textColor == UIColor.black {
            soloSessTextView.text = nil
            soloSessTextView.textColor = ONBPink
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if soloSessTextView.text.isEmpty {
            soloSessTextView.text = "Give a little background on the session you are uploading."
            soloSessTextView.textColor = UIColor.black
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
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction func cancelTouched(_ sender: AnyObject) {
        feedDismissalDelegate?.finishedShowing(viewController: self)

        removeAnimate()
    }
    
    
    func dateFormatted(dateString: String)->Date{
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yy"
        
        dateFormatter.dateFormat = "MM-dd-yy"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateObj = dateFormatter.date(from: dateString)
        
        
        return(dateObj)!
        
    }
    let imagePickerController = UIImagePickerController()
    var videoURL: NSURL?
    
    
    
    var sessionVideoURL: String?
    var downloadURL: URL?
    var mediaArray = [String]()
    var autoIdString = String()
    @IBAction func Upload(_ sender: AnyObject) {
        if (self.bandType == "band" && self.selectedSessionMediaArray.count != 0) || (self.bandType == "onb" && self.onbMediaArray.count != 0){
            
           
                SwiftOverlays.showBlockingTextOverlay("Uploading Session to Feed")
                
                uploadMovieToFirebaseStorage()
           // }
        }else{
            let alert = UIAlertController(title: "Missing Info", message: "Select upload type at top of screen and make sure all required forms are filled.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    var feedArray = [SessionFeedSess]()
    var bandType = String()
    func uploadMovieToFirebaseStorage(){
        if bandType == "solo"{
            print("in Solo, sender: \(bandType)")
            let recipient = self.ref.child("sessionFeed")
            let recipient2 = self.ref.child("users")
            var values = Dictionary<String, Any>()
            var values2 = Dictionary<String, Any>()
            
            values["sessionName"] = self.soloSessionNameTextView.text
            values["sessionArtists"] = [userID!: "-"] as [String: Any]
            values["sessionBio"] = self.soloSessTextView.text
            values["sessionDate"] = ""
            values["sessionID"] = ""
            values["bandID"] = self.userID
            values["pickedBool"] = "false"
            values["bandType"] = "solo"
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots{
                            if snap.key == "name"{
                                
                                values["bandName"] = snap.value as! String
                            }
                        }
                    }
                })

            
           // values["bandName"] = self.ref.child("users").child(userID!).child("name").observeSingleEvent(of: .value, with: snapshot)
            
            var tempArray = [String]()
            
            values["picks"] = 0
            var tempVidArray = [String]()
            for vid in selectedSoloVidArray{
                tempVidArray.append(String(describing: vid))
            }
            
            values["sessionMedia"] = tempVidArray
            values["soloSessBool"] = "true"
            
           
            
            
            
            
            for url in self.selectedSoloVidArray{
                
                let videoName = NSUUID().uuidString
                let storageRef = Storage.storage().reference(withPath: "session_videos/").child("\(videoName).mov")
                let uploadMetadata = StorageMetadata()
                uploadMetadata.contentType = "video/quicktime"
                let uploadTask = storageRef.putFile(from: url as URL, metadata: uploadMetadata){(metadata, error) in
                    if(error != nil){
                        print("got an error: \(error)")
                    }else{
                        print("upload complete: metadata = \(metadata)")
                        print("download url = \(metadata?.downloadURL())")
                    }
                }
            }
            for pic in selectedSoloPicArray{
               // print("soloPic:\(pic)")
            //soloPic
            
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images/").child("\(imageName).jpg")
                if let uploadData = UIImageJPEGRepresentation(pic, 0.1) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        tempArray.append((metadata?.downloadURL()?.absoluteString)!)
                        values["sessionPictureURL"] = tempArray
                    })
                }
            }
            
            let autoId = recipient.childByAutoId()
            var keyString = autoId.key
            var sessionFeedSess = SessionFeedSess()
            
            self.ref.child("sessionFeed").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots{
                        var tempDict = snap.value as! [String:Any]
                        var tempSess = SessionFeedSess()
                        tempSess.setValuesForKeys(tempDict)
                        self.feedArray.append(tempSess)
                    }
                }
                var mult = Int()
                if self.feedArray.count == 0 {
                    mult = 0
                } else {
                    mult = self.feedArray.count - 1
                }
                let button = ONBGuitarButton()
                button.initWithLane(lane: Int(arc4random_uniform(6)))
                button.setYPosition(yPosition: (3 - CGFloat(mult)) * 2.3)
                button.sessionFeedKey = keyString
                button.isDisplayed = Bool()
                button.sessionName = self.soloSessionNameTextView.text
                values["button"] = [String:Any]()
                
                //button.session = values
                let tap = UITapGestureRecognizer(target: self, action: #selector(SessionFeedViewController.scrollToPin))
                
                tap.numberOfTapsRequired = 1
                //button.tap = tap
                button.addGestureRecognizer(tap)
                button.isUserInteractionEnabled = true
                
                button.picks = 0
                //sessionFeedSess.button = button.dictionaryWithValues(forKeys: <#T##[String]#>)
                
                
                var buttonDict = [String: Any]()
                buttonDict["lane"] = button.lane
                buttonDict["sessionName"] = button.sessionName
                //buttonDict["session"] = values
                buttonDict["picks"] = 0
                buttonDict["isDisplayed"] = button.isDisplayed
                //buttonDict["tap"] = NSObject()
                buttonDict["_yPosition"] = button._yPosition
                buttonDict["_slope"] = button._slope
                buttonDict["_baseX"] = button._baseX
                buttonDict["sessionFeedKey"] = button.sessionFeedKey
                buttonDict["kStartY"] = button.kStartY
                buttonDict["kMaxY"] = button.kMaxY
                //buttonDict["isUserInteractionEnabled"] = button.isUserInteractionEnabled
                
                values["button"] = buttonDict
                
                print("valuesb4theUpload: \(values)")
            autoId.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
                
                
            })
            recipient2.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
                DispatchQueue.main.async {
                    print("segue")
                    self.performSegue(withIdentifier: "CancelPressed", sender: self)
                }
            })
                })
        }
        if bandType == "onb"{
            let recipient = self.ref.child("sessionFeed")
            let recipient2 = self.ref.child("oneNightBands").child(self.mostRecentONBSelected.onbID)
           // let recipient3 = self.ref.child("sessions").child(self.mostRecentSessionSelected.sessionUID)
            //print("mrss.sessionUID: \(self.mostRecentSessionSelected.sessionUID)")
            var selectedMediaAsString = [String]()
            for url in self.selectedSessionMediaArray{
                selectedMediaAsString.append(String(describing: url))
            }
            
            var values = Dictionary<String, Any>()
            var values2 = Dictionary<String, Any>()
            var values3 = Dictionary<String, Any>()
            values["bandID"] = self.mostRecentONBSelected.onbID
            values["sessionName"] = ""//self.mostRecentBandSelected.bandName
            values["bandName"] = self.mostRecentONBSelected.onbName
            values["sessionArtists"] = self.mostRecentONBSelected.onbArtists
            values["sessionInfo"] = self.mostRecentONBSelected.onbInfo
            values["sessionDate"] = self.mostRecentONBSelected.onbDate
            values["sessionID"] = ""//self.mostRecentONBSelected.sessionUID
            values["pickedBool"] = "false"
            values["soloSessBool"] = "false"
            //values["bandType"] = self.bandType
            ///
            values["sessionPictureURL"] = self.mostRecentSessionSelected.sessionPictureURL
            values["picks"] = 0
            var tempVidArray = [String]()
            for vid in selectedSessionMediaArray{
                tempVidArray.append(String(describing: vid))
            }
            
            values["sessionMedia"] = tempVidArray
            
            var tempSessArray = (self.mostRecentBandSelected.sessionsOnFeed)
            tempSessArray.append(self.mostRecentSessionSelected.sessionUID)
            values2["sessionsOnFeed"] = tempSessArray
            
            var tempURLArray = self.mostRecentSessionSelected.sessFeedMedia
            if tempURLArray == nil{
                tempURLArray = [String]()
            }
            for url in self.selectedSessionMediaArray{
                if tempURLArray?.count != 0{
                    
                    tempURLArray!.append(String(describing: url))
                    
                } else {
                    tempURLArray!.append(String(describing: url))
                }
                let videoName = NSUUID().uuidString
                let storageRef = Storage.storage().reference(withPath: "onb_videos/").child("\(videoName).mov")
                let uploadMetadata = StorageMetadata()
                uploadMetadata.contentType = "video/quicktime"
                let uploadTask = storageRef.putFile(from: url as URL, metadata: uploadMetadata){(metadata, error) in
                    if(error != nil){
                        print("got an error: \(error)")
                    }else{
                        print("upload complete: metadata = \(metadata)")
                        print("download url = \(metadata?.downloadURL())")
                    }
                }
                
            }
            values3["sessFeedMedia"] = tempURLArray
            
            let autoId = recipient.childByAutoId()
            
            var keyString = autoId.key
            var sessionFeedSess = SessionFeedSess()
            
            self.ref.child("sessionFeed").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots{
                        var tempDict = snap.value as! [String:Any]
                        var tempSess = SessionFeedSess()
                        tempSess.setValuesForKeys(tempDict)
                        self.feedArray.append(tempSess)
                    }
                }
                var mult = self.feedArray.count + 1
                let button = ONBGuitarButton()
                button.initWithLane(lane: Int(arc4random_uniform(6)))
                button.setYPosition(yPosition: (3 - CGFloat(mult)) * 2.3)
                button.sessionFeedKey = keyString
                button.isDisplayed = false
                button.sessionName = self.soloSessionNameTextView.text
                values["button"] = [String:Any]()
                sessionFeedSess.setValuesForKeys(values)
                // button.session = values
                let tap = UITapGestureRecognizer(target: self, action: #selector(SessionFeedViewController.scrollToPin))
                
                tap.numberOfTapsRequired = 1
                //button.tap = tap
                button.addGestureRecognizer(tap)
                button.isUserInteractionEnabled = true
                
                button.picks = 0
                //sessionFeedSess.button = button.dictionaryWithValues(forKeys: <#T##[String]#>)
                
                
                var buttonDict = [String: Any]()
                buttonDict["lane"] = button.lane
                buttonDict["sessionName"] = button.sessionName
                //buttonDict["session"] = values
                buttonDict["picks"] = 0
                buttonDict["isDisplayed"] = button.isDisplayed
                //buttonDict["tap"] = NSObject()
                buttonDict["_yPosition"] = button._yPosition
                buttonDict["_slope"] = button._slope
                buttonDict["_baseX"] = button._baseX
                buttonDict["sessionFeedKey"] = button.sessionFeedKey
                buttonDict["kStartY"] = button.kStartY
                buttonDict["kMaxY"] = button.kMaxY
                //buttonDict["isUserInteractionEnabled"] = button.isUserInteractionEnabled
                
                values["button"] = buttonDict
                
                
                //self.autoIdString = String(describing: autoId)
                autoId.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err as Any)
                        return
                    }
                })
                recipient2.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                })
                /*recipient3.updateChildValues(values3, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    self.performSegue(withIdentifier: "CancelPressed", sender: self)
                })*/
                /*uploadTask.observe(.progress){[weak self] (snapshot) in
                 guard let strongSelf = self else {return}
                 guard let progress = snapshot.progress else {return}
                 strongSelf.progressView.progress = Float(progress.fractionCompleted)
                 print("Uploaded \(progress.completedUnitCount) so far")
                 
                 }*/
                
            })
        

    
        }
        if bandType == "band"{
                let recipient = self.ref.child("sessionFeed")
                let recipient2 = self.ref.child("bands").child(self.mostRecentBandSelected.bandID!)
                let recipient3 = self.ref.child("sessions").child(self.mostRecentSessionSelected.sessionUID)
                print("mrss.sessionUID: \(self.mostRecentSessionSelected.sessionUID)")
                var selectedMediaAsString = [String]()
                for url in self.selectedSessionMediaArray{
                    selectedMediaAsString.append(String(describing: url))
                }
        
                        var values = Dictionary<String, Any>()
                        var values2 = Dictionary<String, Any>()
                        var values3 = Dictionary<String, Any>()
                        values["bandID"] = self.mostRecentBandSelected.bandID
            values["bandName"] = self.mostRecentBandSelected.bandName
                        values["sessionName"] = self.mostRecentSessionSelected.sessionName
                        values["sessionArtists"] = self.mostRecentBandSelected.bandMembers
                        values["sessionBio"] = self.mostRecentSessionSelected.sessionBio
                        values["sessionDate"] = self.mostRecentSessionSelected.sessionDate
                        values["sessionID"] = self.mostRecentSessionSelected.sessionUID
            values["pickedBool"] = "false"
            values["soloSessBool"] = "false"
            values["bandType"] = self.bandType
        ///
                        values["sessionPictureURL"] = self.mostRecentSessionSelected.sessionPictureURL
                        values["picks"] = 0
        var tempVidArray = [String]()
        for vid in selectedSessionMediaArray{
            tempVidArray.append(String(describing: vid))
        }
        
                        values["sessionMedia"] = tempVidArray
                        
                        var tempSessArray = (self.mostRecentBandSelected.sessionsOnFeed)
                        tempSessArray.append(self.mostRecentSessionSelected.sessionUID)
                        values2["sessionsOnFeed"] = tempSessArray
                        
                        var tempURLArray = self.mostRecentSessionSelected.sessFeedMedia
            if tempURLArray == nil{
                tempURLArray = [String]()
            }
                        for url in self.selectedSessionMediaArray{
                            if tempURLArray?.count != 0{
                            
                                tempURLArray!.append(String(describing: url))
                                
                            } else {
                                tempURLArray!.append(String(describing: url))
                            }
                            let videoName = NSUUID().uuidString
                            let storageRef = Storage.storage().reference(withPath: "session_videos/").child("\(videoName).mov")
                            let uploadMetadata = StorageMetadata()
                            uploadMetadata.contentType = "video/quicktime"
                            let uploadTask = storageRef.putFile(from: url as URL, metadata: uploadMetadata){(metadata, error) in
                                if(error != nil){
                                    print("got an error: \(error)")
                                }else{
                                    print("upload complete: metadata = \(metadata)")
                                    print("download url = \(metadata?.downloadURL())")
                                }
                            }

        }
                        values3["sessFeedMedia"] = tempURLArray
                        
                        let autoId = recipient.childByAutoId()
           
            var keyString = autoId.key
            var sessionFeedSess = SessionFeedSess()
            
            self.ref.child("sessionFeed").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots{
                        var tempDict = snap.value as! [String:Any]
                        var tempSess = SessionFeedSess()
                        tempSess.setValuesForKeys(tempDict)
                        self.feedArray.append(tempSess)
                    }
                }
                var mult = self.feedArray.count + 1
                let button = ONBGuitarButton()
                button.initWithLane(lane: Int(arc4random_uniform(6)))
                button.setYPosition(yPosition: (3 - CGFloat(mult)) * 2.3)
                button.sessionFeedKey = keyString
                button.isDisplayed = false
                button.sessionName = self.soloSessionNameTextView.text
                values["button"] = [String:Any]()
                sessionFeedSess.setValuesForKeys(values)
               // button.session = values
                let tap = UITapGestureRecognizer(target: self, action: #selector(SessionFeedViewController.scrollToPin))
                
                tap.numberOfTapsRequired = 1
                //button.tap = tap
                button.addGestureRecognizer(tap)
                button.isUserInteractionEnabled = true
                
                button.picks = 0
                //sessionFeedSess.button = button.dictionaryWithValues(forKeys: <#T##[String]#>)
                
                
                var buttonDict = [String: Any]()
                buttonDict["lane"] = button.lane
                 buttonDict["sessionName"] = button.sessionName
                //buttonDict["session"] = values
                 buttonDict["picks"] = 0
                 buttonDict["isDisplayed"] = button.isDisplayed
                 //buttonDict["tap"] = NSObject()
                 buttonDict["_yPosition"] = button._yPosition
                 buttonDict["_slope"] = button._slope
                 buttonDict["_baseX"] = button._baseX
                 buttonDict["sessionFeedKey"] = button.sessionFeedKey
                 buttonDict["kStartY"] = button.kStartY
                 buttonDict["kMaxY"] = button.kMaxY
                //buttonDict["isUserInteractionEnabled"] = button.isUserInteractionEnabled
                
                values["button"] = buttonDict
                

                        //self.autoIdString = String(describing: autoId)
                        autoId.updateChildValues(values, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err as Any)
                                return
                            }
                        })
                        recipient2.updateChildValues(values2, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err)
                                return
                            }
                        })
                        recipient3.updateChildValues(values3, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err)
                                return
                            }
                            self.performSegue(withIdentifier: "CancelPressed", sender: self)
                        })
        /*uploadTask.observe(.progress){[weak self] (snapshot) in
            guard let strongSelf = self else {return}
            guard let progress = snapshot.progress else {return}
            strongSelf.progressView.progress = Float(progress.fractionCompleted)
            print("Uploaded \(progress.completedUnitCount) so far")
                 
        }*/
        
            })
        }
        
       
            
    }
    
    var movieURLFromPicker: NSURL?


}

/*extension UploadSessionPopup: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //guard let mediaType: String = info[UIImagePickerControllerMediaType] as? String else {
        //    dismiss(animated: true, completion: nil)
        //    return
            
       // }
        //if mediaType ==  "public.movie"{
            if let movieURL = info[UIImagePickerControllerMediaURL] as? NSURL{
                movieURLFromPicker = movieURL
                dismiss(animated: true, completion: nil)
                //uploadMovieToFirebaseStorage(url: movieURL)
            }
            
        //}
    }
    
    @available(iOS 2.0, *)
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
}*/



