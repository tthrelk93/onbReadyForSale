//
//  OneNightBandViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/6/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class OneNightBandViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, PerformSegueInBandBoard, UICollectionViewDelegate, UICollectionViewDataSource /*GetSessionIDDelegate, DismissalDelegate*/ {
    internal func joinBand(bandID: String, wantedAd: WantedAd) {
        
    }
    @IBOutlet weak var onbNameLabel: UILabel!

    @IBOutlet weak var becomeFanButton: UIButton!
    @IBOutlet weak var fanCount: UILabel!
    
    var sizingCell2 = VideoCollectionViewCell()
    var videoCount = 0
    var tempLink: NSURL?
    
    @IBAction func becomeFanPressed(_ sender: Any) {
    }
    
    func performSegueToBandPage(bandID: String){
        
    }
    var sender = String()
    var curUser = String()
    var nsurlArray = [NSURL]()
    var nsurlDict = [NSURL: String]()
    var currentCollect = String()
    var youtubeArray = [NSURL]()
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var onbInfoTextView: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBAction func addMediaPressed(_ sender: Any) {
        performSegue(withIdentifier: "ONBToAddMedia", sender: self)
    }
    @IBOutlet weak var addMediaButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBAction func chatButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ONBToChat", sender: self)
    }
    @IBOutlet weak var findArtistsButton: UIButton!

    @IBAction func findArtistsPressed(_ sender: Any) {
        performSegue(withIdentifier: "ONBToArtistFinder", sender: self)
    }
    @IBOutlet weak var backButton: UIButton!
    var artistDict = [String: Any]()
    var picArray = [UIImage]()
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    var name = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.name = snap.value as! String
                    }
                }
            }
        })

        
        findArtistsButton.setTitleColor(UIColor.darkGray, for: .normal)
         navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        print(sender)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        pictureCollectionView.collectionViewLayout = layout
        
        artistTableView.dataSource = self
        //addMediaButton.layer.cornerRadius = addMediaButton.frame.width/2
        //chatButton.layer.cornerRadius = chatButton.frame.width/2
        //findArtistsButton.layer.cornerRadius = findArtistsButton.frame.width/2

        // Do any additional setup after loading the view.
        
        ref.child("oneNightBands").child(onbID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //fill datasources for collectionViews
                for snap in snapshots{
                    if snap.key == "onbPictureURL"{
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
                    if snap.key == "onbMedia"{
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

                    }
                    if snap.key == "onbName"{
                        self.onbNameLabel.text = snap.value as! String
                    }
                    if snap.key == "onbArtists"{
                        self.artistDict = snap.value as! [String: Any]
                        
                    }
                    if snap.key == "onbDate"{
                        self.dateLabel.text = snap.value as! String
                }
                    if snap.key == "onbInfo"{
                        self.onbInfoTextView.text = snap.value as! String
                    }
                
            }
            }
            
            var tempArray = [String]()
            for (key, val) in self.artistDict{
                tempArray.append(key)
            }
            print("tempArray: \(tempArray)")
            print("curUser: \(self.curUser)")
            if tempArray.contains(self.curUser) == false {
                self.backButton.isHidden = false
                self.addMediaButton.isHidden = true
                self.chatButton.isHidden = true
                //self.becomeFanButton.isHidden = false
            } else {
                self.addMediaButton.isHidden = false
                self.chatButton.isHidden = false
                self.becomeFanButton.isHidden = true
            }

            
                for _ in self.picArray{
                    let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                    self.pictureCollectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                    
                    self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                    self.pictureCollectionView.backgroundColor = UIColor.clear
                    self.pictureCollectionView.dataSource = self
                    self.pictureCollectionView.delegate = self
            }
                
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
                for vid in self.nsurlArray{
                    
                    // Put your code which should be executed with a delay here
                    self.currentCollect = "youtube"
                    
                    self.tempLink = vid
                    
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.videoCollectionView.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    //self.youtubeCollectionView.backgroundColor = UIColor.clear
                    self.videoCollectionView.dataSource = self
                    self.videoCollectionView.delegate = self
                }

                
            let cellNib = UINib(nibName: "ArtistCell", bundle: nil)
            self.artistTableView.register(cellNib, forCellReuseIdentifier: "ArtistCell")
            self.artistTableView.delegate = self
            self.artistTableView.dataSource = self
            DispatchQueue.main.async{
                self.artistTableView.reloadData()
                //self.sessionVidCollectionView.reloadData()
                //print("vidArray: \(self.vidArray)")
                
            }

        })

        self.ref.child("oneNightBands").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if (snap.key == self.onbID){
                        
                        let dictionary = snap.value as? [String: AnyObject]
                        //print(dictionary)
                        let tempONB = ONB()
                        tempONB.setValuesForKeys(dictionary!)
                        self.thisONB = tempONB
                    }
                }
            }
        })
        DispatchQueue.main.async{
            if self.sender == "pfm"{
                self.performSegue(withIdentifier: "ONBToArtistFinder", sender: self)
            }
        }



    }
    var onbID = String()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var sizingCell = PictureCollectionViewCell()
    var currentButton = String()
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.backButtonPressed = true
        if self.sender == "bandBoard"{
            performSegue(withIdentifier: "ONBToBandBoard", sender: self)
        }
        else if self.sender == "feed"{
            performSegue(withIdentifier: "ONBToFeed", sender: self)
        }
        else {
            performSegue(withIdentifier: "ONBToBandMemberProfile", sender: self)
        }
    }
    //var vidCellBool: Bool?
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print((self.thisSession.sessionArtists?.count)!)
        //return (self.thisBand.bandMembers.count)
        return artistDict.count
    }
    var tableViewCellTouched = String()
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       /* //(tableView.cellForRow(at: indexPath) as ArtistCell).artistUID
        self.cellTouchedArtistUID = (tableView.cellForRow(at: indexPath) as! ArtistCell).artistUID
        performSegue(withIdentifier: "ArtistCellTouched", sender: self)*/
        var tempArray = [String]()
        for (key, val) in self.artistDict{
            tempArray.append(key)
        }
        
        self.tableViewCellTouched = tempArray[indexPath.row]
        self.performSegue(withIdentifier: "ONBToBandMemberProfile", sender: self)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath as IndexPath) as! ArtistCell
        let tempArtist = Artist()
        //let userID = Auth.auth().currentUser?.uid
        var artistArray = [String]()
        var instrumentArray = [String]()
        for value in thisONB.onbArtists{
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
            
            print(instrumentArray)
            cell.artistNameLabel.text = tempArtist.name
            cell.artistInstrumentLabel.text = "test"
            cell.artistImageView.loadImageUsingCacheWithUrlString(tempArtist.profileImageUrl.first!)
            cell.artistInstrumentLabel.text = instrumentArray[indexPath.row]
            
        })
        return cell

        /*let tempArtist = Artist()
        //let userID = Auth.auth().currentUser?.uid
        var artistArray = [String]()
        var instrumentArray = [String]()
        for value in thisBand.bandMembers{
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
            
            print(instrumentArray)
            cell.artistNameLabel.text = tempArtist.name
            cell.artistInstrumentLabel.text = "test"
            cell.artistImageView.loadImageUsingCacheWithUrlString(tempArtist.profileImageUrl.first!)
            cell.artistInstrumentLabel.text = instrumentArray[indexPath.row]
            
        })*/
        return cell
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(currentButton as Any)
        if collectionView == pictureCollectionView{
            return picArray.count
        } else if collectionView == videoCollectionView{
            if self.nsurlArray.count == 0{
                return 1
            }else{
                return self.nsurlArray.count
            }
        }

        else { return 0 }
       
        
    }
    
    var tempIndex: Int?
    var pressedButton: String?
    
    
    //cellSelected
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pictureCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath as IndexPath) as! PictureCollectionViewCell
        
        tempIndex = indexPath.row
        self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        
        return cell
        } else if collectionView == videoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath as IndexPath) as! VideoCollectionViewCell
            self.configureVidCell(cell, forIndexPath: indexPath as NSIndexPath)
            cell.indexPath = indexPath
            
            //self.curIndexPath.append(indexPath)
            
            return cell
            
        } else {
            var cell = VideoCollectionViewCell()
            return cell
        }
    }
    
    
    var selectedCell: SessionCell?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.videoCollectionView{
            if (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).videoURL?.absoluteString?.contains("youtube") == false && (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).videoURL?.absoluteString?.contains("youtu.be") == false {
                if (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playbackState == .playing {
                    (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.stop()
                    
                }else{
                    (self.videoCollectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playFromBeginning()
                }
                
            }
        }
    }
    var cellArray = [SessionCell]()
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
    var artistID = String()
    func configureCell(_ cell: PictureCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        cell.picImageView.image = self.picArray[indexPath.row]
        cell.deleteButton.isHidden = true
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
    var destination = String()

    var thisONB = ONB()
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if (segue.identifier! as String) == "ONBToAddMedia"{
            if let vc = segue.destination as? AddMediaToSession{
                vc.onbID = self.onbID
                vc.senderView = "onb"
                
            }
        }
        if (segue.identifier! as String) == "ONBToBandBoard"{
            if let vc = segue.destination as? BandBoardViewController{
                vc.searchType = "OneNightBands"
            }
        }
        if (segue.identifier! as String) == "ONBToArtistFinder"{
            if let vc = segue.destination as? ArtistFinderViewController
            {
                vc.bandID = self.onbID
                vc.thisONBObject = thisONB
                vc.bandType = "onb"
                vc.senderScreen = "onb"
                vc.sender = "onb"
                
            }
        }
        if (segue.identifier! as String) == "ONBToChat"{
            if let vc = segue.destination as? ChatContainer{
                let userID = Auth.auth().currentUser?.uid
                
                vc.name = self.name
                vc.sessionID = self.onbID
                vc.userID = userID!
                vc.bandType = "onb"
                vc.sender = self.sender
                
                
                
                
                
                
            }
        }
        if (segue.identifier! as String) == "ONBToBandMemberProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.sender = "onb"
                if backButtonPressed == false {
                    vc.artistID = self.tableViewCellTouched
                } else {
                    vc.artistID = self.artistID
                }
                vc.senderID = self.onbID
            }
        }
        
        
    }
    var backButtonPressed = false

 

}
