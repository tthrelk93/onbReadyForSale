//
//  BandBoardViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/6/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import CoreLocation

class BandBoardViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, PerformSegueInBandBoard, DismissalDelegate {
    var adsAfterLocationFilter = [WantedAd]()
    var adsAfterInstrumentFilter = [WantedAd]()
    var onbWantedTransfer = [WantedAd]()
    var bandWantedTransfer = [WantedAd]()
    let locationManager = CLLocationManager()
    var selectedWantedBandID = String()
    
    @IBOutlet weak var infoLabel: UILabel!
    
    func finishedShowing(){
        let alert = UIAlertController(title: "Audition Sent!", message: "You have sent your audition successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    func joinBand(bandID: String, wantedAd: WantedAd){
        var auditPending = false
        Database.database().reference().child("wantedAds").child(wantedAd.wantedID).child("responses").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if (snap.value as! [String:Any])["respondingArtist"] as? String == self.userID{
                        auditPending = true
                        break
                        
                    }
                }
            }
            if auditPending == false{
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SendAuditionViewVontroller") as! SendAuditionViewController
                self.addChildViewController(popOverVC)
                popOverVC.view.frame = self.view.frame
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParentViewController: self)
                popOverVC.dismissalDelegate = self
                popOverVC.bandID = bandID
                popOverVC.wantedAd = wantedAd
            } else {
                let alert = UIAlertController(title: "Whoops!", message: "It appears you have already sent an audition for this band that is pending.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })

    }
    
    
    func performSegueToBandPage(bandID: String){
        if self.searchType == "Bands"{
            self.selectedWantedBandID = bandID
            performSegue(withIdentifier: "BandBoardToBandPage", sender: self)
        } else {
            self.selectedWantedBandID = bandID
            performSegue(withIdentifier: "BandBoardToONBPage", sender: self)
        }
    }

    @IBOutlet weak var bandBoardCollect: UICollectionView!
    @IBAction func searchButtonPressed(_ sender: Any) {
        print(self.searchType)
        adsAfterLocationFilter.removeAll()
        adsAfterInstrumentFilter.removeAll()
        onbWanted.removeAll()
        bandWanted.removeAll()
        //bandBoardCollect.isHidden = false
        ref.child("wantedAds").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let dictionary = snap.value as! [String: Any]
                    let tempWanted = WantedAd()
                    tempWanted.setValuesForKeys(dictionary)
                    if tempWanted.bandType == "band"{
                            self.bandWanted.append(tempWanted)
                    } else {
                            print("tw \(tempWanted)")
                            self.onbWanted.append(tempWanted)
                        }
                    }

                if self.searchType == "Bands"{
                    for wanted in self.bandWanted{
                        if self.instrumentText[self.imstrumentPicker.selectedRow(inComponent: 0)] == "All"{
                            self.adsAfterInstrumentFilter.append(wanted as WantedAd)
                        } else {
                            if (wanted as WantedAd).instrumentNeeded.contains(self.instrumentText[self.imstrumentPicker.selectedRow(inComponent: 0)]){
                                self.adsAfterInstrumentFilter.append(wanted as WantedAd)
                            }
                        }
                    }
                    for wanted in self.adsAfterInstrumentFilter{
                        if self.locationText[self.locationPicker.selectedRow(inComponent: 0)] == "Current City"{
                            if (wanted as WantedAd).city == self.currentCity as String{
                                self.adsAfterLocationFilter.append(wanted as WantedAd)
                            }
                        } else if self.locationText[self.locationPicker.selectedRow(inComponent: 0)] == "All"{
                            
                            self.adsAfterLocationFilter.append(wanted as WantedAd)
                        } else {
                            if (wanted as WantedAd).city == self.locationText[self.locationPicker.selectedRow(inComponent: 0)]{
                                self.adsAfterLocationFilter.append(wanted as WantedAd)
                            }
                        }
                    }
                    if self.adsAfterLocationFilter.count == 0{
                        self.infoLabel.isHidden = false
                        self.infoLabel.text = "There are no Bands matching that search criteria."
                        
                        self.bandBoardCollect.isHidden = true
                        
                    } else {
                        self.infoLabel.isHidden = true
                        self.bandBoardCollect.isHidden = false
                        for _ in self.adsAfterLocationFilter{
                            let cellNib = UINib(nibName: "JoinBandCollectionViewCell", bundle: nil)
                            self.bandBoardCollect.register(cellNib, forCellWithReuseIdentifier: "JoinBandCollectionViewCell")
                            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! JoinBandCollectionViewCell
                        
                            self.bandBoardCollect.dataSource = self
                            self.bandBoardCollect.delegate = self
                            self.bandBoardCollect.reloadData()
                            self.bandBoardCollect.gestureRecognizers?.first?.cancelsTouchesInView = false
                            self.bandBoardCollect.gestureRecognizers?.first?.delaysTouchesBegan = false
                    }
                    }

            
                }
        else {
                    
                    for wanted in self.onbWanted{
                        if self.instrumentText[self.imstrumentPicker.selectedRow(inComponent: 0)] == "All"{
                            self.adsAfterInstrumentFilter.append(wanted as WantedAd)
                        } else {
                        if (wanted as WantedAd).instrumentNeeded.contains(self.instrumentText[self.imstrumentPicker.selectedRow(inComponent: 0)]){
                            self.adsAfterInstrumentFilter.append(wanted as WantedAd)
                        }
                        }
                    }
                    for wanted in self.adsAfterInstrumentFilter{
                        if self.locationText[self.locationPicker.selectedRow(inComponent: 0)] == "Current City"{
                            if (wanted as WantedAd).city == self.currentCity as String{
                                self.adsAfterLocationFilter.append(wanted as WantedAd)
                            }
                        } else if self.locationText[self.locationPicker.selectedRow(inComponent: 0)] == "All"{
                        
                            self.adsAfterLocationFilter.append(wanted as WantedAd)
                        } else {
                            if (wanted as WantedAd).city == self.locationText[self.locationPicker.selectedRow(inComponent: 0)]{
                            self.adsAfterLocationFilter.append(wanted as WantedAd)
                        }
                        }
                    }
                    if self.adsAfterLocationFilter.isEmpty {
                        self.bandBoardCollect.isHidden = true
                        self.infoLabel.isHidden = false
                        self.infoLabel.text = "There are no OneNightBands matching that search criteria."
                    } else {
                        self.bandBoardCollect.isHidden = false
                        self.infoLabel.isHidden = true
                        for _ in self.adsAfterLocationFilter{
                            let cellNib = UINib(nibName: "JoinBandCollectionViewCell", bundle: nil)
                            self.bandBoardCollect.register(cellNib, forCellWithReuseIdentifier: "JoinBandCollectionViewCell")
                            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! JoinBandCollectionViewCell
                            self.bandBoardCollect.dataSource = self
                            self.bandBoardCollect.delegate = self
                            self.bandBoardCollect.reloadData()
                            self.bandBoardCollect.gestureRecognizers?.first?.cancelsTouchesInView = false
                            self.bandBoardCollect.gestureRecognizers?.first?.delaysTouchesBegan = false
                        }
                    }

                }
            }
        })
        
    }
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var imstrumentPicker: UIPickerView!
    var currentCity = NSString()
    var searchType = String()
    var ref = Database.database().reference()
    
    var instrumentText = ["All","Guitar", "Bass Guitar", "Piano", "Saxophone", "Trumpet", "Stand-up Bass", "violin", "Drums", "Cello", "Trombone", "Vocals", "Mandolin", "Banjo", "Harp"]
    /*var locationText = ["All","Near You","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]*/
    var cityDict = ["New York":"","Los Angeles":"","Chicago":"","Houston":"","Philadelphia":"","Phoenix":"","San Antonio, TX":"","San Diego":"","Dallas":"","San Jose":"", "Austin":"","Jacksonville": "","San Francisco":"","Indianapolis":"","Columbus":"", "Fort Worth":"","Charlotte":"","Detroit":"","El Paso":"","Seattle":"","Denver":"","Washington":"","Memphis":"","Boston":"","Nashville":"","Atlanta":""]
    var onbWanted = [WantedAd]()
    var bandWanted = [WantedAd]()
    var locationText = [String]()
    var coordinateText = [String]()
    let userID = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLabel.isHidden = false
        self.infoLabel.text = "Select search criteria below and then press Search"
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "location"{
                        let locDict = snap.value as! [String:Any]
                        let tempLongDouble = (locDict["long"] as! Double)
                        let tempLongCoord = CLLocationDegrees(tempLongDouble)
                        
                        let tempLatDouble = (locDict["lat"] as! Double)
                        let tempLatCoord = CLLocationDegrees(tempLatDouble)
                        let tempLoc = CLLocation(latitude: tempLatCoord, longitude: tempLongCoord)
                        let geoCoder = CLGeocoder()
                        geoCoder.reverseGeocodeLocation(tempLoc, completionHandler: {(placemarks, error) -> Void in
                            var placeMark: CLPlacemark!
                            placeMark = placemarks?[0]
                            print(placeMark.addressDictionary as Any)
                            self.currentCity = (placeMark.addressDictionary!["City"] as? NSString)!
                               
                            
                        })
                        
                    }
                }
            }
        })

        for (key, value) in cityDict{
            locationText.append(key)
            coordinateText.append(value)
        }
        locationText.sort()
        locationText.insert("Current City", at: 0)
        locationText.insert("All", at: 0)
        imstrumentPicker.delegate = self
        locationPicker.delegate = self
        

       /* if self.searchType == "Bands"{
            
                    } else {
            for _ in self.onbWanted{
                let cellNib = UINib(nibName: "JoinBandCollectionViewCell", bundle: nil)
                self.bandBoardCollect.register(cellNib, forCellWithReuseIdentifier: "JoinBandCollectionViewCell")
                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! JoinBandCollectionViewCell
                self.bandBoardCollect.dataSource = self
                self.bandBoardCollect.delegate = self
                self.bandBoardCollect.reloadData()
                self.bandBoardCollect.gestureRecognizers?.first?.cancelsTouchesInView = false
                self.bandBoardCollect.gestureRecognizers?.first?.delaysTouchesBegan = false
            }

        }*/

       
    }
    var sizingCell = JoinBandCollectionViewCell()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == self.locationPicker{
            return self.locationText.count
        }else{
            return instrumentText.count
        }
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.locationPicker{
            let titleData = locationText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.black])
            return myTitle
        }else{
            let titleData = instrumentText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.black])
            return myTitle
            
        }
        
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.adsAfterLocationFilter.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JoinBandCollectionViewCell", for: indexPath as IndexPath) as! JoinBandCollectionViewCell
        //cell.delegate = self
        cell.delegate = self
        cell.wantedAd = adsAfterLocationFilter[indexPath.row]
        self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        return cell
        
        
    }
    var wantedAdSelected = WantedAd()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.wantedAdSelected = adsAfterLocationFilter[indexPath.row]
    }
    
    func configureCell(_ cell: JoinBandCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        cell.bandID = adsAfterLocationFilter[indexPath.row].bandID
        cell.wantedAd = adsAfterLocationFilter[indexPath.row] as WantedAd
       
        cell.bandName.text = adsAfterLocationFilter[indexPath.row].bandName
        cell.bandImageView.loadImageUsingCacheWithUrlString(adsAfterLocationFilter[indexPath.row].wantedImage)
        cell.city.text = adsAfterLocationFilter[indexPath.row].city
        cell.experienceWanted.text = adsAfterLocationFilter[indexPath.row].experience
        //make tableview for instruments needed
        
        cell.instrumentWanted.text = self.instrumentText[self.imstrumentPicker.selectedRow(inComponent: 0)]
    
        cell.moreInfoTextView.text = adsAfterLocationFilter[indexPath.row].moreInfo
    
    }
    
    


    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BandBoardToBandPage"{
            if let vc = segue.destination as? SessionMakerViewController{
                vc.sender = "bandBoard"
                vc.sessionID = self.selectedWantedBandID
            }
            
        }
        if segue.identifier == "BandBoardToONBPage"{
            if let vc = segue.destination as? OneNightBandViewController{
                vc.sender = "bandBoard"
                vc.onbID = self.selectedWantedBandID
                
            }
        }

    }
    

}
