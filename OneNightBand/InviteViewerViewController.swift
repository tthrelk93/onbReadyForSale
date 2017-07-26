//
//  InviteViewerViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/18/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AuditAccepted: NSObject {
    var bandName = String()
    var bandID = String()
    var bandPic = String()
    
}

class AuditReceived: NSObject {
    var bandName = String()
    var userID = String()
    var bandID = String()
    var instrumentAuditFor = String()
    var bandPicURL = String()
    var additInfo1 = String()
    var additInfo2 = String()
    var bandType = String()
    var wantedID = String()
    var responseID = String()
}


class InviteViewerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AcceptDeclineDelegate, GoToBandDelegate {
    
    func goToBand(bandID: String){
        
    }
    @IBOutlet weak var noAuditionsReceivedLabel: UILabel!
    @IBOutlet weak var noNewAcceptedLAbel: UILabel!
    @IBOutlet weak var noInviteReceived: UILabel!
    func dismissAccepted(indexPath: IndexPath){
        
        //self.cellArray.remove(at: indexPath.row)
        
        ref.child("users").child(currentUser!).child("acceptedAudits").observeSingleEvent(of: .value, with: {(snapshot) in
            var tempArray = [[String:Any]]()
            if let snapArray = snapshot.value as? [[String:Any]]{
                
                for val in snapArray{
                    if ((val as [String:Any])["bandID"] as! String) != (self.auditAcceptedArray as! [AuditAccepted])[indexPath.row].bandID {
                        
                        
                        tempArray.append(val)
                        
                    }
                }
            }
            
                
            var tempDict = [String:Any]()
            tempDict["acceptedAudits"] = tempArray
            self.auditAcceptedArray.remove(at: indexPath.row)
            self.auditionsAcceptedCollect.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
            self.ref.child("users").child(self.currentUser!).updateChildValues(tempDict)
            })
    }
    @IBOutlet weak var wantedCollect: UICollectionView!
    @IBOutlet weak var auditionsAcceptedCollect: UICollectionView!
    
    @IBOutlet weak var invitesCollect: UICollectionView!
    
    var sender: String?
    var ref = Database.database().reference()
    var currentUser = Auth.auth().currentUser?.uid
    var inviteArray = [Invite]()
    var auditReceivedArray = [AuditReceived]()
    var auditAcceptedArray = [AuditAccepted]()
    var cellArray = [InviteCell]()
    var sizingCell1 = InviteCell()
    var sizingCell2 = WantedReceivedCell()
    var sizingCell3 = AcceptedCell()
    

    var wantedAdsOnFeed = [String]()
    
