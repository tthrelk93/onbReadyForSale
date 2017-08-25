//
//  CreateWantedAdViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/11/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftOverlays


class CreateWantedAdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, WantedAdDelegator {
    @IBOutlet weak var createBandButton: UIButton!
    
    @IBOutlet weak var explanatoryView: UITextView!
    
    @IBOutlet weak var bandOrONBLabel: UILabel!
    @IBAction func moreInfoBackPressed(_ sender: Any) {
        moreInfoView.isHidden = true
    }
    @IBOutlet weak var moreInfoView: UIView!
    @IBAction func onbInfoPressed(_ sender: Any) {
        moreInfoView.isHidden = false
        bandOrONBLabel.text = "OneNightBand"
        explanatoryView.text = "Select Create OneNightBand if you wish to create a temporary band or find musicians to play with that you may or may not see again."
    }
    @IBOutlet weak var onbInfoButton: UIButton!
    @IBAction func bandInfoPressed(_ sender: Any) {
        moreInfoView.isHidden = false
        bandOrONBLabel.text = "Band"
        explanatoryView.text = "Select Create Band if you want to create a page for your pre-existing band, or are trying to create a band that regularly practices or plays gigs."
    }
    var createdBand = Band()
    var createdONB = ONB()
    @IBOutlet weak var bandInfoButton: UIButton!
    @IBAction func createONBPressed(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOneNightBandViewController") as! CreateOneNightBandViewController
        self.addChildViewController(popOverVC)
        popOverVC.searchType = "wanted"
        popOverVC.parentView = self
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    @IBAction func createBandPressed(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateBandViewController") as! CreateBandViewController
        self.addChildViewController(popOverVC)
        popOverVC.searchType = "wanted"
        popOverVC.view.frame = self.view.frame
        popOverVC.parentView = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)    }
    @IBOutlet weak var onbCollect: UICollectionView!
    @IBOutlet weak var bandCollect: UICollectionView!
    @IBOutlet weak var bandSelectorView: UIView!
    @IBOutlet weak var bandImageView: UIImageView!
    //@IBOutlet weak var bandName: UILabel!
    @IBOutlet weak var instrumentPicker: UIPickerView!
    
