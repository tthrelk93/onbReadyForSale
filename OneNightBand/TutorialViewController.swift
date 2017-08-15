//
//  TutorialViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/2/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
import FirebaseAuth
import FirebaseDatabase
import DropDown
import SwiftOverlays

class TutorialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate{
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    let TAGS = ["Guitar", "Bass Guitar", "Piano", "Saxophone", "Trumpet", "Stand-up Bass", "Violin", "Drums", "Cello", "Trombone", "Vocals", "Mandolin", "Banjo", "Harp", "Rapper", "DJ"]
    var sizingCell: TagCell?
    var tags = [Tag]()
    var pageTexts = [String]()
    var currentIndex = 0
    var selectedCount = 0
    var account = [String:Any]()
    let dropDown = DropDown()
    var user = String()
    let dropDown2 = DropDown()
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: Any]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(account, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err as Any)
                return
            }
            
            
        })
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue"{
            if let vc = segue.destination as? profileRedesignViewController {
                vc.artistID = (Auth.auth().currentUser?.uid)!
                vc.userID = (Auth.auth().currentUser?.uid)!
            }
        }
        
    }
    
   
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        infoTextLabel.text = "What Instrument(s) do you play? Select an instrument if you feel comfortable playing it with other musicians in a live environment."
        startExploringButton.isHidden = true
       
            self.collectionView.isHidden = false
            self.editBioTextView.isHidden = true
        continueButton.isHidden = false
        
        backButton.isHidden = true
        //currentIndex = 0

        
    }
    
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func continueSelected(_ sender: AnyObject) {
        startExploringButton.isHidden = false
            self.collectionView.isHidden = true
            self.editBioTextView.isHidden = false
            self.infoTextLabel.text = "Add a bio about your musical style, influences, and background so that other musicians have an idea of your playing style."
        
        
        if(selectedCount != 0 && editBioTextView.text != "Tap here to edit your artist bio!"){
            startExploringButton.isEnabled = true
            //startExploringButton.isHidden = false
            startExploringButton.titleLabel?.text = "Start Exploring!"
        }else{
            startExploringButton.isEnabled = false
            //startExploringButton.isHidden = true
            startExploringButton.titleLabel?.text = "Missing Info"
        }
        
        

        
        

        continueButton.isHidden = true
       
        backButton.isHidden = false
        //currentIndex = 1
        
    }
    @IBOutlet weak var editBioTextView: UITextView!
    @IBOutlet weak var flowLayout: FlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startExploringButton: UIButton!
    
    @IBOutlet weak var infoTextLabel: UILabel!
    var mostRecentTagTouched = IndexPath()
    override func viewDidLoad(){
        super.viewDidLoad()
        SwiftOverlays.removeAllBlockingOverlays()
        infoTextLabel.text = "What Instrument(s) do you play? Select an instrument if you feel comfortable playing it with other musicians in a jam environment."
        backButton.isHidden = true
        continueButton.isHidden = false
        startExploringButton.isHidden = true
        startExploringButton.isEnabled = false
        startExploringButton.titleLabel?.numberOfLines = 2
        
        self.editBioTextView.delegate = self
        self.editBioTextView.isHidden = true
        editBioTextView.text = "Tap here to edit your artist bio!"
        editBioTextView.textColor = self.ONBPink
        //editBioTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -10).isActive = true
        //editBioTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
       
        //let dropDown = DropDown()
        
        dropDown.selectionBackgroundColor = self.ONBPink
        dropDown.anchorView = self.view//collectionView.cellForItem(at: indexPath)
        dropDown.dataSource = ["Beginner","Intermediate","Advanced","Expert","Pro"]
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            self.dropDownLabel.isHidden = false
            
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
        

        
        //initializing TagCell and creating a cell for each item in array TAGS
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.collectionView.backgroundColor = UIColor.clear
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        for name in TAGS {
            let tag = Tag()
            tag.name = name
            self.tags.append(tag)
        }

        pageTexts = ["What Instrument(s) do you play? Select an instrument if you feel comfortable playing it with other musicians in a jam environment.","Select estimated playing level.","Select The number of years you have been playing this instrument","Add a bio about your musical style, influences, and background so that other musicians have an idea of your playing style."]
        
       
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        //initializing first aboutONBViewController
       
        /*self.collectionView.isHidden = false
        self.editBioTextView.isHidden = true*/
        
        
    }
    @IBOutlet weak var dropDownLabel: UILabel!
    var lvlArray = [Int]()
    func set_years_playing(){
        dropDownLabel.text = "Select how long you have been playing this instrument"
        dropDown2.selectionBackgroundColor = self.ONBPink
        dropDown2.anchorView = self.view//collectionView.cellForItem(at: indexPath)
        dropDown2.dataSource = ["1","2","3","4","5+","10+"]
        dropDown2.selectionAction = {[unowned self] (index: Int, item: String) in
            self.lvlArray.append(index)
            self.tagsAndSkill[self.TAGS[self.mostRecentTagTouched.row]] = self.lvlArray
            self.dropDownLabel.isHidden = true
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if editBioTextView.textColor == self.ONBPink {
            editBioTextView.text = nil
            editBioTextView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if editBioTextView.text.isEmpty {
            editBioTextView.text = "Tap here to edit your artist bio!"
            editBioTextView.textColor = self.ONBPink
        }
        /*for tag in tags{
            if(tag.selected == true){
                selectedCount+=1
            }
        }*/
        if(selectedCount != 0 && editBioTextView.text != "Tap here to edit your artist bio!"){
            //startExploringButton.isHidden = false
            startExploringButton.isEnabled = true
            startExploringButton.titleLabel?.text = "Start Exploring?"
        }else{
            //startExploringButton.isHidden = true
            startExploringButton.isEnabled = false
            startExploringButton.titleLabel?.text = "Missing Info"
        }

    }
    //CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
        self.configureCell(cell, forIndexPath: (indexPath as NSIndexPath) as IndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.configureCell(self.sizingCell!, forIndexPath: (indexPath as NSIndexPath) as IndexPath)
        return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    var tagsAndSkill = [String: [Int]]()
    //var instrumentDict = [String: Any]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lvlArray.removeAll()
        self.dropDownLabel.text = "Select Playing Level"
        for val in 0...dropDown.dataSource.count - 1{
            dropDown.deselectRow(at: val)
        }
        //let dropDown = Drop
        self.mostRecentTagTouched = indexPath
        if(tags[indexPath.row].selected == true){
            dropDownLabel.isHidden = true
            selectedCount -= 1
            tagsAndSkill.removeValue(forKey: TAGS[indexPath.row])
        }else{
            dropDownLabel.isHidden = false
            selectedCount += 1
            dropDown.show()

            //self.dropDown.anchorView
        }
        
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
        tags[indexPath.row].selected = !tags[indexPath.row].selected
        self.collectionView.reloadData()
    }
    
    func configureCell(_ cell: TagCell, forIndexPath indexPath: IndexPath) {
        let tag = tags[(indexPath as NSIndexPath).row]
        cell.tagName.text = tag.name
        cell.tagName.textColor = tag.selected ? UIColor.white : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.backgroundColor = tag.selected ? self.ONBPink : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    
    
    @IBAction func startExploringButtonPressed(_ sender: AnyObject) {
        
        print(tagsAndSkill)
        var tagArray = [String]()
        for tag in tags{
            if(tag.selected == true){
                tagArray.append(tag.name!)
                selectedCount+=1
            }

        }
        if(selectedCount != 0 && editBioTextView.text != nil){
            //startExploringButton.isHidden = false
            //startExploringButton.isEnabled = true
        

        //if let user = Auth.auth().currentUser?.uid{
            //let ref = Database.database().reference()
            //let userRef = ref.child("users").child(user)
            //var dict = [String: Any]()
            account["instruments"] = tagsAndSkill
            account["bio"] = editBioTextView.text as Any?
            registerUserIntoDatabaseWithUID(self.user, values: account)
            /*userRef.updateChildValues(dict, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
            })*/
            

            
       // }else{
            //need to sign them out
         //   return
       // }
        

        //successfully authenticate user
        /*else{
         print("Account Created")
         self.performSegue(withIdentifier: "AboutONBSegue", sender: self)
         }*/
        //var ref: DatabaseReference!
        //ref = Database.database().reference()
        
        }
        else{
            let alert = UIAlertController(title: "Missing Info", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }


}