    var wantedAds = [WantedAd]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("sender:\(self.sender)")
            ref.child("users").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if snap.key == "invites"{
                                for inviteSnap in (snap.children.allObjects as! [DataSnapshot]){
                                    if let invites = inviteSnap.value as? [String:Any]{
                                        let invite = Invite()
                                        invite.setValuesForKeys(invites)
                                        self.inviteArray.append(invite)
                                    }
                                }
                            }
                            if snap.key == "wantedAds"{
                                for wantedSnap in (snap.children.allObjects as? [DataSnapshot])!{
                                    self.wantedAdsOnFeed.append(wantedSnap.value as! String)
                                }
                            }
                            if snap.key == "acceptedAudits"{
                               
                                    let acceptSnapArray = snap.value as! [[String:Any]]
                                for val in acceptSnapArray{
                                    let tempDict = val 
                                    let accepted = AuditAccepted()
                                    accepted.setValuesForKeys(tempDict)
                                    print("accepted:\(accepted)")
                                    self.auditAcceptedArray.append(accepted)
                                }
                               
                                
                            }
                        }
                }
                self.ref.child("wantedAds").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                if self.sender == "invite"{
                    self.invitesCollect.isHidden = false
                    self.auditionsAcceptedCollect.isHidden = true
                    self.wantedCollect.isHidden = true
                    if self.inviteArray.count == 0{
                        self.noInviteReceived.isHidden = false
                        self.noNewAcceptedLAbel.isHidden = true
                        self.noAuditionsReceivedLabel.isHidden = true
                    } else {
                        self.noInviteReceived.isHidden = true
                        self.noNewAcceptedLAbel.isHidden = true
                        self.noAuditionsReceivedLabel.isHidden = true
                    }
                    //DispatchQueue.main.async {
                      //  for _ in self.inviteArray{
                            let cellNib = UINib(nibName: "InviteCell", bundle: nil)
                            self.invitesCollect.register(cellNib, forCellWithReuseIdentifier: "InviteCell")
                            self.sizingCell1 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! InviteCell?)!
                            //self.inviteCollectionView.backgroundColor = UIColor.clear
                            self.invitesCollect.dataSource = self
                            self.invitesCollect.delegate = self
                            self.invitesCollect.gestureRecognizers?.first?.cancelsTouchesInView = false
                            self.invitesCollect.gestureRecognizers?.first?.delaysTouchesBegan = false
                            
                       // }
                   // }

                } else if self.sender == "auditReceived"{
                    print("inAuditRec")
                    self.invitesCollect.isHidden = true
                    self.auditionsAcceptedCollect.isHidden = true
                    self.wantedCollect.isHidden = false
                    
                   
                    
                            var auditReceivedDict = [String:Any]()
                            for snap in snapshots{
                                let tempWant = WantedAd()
                                let tempDict = snap.value as! [String:Any]
                                tempWant.setValuesForKeys(tempDict)
                                self.wantedAds.append(tempWant)
                                if self.wantedAdsOnFeed.contains(snap.key){
                                    
                                    if let ad = snap.value as? [String:Any]{
                                        print("ad: \(ad)")
                                        
                                        auditReceivedDict["bandName"] = ad["bandName"]
                                        auditReceivedDict["bandID"] = ad["bandID"]
                                        auditReceivedDict["instrumentAuditFor"] = (ad["instrumentNeeded"] as! String)
                                        auditReceivedDict["bandPicURL"] = ad["wantedImage"]
                                        auditReceivedDict["wantedID"] = ad["wantedID"]
                                        auditReceivedDict["bandType"] = ad["bandType"]
                                        if let adResponses = ad["responses"] as? [String:Any]{
                                        for (key, value) in adResponses{
                                            auditReceivedDict["responseID"] = key
                                            auditReceivedDict["userID"] = (value as! [String:Any])["respondingArtist"] as! String
                                            auditReceivedDict["additInfo1"] = (value as! [String:Any])["infoText1"]
                                            auditReceivedDict["additInfo2"] = (value as! [String:Any])["infoText2"]
                                            
                                        }
                                        print(auditReceivedDict)
                                    var tempAuditReceived = AuditReceived()
                                    tempAuditReceived.setValuesForKeys(auditReceivedDict)
                                    self.auditReceivedArray.append(tempAuditReceived)
                                        }
                                    }
                                    
                                    
                                }
                    }
                    print("auditRecievedDict: \(self.auditReceivedArray)")
                    
                       // DispatchQueue.main.async{
                            if self.auditReceivedArray.count == 0{
                                self.noInviteReceived.isHidden = true
                                self.noNewAcceptedLAbel.isHidden = true
                                self.noAuditionsReceivedLabel.isHidden = false
                            } else {
                                self.noInviteReceived.isHidden = true
                                self.noNewAcceptedLAbel.isHidden = true
                                self.noAuditionsReceivedLabel.isHidden = true
                            }
                            //for _ in self.auditReceivedArray{
                                let cellNib = UINib(nibName: "WantedReceivedCell", bundle: nil)
                                self.wantedCollect.register(cellNib, forCellWithReuseIdentifier: "WantedReceivedCell")
                                self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! WantedReceivedCell)
                                //self.inviteCollectionView.backgroundColor = UIColor.clear
                                self.wantedCollect.dataSource = self
                                self.wantedCollect.delegate = self
                                self.wantedCollect.gestureRecognizers?.first?.cancelsTouchesInView = false
                                self.wantedCollect.gestureRecognizers?.first?.delaysTouchesBegan = false
                           // }
                    
                   
                    
                } else {
                    self.invitesCollect.isHidden = true
                    self.auditionsAcceptedCollect.isHidden = false
                    self.wantedCollect.isHidden = true
                   // DispatchQueue.main.async{
                        if self.auditAcceptedArray.count == 0{
                            self.noInviteReceived.isHidden = true
                            self.noNewAcceptedLAbel.isHidden = false
                            self.noAuditionsReceivedLabel.isHidden = true
                        } else {
                            self.noInviteReceived.isHidden = true
                            self.noNewAcceptedLAbel.isHidden = true
                            self.noAuditionsReceivedLabel.isHidden = true
                        }
                        print(self.wantedAdsOnFeed.count)
                       // for _ in self.wantedAdsOnFeed{
                            let cellNib = UINib(nibName: "AcceptedCell", bundle: nil)
                            self.auditionsAcceptedCollect.register(cellNib, forCellWithReuseIdentifier: "AcceptedCell")
                            self.sizingCell3 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! AcceptedCell)
                            //self.inviteCollectionView.backgroundColor = UIColor.clear
                            self.auditionsAcceptedCollect.dataSource = self
                            self.auditionsAcceptedCollect.delegate = self
                            self.auditionsAcceptedCollect.gestureRecognizers?.first?.cancelsTouchesInView = false
                            self.auditionsAcceptedCollect.gestureRecognizers?.first?.delaysTouchesBegan = false
                        //}
                   // }
                    
                   

                        }
                    }
                
                })
        
        
                
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var onbArray = [String]()
    var bandArray = [String]()
    func acceptPressed(indexPathRow: Int, indexPath: IndexPath, curCell: InviteCell){
        DispatchQueue.main.async {
            
           // noAuditionsReceivedLabel.isHidden =
            var tempDict = [String: Any]()
            var tempDict2 = [String: Any]()
            var tempDict3 = [String: Any]()
            print("accept Pressed")
            
            for invite in 0...self.inviteArray.count - 1{
                if curCell == self.cellArray[invite]{
                    if self.inviteArray[indexPathRow].bandType == "onb"{
                        Database.database().reference().child("users").child(self.currentUser!).child("artistsONBs").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots{
                                self.onbArray.append(snap.value as! String)
                            }
                            self.onbArray.append(self.inviteArray[invite].bandID)
                            tempDict2["artistsONBs"] = self.onbArray
                            Database.database().reference().child("users").child(self.currentUser!).updateChildValues(tempDict2)
                        }
                        Database.database().reference().child("oneNightBands").child(curCell.bandID).child("onbArtists").observeSingleEvent(of: .value, with: { (snapshot) in
                            var dictionary = [String:Any]()
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    dictionary[snap.key] = snap.value
                                }
                                dictionary[self.currentUser!] = self.inviteArray[invite].instrumentNeeded
                                tempDict3["onbArtists"] = dictionary
                                
                                Database.database().reference().child("oneNightBands").child(curCell.bandID).updateChildValues(tempDict3)
                            }
                            Database.database().reference().child("users").child(self.currentUser!).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                var tempDict6 = [String:Any]()
                                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                    //var index = 0
                                    
                                    var temp = self.inviteArray[invite].dictionaryWithValues(forKeys: ["inviteKey"])
                                    for snap in snapshots{
                                        
                                        if (snap.value as! [String: Any])["inviteKey"] as! String == temp["inviteKey"] as! String{
                                            
                                            
                                        }else{
                                            tempDict[snap.key] = snap.value
                                        }
                                    }
                                    tempDict6["invites"] = tempDict
                                    Database.database().reference().child("users").child(self.currentUser!).updateChildValues(tempDict6)
                                }
                                DispatchQueue.main.async {
                                    
                                    self.inviteArray.remove(at: invite)
                                    self.cellArray.remove(at: invite)
                                    self.invitesCollect.deleteItems(at: [IndexPath(row: invite, section: 0)])
                                    print("InviteCollectionViewCells: \(self.invitesCollect.visibleCells.count)")
                                }
                                
                            })
                            })
                        })
                } else {
                        Database.database().reference().child("users").child(self.currentUser!).child("artistsBands").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                //var index = 0
                                for snap in snapshots{
                                    self.bandArray.append(snap.value as! String)
                                }
                                self.bandArray.append(self.inviteArray[invite].bandID)
                                tempDict2["artistsBands"] = self.bandArray
                                Database.database().reference().child("users").child(self.currentUser!).updateChildValues(tempDict2)
                            }
                            Database.database().reference().child("bands").child(curCell.bandID).child("bandMembers").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                var dictionary = [String:Any]()
                                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                    for snap in snapshots{
                                        dictionary[snap.key] = snap.value
                                    }
                                    dictionary[self.currentUser!] = self.inviteArray[invite].instrumentNeeded
                                    tempDict3["bandMembers"] = dictionary
                                    Database.database().reference().child("bands").child(curCell.bandID).updateChildValues(tempDict3)
                                }
                                Database.database().reference().child("users").child(self.currentUser!).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
                                    var tempDict6 = [String:Any]()
                                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                        var temp = self.inviteArray[invite].dictionaryWithValues(forKeys: ["inviteKey"])
                                        for snap in snapshots{
                                            
                                            if (snap.value as! [String: Any])["inviteKey"] as! String == temp["inviteKey"] as! String{
                                            }else{
                                                tempDict[snap.key] = snap.value
                                            }
                                        }
                                        tempDict6["invites"] = tempDict
                                        Database.database().reference().child("users").child(self.currentUser!).updateChildValues(tempDict6)
                                    }
                                    DispatchQueue.main.async {
                                        self.inviteArray.remove(at: invite)
                                        self.cellArray.remove(at: invite)
                                        self.invitesCollect.deleteItems(at: [IndexPath(row: invite, section: 0)])
                                        print("InviteCollectionViewCells: \(self.invitesCollect.visibleCells.count)")
                                    }
                                })
                            })
                        })
                    }
                    break
                
                }
            }
        }
    }
    
    func declinePressed(indexPathRow: Int, indexPath: IndexPath, curCell: InviteCell){
        for invite in 0...self.cellArray.count-1{
            
            if curCell == self.cellArray[invite]{
                Database.database().reference().child("users").child(self.currentUser!).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    var tempDict6 = [String:Any]()
                    var tempDict = [String:Any]()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        //var index = 0
                        print(indexPath.row)
                        var temp = self.inviteArray[invite].dictionaryWithValues(forKeys: ["inviteKey"])
                        for snap in snapshots{
                            
                            if (snap.value as! [String: Any])["inviteKey"] as! String == temp["inviteKey"] as! String{
                                
                            }else{
                                tempDict[snap.key] = snap.value
                            }
                        }
                        tempDict6["invites"] = tempDict
                        Database.database().reference().child("users").child(self.currentUser!).updateChildValues(tempDict6)
                        
                        
                        
                        
                    }
                    DispatchQueue.main.async {
                        
                        self.inviteArray.remove(at: invite)
                        self.cellArray.remove(at: invite)
                        self.invitesCollect.deleteItems(at: [IndexPath(row: invite, section: 0)])
                        print("InviteCollectionViewCells: \(self.invitesCollect.visibleCells.count)")
                    }
                    
                })
                
                
                break
                
            }
            
        }
        
    }
    var acceptedUploadArray = [[String:Any]]()
    func acceptPressedWanted(indexPathRow: Int, indexPath: IndexPath, curCell: WantedReceivedCell){
        //add senderID to band/ONB artists. 
        //add band/onb to senders bands/onbs.
        //remove wantedAd From collect
        //add band name and bandID to acceptedAuditions of sender
        print("in acceptPressedWanted")
        for wanted in 0...self.auditReceivedArray.count - 1{
            if curCell == self.cellArray2[wanted]{
        if curCell.bandType == "onb"{
            ref.child("oneNightBands").child(curCell.bandID).child("onbArtists").observeSingleEvent(of: .value, with: {(snapshot) in
                var values1 = [String:Any]()
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        values1[snap.key] = snap.value as! String
                    }
                }
                values1[curCell.artistID] = curCell.instrumentLabel.text
                self.ref.child("oneNightBands").child(curCell.bandID).child("onbArtists").updateChildValues(values1)
                self.ref.child("wantedAds").child(curCell.wantedID).child("responses").observeSingleEvent(of: .value, with: {(snapshot) in
                    var tempDict = [String:Any]()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            tempDict[snap.key] = snap.value as! [String:Any]
                        }
                        print(curCell.wantedID)
                        print("tempDict b4:\(tempDict)")
                        print("responseID: \(curCell.responseID)")
                        for (key,_) in tempDict{
                            if key == curCell.responseID{
                                print(tempDict.count)
                                if tempDict.count == 1{
                                    self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").observeSingleEvent(of: .value, with: {(snapshot) in
                                        var tempArray = [String]()
                                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                            
                                            for snap in snapshots{
                                                if snap.value as! String != curCell.wantedID{
                                                    tempArray.append(snap.value as! String)
                                                }
                                            }
                                           
                                            var tempDict2 = [String:Any]()
                                            tempDict2["wantedAdResponses"] = tempArray
                                            self.ref.child("users").child(self.currentUser!).updateChildValues(tempDict2)
                                        }
                                    })
                                }

                                tempDict.removeValue(forKey: key)
                                break
                            }
                        }
                        print("tempDict aftr:\(tempDict)")
                        var respDict = [String:Any]()
                        respDict["responses"] = tempDict
                        self.ref.child("wantedAds").child(curCell.wantedID).updateChildValues(respDict)
                    }
                    
                    
                })

                self.ref.child("users").child(curCell.artistID).observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        var auditDict = [String:Any]()
                        var tempArray = [String]()
                        for snap in snapshots{
                            if snap.key == "acceptedAudits"{
                                for val in (snap.value as! [[String:Any]]){
                                    self.acceptedUploadArray.append(val)
                                                                    }
                                break
                            }
                            if snap.key == "artistsONBs"{
                                if let artistSnaps = snap.value as? [String]{
                                    for onb in artistSnaps{
                                        tempArray.append(onb)
                                    }
                                    
                                }
                            }
                        
                        }
                        tempArray.append(curCell.bandID)
                        var tempDict = [String:Any]()
                        tempDict["artistsONBs"] = tempArray
                        self.ref.child("users").child(curCell.artistID).updateChildValues(tempDict)
                        auditDict["bandName"] = curCell.bandNameLabel.text!
                        auditDict["bandID"] = curCell.bandID
                        for wanted in self.wantedAds{
                            if wanted.wantedID == curCell.wantedID{
                                auditDict["bandPic"] = wanted.wantedImage
                            }
                        }
                        self.acceptedUploadArray.append(auditDict)
                        var tempDict2 = [String:Any]()
                        tempDict2["acceptedAudits"] = self.acceptedUploadArray
                        self.ref.child("users").child(curCell.artistID).updateChildValues(tempDict2)
                    }
                    DispatchQueue.main.async {
                        self.auditReceivedArray.remove(at: wanted)
                        self.cellArray2.remove(at: wanted)
                        self.wantedCollect.deleteItems(at: [IndexPath(row: wanted, section: 0)])
                    }

                    
                })
            })
        } else {
            ref.child("bands").child(curCell.bandID).child("bandMembers").observeSingleEvent(of: .value, with: {(snapshot) in
                var values1 = [String:Any]()
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        values1[snap.key] = snap.value as! String
                    }
                }
                values1[curCell.artistID] = curCell.instrumentLabel.text
                self.ref.child("bands").child(curCell.bandID).child("bandMembers").updateChildValues(values1)
                self.ref.child("wantedAds").child(curCell.wantedID).child("responses").child(curCell.responseID).removeValue()
                
                var removeKey: String?
                self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").observeSingleEvent(of: .value, with: {(snapshot) in
                    var tempArray = [String]()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        
                        for snap in snapshots{
                            if snap.value as! String != curCell.wantedID{
                                self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").child(snap.key).removeValue()
                                break
                            }
                        }
                    }
                    //self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").child(removeKey!).removeValue()
                })
                    
                
                /*self.ref.child("wantedAds").child(curCell.wantedID).child("responses").observeSingleEvent(of: .value, with: {(snapshot) in
                    var tempDict = [String:Any]()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            tempDict[snap.key] = snap.value as! [String:Any]
                        }
                        
                        
                        for (key,_) in tempDict{
                            if key == curCell.responseID{
                                
                                    self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").observeSingleEvent(of: .value, with: {(snapshot) in
                                        var tempArray = [String]()
                                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                        
                                            for snap in snapshots{
                                                if snap.key != curCell.wantedID{
                                                    tempArray.append(snap.value as! String)
                                                }
                                            }
                                            var tempDict2 = [String:Any]()
                                            tempDict2["wantedAdResponses"] = tempArray
                                            self.ref.child("users").child(self.currentUser!).updateChildValues(tempDict2)
                                        }
                                    })
                            
                                tempDict.removeValue(forKey: key)
                                break
                            }
                        }
                        self.ref.child("wantedAds").child(curCell.wantedID).child("responses").updateChildValues(tempDict)
                    }
                    
                })*/
                self.ref.child("users").child(curCell.artistID).observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        var auditDict = [String:Any]()
                        var tempArray = [String]()
                        for snap in snapshots{
                            if snap.key == "acceptedAudits"{
                                for (key, value) in (snap.value as! [String:Any]){
                                    auditDict[key] = value
                                }
                                break
                            }
                            if snap.key == "artistsBands"{
                                if let artistBands = snap.value as? [String]{
                                    for band in artistBands{
                                        tempArray.append(band)
                                    }
                                    
                                }
                            }
                            

                        }
                        tempArray.append(curCell.bandID)
                        var tempDict = [String:Any]()
                        tempDict["artistsBands"] = tempArray
                        self.ref.child("users").child(curCell.artistID).updateChildValues(tempDict)
                        auditDict[curCell.bandNameLabel.text!] = curCell.bandID
                        self.ref.child("users").child(curCell.artistID).child("acceptedAudits").updateChildValues(auditDict)
                    }
                    DispatchQueue.main.async {
                        self.auditReceivedArray.remove(at: wanted)
                        self.cellArray2.remove(at: wanted)
                        self.wantedCollect.deleteItems(at: [IndexPath(row: wanted, section: 0)])
                    }

                    
                })
            })
                }
                break
            }
        }
        
        
    }
    func declinePressedWanted(indexPathRow: Int, indexPath: IndexPath, curCell: WantedReceivedCell){
        self.ref.child("wantedAds").child(curCell.wantedID).child("responses").child(curCell.responseID).removeValue()
        
        var removeKey: String?
        self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").observeSingleEvent(of: .value, with: {(snapshot) in
            //var tempArray = [String]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                    if snap.value as! String != curCell.wantedID{
                        removeKey = snap.key
                        break
                    }
                }
            }
            self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").child(removeKey!).removeValue()
        })

        /*for wanted in 0...self.cellArray2.count-1{
         
            if curCell == self.cellArray2[wanted]{
                
                
                
                
                self.ref.child("wantedAds").child(curCell.wantedID).child("responses").observeSingleEvent(of: .value, with: {(snapshot) in
                    var tempDict = [String:Any]()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            tempDict[snap.key] = snap.value as! [String:Any]
                        }
                        print(curCell.wantedID)
                        print("tempDict b4:\(tempDict)")
                        print("responseID: \(curCell.responseID)")
                        for (key,_) in tempDict{
                            if key == curCell.responseID{
                                print(tempDict.count)
                                if tempDict.count == 1{
                                    self.ref.child("users").child(self.currentUser!).child("wantedAdResponses").observeSingleEvent(of: .value, with: {(snapshot) in
                                        var tempArray = [String]()
                                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                            
                                            for snap in snapshots{
                                                if snap.value as! String != curCell.wantedID{
                                                    tempArray.append(snap.value as! String)
                                                }
                                            }
                                            var tempDict2 = [String:Any]()
                                            tempDict2["wantedAdResponses"] = tempArray
                                            self.ref.child("users").child(self.currentUser!).updateChildValues(tempDict2)
                                        }
                                    })
                                }
                                
                                tempDict.removeValue(forKey: key)
                                break
                            }
                        }
                        print("tempDict aftr:\(tempDict)")
                        var respDict = [String:Any]()
                        respDict["responses"] = tempDict
                        self.ref.child("wantedAds").child(curCell.wantedID).updateChildValues(respDict)
                    }
                        DispatchQueue.main.async{
                            self.auditReceivedArray.remove(at: wanted)

                            self.wantedCollect.deleteItems(at: [IndexPath(row: wanted, section: 0)])
                            print("WantedCollectionViewCells: \(self.wantedCollect.visibleCells.count)")
                            }
                    
                })
                
            }
            break
        }*/
    }
    


    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.sender == "invite"{
            return inviteArray.count
        }
        else if self.sender == "auditReceived"{
            return auditReceivedArray.count
        } else {
            //print("auditCollectArray: \(auditAcceptedArray[0].bandName)")
            return auditAcceptedArray.count
        }
        
    }
    
    var cellArray2 = [WantedReceivedCell]()
    var cellArray3 = [AcceptedCell]()
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == invitesCollect{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InviteCell", for: indexPath as IndexPath) as! InviteCell
            cell.acceptDeclineDelegate = self
        
            self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        
            cellArray.append(cell)
        
            return cell
        } else if collectionView == wantedCollect{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WantedReceivedCell", for: indexPath as IndexPath) as! WantedReceivedCell
            cell.acceptDeclineDelegate = self
            
            self.configureWantedCell(cell, forIndexPath: indexPath as NSIndexPath)
            
            cellArray2.append(cell)
            
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AcceptedCell", for: indexPath as IndexPath) as! AcceptedCell
            
            self.configureAcceptedCell(cell, forIndexPath: indexPath as NSIndexPath)
            
            cellArray3.append(cell)
            
            return cell

        }
        
        
    }
    func configureAcceptedCell(_ cell: AcceptedCell, forIndexPath indexPath: NSIndexPath){
        cell.bandNameLabel.text = auditAcceptedArray[indexPath.row].bandName
        cell.bandImageView.loadImageUsingCacheWithUrlString(auditAcceptedArray[indexPath.row].bandPic)
        cell.bandID = auditAcceptedArray[indexPath.row].bandID
        cell.goToBandDelegate = self
        cell.indexPath = indexPath as IndexPath
        
    
    }
    func configureWantedCell(_ cell: WantedReceivedCell, forIndexPath indexPath: NSIndexPath){
        self.ref.child("users").child(auditReceivedArray[indexPath.row].userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        cell.artistNameLabel.text = snap.value as? String
                    }
                }
            }
            cell.indexPath = indexPath as IndexPath!
            cell.artistID = self.auditReceivedArray[indexPath.row].userID
            cell.bandNameLabel.text = self.auditReceivedArray[indexPath.row].bandName
            cell.artistImageView.loadImageUsingCacheWithUrlString(self.auditReceivedArray[indexPath.row].bandPicURL)
            cell.moreInfoTextView1.text = self.auditReceivedArray[indexPath.row].additInfo1
            cell.moreInfoTextView2.text = self.auditReceivedArray[indexPath.row].additInfo2
            cell.bandID = self.auditReceivedArray[indexPath.row].bandID
            cell.wantedID = self.auditReceivedArray[indexPath.row].wantedID
            cell.bandType = self.auditReceivedArray[indexPath.row].bandType
            cell.responseID = self.auditReceivedArray[indexPath.row].responseID
            cell.instrumentLabel.text = self.auditReceivedArray[indexPath.row].instrumentAuditFor
            
        })
    }
    func configureCell(_ cell: InviteCell, forIndexPath indexPath: NSIndexPath){
        self.ref.child("users").child(inviteArray[indexPath.row].sender).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            for snap in snapshots{
                if snap.key == "name"{
                    cell.senderName.text = snap.value as? String
                }
                if snap.key == "profileImageUrl"{
                    cell.senderPic.loadImageUsingCacheWithUrlString((snap.value as! [String]).first!)
                }
            }
            cell.bandID = self.inviteArray[indexPath.row].bandID
            cell.instrumentNeeded.text = self.inviteArray[indexPath.row].instrumentNeeded
            cell.indexPath = indexPath as IndexPath!
            cell.indexPathRow = indexPath.row
            //cell.curCell = cell
            cell.bandType = self.inviteArray[indexPath.row].bandType
            cell.sessionDate.text = self.inviteArray[indexPath.row].date
            cell.sessionName.text = self.inviteArray[indexPath.row].bandName
            //cell.responseID = self.auditReceivedArray[indexPath.row].responseID
            
            if self.inviteArray[indexPath.row].bandType == "onb"{
            self.ref.child("bands").child(self.inviteArray[indexPath.row].bandID).observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                for snap in snapshots{
                    if snap.key == "bandBio"{
                        cell.sessionDescription.text = snap.value as? String
                    }
                
                    if snap.key == "bandPictureURL"{
                        cell.sessionImage.loadImageUsingCacheWithUrlString((snap.value as! [String]).first!)
                    }
                }
                
                
                
            })
            } else {
                self.ref.child("oneNightBands").child(self.inviteArray[indexPath.row].bandID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    for snap in snapshots{
                        if snap.key == "onbInfo"{
                            cell.sessionDescription.text = snap.value as? String
                        }
                        
                        if snap.key == "onbPictureURL"{
                            cell.sessionImage.loadImageUsingCacheWithUrlString((snap.value as! [String]).first!)
                        }
                    }
                    
                    
                    
                })

            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if(collectionView == invitesCollect){
            if self.inviteArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell1.frame.width) * CGFloat(self.inviteArray.count)
                let totalSpacingWidth = 10 * (self.inviteArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        else if collectionView == wantedCollect{
            if self.auditReceivedArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell2.frame.width) * CGFloat(self.auditReceivedArray.count)
                let totalSpacingWidth = 10 * (self.auditReceivedArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
            
        } else {
            if self.auditAcceptedArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell3.frame.width) * CGFloat(self.auditAcceptedArray.count)
                let totalSpacingWidth = 10 * (self.auditAcceptedArray.count - 1)
                
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }

        }
    }

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