    @IBOutlet weak var createONB: UIButton!
    weak var wantedAdDelegate: WantedAdDelegate?
    
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser?.uid
    var bandType = String()
    var bandID = String()
    var wantedIDArray = [String]()
    var tempWanted = WantedAd()
    var sendWanted = [String: Any]()
    @IBAction func postAdPressed(_ sender: Any) {
        if(moreInfoTextView.text != "tap to add info about the type of musician you are looking for. This may include playing style, musical influences, etc... "){
            //performSegue(withIdentifier: "CreateWantedToPFM", sender: self)
            //SwiftOverlays.showBlockingWaitOverlayWithText("Loading Your Bands")
            
            let ref = Database.database().reference()
            let wantedReference = ref.child("wantedAds").childByAutoId()
            let wantedReferenceAnyObject = wantedReference.key
            var values = [String:Any]()
            values["bandType"] = self.bandType
            if bandType == "ONB"{
                values["bandID"] = selectedONB?.onbID
                values["bandName"] = selectedONB?.onbName
                values["date"] = selectedONB?.onbDate
                values["moreInfo"] = selectedONB?.onbInfo
                values["wantedImage"] = selectedONB?.onbPictureURL.first
            } else {
                values["bandID"] = selectedBand?.bandID
                values["bandName"] = selectedBand?.bandName
                values["date"] = ""
                values["moreInfo"] = selectedBand?.bandBio
                values["wantedImage"] = selectedBand?.bandPictureURL.first
            }
            
            values["city"] = locationText[self.cityPicker.selectedRow(inComponent: 0)]
            //onbObject.onbDate
            values["experience"] = expText[self.expPicker.selectedRow(inComponent: 0)]
            
            values["instrumentNeeded"] = instrumentText[instrumentPicker.selectedRow(inComponent: 0)]
            
            values["responses"] = [String:Any]()
            values["senderID"] = self.user
            
            
            values["wantedID"] = wantedReferenceAnyObject
            self.sendWanted = values
            
            
            if self.bandType != "ONB"{
                
                        wantedReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err as Any)
                                return
                            }
                            
                        })
                        self.ref.child("bands").child((selectedBand?.bandID)!).child("wantedAds").observeSingleEvent(of: .value, with: { (snapshot) in
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
                        
                        performSegue(withIdentifier: "WantedToProfile", sender: self)
                        //}
                        
                        
                        

            }
            
            
            /*if self.bandType == "onb"{
                values["bandName"] = onbObject.onbName
                values["city"] = locationText[self.cityPicker.selectedRow(inComponent: 0)]
                values["date"] = onbObject.onbDate
                values["experience"] = expText[self.expPicker.selectedRow(inComponent: 0)]
            
                values["instrumentNeeded"] = instrumentText[instrumentPicker.selectedRow(inComponent: 0)]
                values["moreInfo"] = onbObject.onbInfo
                values["responses"] = [String:Any]()
                values["senderID"] = self.user
                values["wantedImage"] = onbObject.onbPictureURL.first
            
                values["wantedID"] = wantedReferenceAnyObject
                
                
                
                wantedReference.updateChildValues(values)
                
                self.ref.child("oneNightBands").child(onbObject.onbID).child("wantedAds").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            
                            self.wantedIDArray2.append(snap.value as! String)
                        }
                    }
                    
                    self.wantedIDArray2.append(wantedReferenceAnyObject)
                    var tempDict = [String:Any]()
                    tempDict["wantedAds"] = self.wantedIDArray2
                    let onbRef = self.ref.child("oneNightBands").child(self.onbObject.onbID)
                    onbRef.updateChildValues(tempDict, withCompletionBlock: {(err, ref) in
                        if err != nil {
                            print(err as Any)
                            return
                        }
                    })
                })

                
            } else {
                values["bandName"] = bandObject.bandName
                values["city"] = locationText[self.cityPicker.selectedRow(inComponent: 0)]
                values["date"] = ""
                values["experience"] = expText[self.expPicker.selectedRow(inComponent: 0)]
                
                values["instrumentNeeded"] = instrumentText[instrumentPicker.selectedRow(inComponent: 0)]
                values["moreInfo"] = bandObject.bandBio
                values["responses"] = [String:Any]()
                values["senderID"] = self.user
                values["wantedImage"] = bandObject.bandPictureURL.first
                
                values["wantedID"] = wantedReferenceAnyObject
                
                wantedReference.updateChildValues(values)
                
                    self.ref.child("bands").child(self.bandID).child("wantedAds").observeSingleEvent(of: .value, with: { (snapshot) in
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

            }
            
            
           /* ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
                
            })*/
            var userValues = [String:Any]()
            var userWantedAdArray = [String]()
            ref.child("users").child(self.user!).child("wantedAds").observeSingleEvent(of: .value, with: {(snapshot) in
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
                
            
            
                        performSegue(withIdentifier: "CreateWantedToPFM", sender: self)*/

           
            
        } else {
            
        }
                       // let user = Auth.auth().curren
    }
    var currentUser = Auth.auth().currentUser?.uid
    var wantedIDArray2 = [String]()
    var sizingCell5: SessionCell?
  let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    var coordinateText = [String]()
    @IBOutlet weak var moreInfoTextView: UITextView!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var expPicker: UIPickerView!
    var bandName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        onbInfoButton.layer.cornerRadius = bandInfoButton.frame.width/2
        bandInfoButton.layer.cornerRadius = bandInfoButton.frame.width/2
        createONB.layer.cornerRadius = createONB.frame.width/2
        createONB.layer.borderColor = ONBPink.cgColor
        createONB.layer.borderWidth = 2
        
        createBandButton.layer.cornerRadius = createONB.frame.width/2
        createBandButton.layer.borderColor = ONBPink.cgColor
        createBandButton.layer.borderWidth = 2
        
        for (key, value) in cityDict{
            locationText.append(key)
            coordinateText.append(value)
        }
        locationText.sort()
        locationText.insert("Current City", at: 0)
        locationText.insert("All", at: 0)
        moreInfoTextView.delegate = self
        instrumentPicker.delegate = self
        cityPicker.delegate = self
        expPicker.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        
        self.ref.child("bands").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    //self.bandONBCount += 1
                    let dictionary = snap.value as? [String: Any]
                    let tempBand = Band()
                    tempBand.setValuesForKeys(dictionary!)
                    self.bandArray.append(tempBand)
                    self.bandsDict[tempBand.bandID!] = tempBand
                }
            }
            var tempID = Auth.auth().currentUser?.uid
            self.ref.child("users").child(tempID!).child("artistsBands").observeSingleEvent(of: .value, with: { (snapshot) in
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
                    self.ref.child("users").child(tempID!).child("artistsONBs").observeSingleEvent(of: .value, with: {(snapshot) in
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
                            }
                        }
                    })
                })
            })
        })

        
        
        
        moreInfoTextView.text = "tap to add info about the type of musician you are looking for. This may include playing style, musical influences, etc... "
        //if self.bandType == "band"{
            //self.imageString = bandObject.bandPictureURL.first!
            //self.bandName = bandObject.bandName!
            /*ref.child("bands").child(bandID).observeSingleEvent(of: .value, with: { (snapshot) in
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
            })*/
       // } else if self.bandType == "onb" {
           // self.imageString = onbObject.onbPictureURL.first!
            //self.bandName = onbObject.onbName
           // self.onbDate = onbObject.onbDate
            /*ref.child("oneNightBands").child(bandID).observeSingleEvent(of: .value, with: { (snapshot) in
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
            })*/

            
       // }


        // Do any additional setup after loading the view.
    }
        var onbDate = String()
        var imageString = String()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if moreInfoTextView.textColor == UIColor.white {
            moreInfoTextView.text = nil
            moreInfoTextView.textColor = ONBPink
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if moreInfoTextView.text.isEmpty {
            moreInfoTextView.text = "tap to add info about the type of musician you are looking for. This may include playing style, musical influences, etc... "
            moreInfoTextView.textColor = UIColor.white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == onbCollect{
            return onbIDArray.count
        } else{
            return bandIDArray.count
        }
    }
    
    var bandIDArray = [String]()
    var onbIDArray = [String]()
    var bandsDict = [String:Any]()
    var onbDict = [String:Any]()
    var bandArray = [Band]()
    var onbArray = [ONB]()
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
       
            let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for: indexPath as IndexPath) as! SessionCell
            if collectionView == bandCollect{
                if bandIDArray.count == 0
                {
                    tempCell.layer.borderColor = UIColor.darkGray.cgColor
                    tempCell.layer.borderWidth = 2
                    tempCell.sessionCellLabel.text = "No Bands"
                    tempCell.isUserInteractionEnabled = false
                    tempCell.layer.cornerRadius = tempCell.frame.width/2
                } else {
                    print("band: \(bandsDict[bandIDArray[indexPath.row]] as! Band)")
                    tempCell.sessionCellImageView.loadImageUsingCacheWithUrlString((bandsDict[bandIDArray[indexPath.row]] as! Band).bandPictureURL[0])
                    //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
                    tempCell.sessionCellLabel.text = (bandsDict[bandIDArray[indexPath.row]] as! Band).bandName
                    tempCell.sessionCellLabel.textColor = UIColor.white
                    tempCell.sessionId = (bandsDict[bandIDArray[indexPath.row]] as! Band).bandID
                    tempCell.layer.cornerRadius = tempCell.frame.width/2
                }
            }
            else {
                if onbIDArray.count == 0
                {
                    tempCell.layer.borderColor = UIColor.darkGray.cgColor
                    tempCell.layer.borderWidth = 2
                    tempCell.sessionCellLabel.text = "No OneNightBands"
                    tempCell.isUserInteractionEnabled = false
                    tempCell.layer.cornerRadius = tempCell.frame.width/2
                } else {
                    
                    tempCell.sessionCellImageView.loadImageUsingCacheWithUrlString((onbDict[onbIDArray[indexPath.row]] as! ONB).onbPictureURL[0])
                    //print(self.upcomingSessionArray[indexPath.row].sessionUID as Any)
                    tempCell.sessionCellLabel.text = (onbDict[onbIDArray[indexPath.row]] as! ONB).onbName
                    tempCell.sessionCellLabel.textColor = UIColor.white
                    tempCell.sessionId = (onbDict[onbIDArray[indexPath.row]] as! ONB).onbID
                    tempCell.layer.cornerRadius = tempCell.frame.width/2
                }
            }
            
            return tempCell
            
            
        
        
        
    }
    var selectedBand: Band?
    var selectedONB: ONB?
    var selectedBandType = String()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == onbCollect {
            self.selectedONB = onbArray[indexPath.row]
            self.selectedBandType = "ONB"
        } else {
            self.selectedBand = bandArray[indexPath.row]
            self.selectedBandType = "Band"
        }
        bandSelectorView.isHidden = true
        
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
                self.view.superview?.reloadInputViews()
            }
            SwiftOverlays.removeAllBlockingOverlays()
        });
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        //dismissalDelegate?.finishedShowing()
        removeAnimate()
    }
    
    
    var locationText = [String]()
    var cityDict = ["New York":"","Los Angeles":"","Chicago":"","Houston":"","Philadelphia":"","Phoenix, AZ":"","San Antonio":"","San Diego":"","Dallas":"","San Jose":"", "Austin":"","Jacksonville": "","San Francisco":"","Indianapolis":"","Columbus":"", "Fort Worth":"","Charlotte":"","Detroit":"","El Paso":"","Seattle":"","Denver":"","Washington ":"","Memphis":"","Boston":"","Nashville":"","Atlanta":""]
    var instrumentText = ["All","Guitar", "Bass Guitar", "Piano", "Saxophone", "Trumpet", "Stand-up Bass", "violin", "Drums", "Cello", "Trombone", "Vocals", "Mandolin", "Banjo", "Harp"]
    /*var locationText = ["All","Near You","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]*/
    var expText = ["Beginner","Intermediate","Advanced","Expert"]
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == self.cityPicker{
            return locationText.count
        }else if pickerView == self.instrumentPicker{
            return instrumentText.count
        } else {
            return expText.count
        }
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.cityPicker{
            let titleData = locationText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }else if pickerView == self.instrumentPicker{
            let titleData = instrumentText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
            
        } else {
            let titleData = expText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == self.cityPicker{
            
        }else if pickerView == self.instrumentPicker{
            
            
        } else {
            
        }

    }

    
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        SwiftOverlays.removeAllBlockingOverlays()
    }

    
