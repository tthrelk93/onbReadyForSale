//
//  SessionInvitesViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/25/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
//import FirebaseD
import FirebaseAuth
import FirebaseDatabase
import UIKit

protocol GoToBandDelegate : class
{
    func goToBand(bandID: String)
    func dismissAccepted(indexPath: IndexPath)
    
}
protocol GoToBandData : class
{
    weak var goToBandDelegate : GoToBandDelegate? { get set }
}


protocol AcceptDeclineDelegate : class
{
    func acceptPressed(indexPathRow: Int, indexPath: IndexPath, curCell: InviteCell)
    func declinePressed(indexPathRow: Int, indexPath: IndexPath, curCell: InviteCell)
    func acceptPressedWanted(indexPathRow: Int, indexPath: IndexPath, curCell: WantedReceivedCell)
    func declinePressedWanted(indexPathRow: Int, indexPath: IndexPath, curCell: WantedReceivedCell)
    
}
protocol AcceptDeclineData : class
{
    weak var acceptDeclineDelegate : AcceptDeclineDelegate? { get set }
}

class SessionInvitesViewController: UIViewController{
    
    @IBAction func backPressed(_ sender: Any) {
       performSegue(withIdentifier: "BackPressed", sender: self)
    }
    @IBOutlet weak var backButton: UIButton!
    
    var ref = Database.database().reference()
    var sender = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackPressed"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.artistID = Auth.auth().currentUser!.uid
                
            }
        } else {
            if let vc = segue.destination as? InviteViewerViewController{
                vc.sender = self.sender
            }
        }
        
    }
    var curUser = String()
    @IBOutlet weak var invitesAlertCount: UILabel!

    @IBOutlet weak var auditsReceivedAlertCount: UILabel!
    @IBOutlet weak var auditionsAlertCount: UILabel!
    
    @IBAction func invitesReceivedPressed(_ sender: Any) {
        self.sender = "invite"
        self.performSegue(withIdentifier: "InviteToViewer", sender: self)
    }
    
    @IBAction func auditionsReceivedPressed(_ sender: Any) {
        self.sender = "auditReceived"
        self.performSegue(withIdentifier: "InviteToViewer", sender: self)
    }
    @IBAction func auditionsAcceptedPressed(_ sender: Any) {
        self.sender = "auditAccepted"
        self.performSegue(withIdentifier: "InviteToViewer", sender: self)
    }
    var currentUser = Auth.auth().currentUser?.uid
    //var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.auditionsAlertCount.isHidden = true
        self.auditsReceivedAlertCount.isHidden = true
        self.invitesAlertCount.isHidden = true
        
        ref.child("users").child(currentUser!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "invites"{
                        var tempCount = 0
                        var inviteDict = snap.value as! [String:Any]
                        for (_, _) in inviteDict{
                            tempCount += 1
                        }
                        if tempCount > 0{
                            self.auditionsAlertCount.text = String(describing: tempCount)
                            self.auditionsAlertCount.isHidden = false
                        }
                        
                    }
                    if snap.key == "acceptedAudits"{
                        let tempArray = snap.value as! [String:Any]
                        if tempArray.count > 0{
                            self.auditionsAlertCount.text = String(describing: tempArray.count)
                            self.auditionsAlertCount.isHidden = false
                        }
                    }
                    if snap.key == "wantedAdResponses"{
                        let tempArray = snap.value as! [String]
                        if tempArray.count > 0{
                            self.auditsReceivedAlertCount.text = String(describing: tempArray.count)
                            self.auditsReceivedAlertCount.isHidden = false
                        }
                    }
                    
                }
            }
            //ref.chil
        })

    }
    
    
    }

