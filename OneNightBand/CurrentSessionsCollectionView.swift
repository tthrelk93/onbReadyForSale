//
//  CurrentSessionsCollectionView.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/17/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
//import Firebase

class CurrentSessionCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBAction func createSessionPressed(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateSessionPopup") as! CreateSessionPopup
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

    }
    
    @IBOutlet weak var createSessionButton: UIButton!
    
    func finishedShowing(viewController: UIViewController) {
        //if viewController.isBeingPresented && viewController.presentingViewController == self
        //{
        //self.shadeView.isHidden = true
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(1.0)
        
        self.dismiss(animated: true, completion: nil)
        return
        //}
        
        // self.navigationController?.popViewController(animated: true)
    }
    

    
    var currentButton: String? // make array for sessions from each button
    var activeBool = false
    var pastBool = false
    var upcomingBool = false
    var feedBool = false
    
    var pastSessionArray = [Session]()
    var upcomingSessionArray = [Session]()
    var activeSessionsArray = [Session]()
    var sessionFeedArray = [Session]()
    var allSessions = [Session]()

    var sessionIDArray = [String]()
    var cellArray = [SessionCell]()
    var ref = Database.database().reference()
    var sizingCell: SessionCell?
    var tempSess: Session?
    var tempIndex: Int?
    
    var upcomingDidLoad = false
    var sessionsOnFeedDidLoad = false
    var pastSessionsDidLoad = false
    var activeSessionsDidLoad = false
    
    @IBOutlet weak var allSessionsCollectionView: UICollectionView!
    @IBOutlet weak var sessionCollectionView: UICollectionView!
    
    @IBOutlet weak var sessionFeedCollectionView: UICollectionView!
    @IBOutlet weak var upcomingSessionsCollectionView: UICollectionView!
    @IBOutlet weak var pastSessionsCollectionView: UICollectionView!
    
    @IBOutlet weak var sessionsOnFeed: UIButton!
    @IBOutlet weak var upcomingSessions: UIButton!
    @IBOutlet weak var pastSessions: UIButton!
    @IBOutlet weak var activeSessions: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCollectionViews()
        sessionPicker.delegate = self
        sessionPicker.dataSource = self
        DispatchQueue.main.async{
            self.allSessionsCollectionView.isHidden = false
        }
        
        //sessionPicker.selectRow(0, inComponent: 0, animated: false)
        
    }
    
    var curFeedArrayIndex = 0
    var curPastArrayIndex = 0
    var curActiveArrayIndex = 0
    var curUpcomingArrayIndex = 0
    
    var sessText = ["All Sessions", "Past Sessions", "Active Sessions", "Upcoming Sessions", "Sessions on Feed"]
    
    @IBOutlet weak var sessionPicker: UIPickerView!
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return sessText.count
        
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       
            let titleData = sessText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if self.sessText[row] == "Past Sessions"{
            sessionCollectionView.isHidden = true
            upcomingSessionsCollectionView.isHidden = true
            pastSessionsCollectionView.isHidden = false
            sessionFeedCollectionView.isHidden = true
            allSessionsCollectionView.isHidden = true
        }else if self.sessText[row] == "Active Sessions"{
            sessionCollectionView.isHidden = false
            upcomingSessionsCollectionView.isHidden = true
            pastSessionsCollectionView.isHidden = true
            sessionFeedCollectionView.isHidden = true
            allSessionsCollectionView.isHidden = true
        }else if self.sessText[row] == "Upcoming Sessions"{
            sessionCollectionView.isHidden = true
            upcomingSessionsCollectionView.isHidden = false
            pastSessionsCollectionView.isHidden = true
            sessionFeedCollectionView.isHidden = true
            allSessionsCollectionView.isHidden = true
        }
         else if self.sessText[row] == "All Sessions"{
            sessionCollectionView.isHidden = true
            upcomingSessionsCollectionView.isHidden = true
            pastSessionsCollectionView.isHidden = true
            sessionFeedCollectionView.isHidden = true
            allSessionsCollectionView.isHidden = false
            
        }
        else{
            sessionCollectionView.isHidden = true
            upcomingSessionsCollectionView.isHidden = true
            pastSessionsCollectionView.isHidden = true
            sessionFeedCollectionView.isHidden = false
            allSessionsCollectionView.isHidden = true
            

        }
        
        
    }

    var allSessionsDict = [String: Session]()
    func loadCollectionViews(){
        activeSessionsArray.removeAll()
        pastSessionArray.removeAll()
        upcomingSessionArray.removeAll()
        sessionFeedArray.removeAll()
        sessionIDArray.removeAll()
        allSessions.removeAll()
        navigationItem.title = "Our Sessions"
        sessionCollectionView.isHidden = true
        upcomingSessionsCollectionView.isHidden = true
        pastSessionsCollectionView.isHidden = true
        sessionFeedCollectionView.isHidden = true
        
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("sessions").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let dictionary = snap.value as? [String: Any]
                    let tempSess = Session()
                    tempSess.setValuesForKeys(dictionary!)
                    self.allSessionsDict[tempSess.sessionUID] = tempSess
                }
            }

        self.ref.child("users").child(userID!).child("activeSessions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    self.sessionIDArray.append((snap.value! as! String))
                }
            }
            
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
            
            
            self.ref.child("sessions").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        for id in self.sessionIDArray{
                            if snap.key == id{
                                let dictionary = snap.value as? [String: Any]
                                let dateFormatter = DateFormatter()
                                dateFormatter.timeStyle = DateFormatter.Style.none
                                dateFormatter.dateStyle = DateFormatter.Style.short
                                let now = Date()
                                let order = Calendar.current.compare(now, to: self.dateFormatted(dateString: dictionary?["sessionDate"] as! String), toGranularity: .day)
                                print(now)
                                print(self.dateFormatted(dateString: dictionary?["sessionDate"] as! String))
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
                    for session in self.activeSessionsArray{
                        self.currentButton = "active"
                        self.curActiveArrayIndex = self.activeSessionsArray.index(of: session)!
                        let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                        self.sessionCollectionView.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                        self.sessionCollectionView.backgroundColor = UIColor.clear
                        self.sessionCollectionView.dataSource = self
                        self.sessionCollectionView.delegate = self
                        }
                    DispatchQueue.main.async {
                    for session in self.pastSessionArray{
                        self.currentButton = "past"
                        self.curPastArrayIndex = self.pastSessionArray.index(of: session)!
                    
                        let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                        self.pastSessionsCollectionView.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                        self.pastSessionsCollectionView.backgroundColor = UIColor.clear
                        self.pastSessionsCollectionView.dataSource = self
                        self.pastSessionsCollectionView.delegate = self
                        }
                        DispatchQueue.main.async {
                        for session in self.upcomingSessionArray{
                            self.currentButton = "upcoming"
                            self.curUpcomingArrayIndex = self.upcomingSessionArray.index(of: session)!
                            let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                            self.upcomingSessionsCollectionView.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                            self.upcomingSessionsCollectionView.backgroundColor = UIColor.clear
                            self.upcomingSessionsCollectionView.dataSource = self
                            self.upcomingSessionsCollectionView.delegate = self
                            }
                            DispatchQueue.main.async{
                                for session in self.allSessions{
                                    self.currentButton = "all"
                                    //self.curAllArrayIndex = self.allSessions.index(of: session)!
                                    
                                    let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                                    self.allSessionsCollectionView.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                                    self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                                    self.allSessionsCollectionView.backgroundColor = UIColor.clear
                                    self.allSessionsCollectionView.dataSource = self
                                    self.allSessionsCollectionView.delegate = self
                                }
                                
                                    
                            }
                        }
                        }
                        
                }
            /******ADD THIS BACK END BUT REMOVE THE Array.removeAll()
            self.ref.child("sessionFeed").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    print(self.sessionIDArray)
                    self.sessionIDArray.removeAll()
                    for snap in snapshots{
                        let tempSess = Session()
                        let dictionary = snap.value as! [String: Any]
                        tempSess.setValuesForKeys(dictionary)
                        if self.sessionIDArray.contains(tempSess.sessionUID!) == false{
                            self.sessionFeedArray.append(tempSess)
                            self.sessionIDArray.append(tempSess.sessionUID!)
                            print("no contain")
                        }else{
                            print("yes contain")
                        }

                    
                    }*/
                print(self.sessionFeedArray)
                for session in self.sessionFeedArray{
                    if self.sessionIDArray.contains(session.sessionUID){
                        self.currentButton = "feed"
                        self.curFeedArrayIndex = self.sessionFeedArray.index(of: session)!
                        let cellNib = UINib(nibName: "SessionCell", bundle: nil)
                        self.sessionFeedCollectionView.register(cellNib, forCellWithReuseIdentifier: "SessionCell")
                        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! SessionCell?
                        self.sessionFeedCollectionView.backgroundColor = UIColor.clear
                        self.sessionFeedCollectionView.dataSource = self
                        self.sessionFeedCollectionView.delegate = self
                    }
                }
                

                })
                

                    })
            
            })

        })
    }




    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(currentButton as Any)
        if(self.currentButton == "upcoming"){
            
            return upcomingSessionArray.count
            
            
        }
        else if(self.currentButton == "past"){
            return pastSessionArray.count
            
        }
        else if(self.currentButton == "feed"){
            return sessionFeedArray.count
        }
        else if(self.currentButton == "active"){
            return activeSessionsArray.count
        }else if(self.currentButton == "all"){
            return allSessions.count
        }
        else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for: indexPath as IndexPath) as! SessionCell
        
        tempIndex = indexPath.row
        self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.upcomingSessionsCollectionView){
            tempIndex = indexPath.row
            self.pressedButton = "upcoming"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if(collectionView == self.pastSessionsCollectionView){
            tempIndex = indexPath.row
            self.pressedButton = "past"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if(collectionView == self.sessionFeedCollectionView){
            tempIndex = indexPath.row
            self.pressedButton = "feed"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if(collectionView == self.sessionCollectionView){
            tempIndex = indexPath.row
            self.pressedButton = "active"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }
        if (collectionView == self.allSessionsCollectionView){
            tempIndex = indexPath.row
            self.pressedButton = "all"
            performSegue(withIdentifier: "SessionCollectionToSessionView", sender: self)
        }

    }
    
    func configureCell(_ cell: SessionCell, forIndexPath indexPath: NSIndexPath) {

        if(self.currentButton == "upcoming"){
            print("Whyyyyy")
            if upcomingSessionArray.count == 0{
                cell.sessionCellLabel.text = "No Upcoming Sessions"
                cell.sessionCellLabel.textColor = UIColor.white
            }

          if(indexPath.row < upcomingSessionArray.count){
            cell.sessionCellImageView.loadImageUsingCacheWithUrlString((upcomingSessionArray[indexPath.row] as Session).sessionPictureURL[0])
            print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
            cell.sessionCellLabel.text = upcomingSessionArray[indexPath.row].sessionName
            cell.sessionCellLabel.textColor = UIColor.white
            cell.sessionId = sessionIDArray[indexPath.row]
            }
            cellArray.append(cell)

        }
        if(self.currentButton == "past"){
            if pastSessionArray.count == 0{
                cell.sessionCellLabel.text = "No Past Sessions"
                cell.sessionCellLabel.textColor = UIColor.white
            }
            if(indexPath.row < pastSessionArray.count){
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((pastSessionArray[indexPath.row] as Session).sessionPictureURL[0])
                cell.sessionCellLabel.text = pastSessionArray[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = sessionIDArray[indexPath.row]
                }
            cellArray.append(cell)
        }
        if(self.currentButton == "feed"){
            if sessionFeedArray.count == 0{
                cell.sessionCellLabel.text = "No Sessions on Feed"
                cell.sessionCellLabel.textColor = UIColor.white
            }

            if(indexPath.row < sessionFeedArray.count){
                print(indexPath.row)
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((sessionFeedArray[indexPath.row] as Session).sessionPictureURL[0])
                cell.sessionCellLabel.text = sessionFeedArray[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = sessionIDArray[indexPath.row]
            }
            cellArray.append(cell)
        }
        if(self.currentButton == "active"){
            if activeSessionsArray.count == 0{
                cell.sessionCellLabel.text = "No Active Sessions"
                cell.sessionCellLabel.textColor = UIColor.white
            }
            if(indexPath.row < activeSessionsArray.count){
            cell.sessionCellImageView.loadImageUsingCacheWithUrlString((activeSessionsArray[indexPath.row].sessionPictureURL[0]))
            cell.sessionCellLabel.text = activeSessionsArray[indexPath.row].sessionName
            cell.sessionCellLabel.textColor = UIColor.white
            cell.sessionId = sessionIDArray[indexPath.row]
            }
            cellArray.append(cell)
            }
        if(self.currentButton == "all"){
            if allSessions.count == 0{
                cell.sessionCellLabel.text = "No Sessions"
                cell.sessionCellLabel.textColor = UIColor.white
            }
            if(indexPath.row < allSessions.count){
                cell.sessionCellImageView.loadImageUsingCacheWithUrlString((allSessions[indexPath.row] as Session).sessionPictureURL[0])
                cell.sessionCellLabel.text = allSessions[indexPath.row].sessionName
                cell.sessionCellLabel.textColor = UIColor.white
                cell.sessionId = sessionIDArray[indexPath.row]
            }
            cellArray.append(cell)
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if(self.currentButton == "active"){
            if self.activeSessionsArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.activeSessionsArray.count)
                let totalSpacingWidth = 10 * (self.activeSessionsArray.count - 1)
            
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        else if(self.currentButton == "past"){
            if self.pastSessionArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
            let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.pastSessionArray.count)
            let totalSpacingWidth = 10 * (self.pastSessionArray.count - 1)
            
            let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
            let rightInset = leftInset
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        else if(self.currentButton == "upcoming"){
            if self.upcomingSessionArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.upcomingSessionArray.count)
                let totalSpacingWidth = 10 * (self.upcomingSessionArray.count - 1)
            
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        else if(self.currentButton == "all"){
            if self.allSessions.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.allSessions.count)
                let totalSpacingWidth = 10 * (self.allSessions.count - 1)
            
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        else{
            if sessionFeedArray.count != 1{
                return UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
            
                let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.sessionFeedArray.count)
                let totalSpacingWidth = 10 * (self.sessionFeedArray.count - 1)
            
                let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
                let rightInset = leftInset
                return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            }
        }
        
    }
    
    
    var pressedButton = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SessionCollectionToSessionView" {
            if let viewController = segue.destination as? SessionMakerViewController {
                viewController.sessionID = self.sessionIDArray[tempIndex!]
                if(self.pressedButton == "upcoming"){
                    viewController.sessionID = self.upcomingSessionArray[tempIndex!].sessionUID
                }
                if(self.pressedButton == "past"){
                    viewController.sessionID = self.pastSessionArray[tempIndex!].sessionUID
                }
                if(self.pressedButton == "feed"){
                    viewController.sessionID = self.sessionFeedArray[tempIndex!].sessionUID
                }
                if(self.pressedButton == "active"){
                    viewController.sessionID = self.activeSessionsArray[tempIndex!].sessionUID                    
                }
                if(self.pressedButton == "all"){
                    viewController.sessionID = self.allSessions[tempIndex!].sessionUID
                }
            }
        }
    }
    
    func dateFormatted(dateString: String)->Date{
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM-dd-yy"
        
        let dateObj = dateFormatter.date(from: dateString)
        
        
        return(dateObj)!
        
    }
    
    


}
