//
//  ArtistProfileViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 11/26/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
import FirebaseAuth
import FirebaseDatabase


class ArtistProfileViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bioTextView: UITextView!
    var PFMChoiceSelected = Bool()
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var ref = Database.database().reference()
    var dictionaryOfInstruments: [NSDictionary] = [NSDictionary]()
    var tags = [Tag]()
    var artistUID: String!
    var youtubeArray = [NSURL]()
    var sizingCell2: VideoCollectionViewCell?
    var sizingCell: PictureCollectionViewCell?
    var tempLink: NSURL?
    var picArray = [UIImage]()
    var group = DispatchGroup()
    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        pictureCollectionView.collectionViewLayout = layout

        self.bioTextView.delegate = self
        
        
        _ = Auth.auth().currentUser?.uid
        ref.child("users").child(self.artistUID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //print(snapshot.value as? NSDictionary)
            let value = snapshot.value as? NSDictionary
            self.bioTextView.text = value?["bio"] as! String
            self.navigationItem.title = (value?["name"] as! String)
            
            //self.profilePicture.image?.accessibilityIdentifier = value?["profileImageUrl"] as! String
            //let user = users[(indexPath as NSIndexPath).row]
            //cell.textLabel?.text = user.name
            //cell.detailTextLabel?.text = user.email
            
            /*if let profileImageUrl = value?["profileImageUrl"] {
                self.profilePicture.loadImageUsingCacheWithUrlString((profileImageUrl as! [String]).first!)
            }*/
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("users").child(artistUID!).child("instruments").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let tag = Tag()
                    tag.name = (snap.key)
                    tag.selected = true
                    self.tags.append(tag)
                }
            }
            

            
        })
       /* ref.child("users").child(self.artistUID).child("media").child("youtube").observeSingleEvent(of: .value, with: { (snapshot) in
            self.group.enter()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                self.currentCollect = "youtube"
                
                for snap in snapshots{
                    
                    self.youtubeArray.append(NSURL(string: snap.value as! String)!)
                    
                    
                }
                if self.youtubeArray.count == 0{
                    self.currentCollect = "vid"
                    self.videoCollectEmpty = true
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    
                    self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.videoCollectionView.backgroundColor = UIColor.clear
                    self.videoCollectionView.dataSource = self
                    self.videoCollectionView.delegate = self
                    
                }else{
                    self.videoCollectEmpty = false
                    for snap in snapshots{
                        self.currentCollect = "vid"
                        self.tempLink = NSURL(string: (snap.value as? String)!)
                        
                        //self.YoutubeArray.append(snap.value as! String)
                        
                        let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                        self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                        
                        self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                        self.videoCollectionView.backgroundColor = UIColor.clear
                        self.videoCollectionView.dataSource = self
                        self.videoCollectionView.delegate = self
                        //self.curCount += 1
                        
                    }
                }
            }
            
            
            
            
            
            self.ref.child("users").child(self.artistUID!).child("activeSessions").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    //self.sessionsPlayed.text = String(snapshots.count)
                    
                }
            })
            
            self.group.leave()
            
            
            self.group.enter()
            self.ref.child("users").child(self.artistUID!).child("profileImageUrl").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    
                    for snap in snapshots{
                        
                        if let url = NSURL(string: snap.value as! String){
                            if let data = NSData(contentsOf: url as URL){
                                self.picArray.append(UIImage(data: data as Data)!)
                                
                            }
                            
                        }
                    }
                }
                print("pArray: \(self.picArray)")
                
                self.videoCollectEmpty = false
                for pic in self.picArray{
                    //self.tempLink = NSURL(string: (snap.value as? String)!)
                    self.currentCollect = "pic"
                    //self.YoutubeArray.append(snap.value as! String)
                    
                    let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                    self.pictureCollectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                    
                    self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                    self.pictureCollectionView.backgroundColor = UIColor.clear
                    self.pictureCollectionView.dataSource = self
                    self.pictureCollectionView.delegate = self
                    
                }
            })
            self.group.leave()
        })*/
    

    
        
        
    }
    var instrumentArray = [String]()
    var videoCollectEmpty: Bool?
    var currentCollect: String?
    var vidFromPhoneArray = [NSURL]()
    var viewDidAppearBool = false
    var nsurlArray = [NSURL]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor.clear
        self.view.alpha = 1.0
        
        
        
        if viewDidAppearBool == false{
            
            
            self.ref.child("users").child(self.artistUID!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    //fill datasources for collectionViews
                    for snap in snapshots{
                        if snap.key == "media"{
                            let mediaSnaps = snap.children.allObjects as? [DataSnapshot]
                            for m_snap in mediaSnaps!{
                                //fill youtubeArray
                                if m_snap.key == "youtube"{
                                    for y_snap in m_snap.value as! [String]
                                    {
                                        
                                        self.youtubeArray.append(NSURL(string: y_snap)!)
                                        self.nsurlArray.append(NSURL(string: y_snap)!)
                                        //self.nsurlDict[NSURL(string: y_snap)!] = "y"
                                    }
                                }
                                    //fill vidsFromPhone array
                                else{
                                    for v_snap in m_snap.value as! [String]
                                    {
                                        self.vidFromPhoneArray.append(NSURL(string: v_snap)!)
                                        self.nsurlArray.append(NSURL(string: v_snap)!)
                                        //self.nsurlDict[NSURL(string: v_snap)!] = "v"
                                    }
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
                        }
                    }
                }
                print(self.nsurlArray)
                if self.nsurlArray.count == 0{
                    // Put your code which should be executed with a delay here
                    self.currentCollect = "youtube"
                    
                    self.tempLink = nil
                    
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    
                    self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.videoCollectionView.backgroundColor = UIColor.clear
                    self.videoCollectionView.dataSource = self
                    self.videoCollectionView.delegate = self

                }
                for vid in self.nsurlArray{
                    
                    // Put your code which should be executed with a delay here
                    self.currentCollect = "youtube"
                    
                    self.tempLink = vid
                    
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    
                    self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    self.videoCollectionView.backgroundColor = UIColor.clear
                    self.videoCollectionView.dataSource = self
                    self.videoCollectionView.delegate = self
                }
                
                
                self.viewDidAppearBool = true
                
                self.ref.child("users").child(self.artistUID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    self.bioTextView.text = value?["bio"] as! String
                    
                    let instrumentDict = value?["instruments"] as! [String: Any]
                    //var instrumentArray = [String]()
                    for key in instrumentDict.keys{
                        self.instrumentArray.append(key)
                        
                    }
                    //print(instrumentArray)
                    for instrument in self.instrumentArray{
                        let cellNib = UINib(nibName: "InstrumentTableViewCell", bundle: nil)
                        self.instrumentTableView.register(cellNib, forCellReuseIdentifier: "InstrumentCell")
                        self.instrumentTableView.delegate = self
                        self.instrumentTableView.dataSource = self
                    }

                    
                    self.navigationItem.title = (value?["name"] as! String)
                
                self.ref.child("users").child(self.artistUID!).child("activeSessions").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                       // self.sessionsPlayed.text = String(snapshots.count)
                        
                    }
                    for _ in self.picArray{
                        self.currentCollect = "pic"
                        //self.tempLink = NSURL(string: (snap.value as? String)!)
                        
                        //self.YoutubeArray.append(snap.value as! String)
                        
                        let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                        self.pictureCollectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                        
                        self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                        self.pictureCollectionView.backgroundColor = UIColor.clear
                        self.pictureCollectionView.dataSource = self
                        self.pictureCollectionView.delegate = self
                        
                    }
                    })
                    DispatchQueue.main.async{
                        self.instrumentTableView.reloadData()
                    }
                    
                })
            })
            //self.viewDidAppearBool = true
        }
    }

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.currentCollect == "pic"{
            return self.picArray.count
        }else{
            if self.nsurlArray.count == 0{
                return 1
            }else{
                return self.nsurlArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentCollect != "pic"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath as IndexPath) as! VideoCollectionViewCell
            self.configureVidCell(cell, forIndexPath: indexPath as NSIndexPath)
            cell.indexPath = indexPath
            
            //self.curIndexPath.append(indexPath)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath as IndexPath) as! PictureCollectionViewCell
            self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
            
            
            //self.curIndexPath.append(indexPath)
            
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.pictureCollectionView{
        if (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).videoURL?.absoluteString?.contains("youtube") == false {
            if (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playbackState == .playing {
                (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.stop()
                
            }else{
                (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playFromBeginning()
            }
            
        }
        }

    }
    @IBOutlet weak var instrumentTableView: UITableView!
        func configureVidCell(_ cell: VideoCollectionViewCell, forIndexPath indexPath: NSIndexPath){
           
            
            if self.nsurlArray.count == 0{
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
                
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
                
                //cell.youtubePlayerView.isHidden = true
                cell.removeVideoButton.isHidden = true
                cell.noVideosLabel.isHidden = true
                
                
                
                cell.videoURL =  self.nsurlArray[indexPath.row] as NSURL?
                if(String(describing: cell.videoURL).contains("youtube") || String(describing: cell.videoURL).contains("youtu.be")) {
                    cell.youtubePlayerView.loadVideoURL(cell.videoURL as! URL)
                    cell.youtubePlayerView.isHidden = false
                    cell.player?.view.isHidden = true
                    cell.isYoutube = true
                }else{
                    cell.player?.setUrl(cell.videoURL as! URL)
                    cell.player?.view.isHidden = false
                    cell.youtubePlayerView.isHidden = true
                    cell.isYoutube = false
                    cell.player?.fillMode = "AVLayerVideoGravityResizeAspectFill"
                }
                //print(self.vidArray[indexPath.row])
                //cell.youtubePlayerView.loadVideoURL(self.vidArray[indexPath.row] as URL)
                //self.group.leave()
            }
            
            
            
        }
        func configureCell(_ cell: PictureCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
            
            cell.picImageView.image = self.picArray[indexPath.row]
            cell.deleteButton.isHidden = true
            /* switch UIScreen.main.bounds.width{
             case 320:
             
             cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width:320, height:267)
             
             case 375:
             cell.frame = CGRect(x: cell.frame.origin.x,y: cell.frame.origin.y,width:375,height:267)
             
             
             case 414:
             cell.frame = CGRect(x: cell.frame.origin.x,y: cell.frame.origin.y,width:414,height:267)
             
             default:
             cell.frame = CGRect(x: cell.frame.origin.x,y: cell.frame.origin.y,width:414,height:267)
             
             
             
             }*/
            
        }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print((self.thisSession.sessionArtists?.count)!)
        return self.instrumentArray.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //(tableView.cellForRow(at: indexPath) as ArtistCell).artistUID
        //self.cellTouchedArtistUID = (tableView.cellForRow(at: indexPath) as! ArtistCell).artistUID
        //performSegue(withIdentifier: "ArtistCellTouched", sender: self)
    }
    
    
    /*  var vidArray = [NSURL]()
     var videoCollectEmpty: Bool?
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
     if self.vidArray.count != 0{
     self.videoCollectEmpty = false
     return self.vidArray.count
     
     }else{
     self.videoCollectEmpty = true
     return 1
     }
     }*/
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentCell", for: indexPath as IndexPath) as! InstrumentTableViewCell
        cell.instrumentLabel.text = self.instrumentArray[indexPath.row]
        //let tempArtist = Artist()
        //let userID = Auth.auth().currentUser?.uid
        //var artistArray = [String]()
        //var instrumentArray = [String]()
        /*for value in thisSession.sessionArtists{
         artistArray.append(value.key)
         instrumentArray.append(value.value as! String)
         }
         
         
         ref.child("users").child(artistArray[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
         
         
         let dictionary = snapshot.value as? [String: AnyObject]
         tempArtist.setValuesForKeys(dictionary!)
         
         /*var tempInstrument = ""
         let userID = Auth.auth().currentUser?.uid
         for value in self.thisSession.sessionArtists{
         if value.key == userID{
         tempInstrument = value.value as! String
         
         }
         }*/
         cell.artistUID = tempArtist.artistUID!
         
         cell.artistNameLabel.text = tempArtist.name
         cell.artistInstrumentLabel.text = "test"
         cell.artistImageView.loadImageUsingCacheWithUrlString(tempArtist.profileImageUrl.first!)
         cell.artistInstrumentLabel.text = instrumentArray[indexPath.row]*/
        
        return cell
    }
    

    

    

    
}
