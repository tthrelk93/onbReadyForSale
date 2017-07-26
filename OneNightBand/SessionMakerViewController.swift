//
//  SessionMakerViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/8/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
//import Firebase
import FirebaseStorage
import FirebaseDatabase
//import Firebase
import UIKit
import FirebaseAuth




protocol GetSessionIDDelegate : class
{
    func getSessID()->String
    
}
protocol SessionIDDest : class
{
    weak var getSessionID : GetSessionIDDelegate? { get set }
}





class SessionMakerViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, GetSessionIDDelegate, DismissalDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITabBarDelegate{
    
    @IBOutlet weak var tabBar: UITabBar!
    var destination = String()
    internal func finishedShowing() {
        
    }

    
    var sessionID: String?
    let userID = Auth.auth().currentUser?.uid
    
    @IBAction func addSessionTouched(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateSessionPopup") as! CreateSessionPopup
        popOverVC.bandID = self.thisBand.bandID
        popOverVC.bandObject = self.thisBand
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    var backPressed = false
    @IBAction func backPressed(_ sender: Any) {
        self.backPressed = true
        if self.sender == "bandBoard"{
            performSegue(withIdentifier: "BandToBandBoard", sender: self)
        }
        else if self.sender == "feed"{
            performSegue(withIdentifier: "BandToFeed", sender: self)
        } else {
            performSegue(withIdentifier: "BandToArtistProfile", sender: self)
        }
        
    }
    
    @IBOutlet weak var addNewSession: UIButton!
    @IBOutlet weak var sessionImageView: UIImageView!
    @IBOutlet weak var addSessionPicButton: UIButton!
    @IBOutlet weak var AddMusiciansButton: UIButton!
    @IBOutlet weak var sessionArtistsTableView: UITableView!
    @IBOutlet weak var sessionInfoTextView: UITextView!
    @IBOutlet weak var editSessionInfoButton: UIButton!
    @IBOutlet weak var removeArtistButton: UIButton!
    var artistID = String()
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var becomeFanButton: UIButton!
    @IBAction func becomeFanPressed(_ sender: Any) {
    }
    @IBOutlet weak var editSessionButton: UIButton!
    var cellTouchedArtistUID = String()
    var sender = "band"
    var backToSM = false 
    var tableViewCellTouched = String()
    @IBOutlet weak var uploadSessionToFeed: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "BandToBandBoard"{
            if let vc = segue.destination as? BandBoardViewController{
                vc.searchType = "Bands"
            }
        }
        
        if (segue.identifier! as String) == "SessionToArtistFinder"{
            if let vc = segue.destination as? ArtistFinderViewController
            {
                vc.bandID = sessionID!
                vc.thisBandObject = thisBand
                vc.bandType = "band"
                vc.senderScreen = "band"
                vc.sender = "band"
            }
        }
        if (segue.identifier! as String) == "SessionToChat"{
            if let vc = segue.destination as? ChatContainer{
                let userID = Auth.auth().currentUser?.uid
                vc.name = self.name
                vc.sessionID = self.sessionID!
                vc.userID = userID!
                vc.bandType = "band"
            }
        }
        if (segue.identifier! as String) == "ArtistCellTouched"{
            if let vc = segue.destination as? ArtistProfileViewController{
                vc.artistUID = cellTouchedArtistUID
            }
        }
        if (segue.identifier! as String) == "BandToArtistProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.sender = "band"
                vc.senderID = self.sessionID!
                
                if self.backToSM == true {
                    vc.artistID = self.cellTouchedArtistUID
                    
                } else {
                    vc.artistID = self.artistID
                }

            }
        }
        if (segue.identifier! as String) == "SessionToMP3"{
            if let vc = segue.destination as? MP3PlayerViewController{
                vc.BandID = self.sessionID!
                print("sesssssss: \(self.sessionID!)")
                print(self.selectedCell?.sessionId)
                vc.viewerInBand = self.viewerInBand
                vc.sessionID = self.selectedCell?.sessionId
                vc.navigationController?.isNavigationBarHidden = false
                vc.navigationItem.hidesBackButton = false
                if self.sender == "feed" {
                    vc.sender = "feed"
                } else if self.sender == "bandBoard"{
                    vc.sender = "bandBoard"
                }else {
                    vc.sender = "bandPage"
                }
                vc.artistID = self.artistID
            }

        }
        
    }
    
    @IBAction func editPressed(_ sender: Any) {
        self.sessionInfoTextView.select(self)
    }
   
    var yearsArray = [String]()
    var playingYearsArray = ["1","2","3","4","5+","10+"]
    var playingLevelArray = ["beginner", "intermediate", "advanced", "expert"]

    @IBAction func chatPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SessionToChat", sender: self)
    }
    @IBOutlet weak var chatViewContainerView: UIView!
    
    @IBAction func addMusicianPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SessionToArtistFinder", sender: self)
    }
    var ref = Database.database().reference()
    var sessionIDArray = [String]()
    var thisBand = Band()
    var sessionChat = ChatViewController()
    var sizingCell2: VideoCollectionViewCell?
    
    @IBOutlet weak var sessionVidCollectionView: UICollectionView!
    
    @IBOutlet weak var chatButton: UIButton!
    
    func getSessID()->String{
        return sessionID!
    }
    var viewerInBand = Bool()
    @IBOutlet weak var backButton: UIButton!
    var curUser = String()
    @IBAction func ourSessionsPressed(_ sender: Any) {
    }
    @IBOutlet weak var ourSessionsButton: UIButton!
    var mediaKidArray = [String]()
    
    @IBOutlet weak var allSessionsCollect: UICollectionView!
    
    @IBOutlet weak var currentSessionsCollect: UICollectionView!
    
    @IBOutlet weak var fanCount: UILabel!
    @IBOutlet weak var sessionsOnFeedCollect: UICollectionView!
    @IBOutlet weak var upcomingSessionsCollect: UICollectionView!
    @IBOutlet weak var pastSessionsCollect: UICollectionView!
    var vidArray = [NSURL]()
    
    var sizingCell: SessionCell?
    var name = String()
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        self.curUser = (Auth.auth().currentUser?.uid)!
        
        
        
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.name = snap.value as! String
                    }
                }
            }
        })

        
        self.sessionImageView.layer.cornerRadius = 10
        /*if self.sender == "feed"{
            
            self.editSessionInfoButton.isHidden = true
            self.backButton.isHidden = false
            
        }
        else if self.sender == "bandBoard"{
            self.editSessionInfoButton.isHidden = true
            self.backButton.isHidden = false
            
        } else {
            self.editSessionInfoButton.isHidden = false
            self.backButton.isHidden = false
            
        }*/
        self.tabBar.delegate = self
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        sessionPicker.delegate = self
        sessionPicker.dataSource = self
        //sessionPicker.selectRow(1, inComponent: 1, animated: false)
        
        loadCollectionViews()
        
        
        DispatchQueue.main.async{
            self.allSessionsCollect.isHidden = false
        }
        
                ref.child("users").child(userID!).child("artistsBands").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    self.sessionIDArray.append((snap.value! as! String))
                }
            }
        var bandMemberArray = [String]()
                
        self.ref.child("bands").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if (snap.key == self.getSessID()){
                            
                            let dictionary = snap.value as? [String: AnyObject]
                            
                            let tempBand = Band()
                            tempBand.setValuesForKeys(dictionary!)
                            self.thisBand = tempBand
                            for (key, val) in tempBand.bandMembers{
                                bandMemberArray.append(key)
                            }
                            for val in tempBand.bandMedia{
                                //self.mediaKidArray.append(val)
                                self.vidArray.append(NSURL(string: val)!)
                            }
                            self.sessionID = self.thisBand.bandID
                            self.sessionInfoTextView?.text = tempBand.bandBio!
                            self.sessionImageView?.loadImageUsingCacheWithUrlString(tempBand.bandPictureURL[0])
                            self.bandNameLabel.text = tempBand.bandName
                            //print(self.thisSession.sessionBio)
                            let cellNib = UINib(nibName: "ArtistCell", bundle: nil)
                            self.sessionArtistsTableView.register(cellNib, forCellReuseIdentifier: "ArtistCell")
                            self.sessionArtistsTableView.delegate = self
                            self.sessionArtistsTableView.dataSource = self
                            break
                        }
                }
                
                if bandMemberArray.contains(self.curUser){
                    self.viewerInBand = true
                    self.becomeFanButton.isHidden = true
                    self.AddMusiciansButton.titleLabel?.textAlignment = NSTextAlignment.center
                    self.editSessionInfoButton.isHidden = false
                    self.chatButton.isHidden = false
                    self.addNewSession.isHidden = false

                    
                } else {
                    self.viewerInBand = false
                    self.editSessionInfoButton.isHidden = true
                    self.AddMusiciansButton.isHidden = true
                    self.chatButton.isHidden = true
                    self.addNewSession.isHidden = true
                    self.becomeFanButton.isHidden = true
                }

                

            }
            DispatchQueue.main.async{
                self.sessionArtistsTableView.reloadData()
                //self.sessionVidCollectionView.reloadData()
                print("vidArray: \(self.vidArray)")
                if self.sender == "pfm"{
                    self.performSegue(withIdentifier: "SessionToArtistFinder", sender: self)
                }
                
            }

            
            
        
        })
    
    
    })
        
        
}
    
    
    var allSessionsDict = [String: Session]()
    var pastSessionArray = [Session]()
    var upcomingSessionArray = [Session]()
    var activeSessionsArray = [Session]()
    var sessionFeedArray = [Session]()
    var allSessions = [Session]()
    var bandSessions = [String]()
    
    var curFeedArrayIndex = 0
    var curPastArrayIndex = 0
    var curActiveArrayIndex = 0
    var curUpcomingArrayIndex = 0
    
    func loadCollectionViews(){
        activeSessionsArray.removeAll()
        pastSessionArray.removeAll()
        upcomingSessionArray.removeAll()
        sessionFeedArray.removeAll()
        sessionIDArray.removeAll()
        allSessions.removeAll()
        bandSessions.removeAll()
        navigationItem.title = "Our Sessions"
        allSessionsCollect.isHidden = true
        upcomingSessionsCollect.isHidden = true
        pastSessionsCollect.isHidden = true
        currentSessionsCollect.isHidden = true
        sessionsOnFeedCollect.isHidden = true
        
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("sessions").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshotsss = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshotsss{
                    let dictionary = snap.value as? [String: Any]
                    print("dict: \(dictionary)")
                    let tempSess = Session()
                    tempSess.setValuesForKeys(dictionary!)
                    self.allSessionsDict[tempSess.sessionUID] = tempSess
                }
            }
            
            self.ref.child("bands").child(self.sessionID!).child("bandSessions").observeSingleEvent(of: .value, with: { (ssnapshot) in
                if let ssnapshots = ssnapshot.children.allObjects as? [DataSnapshot]{
                    for ssnap in ssnapshots{
                        self.bandSessions.append((ssnap.value! as! String))
                    }
                }
                self.bandSessions.reverse()
                
                self.ref.child("sessionFeed").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            let sessionKids = snap.children.allObjects as? [DataSnapshot]
                            for ssnap in sessionKids!{
                                if ssnap.key == "sessionUID"{
                                    
                                    let dictionary = snap.value as? [String: Any]
                                    let tempSess = Session()
                                    tempSess.setValuesForKeys(dictionary!)
                                    if self.sessionIDArray.contains(tempSess.sessionUID) {
                                        
                                        self.sessionFeedArray.append(self.allSessionsDict[tempSess.sessionUID]!)
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    print("sessIDArray: \(self.bandSessions)")
                    self.ref.child("sessions").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            
                            for snap in snapshots{
                                print("snapKey: \(snap.key)")
                                for id in self.bandSessions{
                                    if snap.key == id{
                                        print("id: \(id)")
                                        let dictionary = snap.value as? [String: Any]
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.timeStyle = DateFormatter.Style.none
                                        dateFormatter.dateStyle = DateFormatter.Style.short
                                        let now = Date()
                                        let order = Calendar.current.compare(now, to: self.dateFormatted(dateString: dictionary?["sessionDate"] as! String), toGranularity: .day)
                                        
                                        let tempSess2 = Session()
                                        tempSess2.setValuesForKeys(dictionary!)
                                        
                                        self.allSessions.append(tempSess2)
                                        
                                        switch order {
                                            
                                        case .orderedSame:
                                            let tempSess = Session()
                                            tempSess.setValuesForKeys(dictionary!)
                                            self.activeSessionsArray.append(tempSess)
                                        case .orderedAscending:
                                            let tempSess = Session()
                                            tempSess.setValuesForKeys(dictionary!)
                                            self.upcomingSessionArray.append(tempSess)
                                        case .orderedDescending:
                                            let tempSess = Session()
                                            tempSess.setValuesForKeys(dictionary!)
                                            self.pastSessionArray.append(tempSess)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        
                        DispatchQueue.main.async {
                            if self.activeSessionsArray.count == 0{
                                self.currentButton = "active"
                                
                                let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                self.currentSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                
                                self.currentSessionsCollect.dataSource = self
                                self.currentSessionsCollect.delegate = self
                                
                            }else{

                            for session in self.activeSessionsArray{
                                self.currentButton = "active"
                                self.curActiveArrayIndex = self.activeSessionsArray.index(of: session)!
                                let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                self.currentSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                
                                self.currentSessionsCollect.dataSource = self
                                self.currentSessionsCollect.delegate = self
                            }
                            }
                            
                            DispatchQueue.main.async {
                                if self.pastSessionArray.count == 0{
                                    self.currentButton = "past"
                                    
                                    
                                    let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                    self.pastSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                    self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                    
                                    self.pastSessionsCollect.dataSource = self
                                    self.pastSessionsCollect.delegate = self
                                    
                                }
                                else{

                                for session in self.pastSessionArray{
                                    self.currentButton = "past"
                                    self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                                    
                                    let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                    self.pastSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                    self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                    
                                    self.pastSessionsCollect.dataSource = self
                                    self.pastSessionsCollect.delegate = self
                                }
                                }
                                
                                
                                DispatchQueue.main.async {
                                    if self.upcomingSessionArray.count == 0{
                                        self.currentButton = "upcoming"
                                        
                                        let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                        self.upcomingSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                        
                                        self.upcomingSessionsCollect.dataSource = self
                                        self.upcomingSessionsCollect.delegate = self
                                    }
                                    else{

                                    for session in self.upcomingSessionArray{
                                        self.currentButton = "upcoming"
                                        self.curUpcomingArrayIndex = self.upcomingSessionArray.index(of: session)!
                                        let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                        self.upcomingSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                       
                                        self.upcomingSessionsCollect.dataSource = self
                                        self.upcomingSessionsCollect.delegate = self
                                    }
                                    }
                                    DispatchQueue.main.async{
                                        if self.allSessions.count == 0{
                                            self.currentButton = "all"
                                           
                                            let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                            self.allSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                          
                                            self.allSessionsCollect.dataSource = self
                                            self.allSessionsCollect.delegate = self
                                            
                                        }
                                        else{

                                                                            
                                        for _ in self.allSessions{
                                            self.currentButton = "all"
                                          
                                            
                                            let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                            self.allSessionsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                        
                                            self.allSessionsCollect.dataSource = self
                                            self.allSessionsCollect.delegate = self
                                        }
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
 
                        print(self.sessionFeedArray)
                        if self.sessionFeedArray.count == 0{
                            self.currentButton = "feed"
                            //self.curFeedArrayIndex = self.sessionFeedArray.index(of: session)!
                            let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                            self.sessionsOnFeedCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                            
                            //self.sessionsOnFeedCollect.backgroundColor = UIColor.clear
                            self.sessionsOnFeedCollect.dataSource = self
                            self.sessionsOnFeedCollect.delegate = self
                            
                        }else{

                        for session in self.sessionFeedArray{
                            if self.sessionIDArray.contains(session.sessionUID){
                                self.currentButton = "feed"
                                self.curFeedArrayIndex = self.sessionFeedArray.index(of: session)!
                                let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                self.sessionsOnFeedCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                
                                //self.sessionsOnFeedCollect.backgroundColor = UIColor.clear
                                self.sessionsOnFeedCollect.dataSource = self
                                self.sessionsOnFeedCollect.delegate = self
                            }
                            }
                                                    }
                        
                        
                    })
                    
                    
                })
                
            })
            
        })
    }
    
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "BandToFindMusicians", sender: self)
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "BandToJoinBand", sender: self)
            
        } else if item == tabBar.items?[2]{
            performSegue(withIdentifier: "TabBarBandToProfile", sender: self)
            
        } else {
            performSegue(withIdentifier: "BandToFeed", sender: self)
        }
    }


    
    
    var currentButton = String()
    
    //var vidCellBool: Bool?
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print((self.thisSession.sessionArtists?.count)!)
        return (self.thisBand.bandMembers.count)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //(tableView.cellForRow(at: indexPath) as ArtistCell).artistUID
        self.backToSM = true
        self.cellTouchedArtistUID = (tableView.cellForRow(at: indexPath) as! ArtistCell).artistUID
        performSegue(withIdentifier: "BandToArtistProfile", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(currentButton as Any)
        if(self.currentButton == "upcoming"){
            if upcomingSessionArray.count == 0{
                return 1
            }else{
                return upcomingSessionArray.count
            }
            
            
        }
        else if(self.currentButton == "past"){
            if pastSessionArray.count == 0{
                return 1
            }else{
                return pastSessionArray.count
            }
            
        }
        else if(self.currentButton == "feed"){
            if sessionFeedArray.count == 0{
                return 1
            }else{
                return sessionFeedArray.count
            }
        }
        else if(self.currentButton == "active"){
            if activeSessionsArray.count == 0{
                return 1
            }else{
                return activeSessionsArray.count
            }
        }else if(self.currentButton == "all"){
            if allSessions.count == 0{
                return 1
            }else{
            return allSessions.count
            }
        }
        else{
            return 0
        }
        
    }
    var tempIndex: Int?
    var pressedButton: String?

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for: indexPath as IndexPath) as! SessionCell
        
        tempIndex = indexPath.row
        self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    
    var selectedCell: SessionCell?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // self.bandTypeView.isHidden = true
        /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MP3PlayerVC") as! MP3PlayerViewController
        popOverVC.sessionID = (collectionView.cellForItem(at: indexPath) as! SessionCell).sessionId
        //popOverVC.sessionNameLabel.text = (collectionView.cellForItem(at: indexPath) as! SessionCell).sessionCellLabel.text
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)*/
        self.selectedCell = collectionView.cellForItem(at: indexPath) as! SessionCell
        print("selectedCellName: \(self.selectedCell?.sessionCellLabel.text)")
        print("selectedCellID: \(self.selectedCell?.sessionId)")
        self.performSegue(withIdentifier: "SessionToMP3", sender: self)
        //self.dropDownDone = true
        //self.createNewBandButton.isHidden = false

        /*if(collectionView == self.upcomingSessionsCollect){
            tempIndex = indexPath.row
            self.pressedButton = "upcoming"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if(collectionView == self.pastSessionsCollect){
            tempIndex = indexPath.row
            self.pressedButton = "past"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if(collectionView == self.sessionsOnFeedCollect){
            tempIndex = indexPath.row
            self.pressedButton = "feed"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if(collectionView == self.currentSessionsCollect){
            tempIndex = indexPath.row
            self.pressedButton = "active"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if (collectionView == self.allSessionsCollect){
            tempIndex = indexPath.row
            self.pressedButton = "all"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }*/
        
    }
    var cellArray = [SessionCell]()
    func configureCell(_ cell: SessionCell, forIndexPath indexPath: NSIndexPath) {
        
        if(self.currentButton == "upcoming"){
            print("Whyyyyy")
            if upcomingSessionArray.count == 0{
                cell.emptyLabel.isHidden = false
                cell.emptyLabel.text = "No Upcoming Sessions"
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.emptyLabel.textColor = UIColor.white
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.isHidden = true
            }
            
            if(indexPath.row < upcomingSessionArray.count){
                cell.emptyLabel.isHidden = true
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((upcomingSessionArray[indexPath.row] as Session).sessionPictureURL[0])
                //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
                cell.sessionCellLabel.text = upcomingSessionArray[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = bandSessions[indexPath.row]
            }
            cellArray.append(cell)
            
        }
        if(self.currentButton == "past"){
            if pastSessionArray.count == 0{
                cell.isHidden = false
                cell.emptyLabel.isHidden = false
                cell.emptyLabel.text = "No Past Sessions"
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.emptyLabel.textColor = UIColor.white
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.isHidden = true
            }else{
                cell.emptyLabel.isHidden = true
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.sessionCellImageView.isHidden = false
                cell.sessionCellLabel.isHidden = false
                if(indexPath.row < pastSessionArray.count){
                    
                    cell.sessionCellImageView.loadImageUsingCacheWithUrlString((pastSessionArray[indexPath.row] as Session).sessionPictureURL[0])
                    cell.sessionCellLabel.text = pastSessionArray[indexPath.row].sessionName
                    cell.sessionCellLabel.textColor = UIColor.white
                    cell.sessionId = bandSessions[indexPath.row]
                }

            }
                        cellArray.append(cell)
        }
        if(self.currentButton == "feed"){
            if sessionFeedArray.count == 0{
                cell.emptyLabel.isHidden = false
                cell.emptyLabel.text = "No Sessions On Feed"
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.emptyLabel.textColor = UIColor.white
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.isHidden = true
            }else{
                cell.emptyLabel.isHidden = true
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.sessionCellImageView.isHidden = false
                cell.sessionCellLabel.isHidden = false

            }
            
            if(indexPath.row < sessionFeedArray.count){
                print(indexPath.row)
                                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((sessionFeedArray[indexPath.row] as Session).sessionPictureURL[0])
                cell.sessionCellLabel.text = sessionFeedArray[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = bandSessions[indexPath.row]
            }
            cellArray.append(cell)
        }
        if(self.currentButton == "active"){
            if activeSessionsArray.count == 0{
                cell.emptyLabel.isHidden = false
                cell.emptyLabel.text = "No Active Sessions"
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.emptyLabel.textColor = UIColor.white
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.isHidden = true
                
            }else{
                cell.emptyLabel.isHidden = true
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.sessionCellImageView.isHidden = false
                cell.sessionCellLabel.isHidden = false
            }
            if(indexPath.row < activeSessionsArray.count){
                
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((activeSessionsArray[indexPath.row] as Session).sessionPictureURL[0])
                cell.sessionCellLabel.text = activeSessionsArray[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = bandSessions[indexPath.row]
            }
            cellArray.append(cell)
        }
        if(self.currentButton == "all"){
            if allSessions.count == 0{
                cell.sessionCellImageView.isHidden = true
                cell.sessionCellLabel.isHidden = true
                cell.emptyLabel.isHidden = false
                cell.emptyLabel.text = "No Sessions to Show"
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.emptyLabel.textColor = UIColor.white
            }else{
                cell.emptyLabel.isHidden = true
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.sessionCellImageView.isHidden = false
                cell.sessionCellLabel.isHidden = false
            }
            if(indexPath.row < allSessions.count){
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((allSessions[indexPath.row] as Session).sessionPictureURL[0])
                cell.sessionCellLabel.text = allSessions[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = bandSessions[indexPath.row]
            }
            cellArray.append(cell)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        /*if(self.currentButton == "active"){
            
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.activeSessionsArray.count)
                let totalSpacingWidth = 10 * (self.activeSessionsArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        
        else if(self.currentButton == "past"){
            
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.pastSessionArray.count)
                let totalSpacingWidth = 10 * (self.pastSessionArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        
        else if(self.currentButton == "upcoming"){
            
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.upcomingSessionArray.count)
                let totalSpacingWidth = 10 * (self.upcomingSessionArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        
        else if(self.currentButton == "all"){
            
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.allSessions.count)
                let totalSpacingWidth = 10 * (self.allSessions.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        
        else{
            
                
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.sessionFeedArray.count)
                let totalSpacingWidth = 10 * (self.sessionFeedArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            
        }*/
        return UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
    
    func finishedShowing(viewController: UIViewController) {
        //if viewController.isBeingPresented && viewController.presentingViewController == self
        //{
        //self.shadeView.isHidden = true
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(1.0)
        /*self.allSessionsCollect.reloadData()
        self.currentSessionsCollect.reloadData()
        self.pastSessionsCollect.reloadData()
        self.upcomingSessionsCollect.reloadData()
        self.sessionsOnFeedCollect.reloadData()
        self.dismiss(animated: true, completion: nil)*/
        return
        //}
        
        // self.navigationController?.popViewController(animated: true)
    }

    
    
    
    
    

    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath as IndexPath) as! ArtistCell
        let tempArtist = Artist()
        //let userID = Auth.auth().currentUser?.uid
        var artistArray = [String]()
        var instrumentArray = [String]()
        for value in thisBand.bandMembers{
            artistArray.append(value.key)
            instrumentArray.append(value.value as! String)
        }
        

        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == artistArray[indexPath.row]{
                        let dictionary = snap.value as? [String: Any]
                        print(dictionary! as [String:Any])
                        tempArtist.setValuesForKeys(dictionary!)
                    }
                }
            }
        
       /* print()
            let dictionary = snapshot.value as? [String: AnyObject]
            tempArtist.setValuesForKeys(dictionary!)*/

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
    }
    
    func dateFormatted(dateString: String)->Date{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yy"
        
        let dateObj = dateFormatter.date(from: dateString)
        
        
        return(dateObj)!
        
    }
    
    @IBOutlet weak var sessionPicker: UIPickerView!
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    var sessText = ["All","Upcoming","Past", "Active","On Feed"]
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return sessText.count
        
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = sessText[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 8.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if self.sessText[row] == "Past"{
            print("p")
            /*if pastSessionArray.count == 0{
                (pastSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = false
                (pastSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.text = "No Past Sessions"
                (pastSessionsCollect.visibleCells.first as! SessionCell).layer.borderColor = UIColor.white.cgColor
                (pastSessionsCollect.visibleCells.first as! SessionCell).layer.borderWidth = 2
                (pastSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.textColor = UIColor.white
            }else{
                (pastSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = true
            }*/
            print(pastSessionArray.count)
            currentSessionsCollect.isHidden = true
            upcomingSessionsCollect.isHidden = true
            pastSessionsCollect.isHidden = false
            sessionsOnFeedCollect.isHidden = true
            allSessionsCollect.isHidden = true
        }else if self.sessText[row] == "Active"{
           /* if activeSessionsArray.count == 0{
                (currentSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = false
                (currentSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.text = "No Active Sessions"
                (currentSessionsCollect.visibleCells.first as! SessionCell).layer.borderColor = UIColor.white.cgColor
                (currentSessionsCollect.visibleCells.first as! SessionCell).layer.borderWidth = 2
                (currentSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.textColor = UIColor.white
            }else{
                (currentSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = true
            }*/

            
            print("a")
            print(activeSessionsArray.count)
            currentSessionsCollect.isHidden = false
            upcomingSessionsCollect.isHidden = true
            pastSessionsCollect.isHidden = true
            sessionsOnFeedCollect.isHidden = true
            allSessionsCollect.isHidden = true
        }else if self.sessText[row] == "Upcoming"{
           /* if upcomingSessionArray.count == 0{
                (upcomingSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = false
                (upcomingSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.text = "No Upcoming Sessions"
                (upcomingSessionsCollect.visibleCells.first as! SessionCell).layer.borderColor = UIColor.white.cgColor
                (upcomingSessionsCollect.visibleCells.first as! SessionCell).layer.borderWidth = 2
                (upcomingSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.textColor = UIColor.white
            }else{
                (upcomingSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = true
            }*/

            print("U")
            print(upcomingSessionArray.count)
            currentSessionsCollect.isHidden = true
            upcomingSessionsCollect.isHidden = false
            pastSessionsCollect.isHidden = true
            sessionsOnFeedCollect.isHidden = true
            allSessionsCollect.isHidden = true
        }
        else if self.sessText[row] == "All"{
           /* if allSessions.count == 0{
                (allSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = false
                (allSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.text = "No Sessions to Display"
                (allSessionsCollect.visibleCells.first as! SessionCell).layer.borderColor = UIColor.white.cgColor
                (allSessionsCollect.visibleCells.first as! SessionCell).layer.borderWidth = 2
                (allSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.textColor = UIColor.white
            }else{
                (allSessionsCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = true
            }*/

            
            print("all")
            print(allSessions.count)
            currentSessionsCollect.isHidden = true
            upcomingSessionsCollect.isHidden = true
            pastSessionsCollect.isHidden = true
            sessionsOnFeedCollect.isHidden = true
            allSessionsCollect.isHidden = false
            
        }
        else{
            
            /*if sessionFeedArray.count == 0{
                (sessionsOnFeedCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = false
                (sessionsOnFeedCollect.visibleCells.first as! SessionCell).emptyLabel.text = "No Sessions On Feed"
                (sessionsOnFeedCollect.visibleCells.first as! SessionCell).layer.borderColor = UIColor.white.cgColor
                (sessionsOnFeedCollect.visibleCells.first as! SessionCell).layer.borderWidth = 2
                (sessionsOnFeedCollect.visibleCells.first as! SessionCell).emptyLabel.textColor = UIColor.white
            }else{
                (sessionsOnFeedCollect.visibleCells.first as! SessionCell).emptyLabel.isHidden = true
            }*/

            
            print("f")
            print(sessionFeedArray.count)
            currentSessionsCollect.isHidden = true
            upcomingSessionsCollect.isHidden = true
            pastSessionsCollect.isHidden = true
            sessionsOnFeedCollect.isHidden = false
            allSessionsCollect.isHidden = true
            
            
        }
        
        
    }



    
    

}
