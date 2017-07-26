//
//  profileRedesignViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 5/22/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SwiftOverlays
import DropDown
class profileRedesignViewController: UIViewController, UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBAction func logoutPressed(_ sender: Any) {
        handleLogout()
    }
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func segmentSwitched(_ sender: Any) {
        if self.bandONBSegment.selectedSegmentIndex == 0 {
            if self.bandIDArray.count == 0{
                self.noBandsLabel.isHidden = false
            } else {
                self.noBandsLabel.isHidden = true
            }

            self.onbCollect.isHidden = true
            self.bandCollect.isHidden = false
        } else {
            if self.onbIDArray.count == 0{
                self.noBandsLabel.isHidden = false
            } else {
                self.noBandsLabel.isHidden = true
            }

            self.onbCollect.isHidden = false
            self.bandCollect.isHidden = true
        }
    }
    var sender = String()
    var picArray = [UIImage]()
    var userID = String()
    var yearsArray = [String]()
    var playingYearsArray = ["1","2","3","4","5+","10+"]
    var playingLevelArray = ["Beginner", "Intermediate", "Advanced", "Expert","Pro"]
    var tempLink: NSURL?
    var rotateCount = 0
    var sizingCell: PictureCollectionViewCell?
    var sizingCell2: VideoCollectionViewCell?
    var sizingCell3: VideoCollectionViewCell?
    var sizingCell4: SessionCell?
    var instrumentArray = [String]()
    var youtubeArray = [NSURL]()
    var nsurlArray = [NSURL]()
    var ref = Database.database().reference()
    var dictionaryOfInstruments = [String: Any]()
    var tags = [Tag]()
    var vidFromPhoneArray = [NSURL]()
    var viewDidAppearBool = false
    var isYoutubeCell: Bool?
    var skillArray = [String]()
    var currentCollect = String()
    var nsurlDict = [NSURL: String]()
    var bandArray = [Band]()
    var bandIDArray = [String]()
    var ONBArray = [Band]()
    var bandsDict = [String: Any]()
    var sizingCell5: SessionCell?
    var onbArray = [ONB]()
    var onbDict = [String: Any]()
    var onbIDArray = [String]()

    @IBOutlet weak var pianoLine3: UIView!
    @IBOutlet weak var pianoLine2: UIView!
    @IBOutlet weak var pianoLine1: UIView!
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistBio: UITextView!
    @IBOutlet weak var onbCollect: UICollectionView!
    @IBOutlet weak var bandCollect: UICollectionView!
    @IBOutlet weak var instrumentTableView: UITableView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var bandONBSegment: UISegmentedControl!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var infoShiftLocation: UIView!
    @IBAction func bandCountPressed(_ sender: Any) {
    
        if infoExpanded == true{
            artistBio.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.noBandsLabel.isHidden = true
                self.artistInfoView.bounds = self.infoViewBounds
                self.artistInfoView.frame.origin = self.infoViewOrigin
                
                //self.positionView.isHidden = true
                
            })
            
        } else {
            artistBio.isHidden = true
            if self.bandIDArray.count == 0{
                self.noBandsLabel.isHidden = false
            } else {
                self.noBandsLabel.isHidden = true
            }
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.artistInfoView.bounds = self.infoShiftViewBounds
                self.artistInfoView.frame.origin = self.infoShiftViewOrigin
                
                if self.bandONBSegment.selectedSegmentIndex == 0 {
                    self.onbCollect.isHidden = true
                    self.bandCollect.isHidden = false
                } else {
                    self.onbCollect.isHidden = false
                    self.bandCollect.isHidden = true
                }
                
                self.bandONBSegment.isHidden = false
                self.instrumentTableView.isHidden = true
                self.videoCollectionView.isHidden = true
                //self.positionView.isHidden = true
                
            })
            
        }
        infoExpanded = !self.infoExpanded
        

    }
    @IBAction func mediaButtonPressed(_ sender: Any) {
        if infoExpanded == true{
            artistBio.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.artistInfoView.bounds = self.infoViewBounds
                self.artistInfoView.frame.origin = self.infoViewOrigin
                self.noBandsLabel.isHidden = true

                //self.positionView.isHidden = true
                
            })
            
        } else {
            artistBio.isHidden = true
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.artistInfoView.bounds = self.infoShiftViewBounds
                self.artistInfoView.frame.origin = self.infoShiftViewOrigin
                //self.positionView.isHidden = true
                self.noBandsLabel.isHidden = true

                self.onbCollect.isHidden = true
                self.bandCollect.isHidden = true
                self.bandONBSegment.isHidden = true
                self.instrumentTableView.isHidden = true
                self.videoCollectionView.isHidden = false

                
            })
            
        }
        infoExpanded = !self.infoExpanded
    }
    @IBOutlet weak var mediaLabelCount: UILabel!
    @IBOutlet weak var bandsCountLabel: UILabel!
    @IBOutlet weak var instrumentLabel: UILabel!
    @IBAction func createWantedContinuePressed(_ sender: Any) {
        self.createWantedSuccess.isHidden = true
    }
    @IBOutlet weak var createWantedSuccess: UIView!
    @IBAction func instrumentButtonTouched(_ sender: Any) {
        if infoExpanded == true{
            artistBio.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.artistInfoView.bounds = self.infoViewBounds
                self.artistInfoView.frame.origin = self.infoViewOrigin
                self.noBandsLabel.isHidden = true

                //self.positionView.isHidden = true
                
            })
            
        } else {
            artistBio.isHidden = true
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.artistInfoView.bounds = self.infoShiftViewBounds
                self.artistInfoView.frame.origin = self.infoShiftViewOrigin
                //self.positionView.isHidden = true
                self.noBandsLabel.isHidden = true

                self.onbCollect.isHidden = true
                self.bandCollect.isHidden = true
                self.bandONBSegment.isHidden = true
                self.instrumentTableView.isHidden = false
                self.videoCollectionView.isHidden = true
                
            })
            
        }
        infoExpanded = !self.infoExpanded
    }
    
    @IBOutlet weak var menuShiftLocation: UIView!
    var menuExpanded = false
    var infoExpanded = false
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var artistInfoView: UIView!
    var menuViewBounds = CGRect()
    var menuViewOrigin = CGPoint()
    var shiftViewBounds = CGRect()
    var shiftViewOrigin = CGPoint()
    var backToSM = false
    var infoViewBounds = CGRect()
    var infoViewOrigin = CGPoint()
    var infoShiftViewBounds = CGRect()
    var infoShiftViewOrigin = CGPoint()

    @IBOutlet weak var artistAllInfoView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let TAGS = ["Guitar", "Bass Guitar", "Piano", "Saxophone", "Trumpet", "Stand-up Bass", "violin", "Drums", "Cello", "Trombone", "Vocals", "Mandolin", "Banjo", "Harp", "rapper", "DJ"]
     var mostRecentTagTouched = IndexPath()
    @IBOutlet weak var dropDownLabel: UILabel!
    var selectedCount = 0
    let dropDown = DropDown()
    let dropDown2 = DropDown()
    var lvlArray = [Int]()
    func set_years_playing(){
        dropDownLabel.text = "Select the number of years have you been playing this instrument"
        dropDown2.selectionBackgroundColor = self.ONBPink
        dropDown2.anchorView = self.view//collectionView.cellForItem(at: indexPath)
        dropDown2.dataSource = ["1","2","3","4","5+","10+"]
        dropDown2.selectionAction = {[unowned self] (index: Int, item: String) in
            self.lvlArray.append(index)
            self.tagsAndSkill[self.TAGS[self.mostRecentTagTouched.row]] = self.lvlArray
            //self.dropDownLabel.isHidden = true
            self.dropDownLabel.text = "Select/Deselect Instruments on Left or the Bio on right to Edit Before Pressing Save"
            
            //self.dropDown2.selectRow(at: index)
            //self.dropDown.selectRow(at: 2)
            //self.dropDown.hide()
        }
        dropDown2.direction = .top
        //dropDown2.selectRow(at: 1)
        dropDown2.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        dropDown2.textColor = UIColor.white.withAlphaComponent(0.8)
        dropDown2.show()
        
    }

   //var userIdd = String()
    @IBAction func saveButtonPressed(_ sender: Any) {
        var tagArray = [String]()
        for tag in tags{
            if(tag.selected == true){
                tagArray.append(tag.name!)
                selectedCount+=1
            }
            
        }
            if let user = Auth.auth().currentUser?.uid{
                let ref = Database.database().reference()
                let userRef = ref.child("users").child(user)
                var dict = [String: Any]()
                dict["instruments"] = tagsAndSkill
                dict["bio"] = bioTextView.text as Any?
                userRef.updateChildValues(dict, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err as Any)
                        return
                    }
                })
                DispatchQueue.main.async{
                    self.skillArray.removeAll()
                    self.yearsArray.removeAll()
                    
                    self.instrumentArray.removeAll()
                    self.instrumentCount = 0
                    self.ref.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        
                        self.artistBio.text = value?["bio"] as! String
                        self.artistName.text = (value?["name"] as! String)
                        let instrumentDict = value?["instruments"] as! [String: Any]
                        self.dictionaryOfInstruments = value?["instruments"] as! [String: Any]
                        //var instrumentArray = [String]()
                        for (key, value) in instrumentDict{
                            self.instrumentCount += 1
                            self.instrumentArray.append(key)
                            self.skillArray.append(self.playingLevelArray[(value as! [Int])[0]])
                            self.yearsArray.append(self.playingYearsArray[(value as! [Int])[1]])
                            
                        }
                        
                        
                        //print(instrumentArray)
                        for _ in self.instrumentArray{
                            let cellNib = UINib(nibName: "InstrumentTableViewCell", bundle: nil)
                            self.instrumentTableView.register(cellNib, forCellReuseIdentifier: "InstrumentCell")
                            self.instrumentTableView.delegate = self
                            self.instrumentTableView.dataSource = self
                        }
                        DispatchQueue.main.async{
                            self.instrumentTableView.reloadData()
                            self.instrumentLabel.text = String(describing: self.instrumentArray.count)
                        }

                    })
                    
                        self.editInfoView.isHidden = true
                        self.editShowing = false
                    
                    

                }
                
                
                
          
        }
        
    }
    
    @IBOutlet weak var flowLayout: FlowLayout!
       @IBAction func hideButtonPressed(_ sender: Any) {
        editInfoView.isHidden = true
        editShowing = false
    }
    var tagsAndSkill = [String: [Int]]()
    var notUser: Bool?
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var editInfoView: UIView!
    @IBOutlet weak var noBandsLabel: UILabel!
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var notificationBubble1: UILabel!
    var inviteCount = 0
    @IBOutlet weak var notificationBubble2: UILabel!
    var bandONBCount = 0
    var videoCount = 0
    var instrumentCount = 0
    var artistID = String()
    var fromTabBar: Bool?
    var tempID = String()
    var sizingCell6:TagCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noBandsLabel.layer.borderWidth = 1
        self.noBandsLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.hideButton.layer.cornerRadius = 10
        
        bioTextView.textColor = UIColor.lightGray
        bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        bioTextView.layer.borderWidth = 1
        bioTextView.delegate = self
        
        //let dropDown = DropDown()
        
        dropDown.selectionBackgroundColor = self.ONBPink
        dropDown.anchorView = self.view//collectionView.cellForItem(at: indexPath)
        dropDown.dataSource = ["Beginner","Intermediate","Advanced","Expert","Pro"]
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            //self.dropDownLabel.isHidden = false
            
            self.lvlArray.append(index)
            self.tagsAndSkill[self.TAGS[self.mostRecentTagTouched.row]] = self.lvlArray
            //self.dropDown.selectRow(at: index)
            //self.dropDown.selectRow(at: 2)
            //self.dropDown.hide()
            self.set_years_playing()
        }


        dropDown.direction = .top
        //dropDown.selectRow(at: 1)
        dropDown.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        dropDown.textColor = UIColor.white.withAlphaComponent(0.8)
        
        
        
        updateInfoButton.layer.cornerRadius = 7
        addMedia.layer.cornerRadius = 7
        invitesMessagesButton.layer.cornerRadius = 7
        notificationBubble1.layer.cornerRadius = 7//notificationBubble1.frame.width/2
        notificationBubble2.layer.cornerRadius = notificationBubble2.frame.width/2
        
        bandONBSegment.layer.masksToBounds = true
        bandONBSegment.layer.cornerRadius = 10
        inviteCount = 0
        
        //SwiftOverlays.showBlockingTextOverlay("Loading Profile")
        if self.sender == "wantedAdCreated"{
            self.createWantedSuccess.isHidden = false
        }
        print("artistID: \(artistID)")
        if Auth.auth().currentUser?.uid != self.artistID{
            self.notUser = true
            //self.tabBar.isHidden = true
            self.backButton.isHidden = false
            self.notificationBubble1.isHidden = true
            self.notificationBubble2.isHidden = true
                self.logoutButton.isHidden = true
                self.notYourProfView.isHidden = false
            
        } else {
            self.notUser = false
           // self.tabBar.isHidden = false
            self.notificationBubble1.isHidden = false
            self.notificationBubble2.isHidden = false
            self.backButton.isHidden = true
            self.logoutButton.isHidden = false
            
            self.notYourProfView.isHidden = true
           
        }
        tabBar.tintColor = ONBPink
        tabBar.selectedItem = tabBar.items?[2]
        picCollect.isHidden = true
        self.menuView.isHidden = true
        self.artistInfoView.isHidden = true
        self.artistBio.isHidden = true
        self.artistName.isHidden = true
        tabBar.delegate = self
        picCollect.layer.cornerRadius = 10
        
        menuView.layer.cornerRadius = 10
        //profileImageView.dropShadow()
       
        self.shiftViewBounds = menuShiftLocation.bounds
        
        self.shiftViewOrigin = menuShiftLocation.frame.origin
        self.menuViewBounds = menuView.bounds
        self.menuViewOrigin = menuView.frame.origin
        
        self.infoShiftViewBounds = infoShiftLocation.bounds
        
        self.infoShiftViewOrigin = infoShiftLocation.frame.origin
        self.infoViewBounds = artistInfoView.bounds
        self.infoViewOrigin = artistInfoView.frame.origin
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: picCollect.bounds.width, height: picCollect.bounds.width)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        picCollect.collectionViewLayout = layout
        menuButton.dropShadow2()
        menuButton.layer.cornerRadius = 10
        artistInfoView.dropShadow3()
        artistInfoView.layer.cornerRadius = 10
        notificationBubble1.layer.cornerRadius = 10
        notificationBubble2.layer.cornerRadius = 10
        self.userID = (Auth.auth().currentUser?.uid)!
        if notUser == true{
            self.tempID = self.artistID
        } else {
            self.tempID = (Auth.auth().currentUser?.uid)!
        }
        print("tempID: \(tempID)")
        self.ref.child("users").child(tempID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //fill datasources for collectionViews
                for snap in snapshots{
                    if snap.key == "media"{
                        let mediaSnaps = snap.value as! [String]
                        for m_snap in mediaSnaps{
                            //fill youtubeArray
                            self.videoCount += 1
                            self.youtubeArray.append(NSURL(string: m_snap)!)
                            self.nsurlArray.append(NSURL(string: m_snap)!)
                            if m_snap.contains("yout"){
                                self.nsurlDict[NSURL(string: m_snap)!] = "y"
                            } else {
                                self.nsurlDict[NSURL(string: m_snap)!] = "v"
                            }
                        }
                        //fill prof pic array
                    } else if snap.key == "profileImageUrl"{
                        if let snapshots = snap.children.allObjects as? [DataSnapshot]{
                            for p_snap in snapshots{
                                if let url = NSURL(string: p_snap.value as! String){
                                    if let data = NSData(contentsOf: url as URL){
                                        self.picArray.append(UIImage(data: data as Data)!)
                                    }
                                }
                            }
                        }
                    }  else if snap.key == "invites"{
                        for _ in (snap.value as! [String: Any]){
                            self.inviteCount += 1
                        }
                    } else if snap.key == "wantedAdResponses"{
                        for _ in (snap.value as! [String]){
                            self.inviteCount += 1
                        }
                        
                    }

                }
                if self.inviteCount > 0 {
                    self.notificationBubble1.text = String(describing: self.inviteCount)
                    self.notificationBubble1.isHidden = false
                    self.notificationBubble2.text = String(describing: self.inviteCount)
                }else{
                    self.notificationBubble1.isHidden = true
                    self.notificationBubble2.isHidden = true
                    
                }

            }
            print(self.nsurlArray)
            if self.nsurlArray.count == 0{
                self.currentCollect = "youtube"
                
                self.tempLink = nil
                
                let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                //self.youtubeCollectionView.backgroundColor = UIColor.clear
                self.videoCollectionView.dataSource = self
                self.videoCollectionView.delegate = self
                
            }
           // for vid in self.nsurlArray{
                
                // Put your code which should be executed with a delay here
                self.currentCollect = "youtube"
                
               // self.tempLink = vid
                
                let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                //self.youtubeCollectionView.backgroundColor = UIColor.clear
                self.videoCollectionView.dataSource = self
                self.videoCollectionView.delegate = self
            //}
            
            
            self.viewDidAppearBool = true
            
            self.ref.child("users").child(self.tempID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.bioTextView.text = value?["bio"] as! String
                self.artistBio.text = value?["bio"] as! String
                self.artistName.text = (value?["name"] as! String)
                let instrumentDict = value?["instruments"] as! [String: Any]
                self.dictionaryOfInstruments = value?["instruments"] as! [String: Any]
                //var instrumentArray = [String]()
                for (key, value) in instrumentDict{
                   // tagsAndSkill[key] = [self.playingLevelArray[(value as! [Int])[0]], self.playingYearsArray[(value as! [Int])[1]]]
                    self.instrumentCount += 1
                    self.instrumentArray.append(key)
                    self.skillArray.append(self.playingLevelArray[(value as! [Int])[0]])
                    self.yearsArray.append(self.playingYearsArray[(value as! [Int])[1]])
                    
                }
                
                
                //print(instrumentArray)
               // for _ in self.instrumentArray{
                    let cellNib = UINib(nibName: "InstrumentTableViewCell", bundle: nil)
                    self.instrumentTableView.register(cellNib, forCellReuseIdentifier: "InstrumentCell")
                    self.instrumentTableView.delegate = self
                    self.instrumentTableView.dataSource = self
              //  }
                
                
                self.ref.child("users").child(self.tempID).child("activeSessions").observeSingleEvent(of: .value, with: {(snapshot) in
                    /*if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                     
                     
                     }*/
                    for _ in self.picArray{
                        self.currentCollect = "pic"
                        //self.tempLink = NSURL(string: (snap.value as? String)!)
                        
                        //self.YoutubeArray.append(snap.value as! String)
                        
                        let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                        self.picCollect.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                        
                        self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                        self.picCollect.backgroundColor = UIColor.clear
                        self.picCollect.dataSource = self
                        self.picCollect.delegate = self
                        
                    }
                    self.ref.child("bands").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots{
                                self.bandONBCount += 1
                                let dictionary = snap.value as? [String: Any]
                                let tempBand = Band()
                                tempBand.setValuesForKeys(dictionary!)
                                self.bandArray.append(tempBand)
                                self.bandsDict[tempBand.bandID!] = tempBand
                            }
                        }
                        
                        self.ref.child("users").child(self.tempID).child("artistsBands").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    self.bandIDArray.append((snap.value! as! String))
                                    //self.bandONBCount += 1
                                }
                            }
                            
                            self.ref.child("oneNightBands").observeSingleEvent(of: .value, with: {(snapshot) in
                                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                    for snap in snapshots{
                                        //self.bandONBCount += 1
                                        let dictionary = snap.value as? [String: Any]
                                        let tempONB = ONB()
                                        tempONB.setValuesForKeys(dictionary!)
                                        self.onbArray.append(tempONB)
                                        self.onbDict[tempONB.onbID] = tempONB
                                    }
                                }
                                self.ref.child("users").child(self.tempID).child("artistsONBs").observeSingleEvent(of: .value, with: {(snapshot) in
                                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                        for snap in snapshots{
                                            self.onbIDArray.append((snap.value! as! String))
                                            //self.bandONBCount += 1
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                        
                                    DispatchQueue.main.async {
                    
                                       // for _ in self.bandIDArray{
                                            
                                            let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                            self.bandCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                            self.sizingCell5 = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                            self.bandCollect.backgroundColor = UIColor.clear
                                            self.bandCollect.dataSource = self
                                            self.bandCollect.delegate = self
                                        //}
                                        DispatchQueue.main.async{
                                           // for _ in self.onbIDArray{
                                                let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                                self.onbCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                                self.sizingCell5 = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                                self.onbCollect.backgroundColor = UIColor.clear
                                                self.onbCollect.dataSource = self
                                                self.onbCollect.delegate = self
                                           // }
                                            self.mediaLabelCount.text = String(describing: self.videoCount)
                                            self.instrumentLabel.text = String(describing: self.instrumentCount)
                                            self.bandsCountLabel.text = String(describing: self.bandIDArray.count + self.onbIDArray.count)
                                            
                                            self.menuView.isHidden = false
                                            self.artistInfoView.isHidden = false
                                            self.picCollect.isHidden = false
                                            self.artistBio.isHidden = false
                                            self.artistName.isHidden = false
                                            //self.logoutButton.isHidden = false
                                            let cellNib2 = UINib(nibName: "TagCell", bundle: nil)
                                            self.instrumentCollect.register(cellNib2, forCellWithReuseIdentifier: "TagCell")
                                            self.instrumentCollect.backgroundColor = UIColor.clear
                                            self.sizingCell6 = (cellNib2.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
                                           // self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
                                            for name in self.TAGS {
                                                let tag = Tag()
                                                tag.name = name
                                                
                                                self.tags.append(tag)
                                                
                                            }
                                            //self.instrumentCollect.setCollectionViewLayout(self.flowLayout, animated: true)
                                            self.instrumentCollect.dataSource = self
                                            self.instrumentCollect.delegate = self
                                            
                                            DispatchQueue.main.async {
                                                SwiftOverlays.removeAllBlockingOverlays()
                                            }
                                            
                                        
                                        
                                        }
                                    }
                                })
                            })
                        })
                        
                    })

                    
                    
                })
                DispatchQueue.main.async{
                    self.instrumentTableView.reloadData()
                }
            })
        })
        
    
    if Auth.auth().currentUser?.uid == nil {
    perform(#selector(handleLogout), with: nil, afterDelay: 0)
    }
    

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var instrumentCollect: UICollectionView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        performSegue(withIdentifier: "LogoutSegue", sender: self)
    }



    
    // MARK: - Navigation
    var afType = String()
    var tabBarPressed = Bool()
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var senderID = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfToInvites"{
            if let vc = segue.destination as? SessionInvitesViewController{
                
            }
        }
        if segue.identifier == "ProfToAddMedia"{
            if let vc = segue.destination as? AddMediaToSession {
                vc.senderView = "main"
               // vc.userID = self.userIdd
            }
            
        }
        if segue.identifier == "ProfileToFindMusicians"{
            if let vc = segue.destination as? ArtistFinderViewController{
                if self.afType == "band"{
                    vc.thisBandObject = self.thisBand
                    vc.senderScreen = "band"
                    vc.sender = self.sender
                    vc.bandType = "band"
                } else {
                    vc.thisONBObject = self.thisONB
                    vc.senderScreen = "onb"
                    vc.sender = self.sender
                    vc.bandType = "onb"
                }
            }
            
        }
        if segue.identifier == "ProfileToSessionMaker" {
            if let viewController = segue.destination as? SessionMakerViewController {
                if self.sender == "band" || self.sender == "bandBoard"{
                    viewController.sessionID = self.senderID
                    viewController.curUser = self.userID
                } else {
                    
                    viewController.curUser = self.userID
                    viewController.sessionID = self.bandIDArray[tempIndex]
                }
                viewController.artistID = self.artistID

                viewController.sender = self.sender
                
            }
        }
        if segue.identifier == "ProfileToONB"{
            if let viewController = segue.destination as? OneNightBandViewController {
                //viewController.sender = "profile"
                if self.sender == "onb"{
                    viewController.onbID = self.senderID
                    viewController.curUser = self.userID
                } else {
                    viewController.onbID = self.onbIDArray[tempIndex]
                    viewController.curUser = self.userID
                }
                viewController.artistID = self.artistID
                 viewController.sender = self.sender
            }
        }
        if segue.identifier == "ProfileToPFM" {
            if let vc = segue.destination as? ProfileFindMusiciansViewController{
               // vc.sender = self.sender
            }
        }

    }
    
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
    
    func
        out() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        performSegue(withIdentifier: "LogoutSegue", sender: self)
    }

    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if menuExpanded == true{
            artistBio.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.menuView.bounds = self.menuViewBounds
                self.menuView.frame.origin = self.menuViewOrigin
                self.notificationBubble2.isHidden = true
                if self.inviteCount > 0 {
                    self.notificationBubble1.isHidden = false
                } else {
                    self.notificationBubble1.isHidden = true
                }
                
                
            })

        } else {
            artistBio.isHidden = true
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.menuView.bounds = self.shiftViewBounds
                self.menuView.frame.origin = self.shiftViewOrigin
                //self.positionView.isHidden = true
                self.notificationBubble1.isHidden = true
                if self.inviteCount > 0 {
                    self.notificationBubble2.isHidden = false
                } else {
                    self.notificationBubble2.isHidden = true
                }

                
            })

        }
        menuExpanded = !self.menuExpanded
        
    }
    
    @IBAction func addMediaPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfToAddMedia", sender: self)
    }
    @IBOutlet weak var addMedia: UIButton!
    @IBAction func invitesPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfToInvites", sender: self)
    }
    @IBOutlet weak var invitesMessagesButton: UIButton!
    var editShowing = false
    @IBAction func updateInfoPressed(_ sender: Any) {
        if editShowing == false {
            editInfoView.isHidden = false
            editShowing = true
        } else {
            editInfoView.isHidden = true
            editShowing = false
        }
    }
    
    @IBOutlet weak var updateInfoButton: UIButton!
    @IBOutlet weak var picCollect: UICollectionView!
    @IBOutlet weak var ONBLabel: UILabel!
    private func rotateView(targetView: UIView, duration: Double = 5) {
        if rotateCount == 4 {
            //performSegue(withIdentifier: "LaunchToScreen1", sender: self)
            ONBLabel.isHidden = true
            artistAllInfoView.isHidden = false
            
        } else {
            
            
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI_4))
            }) { finished in
                //self.rotateCount = self.rotateCount + 1
                //self.rotateView(targetView: targetView, duration: duration)
                self.ONBLabel.isHidden = true
                self.artistAllInfoView.isHidden = false
            }
        }
    }

    
    @available(iOS 2.0, *)
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        self.sender = "profile"
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "ProfileToPFM", sender: self)
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "ProfToJoinBand", sender: self)
            
        } else if item == tabBar.items?[2]{
            
        } else {
            performSegue(withIdentifier: "redesignProfileToFeed", sender: self)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.textColor == UIColor.lightGray {
            //editBioTextView.text = nil
            bioTextView.textColor = self.ONBPink
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text.isEmpty {
           // bioTextView.text = "Tap here to edit your artist bio!"
            bioTextView.textColor = UIColor.lightGray
        }
    
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == instrumentCollect{
            print(tags.count)
            return tags.count
        }
        if collectionView == picCollect{
            return self.picArray.count
        }else if collectionView == videoCollectionView{
            if self.nsurlArray.count == 0{
                return 1
            }else{
                return self.nsurlArray.count
            }
        } else if collectionView == onbCollect{
           return onbIDArray.count
        } else if collectionView == bandCollect{
            return bandIDArray.count
        } else {
            return 0
        }
    }
    var touchedTags = [Tag]()
    func configureTagCell(_ cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        
        let tag = tags[indexPath.row]
        
            if instrumentArray.contains(tag.name!) {
                if tag.changed == false{
                    tag.selected = true
                    tagsAndSkill[tag.name!] = (dictionaryOfInstruments[tag.name!] as! [Int])
                }
                
             
        }
     
        cell.tagName.text = tag.name
        cell.tagName.textColor = tag.selected ? UIColor.white : ONBPink
        cell.backgroundColor = tag.selected ? self.ONBPink : UIColor.white
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == instrumentCollect{
            print("inCellForTag")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
            self.configureTagCell(cell, forIndexPath: indexPath as NSIndexPath)
            return cell

        }
        else if collectionView == picCollect{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath as IndexPath) as! PictureCollectionViewCell
            self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
            cell.layer.cornerRadius = 10
            
            
            //self.curIndexPath.append(indexPath)
            
            return cell

        }else if collectionView == videoCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath as IndexPath) as! VideoCollectionViewCell
            self.configureVidCell(cell, forIndexPath: indexPath as NSIndexPath)
            cell.indexPath = indexPath
            
            //self.curIndexPath.append(indexPath)
            
            return cell

        } else if collectionView == onbCollect || collectionView == bandCollect {
            var tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for: indexPath) as! SessionCell
            if collectionView == bandCollect{
                if bandIDArray.count == 0
                {
                    tempCell.layer.borderColor = UIColor.darkGray.cgColor
                    tempCell.layer.borderWidth = 2
                    tempCell.sessionCellLabel.text = "No Bands"
                    tempCell.isUserInteractionEnabled = false
                } else {
                tempCell.sessionCellImageView.loadImageUsingCacheWithUrlString((bandsDict[bandIDArray[indexPath.row]] as! Band).bandPictureURL[0])
                //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
                tempCell.sessionCellLabel.text = (bandsDict[bandIDArray[indexPath.row]] as! Band).bandName
                tempCell.sessionCellLabel.textColor = UIColor.white
                tempCell.sessionId = (bandsDict[bandIDArray[indexPath.row]] as! Band).bandID
                }
            }
            else {
                if onbIDArray.count == 0
                {
                    tempCell.layer.borderColor = UIColor.darkGray.cgColor
                    tempCell.layer.borderWidth = 2
                    tempCell.sessionCellLabel.text = "No OneNightBands"
                    tempCell.isUserInteractionEnabled = false
                } else {

                    tempCell.sessionCellImageView.loadImageUsingCacheWithUrlString((onbDict[onbIDArray[indexPath.row]] as! ONB).onbPictureURL[0])
                    //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
                    tempCell.sessionCellLabel.text = (onbDict[onbIDArray[indexPath.row]] as! ONB).onbName
                    tempCell.sessionCellLabel.textColor = UIColor.white
                    tempCell.sessionId = (onbDict[onbIDArray[indexPath.row]] as! ONB).onbID
                }
            }
            
            return tempCell


        } else {
            print("wut")
            let cell = UICollectionViewCell()
            return cell
        }

    }
    
    @IBOutlet weak var notYourProfView: UIView!
    
    @IBOutlet weak var notYourProfLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == instrumentCollect {
            lvlArray.removeAll()
            self.dropDownLabel.text = "Select Playing Level"
            tags[indexPath.row].changed = true
            //touchedTags.append(tags[indexPath.row])
            //let dropDown = Drop
            self.mostRecentTagTouched = indexPath
            if(tags[indexPath.row].selected == true){
                //dropDownLabel.isHidden = true
                selectedCount -= 1
                tagsAndSkill.removeValue(forKey: TAGS[indexPath.row])
                //(collectionView.cellForItem(at: indexPath) as! TagCell).isSelected = false
            }else{
                //dropDownLabel.isHidden = false
                selectedCount += 1
                dropDown.show()
               // tagsAndSkill[TAGS[indexPath.row]] = skillArray[indexPath.row]
                //(collectionView.cellForItem(at: indexPath) as! TagCell).isSelected = true
                //self.dropDown.anchorView
            }
            
            collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
           // (instrumentCollect.cellForItem(at: indexPath) as! TagCell).tagName.textColor = tags[indexPath.row].selected ? UIColor.white : ONBPink
            //(instrumentCollect.cellForItem(at: indexPath) as! TagCell).backgroundColor = tags[indexPath.row].selected ? self.ONBPink : UIColor.white
            tags[indexPath.row].selected = !tags[indexPath.row].selected
            self.instrumentCollect.reloadData()
        }
        if collectionView == self.videoCollectionView{
            if (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).videoURL?.absoluteString?.contains("youtube") == false && (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).videoURL?.absoluteString?.contains("youtu.be") == false {
                if (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playbackState == .playing {
                    (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.stop()
                    
                }else{
                    (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playFromBeginning()
                }
                
            }
        } else if(collectionView == bandCollect){
            self.tempIndex = indexPath.row
            if self.sender != "onb" && self.sender != "band"{
                self.sender = "profile"
                performSegue(withIdentifier: "ProfileToSessionMaker", sender: self)
            } else {
                //present bandviewer***************
            }
        } else if collectionView == onbCollect{
            self.tempIndex = indexPath.row
            self.sender = "profile"
            performSegue(withIdentifier: "ProfileToONB", sender: self)
        }

        
        
        
    }
    var tempIndex = Int()
    
    
    func configureVidCell(_ cell: VideoCollectionViewCell, forIndexPath indexPath: NSIndexPath){
        
        
        if self.nsurlArray.count == 0{
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.borderWidth = 1
            cell.removeVideoButton.isHidden = true
            cell.videoURL = nil
            cell.player?.view.isHidden = true
            cell.youtubePlayerView.isHidden = true
            //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
            cell.removeVideoButton.isHidden = true
            cell.noVideosLabel.isHidden = false
        }else {
            
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
            
            //cell.youtubePlayerView.isHidden = true
            cell.removeVideoButton.isHidden = true
            cell.noVideosLabel.isHidden = true
            
            
            
            cell.videoURL =  self.nsurlArray[indexPath.row] as NSURL?
            if(String(describing: cell.videoURL).contains("youtube") || String(describing: cell.videoURL).contains("youtu.be")){
                cell.youtubePlayerView.loadVideoURL(cell.videoURL as! URL)
                cell.youtubePlayerView.isHidden = false
                cell.player?.view.isHidden = true
                cell.isYoutube = true
            }else{
                cell.player?.setUrl(cell.videoURL as! URL)
                cell.player?.view.isHidden = false
                cell.youtubePlayerView.isHidden = true
                cell.isYoutube = false
            }
            //print(self.vidArray[indexPath.row])
            //cell.youtubePlayerView.loadVideoURL(self.vidArray[indexPath.row] as URL)
            //self.group.leave()
        }
        
        
        
    }
    func configureCell(_ cell: PictureCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        
        cell.picImageView.image = self.picArray[indexPath.row]
        cell.deleteButton.isHidden = true
    }
    
    //TABLEVIEW FUNCTIONS********************
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print((self.thisSession.sessionArtists?.count)!)
        return self.instrumentArray.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //(tableView.cellForRow(at: indexPath) as ArtistCell).artistUID
        
        //self.cellTouchedArtistUID = (tableView.cellForRow(at: indexPath) as! ArtistCell).artistUID
        //performSegue(withIdentifier: "ArtistCellTouched", sender: self)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentCell", for: indexPath as IndexPath) as! InstrumentTableViewCell
        cell.instrumentLabel.text = self.instrumentArray[indexPath.row]
        cell.skillLabel.text =  self.skillArray[indexPath.row]
        cell.yearsLabel.text =  "\(self.yearsArray[indexPath.row]) years"
        
        
        return cell
    }
    var thisBand = Band()
    var thisONB = ONB()
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonPressed(_ sender: Any) {
        print("sender: \(self.sender)")
        if self.sender == "onb"{
            self.performSegue(withIdentifier: "ProfileToONB", sender: self)
        } else if self.sender == "feed" || self.sender == "tab"{
            if self.backToSM == false {
                performSegue(withIdentifier: "redesignProfileToFeed", sender: self)
            } else {
                performSegue(withIdentifier: "ProfileToSessionMaker", sender: self)
            }
        } else if self.sender == "af"{
            performSegue(withIdentifier: "ProfileToFindMusicians", sender: self)
        } else if self.sender == "band" {
            self.performSegue(withIdentifier: "ProfileToSessionMaker", sender: self)
        }
    }
    
}
extension UIImageView{
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 40
        self.layer.cornerRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}
extension UIButton{
    
    func dropShadow2() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 40
        self.layer.cornerRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}
extension UIView{
    
    func dropShadow3() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 40
        self.layer.cornerRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}