//where is segue
    
    // MARK: - Navigation
    
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var bandObject = Band()
    var onbObject = ONB()
    var wantedAd = WantedAd()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "PfmToBandBoard"
        if segue.identifier == "WantedToProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.userID = (Auth.auth().currentUser?.uid)!
                vc.artistID = (Auth.auth().currentUser?.uid)!
    
                        vc.sender = "wantedAdCreated"
            }
        }
        

        
    
        if segue.identifier == "CreateWantedToPFM"{
            if let vc = segue.destination as? ProfileFindMusiciansViewController{
                //vc.sender = "wantedAdCreated"
                //vc.artistID = self.user!
                vc.wantedAd = self.sendWanted
                vc.searchType = "wanted"
                
                //print("heyyyg")
                //vc.instrumentNeeded = instrumentText[instrumentPicker.selectedRow(inComponent: 0)]
                //vc.locationText = locationText[cityPicker.selectedRow(inComponent: 0)]
                //vc.expText = expText[expPicker.selectedRow(inComponent: 0)]
                //vc.moreInfoText = moreInfoTextView.text
                //vc.destination = "bb"
                //SwiftOverlays.removeAllBlockingOverlays()
            }
        } /*else{
        if let vc = segue.destination as? BandBoardViewController{
            if self.bandType == "band"{
                vc.searchType = "Bands"
            } else {
                vc.searchType = "OneNightBands"
            }
        }*/
    }
    

}