/*class SessionInvitesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AcceptDeclineDelegate {
     //var inviteCollectionView: UICollectionView
    var inviteArray = [Invite]()
    var snapKey = [String: Any]()
    var collectCount: Int?
    var sessionsArray = [String]()
    var currentArtistArray = [String]()
    let currentUser = Auth.auth().currentUser?.uid
    var cellArray = [InviteCell]()

    internal func acceptPressed(indexPathRow: Int, indexPath: IndexPath, curCell: InviteCell) {
        DispatchQueue.main.async {
            
        var tempDict = [String: Any]()
        var tempDict2 = [String: Any]()
        var tempDict3 = [String: Any]()
        print("accept Pressed")
    
        for invite in 0...self.cellArray.count-1{
            
            if curCell == self.cellArray[invite]{
                
                Database.database().reference().child("users").child(self.currentUser!).child("activeSessions").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        //var index = 0
                        
                        for snap in snapshots{
                            
                            self.sessionsArray.append(snap.value as! String)
                        }
                        self.sessionsArray.append(self.inviteArray[invite].bandID!)
                        
                        tempDict2["activeSessions"] = self.sessionsArray
                        
                        Database.database().reference().child("users").child(self.currentUser!).updateChildValues(tempDict2)
                    }
                    
                    
                    
                    
                    Database.database().reference().child("sessions").child(self.inviteArray[curCell.indexPath.row].sessionID!).child("sessionArtists").observeSingleEvent(of: .value, with: { (snapshot) in
                        var dictionary = [String:Any]()
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            //var index = 0
                            
                            for snap in snapshots{
                                
                                self.currentArtistArray.append(snap.value as! String)
                                dictionary[snap.key] = snap.value
                            }
                            dictionary[self.currentUser!] = self.inviteArray[invite].instrumentNeeded
                            //self.currentArtistArray.append(self.currentUser!)
                            
                            tempDict3["sessionArtists"] = dictionary
                            
                            Database.database().reference().child("sessions").child(self.inviteArray[curCell.indexPath.row].sessionID!).updateChildValues(tempDict3)
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
                        /*Database.database().reference().child("sessionFeed").observeSingleEvent(of: .value, with: { (snapshot) in
                                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                    for snap in snapshots{
                                        let sessionKids = snap.children.allObjects as? [DataSnapshot]
                                        for ssnap in sessionKids!{
                                            if ssnap.key == "sessionUID"{
                                                let dictionary = snap.value as? [String: Any]
                                                let tempSess = Session()
                                                tempSess.setValuesForKeys(dictionary!)
                                                if self.sessionsArray.contains(ssnap.value as! String) || tempSess.sessionName == self.cellArray[invite].sessionName.text{
                                                    
                                                    
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                }*/

                    
                
                
                
                        DispatchQueue.main.async {
                        
                        self.inviteArray.remove(at: invite)
                        self.cellArray.remove(at: invite)
                        self.inviteCollectionView.deleteItems(at: [IndexPath(row: invite, section: 0)])
                        print("InviteCollectionViewCells: \(self.inviteCollectionView.visibleCells.count)")
                    }
                        
                        })
                        
                    })
                    
                
            
            
                })
                break
                
                }
                
                
                }
            
        
        
        
        
       
            
                
                
                
                /*for invite in 0...self.inviteArray.count-1{
                    if curCell == self.inviteArray[invite]{
                        self.inviteArray.remove(at: invite)
                        DispatchQueue.main.async{
                            self.inviteCollectionView.deleteItems(at: [self.inviteCollectionView.indexPath(for: curCell)!] )
                            //print("PiccollectionViewCells: \(self.picCollectionView.visibleCells.count)")
                        }
                        break
                    }
        }*/


        
            
            
       
        

        
        
        
        
 
        }
        
        

        
        
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

    //Problem is that indexPath.row goes out of index because we delete items from inviteArray
    internal func declinePressed(indexPathRow: Int, indexPath: IndexPath, curCell: InviteCell){
        print("decline Pressed")
        
        
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
                            self.inviteCollectionView.deleteItems(at: [IndexPath(row: invite, section: 0)])
                            print("InviteCollectionViewCells: \(self.inviteCollectionView.visibleCells.count)")
                        }

                    })

                    
                    break
                    
                }

        }
        
    }
    var acceptDeclineDelegate: AcceptDeclineDelegate?
    
    
    @IBOutlet weak var inviteCollectionView: UICollectionView!
    
   let emptyLabel: UILabel = {
        var tempLabel = UILabel()
        tempLabel.text = "You have 0 pending invites"
        tempLabel.textColor = UIColor.white
        tempLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightLight)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    
    }()
    func setupEmptyLabel(){
        emptyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    
    
    var sizingCell: InviteCell?
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionsArray.removeAll()
        currentArtistArray.removeAll()
        
        
        self.view.addSubview(emptyLabel)
        setupEmptyLabel()
        emptyLabel.isHidden = true
        
        
        
        Database.database().reference().child("users").child(currentUser!).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount != 0{
                self.emptyLabel.isHidden = true
                self.inviteCollectionView.isHidden = false
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //var index = 0
                
                for snap in snapshots{
                    
                    if let dictionary = snap.value as? [String: Any] {
                        
                        //self.snapKey = dictionary
                        let invite = Invite()
                        invite.setValuesForKeys(dictionary)
                        self.inviteArray.append(invite)
                        //print(dictionary)
                        let cellNib = UINib(nibName: "InviteCell", bundle: nil)
                        self.inviteCollectionView.register(cellNib, forCellWithReuseIdentifier: "InviteCell")
                        self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! InviteCell?)!
                        //self.inviteCollectionView.backgroundColor = UIColor.clear
                        self.inviteCollectionView.dataSource = self
                        self.inviteCollectionView.delegate = self
                        self.inviteCollectionView.gestureRecognizers?.first?.cancelsTouchesInView = false
                        self.inviteCollectionView.gestureRecognizers?.first?.delaysTouchesBegan = false
                    
                    }
                    }
                }
            

        
           
            }else{
                self.inviteCollectionView.isHidden = true
                self.emptyLabel.isHidden = false
            }

        })
    
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return inviteArray.count
        
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InviteCell", for: indexPath as IndexPath) as! InviteCell
        cell.acceptDeclineDelegate = self
        
        self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        
        cellArray.append(cell)
        
        return cell

        
    }
    
    func configureCell(_ cell: InviteCell, forIndexPath indexPath: NSIndexPath){
        
        //cell.layer.borderColor = UIColor.white.cgColor
        //cell.layer.borderWidth = 2
        self.ref.child("users").child(inviteArray[indexPath.row].sender!).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            for snap in snapshots{
                if snap.key == "name"{
                    cell.senderName.text = snap.value as? String
                }
                if snap.key == "profileImageUrl"{
                    cell.senderPic.loadImageUsingCacheWithUrlString((snap.value as! [String]).first!)
                }
            }
            cell.instrumentNeeded.text = self.inviteArray[indexPath.row].instrumentNeeded
            cell.indexPath = indexPath as IndexPath!
            cell.indexPathRow = indexPath.row
            //cell.curCell = cell

            cell.sessionDate.text = self.inviteArray[indexPath.row].sessionDate
            cell.sessionName.text = self.inviteArray[indexPath.row].sessionID
            self.ref.child("sessions").child(self.inviteArray[indexPath.row].sessionID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                for snap in snapshots{
                    if snap.key == "sessionName"{
                        cell.sessionName.text = snap.value as! String?
                    }
                    if snap.key == "sessionBio"{
                        cell.sessionDescription.text = snap.value as? String
                    }
                    if snap.key == "sessionDate"{
                        cell.sessionDate.text = snap.value as? String
                    }
                    if snap.key == "sessionPictureURL"{
                        cell.sessionImage.loadImageUsingCacheWithUrlString(snap.value as! String)
                    }
                }

                
                
            })
        })
        }

    
    
    
    //PageController Functions
    
    
}*/
