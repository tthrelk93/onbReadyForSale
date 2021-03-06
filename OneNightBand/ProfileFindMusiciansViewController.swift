//
//  ProfileFindMusiciansViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/24/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FlexibleSteppedProgressBar

class ProfileFindMusiciansViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, FlexibleSteppedProgressBarDelegate, UITabBarDelegate {
    @IBOutlet weak var addMusicians2Label: UILabel!
    var sender = String()
    var senderScreen = String()
    @IBOutlet weak var tabBar: UITabBar!
    @available(iOS 2.0, *)
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        self.sender = "artistFinder"
        if item == tabBar.items?[0]{
            //performSegue(withIdentifier: "ProfileToPFM", sender: self)
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "PFMTabBarToJoinBand", sender: self)
            
        } else if item == tabBar.items?[2]{
            performSegue(withIdentifier: "PFMTabBarToProfile", sender: self)
        } else {
            performSegue(withIdentifier: "PFMTabBarToFeed", sender: self)
        }
    }

    
    
    var progressBar: FlexibleSteppedProgressBar!
    var searchType = String()
    var artistUID = String()
    var wantedAd = [String:Any]()
    @IBOutlet weak var addMusiciansLabel: UILabel!
    //@IBOutlet weak var option2Label: UILabel!
    //@IBOutlet weak var option1Label: UILabel!
   // @IBAction func cancelButtonPressed(_ sender: Any) {
    //}
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonPressed(_ sender: Any) {
        inUseExisting = false
        addMusiciansLabel.isHidden = false
        addMusicians2Label.isHidden = false
        backButton.isHidden = true
        createNewButton.isHidden = false
        useExistingLabel.isHidden = false
        createNewLabel.isHidden = false
        useExistingBandButton.isHidden = false
        //orLabel.isHidden = false
        collectViewHolder.isHidden = true
        backButton.isHidden = true
        infoHolder.backgroundColor = UIColor.white.withAlphaComponent(0.63)
    }
    var cancelPressed = Bool()
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var createNewButton: UIButton!
    @IBOutlet weak var useExistingBandButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //option1Label.isHidden = false
        //option2Label.isHidden = false
        cancelPressed = true
        createNewButton.isHidden = false
        useExistingBandButton.isHidden = false
        //orLabel.isHidden = false
        collectViewHolder.isHidden = true
        backButton.isHidden = true
    }
    @IBOutlet weak var collectViewHolder: UIView!
    @IBOutlet weak var bandsCollect: UICollectionView!

    @IBOutlet weak var useExistingLabel: UILabel!
    @IBAction func useExistingBandPressed(_ sender: Any) {
        self.inUseExisting = true
       // option1Label.isHidden = true
       // option2Label.isHidden = true
        addMusiciansLabel.isHidden = true
        addMusicians2Label.isHidden = true
        self.topLabel.text = "Add Musicians To One of Your Bands or OneNightBands"
        infoHolder.backgroundColor = UIColor.clear
        backButton.isHidden = false
        createNewButton.isHidden = true
        useExistingLabel.isHidden = true
        createNewLabel.isHidden = true
        useExistingBandButton.isHidden = true
        //orLabel.isHidden = true
        collectViewHolder.isHidden = false
        backButton.isHidden = false
    }
    @IBOutlet weak var createNewLabel: UILabel!
    @IBAction func createNewBandOrOnb(_ sender: Any) {
        
        performSegue(withIdentifier: "CreateBandToMyBands", sender: self)
    }
    @IBOutlet weak var onbCollect: UICollectionView!
    var bandType = String()
    var bandID = String()
    var imageString = String()
    var bandName = String()
    var onbDate = String()
    
    @IBOutlet weak var progressBarFrame: UIProgressView!
    @IBOutlet weak var infoView: UIView!
    var inUseExisting = false
    @IBAction func infoButtonPressed(_ sender: Any) {
        
        if infoView.isHidden == true{
            infoView.isHidden = false
            topLabel.isHidden = true
            addMusiciansLabel.isHidden = true
            addMusicians2Label.isHidden = true
            backButton.isHidden = true
            createNewButton.isHidden = true
            useExistingLabel.isHidden = true
            createNewLabel.isHidden = true
            useExistingBandButton.isHidden = true
            //orLabel.isHidden = false
            collectViewHolder.isHidden = true
            backButton.isHidden = true
            infoHolder.isHidden = true

        } else {
            infoView.isHidden = true
            topLabel.isHidden = false
            
            //orLabel.isHidden = false
            if inUseExisting == true{
                collectViewHolder.isHidden = false
                backButton.isHidden = false
                self.topLabel.text = "Add Musicians To One of Your Bands or OneNightBands"
                addMusiciansLabel.isHidden = true
                addMusicians2Label.isHidden = true
                backButton.isHidden = false
                createNewButton.isHidden = true
                useExistingLabel.isHidden = true
                createNewLabel.isHidden = true
                useExistingBandButton.isHidden = true
            } else {
                collectViewHolder.isHidden = true
                backButton.isHidden = true
                self.topLabel.text = "Choose One of the Two Options Below to Continue Searching for Musicians"
                addMusiciansLabel.isHidden = false
                addMusicians2Label.isHidden = false
                backButton.isHidden = true
                createNewButton.isHidden = false
                useExistingLabel.isHidden = false
                createNewLabel.isHidden = false
                useExistingBandButton.isHidden = false
            }
            infoHolder.isHidden = false
        }
    }
    var progressBounds = CGRect()
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    
     let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 10
        progressBounds = progressBarFrame.frame
        tabBar.delegate = self
        tabBar.tintColor = ONBPink
        tabBar.selectedItem = tabBar.items?[0]
        progressBar = FlexibleSteppedProgressBar()
        progressBar.frame = progressBounds
        progressBar.viewBackgroundColor = UIColor.blue
        progressBar.backgroundShapeColor = UIColor.white.withAlphaComponent(40)
        progressBar.selectedBackgoundColor = UIColor.blue
        progressBar.stepTextColor = UIColor.white
        progressBar.currentSelectedTextColor = ONBPink
        progressBar.currentSelectedCenterColor = ONBPink
        progressBar.selectedOuterCircleStrokeColor = ONBPink
        progressBar.isUserInteractionEnabled = false
        progressBar.currentIndex = 0
        progressBar.isHidden = true
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressBar)
        
        //let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
       /* let verticalConstraint = progressBar.topAnchor.constraintEqualToAnchor(
            equalTo: view.topAnchor,
            constant: 80
        )
        let widthConstraint = progressBar.constraint.constraintEqualToAnchor(nil, constant: 500)
        let heightConstraint = progressBar.constraint.constraintEqualToAnchor(nil, constant: 150)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])*/
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 3
        progressBar.lineHeight = 9
        progressBar.radius = 15
        progressBar.progressRadius = 50
        progressBar.progressLineHeight = 3
        progressBar.delegate = self
        //progressBar.didSelect
        
       infoButton.backgroundColor = UIColor.clear
        infoButton.layer.borderColor = ONBPink.cgColor
        infoButton.layer.borderWidth = 2
       infoButton.layer.cornerRadius = infoButton.frame.height/2
        self.topLabel.text = "Invite Musician to either a Band or OneNightBand"
       
        loadCollectionViews()
        backButton.isHidden = true
        createNewButton.isHidden = false
        useExistingBandButton.isHidden = false
        //orLabel.isHidden = false
        collectViewHolder.isHidden = true
        backButton.isHidden = true
        
        //wantedAd.bandID = self.bandID
        //wantedAd.bandType = self.bandType
        //wantedAd.wantedImage = self.imageString
        //wantedAd.bandName = self.bandName
        //if self.bandType == "onb"{
          //  wantedAd.date = self.onbDate
       // }
        
       /* if self.bandType == "band"{
            ref.child("bands").child(selectedBandID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == "bandPictureURL"{
                            var tempArray = snap.value as! [String]
                            //self.bandImageView.loadImageUsingCacheWithUrlString(tempArray.first!)
                            self.imageString = tempArray.first!
                        }
                        if snap.key == "bandName"{
                            self.bandName = snap.value as! String
                        }
                        
                    }
                }
            })
        } else if self.bandType == "onb" {
            ref.child("oneNightBands").child(selectedBandID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == "onbPictureURL"{
                            var tempArray = snap.value as! [String]
                            //self.bandImageView.loadImageUsingCacheWithUrlString(tempArray.first!)
                            self.imageString = tempArray.first!
                        }
                        if snap.key == "onbName"{
                            self.bandName = snap.value as! String
                        }
                        if snap.key == "onbDate"{
                            self.onbDate = snap.value as! String
                        }
                        
                    }
                }
            })
            
            
        }*/

        

        // Do any additional setup after loading the view.
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom{
            switch index {
                
            case 0: return "Select Band"
            case 1: return "Search Type"
            case 2: return "Find Musicians"
            //case 3: return "Fourth"
            //case 4: return "Fifth"
            default: return "Date"
                
            }
        }
        return ""
    }
    
    
    
    //var wantedAd = WantedAd()
    var picArray = [UIImage]()
    let userID = Auth.auth().currentUser?.uid
    var bandArray = [Band]()
    var bandIDArray = [String]()
    var ONBArray = [Band]()
    var bandsDict = [String: Any]()
    var sizingCell: SessionCell?
    var onbArray = [ONB]()
    var onbDict = [String: Any]()
    var onbIDArray = [String]()
    var ref = Database.database().reference()
    
    
    
    func loadCollectionViews(){
        bandArray.removeAll()
        ONBArray.removeAll()
        //navigationItem.title = "Your Bands"
        bandsCollect.isHidden = false
        onbCollect.isHidden = false
        
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("bands").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let dictionary = snap.value as? [String: Any]
                    let tempBand = Band()
                    tempBand.setValuesForKeys(dictionary!)
                    self.bandArray.append(tempBand)
                    self.bandsDict[tempBand.bandID!] = tempBand
                }
            }
            
            self.ref.child("users").child(userID!).child("artistsBands").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        self.bandIDArray.append((snap.value! as! String))
                    }
                }
                
                self.ref.child("oneNightBands").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            let dictionary = snap.value as? [String: Any]
                            let tempONB = ONB()
                            tempONB.setValuesForKeys(dictionary!)
                            self.onbArray.append(tempONB)
                            self.onbDict[tempONB.onbID] = tempONB
                        }
                    }
                    self.ref.child("users").child(userID!).child("artistsONBs").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots{
                                self.onbIDArray.append((snap.value! as! String))
                            }
                        }
                        
                        
                        
                        
                        
                        
                        DispatchQueue.main.async {
                            for _ in self.bandIDArray{
                                
                                let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                self.bandsCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                self.bandsCollect.backgroundColor = UIColor.clear
                                self.bandsCollect.dataSource = self
                                self.bandsCollect.delegate = self
                            }
                            DispatchQueue.main.async{
                                for _ in self.onbIDArray{
                                    let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                    self.onbCollect.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                    self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                    self.onbCollect.backgroundColor = UIColor.clear
                                    self.onbCollect.dataSource = self
                                    self.onbCollect.delegate = self
                                }
                            }
                        }
                    })
                })
            })
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == bandsCollect{
            return self.bandIDArray.count
        }
        else{
            return self.onbIDArray.count
        }
        
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        var tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for: indexPath) as! SessionCell
        if collectionView == bandsCollect{
            tempCell.sessionCellImageView.loadImageUsingCacheWithUrlString((bandsDict[bandIDArray[indexPath.row]] as! Band).bandPictureURL[0])
            //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
            tempCell.sessionCellLabel.text = (bandsDict[bandIDArray[indexPath.row]] as! Band).bandName
            tempCell.sessionCellLabel.textColor = UIColor.white
            tempCell.sessionId = (bandsDict[bandIDArray[indexPath.row]] as! Band).bandID
        }
        else {
            tempCell.sessionCellImageView.loadImageUsingCacheWithUrlString((onbDict[onbIDArray[indexPath.row]] as! ONB).onbPictureURL[0])
            //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
            tempCell.sessionCellLabel.text = (onbDict[onbIDArray[indexPath.row]] as! ONB).onbName
            tempCell.sessionCellLabel.textColor = UIColor.white
            tempCell.sessionId = (onbDict[onbIDArray[indexPath.row]] as! ONB).onbID
        }
        
        return tempCell
    }
    var tempIndex = Int()
    var selectedBandID = String()
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        /*if(collectionView == bandsCollect){
            if self.bandIDArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.bandIDArray.count)
                let totalSpacingWidth = 10 * (self.bandIDArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        else{
            if self.onbIDArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.onbIDArray.count)
                let totalSpacingWidth = 10 * (self.onbIDArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
            
        }*/
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    var inviteDict = [String:Any]()
    var bandSelected = Band()
    var onbSelected = ONB()
    var wantedIDArray2 = [String]()
    //if destination is af go to af vice versa
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wantedReference = ref.child("wantedAds").childByAutoId()
        let wantedReferenceAnyObject = wantedReference.key
        if self.searchType == "wanted"{
        if(collectionView == self.bandsCollect){
            tempIndex = indexPath.row
            self.selectedCell = "band"
            self.bandSelected = bandArray[indexPath.row]
            
            self.selectedBandID = bandArray[indexPath.row].bandID!
            
            
            
                       // var values2 = [String:Any]()
            wantedAd["bandType"] = "band"
            wantedAd["bandID"] = bandArray[indexPath.row].bandID!
            wantedAd["bandName"] = bandArray[indexPath.row].bandName!
            //wantedAd["city"] = self.locationText
           wantedAd["date"] = "n/a"
            
            wantedAd["senderID"] = self.currentUser!
            wantedAd["wantedImage"] = bandArray[indexPath.row].bandPictureURL.first!
            wantedAd["wantedID"] = wantedReferenceAnyObject
            
            wantedReference.updateChildValues(wantedAd, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
                
            })
            self.ref.child("bands").child(bandArray[indexPath.row].bandID!).child("wantedAds").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        
                        self.wantedIDArray2.append(snap.value as! String)
                    }
                }
                
                self.wantedIDArray2.append(wantedReferenceAnyObject)
                var tempDict = [String:Any]()
                tempDict["wantedAds"] = self.wantedIDArray2
                let bandRef = self.ref.child("bands").child(self.bandID)
                bandRef.updateChildValues(tempDict, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err as Any)
                        return
                    }
                })
            })

            performSegue(withIdentifier: "PFMToProfile", sender: self)
            //}

            
            
        } else{
            tempIndex = indexPath.row
            self.selectedCell = "onb"
            self.onbSelected = onbArray[indexPath.row]
            
            self.selectedBandID = onbArray[indexPath.row].onbID
            
            
            
           
            // var values2 = [String:Any]()
            wantedAd["bandType"] = "onb"
            wantedAd["bandID"] = onbArray[indexPath.row].onbID
            wantedAd["bandName"] = onbArray[indexPath.row].onbName
            //wantedAd["city"] = self.locationText
            wantedAd["date"] = onbArray[indexPath.row].onbDate
            
            wantedAd["senderID"] = self.currentUser!
            wantedAd["wantedImage"] = onbArray[indexPath.row].onbPictureURL.first!
            wantedAd["wantedID"] = wantedReferenceAnyObject
            
            wantedReference.updateChildValues(wantedAd, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
                
            })
            self.ref.child("oneNightBands").child(onbArray[indexPath.row].onbID).child("wantedAds").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        
                        self.wantedIDArray2.append(snap.value as! String)
                    }
                }
                
                self.wantedIDArray2.append(wantedReferenceAnyObject)
                var tempDict = [String:Any]()
                tempDict["wantedAds"] = self.wantedIDArray2
                let onbRef = self.ref.child("oneNightBands").child(self.onbArray[indexPath.row].onbID)
                onbRef.updateChildValues(tempDict, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err as Any)
                        return
                    }
                })
            })

            performSegue(withIdentifier: "PFMToProfile", sender: self)           // }

            
            
            //upload info to database after asking if sure
            
            //performSegue(withIdentifier: "PFMToONB", sender: self)
            }
            
            var userValues = [String:Any]()
            var userWantedAdArray = [String]()
            ref.child("users").child(self.currentUser!).child("wantedAds").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        
                        let wantedID = snap.value as! String
                        userWantedAdArray.append(wantedID )
                        
                    }
                    
                }
            })
            userWantedAdArray.append(wantedReferenceAnyObject)
            var tempDict = [String:Any]()
            tempDict["wantedAds"] = userWantedAdArray
            ref.child("users").child(self.currentUser!).updateChildValues(tempDict)
            
        } else {
           
            
            if collectionView == bandsCollect{
                 self.selectedBandID = bandArray[indexPath.row].bandID!
                ref.child("users").child(artistUID).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if snap.key == "artistsBands"{
                                for string in snap.value as! [String]{
                                    if string == self.selectedBandID{
                                        let alert = UIAlertController(title: "Whoops!", message: "Artist already has pending invite for this band.", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return
                                    }
                                }
                            }
                        }
                    }
                    
                })
                let alert2 = UIAlertController(title: "Success!", message: "Invite Sent.", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)

                
                
               // let currentUser = Auth.auth().currentUser?.uid
                let recipient = self.ref.child("users").child(self.artistUID).child("invites")
                let tempID = recipient.childByAutoId()
                
                //values[sessRef] = testArray //as Any?
                //values["sender"] = currentUser!
                inviteDict["bandID"] = bandArray[indexPath.row].bandID!
                //values["instrumentNeeded"] = self.buttonName
                inviteDict["date"] = "n/a"//self.sessionDate
                inviteDict["inviteKey"] = String(describing: tempID.key)
                inviteDict["bandType"] = "band"//self.bandType
                //values["artistCount"] = self.artistCount
                //values["bandType"] = self.bandType
                inviteDict["bandName"] = bandArray[indexPath.row].bandName!
                //values["inviteResponse"] = String()
                
                
                tempID.updateChildValues(inviteDict, withCompletionBlock: {(err, ref) in
                 if err != nil {
                 print(err as Any)
                 return
                 }
                 })
                performSegue(withIdentifier: "PFMToProfile", sender: self)

            } else {
                 self.selectedBandID = onbArray[indexPath.row].onbID
                // let currentUser = Auth.auth().currentUser?.uid
                ref.child("users").child(artistUID).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if snap.key == "artistsONBs"{
                                for string in snap.value as! [String]{
                                    if string == self.selectedBandID{
                                        let alert = UIAlertController(title: "Whoops!", message: "Artist already has pending invite for this band.", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return
                                    }
                                }
                            }
                        }
                    }
                    
                })
                let alert2 = UIAlertController(title: "Success!", message: "Invite Sent.", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)

                let recipient = self.ref.child("users").child(self.artistUID).child("invites")
                let tempID = recipient.childByAutoId()
                
                //values[sessRef] = testArray //as Any?
                //values["sender"] = currentUser!
                inviteDict["bandID"] = onbArray[indexPath.row].onbID
                //values["instrumentNeeded"] = self.buttonName
                inviteDict["date"] = "n/a"//self.sessionDate
                inviteDict["inviteKey"] = String(describing: tempID.key)
                inviteDict["bandType"] = "onb"//self.bandType
                //values["artistCount"] = self.artistCount
                //values["bandType"] = self.bandType
                inviteDict["bandName"] = onbArray[indexPath.row].onbName
                //values["inviteResponse"] = String()
                
                
                tempID.updateChildValues(inviteDict, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err as Any)
                        return
                    }
                })
                performSegue(withIdentifier: "PFMToProfile", sender: self)

            }
        }
        
        
        
    }
    

    @IBOutlet weak var infoHolder: UIView!


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    var date = String()
    var instrumentNeeded = String()
    var moreInfoText = String()
    var locationText = String()
    var expText = String()
    
    var currentUser = Auth.auth().currentUser?.uid
    var wantedIDArray = [String]()
    var destination = String()
    var selectedCell = String()
    var PFMChoiceSelected = false
    var wantedAd2 = WantedAd()
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PFMTabBarToProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.userID = (Auth.auth().currentUser?.uid)!
                vc.artistID = (Auth.auth().currentUser?.uid)!
            }
        }
        if segue.identifier == "PFMToArtistFinder"{
            
            if let vc = segue.destination as? ArtistFinderViewController{
                if selectedCell == "band"{
                    vc.thisBandObject = bandSelected
                } else {
                    vc.thisONBObject = onbSelected
                }
                vc.senderScreen = "pfm"
                vc.bandID = self.selectedBandID
                vc.bandType = selectedCell
                vc.PFMChoiceSelected = true
                
                
                
            }
            
            
        }
        if segue.identifier == "CreateBandToMyBands"{
            if let vc = segue.destination as? MyBandsViewController{
                print("segueToMYBands")
                vc.sender = "pfm"
                vc.artistUID = self.artistUID
                vc.destination1 = self.destination
                vc.searchType = self.searchType
                if self.searchType == "wanted"{
                
               vc.wantedAd = self.wantedAd
                    // self.selectedBandID = ""

                
                vc.wantedAd = self.wantedAd
                //vc.onbID = self.onbIDArray[tempIndex]
                } else {
                    vc.inviteDict = self.inviteDict
                }
                
                
                }
        }
        if segue.identifier == "PFMToProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.userID = (Auth.auth().currentUser?.uid)!
                vc.artistID = (Auth.auth().currentUser?.uid)!
                if self.cancelPressed != true{
                    if self.searchType == "wanted"{
                    vc.sender = "wantedAdCreated"
                    } else {
                        vc.sender = "af"
                    }
                }
            }
            
        }
        if segue.identifier == "PFMToBand"{
            if let vc = segue.destination as? SessionMakerViewController{
                vc.sender = "pfm"
                vc.sessionID = self.bandIDArray[tempIndex]
                
                
                
                let ref = Database.database().reference()
                
                
                
            }
        }
        if segue.identifier == "CreateBandToFindMusicians"{
            if let vc = segue.destination as? MyBandsViewController{
                vc.sender = "pfm"
                //vc.destination = self.selectedButton
            
            }
        }
    }
    

}
