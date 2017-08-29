//
//  ArtistFinderViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/8/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
import SwiftOverlays
//import FlexibleSteppedProgressBar

protocol WantedAdDelegate : class
{
    func wantedAdCreated(wantedAd: WantedAd)
}



protocol WantedAdDelegator : class
{
    weak var wantedAdDelegate : WantedAdDelegate? { get set }
}



class ArtistFinderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SessionIDDest, PerformSegueInArtistFinderController, UIPickerViewDelegate,UIPickerViewDataSource, WantedAdDelegate, UITabBarDelegate{
    
   // var progressBar: FlexibleSteppedProgressBar!
 
    @IBOutlet weak var searchByInstrumentButton: UIButton!
    @IBOutlet weak var searchNarrowView: UIView!
    @IBOutlet weak var postToBoardButton: UIButton!
    var thisONBObject = ONB()
    var thisBandObject = Band()
    
    func wantedAdCreated(wantedAd: WantedAd) {
        self.wantedAd = wantedAd
       // print("WantedAd: \(self.wantedAd)")
        performSegue(withIdentifier: "ArtistFinderToPFM", sender: self)
    }
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var onbCollect: UICollectionView!
    
    @IBOutlet weak var addBandView: UIView!
    
    @IBAction func newONBButtonPressed(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOneNightBandViewController") as! CreateOneNightBandViewController
        self.addChildViewController(popOverVC)
        popOverVC.searchType = "af"
        popOverVC.parentView2 = self
        popOverVC.artistUID = self.artistUID
        //popOverVC.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width - 50, height: self.view.frame.height - 50)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

        
        
    }
    @IBOutlet weak var newONBButton: UIButton!
    @IBOutlet weak var bandCollect: UICollectionView!
    @IBOutlet weak var newBandButton: UIButton!
    @IBAction func newBandButtonPressed(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateBandViewController") as! CreateBandViewController
        self.addChildViewController(popOverVC)
        popOverVC.searchType = "af"
        popOverVC.view.frame = self.view.frame
        popOverVC.parentView2 = self
        popOverVC.artistUID = self.artistUID
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    
    @IBAction func postToBoardButtonPressed(_ sender: Any) {
        self.destination = "wanted"
        self.buttonSelected = "wanted"
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateWantedAdViewController") as! CreateWantedAdViewController
        self.addChildViewController(popOverVC)
        
            popOverVC.bandID = ""
            popOverVC.bandType = ""
            popOverVC.wantedAdDelegate = self
        
        popOverVC.view.frame = UIScreen.main.bounds
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
            //searchNarrowView.isHidden = true
        
        
    }
    var senderScreen = String()
    var sender = String()
    @IBAction func afBackButton(_ sender: Any) {
        backButton.isHidden = true
        if self.senderScreen == "band"{
            performSegue(withIdentifier: "afBackToBand", sender: self)
        } else if self.senderScreen == "artistFinder"{
           // self.progressBar.isHidden = false
            searchNarrowView.isHidden = false
        }else if self.senderScreen == "onb"{
            performSegue(withIdentifier: "afBackToONB", sender: self)
        } else if self.senderScreen == "pfm" {
            performSegue(withIdentifier: "afBackToPFM", sender: self)
        }
    }
    @IBAction func searchByInstrumentPressed(_ sender: Any) {
        //searchNarrowView.isHidden = true
        self.senderScreen = "artistFinder"
        self.destination = "artistFinder"
        self.buttonSelected = "artistFinder"
        //performSegue(withIdentifier: "ArtistFinderToPFM", sender: self)
        self.searchNarrowView.isHidden = true
        self.backButton.isHidden = false
        //progressBar.isHidden = true
    }
    @IBOutlet weak var InstrumentPicker: UIPickerView!
    
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    
    @IBOutlet weak var noArtistsFoundLabel: UILabel!
    
    var sizingCell: ArtistCardCell?
    weak var getSessionID : GetSessionIDDelegate?
    var artistPageViewController: UIPageViewController!
    var artistArray = [Artist]()
    var ref = Database.database().reference()
    var thisSession: String!
    var thisSessionObject: Band!
    var bandID = String()
    var bandType = String()
    var instrumentPicked: String!
    var distancePicked: String!
    var profileArtistUID: String?
    var wantedAd = WantedAd()
    var destination = String()
    var buttonSelected = String()
    var fromTabBar = false
    var cityDict = ["New York":"","Los Angeles":"","Chicago":"","Houston":"","Philadelphia":"","Phoenix, AZ":"","San Antonio":"","San Diego":"","Dallas":"","San Jose":"", "Austin":"","Jacksonville": "","San Francisco":"","Indianapolis":"","Columbus":"", "Fort Worth":"","Charlotte":"","Detroit":"","El Paso":"","Seattle":"","Denver":"","Washington ":"","Memphis":"","Boston":"","Nashville":"","Atlanta":""]
    var distanceMenuText = ["25", "50", "75", "100", "125","150", "175","500", "2000"]
    var menuText = ["All","Guitar", "Bass Guitar", "Piano", "Saxophone", "Trumpet", "Stand-up Bass", "Violin", "Drums", "Cello", "Trombone", "Vocals", "Mandolin", "Banjo", "Harp", "Rapper", "DJ"]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! as String) == "ArtistFinderToPFM"{
            print("pfmToAFPrepare")
                if let vc = segue.destination as? ProfileFindMusiciansViewController{
                    vc.artistUID = self.artistUID
                    vc.searchType = "af"
                    vc.inviteDict = self.inviteDict
                   // if buttonSelected == "wanted"{
                     //   vc.wantedAd = self.wantedAd
                        //vc.destination = self.destination
                  //  } else {
                
                      //  vc.destination = self.destination
                   // }
            }

        } else if segue.identifier == "ArtistFinderToProfile" {
            if let vc = segue.destination as? profileRedesignViewController{
                if fromTabBar == false && self.sender != "joinBand"{
                    
                        vc.artistID = self.profileArtistUID!
                        vc.userID = self.profileArtistUID!
                    
                } else {
                    vc.artistID = (Auth.auth().currentUser?.uid)!
                    vc.userID = (Auth.auth().currentUser?.uid)!
                }

                if self.sender != "joinBand"{
                    vc.sender = "af"
                    vc.afType = self.bandType
                    
                if self.bandType == "band"{
                    vc.thisBand = self.thisBandObject
                } else {
                    vc.thisONB = self.thisONBObject
                }
                }
            }
        }else if segue.identifier! == "afBackToONB" {
            if let vc = segue.destination as? OneNightBandViewController{
                vc.onbID = self.bandID
                
                
            }
        } else if segue.identifier! == "afBackToBand" {
            if let vc = segue.destination as? SessionMakerViewController{
                vc.sessionID = self.bandID
            }
        } else {
            
        
        }

        
    }
    
    
    
    
   /* func progressBar(_ progressBar: FlexibleSteppedProgressBar,
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
            case 1: return "Create Band/ONB"
            case 2: return "Search Type"
                //case 3: return "Fourth"
            //case 4: return "Fifth"
            default: return "Date"
                
            }
        }
        return ""
    }
*/
    
    var pickerHolderPosition1Frame = CGRect()
    var collectPosition1Frame = CGRect()
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]

    @IBAction func backToP1Pressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: self.animationOptions, animations: {
            self.pickerHolderPosition1.isHidden = false
            self.artistCollectionView.isHidden = true
            self.backtoPosition1.isHidden = true
            self.pickerHolderPosition1.bounds = self.pickerHolderPosition1Frame
            self.pickerHolderPosition1.frame.origin = self.pickerHolderPosition1Origin
            
            self.collectPosition1.bounds = self.collectPosition1Frame
            self.collectPosition1.frame.origin = self.collectPosition1Origin
        })

        
        
       
        
    }
    @IBOutlet weak var backtoPosition1: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    func performSegueToProfile(artistUID: String) {
        self.profileArtistUID = artistUID
        performSegue(withIdentifier: "ArtistFinderToProfile", sender: self)
    }
    @IBOutlet weak var distancePicker: UIPickerView!
    
    var coordinateUser1: CLLocation?
    var coordinateUser2: CLLocation?
    //var distance: Double?
    
    //var tempLong: CLLocationDegrees?
    //var tempLat: CLLocationDegrees?
    var distanceInMeters: Double?
    var artistAfterDist = [Artist]()
    
    var instrumentArray = [String]()
    var inviteDict = [String: Any]()
    var artistUID = String()
    
    var tempCoordinate: CLLocation?
    var tempLong: CLLocationDegrees?
    var tempLat: CLLocationDegrees?
    var tempCoordinate2: CLLocation?
    var tempLong2: CLLocationDegrees?
    var tempLat2: CLLocationDegrees?
    var tempDistInMeters: Double?
    
    
    func performSegueToPFM(artistUID: String, dict: [String: Any]){
        print("performSegAFToPFM:\(artistUID)")
        self.artistUID = artistUID
        self.inviteDict = dict
        addBandView.isHidden = false
        //performSegue(withIdentifier: "ArtistFinderToPFM", sender: self)
    
    }
    
    @IBAction func backFromAddBandPressed(_ sender: Any) {
        addBandView.isHidden = true
    }
    
    @IBAction func searchForArtistsPressed(_ sender: AnyObject) {
        SwiftOverlays.showBlockingWaitOverlayWithText("Finding Musicians")
        
        var tempLoc = CLLocation()
        self.ref.child("cityData").observeSingleEvent(of: .value, with: { (snapshot3) in
            if let snapshots3 = snapshot3.children.allObjects as? [DataSnapshot]{
                for snap3 in snapshots3{
                    if snap3.key == self.cityNameArray[self.distancePicker.selectedRow(inComponent: 0)]{
                        var tempDict = snap3.value as! [String:Any]
                        tempLoc = CLLocation(latitude: tempDict["latitude"] as! CLLocationDegrees, longitude: tempDict["longitude"] as! CLLocationDegrees)
                       break
                    }
                }
            }
        })
        
        
        artistArray.removeAll()
        artistAfterDist.removeAll()
        instrumentArray.removeAll()
        self.instrumentPicked = self.menuText[self.InstrumentPicker.selectedRow(inComponent: 0)]
       // print("ip: \(instrumentPicked)")
        artistArray = [Artist]()
        artistAfterDist = [Artist]()
        //DispatchQueue.global(qos: .default).async{
        let group = DispatchGroup()
        let group2 = DispatchGroup()
        let group3 = DispatchGroup()
        
        //group3.enter()
        
       // DispatchQueue.main.async{
        group.enter()
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let dictionary = snap.value as? [String: Any]
                    let artist = Artist()
                    artist.setValuesForKeys(dictionary!)
                    self.artistArray.append(artist)
                }
                
                
                    for artist in self.artistArray {
                      //  group3.wait()
                       // group2.enter()
                        self.instrumentArray.removeAll()
                        if(artist.artistUID != Auth.auth().currentUser?.uid){
                                        for key in artist.instruments.keys{
                                            self.instrumentArray.append(key)
                                        }
                                    if self.menuText[self.InstrumentPicker.selectedRow(inComponent: 0)] == "All" {
                                    } else {
                                        if(self.instrumentArray.contains(self.menuText[self.InstrumentPicker.selectedRow(inComponent: 0)]) == false){
                                            self.artistArray.remove(at: self.artistArray.index(of: artist)!)
                                        }
                            }
                        } else {
                            self.artistArray.remove(at: self.artistArray.index(of: artist)! )
                        }
                }
            }
        
        
                        let userID = Auth.auth().currentUser?.uid
                        self.ref.child("users").child(userID!).child("location").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    if snap.key == "long"{
                                        self.tempLong2 = snap.value as? CLLocationDegrees
                                    }else{
                                        self.tempLat2 = snap.value as? CLLocationDegrees
                                    }
                                }
                                
                                
                                
                                // group2.leave()
                                
                                
                                
                            }
                            self.tempCoordinate2 = CLLocation(latitude: self.tempLat2!, longitude: self.tempLong2!)
                            
                            var tempCount = 0
                          //  DispatchQueue.main.async{
                            for artist in self.artistArray{
                                
                                tempCount += 1
                                self.tempLong = artist.location["long"] as? CLLocationDegrees
                                self.tempLat = artist.location["lat"] as? CLLocationDegrees
                                self.tempCoordinate = CLLocation(latitude: self.tempLat!, longitude: self.tempLong!)
                                let geoCoder = CLGeocoder()
                                let geoCoder2 = CLGeocoder()
                                
                                if self.cityNameArray[self.distancePicker.selectedRow(inComponent: 0)] == "Current" {
                                   // tempCount += 1
                                    
                                    if Int((self.tempCoordinate?.distance(from: self.tempCoordinate2!))!) <= 20000 {
                                        self.artistAfterDist.append(artist)
                                        
                                    }
                                    if tempCount == self.artistArray.count {
                                        group.leave()
                                    }
                                } else if self.cityNameArray[self.distancePicker.selectedRow(inComponent: 0)] == "All"{
                                   // tempCount += 1
                                    
                                    self.artistAfterDist.append(artist)
                                    if tempCount == self.artistArray.count {
                                        group.leave()
                                    }
                                } else {
                                   // tempCount += 1
                                    print("dist: \(Int((self.tempCoordinate?.distance(from: tempLoc))!))")
                                    if Int((self.tempCoordinate?.distance(from: tempLoc))!) <= 20000 {
                                        print("justworkkkk")
                                        self.artistAfterDist.append(artist)
                                        
                                    }
                                    if tempCount == self.artistArray.count {
                                        group.leave()
                                    }
                                }
                            }
                          //  }
                       // })
       // })

    
                                //DispatchQueue.main.async{
                                /*geoCoder.reverseGeocodeLocation(self.tempCoordinate!, completionHandler: { (placemarks, error) ->  Void in
                                    var placeMark: CLPlacemark!
                                    placeMark = placemarks?[0]
                                    
                                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                                       print("city \(city)")
                                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                            for snap in snapshots{
                                                if snap.key == "long"{
                                                    self.tempLong2 = snap.value as? CLLocationDegrees
                                                }else{
                                                    self.tempLat2 = snap.value as? CLLocationDegrees
                                                }
                                            }
                                        
                                        
                                            
                                           // group2.leave()
                                        
                                      
                                
                                        }
                                        self.tempCoordinate2 = CLLocation(latitude: self.tempLat2!, longitude: self.tempLong2!)
                                //group2.notify(queue: .main, execute: {
                                   // group3.enter()
                                    geoCoder2.reverseGeocodeLocation(self.tempCoordinate2!, completionHandler: { (placemarks2, error) -> Void in
                                        
                                        var placeMark2: CLPlacemark!
                                        placeMark2 = placemarks2?[0]
                                        
                                        if let city2 = placeMark2.addressDictionary!["City"] as? NSString {
                                            print("city2: \(city2)")
                                            var tempInt = self.distancePicker.selectedRow(inComponent: 0) as Int
                                            if self.cityNameArray[self.distancePicker.selectedRow(inComponent: 0)] == "Current" {
                                                tempCount += 1
                                                
                                                if Int((self.tempCoordinate?.distance(from: self.tempCoordinate2!))!) <= 2000 {
                                                    self.artistAfterDist.append(artist)
                                                    group.leave()
                                                }
                                            } else if self.cityNameArray[self.distancePicker.selectedRow(inComponent: 0)] == "All"{
                                                tempCount += 1
                                                
                                                self.artistAfterDist.append(artist)
                                                group.leave()
                                            } else {
                                                tempCount += 1
                                                print("dist: \(Int((self.tempCoordinate?.distance(from: tempLoc))!))")
                                                if Int((self.tempCoordinate?.distance(from: tempLoc))!) <= 1000 {
                                                    print("justworkkkk")
                                                    self.artistAfterDist.append(artist)
                                                    if tempCount == self.artistArray.count - 1 {
                                                        group.leave()
                                                    }
                                                }
                                            }
                                           // group3.leave()
                                        }
                                    
                                    })
                                    
                                        
                                        
                                  //  })
                                        
                                    }
                                    
                                    })

                                    
                                
                            }
                        })
        })*/
                            })
            
                            
                                
                                   
                            
       
    
        group.notify(queue: .main, execute: {
        if self.artistAfterDist.isEmpty{
            self.noArtistsFoundLabel.isHidden = false
            self.artistCollectionView.isHidden = true
            self.artistCollectionView.reloadData()
        }else{
            self.noArtistsFoundLabel.isHidden = true
            self.artistCollectionView.isHidden = false
            self.InstrumentPicker.delegate = self
            self.InstrumentPicker.dataSource = self
            self.distancePicker.delegate = self
            self.distancePicker.dataSource = self
            let cellNib = UINib(nibName: "ArtistCardCell", bundle: nil)
            self.artistCollectionView.register(cellNib, forCellWithReuseIdentifier: "ArtistCardCell")
            self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! ArtistCardCell?
            self.artistCollectionView.dataSource = self
            self.artistCollectionView.delegate = self
            self.artistCollectionView.reloadData()
            
            self.artistCollectionView.gestureRecognizers?.first?.cancelsTouchesInView = false
            self.artistCollectionView.gestureRecognizers?.first?.delaysTouchesBegan = false
        }
            
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: self.animationOptions, animations: {
                self.pickerHolderPosition1.isHidden = true
                self.artistCollectionView.isHidden = false
                //self.artistCollectionView.bounds = self.collectPosition2.bounds
                self.backtoPosition1.isHidden = false
                self.backtoPosition1.bounds = self.pickerHolderPosition2.bounds
                self.backtoPosition1.frame.origin = self.pickerHolderPosition2.frame.origin
                
                self.pickerHolderPosition1.bounds = self.pickerHolderPosition2.bounds
                self.pickerHolderPosition1.frame.origin = self.pickerHolderPosition2.frame.origin
                
                self.collectPosition1.bounds = self.collectPosition2.bounds
                self.collectPosition1.frame.origin = self.collectPosition2.frame.origin
            })
            
            
       
        
        
        
        SwiftOverlays.removeAllBlockingOverlays()
            
            
        })
    })
    

        
        
        
        
    }







    
    
    
    
    
    
    
    
    
   
    

   
    
   
    
     let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    var cityArray = String()
    var cityNameArray = [String]()
    var cityInfoDict = [String:Any]()
    var progressBounds = CGRect()
    
    var sizingCell5: SessionCell?
    
    @IBOutlet weak var pickerHolderPosition1: UIView!
    @IBOutlet weak var pickerHolderPosition2: UIView!
    var pickerHolderPosition1Origin = CGPoint()
    var bandIDArray = [String]()
    var onbIDArray = [String]()
    var bandsDict = [String:Any]()
    var onbDict = [String:Any]()
    var bandArray = [Band]()
    var onbArray = [ONB]()
    
    @IBOutlet weak var collectPosition1: UIView!
    
    @IBOutlet weak var collectPosition2: UIView!
    var collectPosition1Origin = CGPoint()
    
    
    @IBOutlet weak var backButton: UIButton!
    
    
   override func viewDidLoad() {
        super.viewDidLoad()
    if createInviteSuccess == true{
        let alert = UIAlertController(title: "Success!", message: "Invite sent.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    newBandButton.layer.borderColor = ONBPink.cgColor
    newBandButton.layer.borderWidth = 2
    newBandButton.layer.cornerRadius = newBandButton.frame.width/2
    
    newONBButton.layer.borderColor = ONBPink.cgColor
    newONBButton.layer.borderWidth = 2
    newONBButton.layer.cornerRadius = newBandButton.frame.width/2
    
    //bandCollect.layer.borderWidth = 2
   // onbCollect.layer.borderWidth = 2
    //bandCollect.layer.borderColor = UIColor.black.cgColor
    //onbCollect.layer.borderColor = UIColor.black.cgColor
    
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    backButton.isHidden = true
    backButton.layer.cornerRadius = 10
    collectPosition1Frame = collectPosition1.bounds
    pickerHolderPosition1Frame = pickerHolderPosition1.bounds
    searchNarrowView.isHidden = false
    pickerHolderPosition1Origin = pickerHolderPosition1.frame.origin
    collectPosition1Origin = collectPosition1.frame.origin
    bandCollect.delegate = self
    onbCollect.delegate = self
    
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

        
    
   /* progressBounds = progressBarFrame.frame
    
    progressBar = FlexibleSteppedProgressBar()
    progressBar.frame = progressBounds
    progressBar.viewBackgroundColor = UIColor.blue
    progressBar.backgroundShapeColor = ONBPink
    progressBar.selectedBackgoundColor = UIColor.blue
    progressBar.stepTextColor = UIColor.white
    progressBar.currentSelectedTextColor = ONBPink
    progressBar.currentSelectedCenterColor = ONBPink
    progressBar.selectedOuterCircleStrokeColor = ONBPink
    progressBar.isUserInteractionEnabled = false
    progressBar.currentIndex = 2
    
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(progressBar)
    progressBar.isHidden = true*/
    
    //let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    /* let verticalConstraint = progressBar.topAnchor.constraintEqualToAnchor(
     equalTo: view.topAnchor,
     constant: 80
     )
     let widthConstraint = progressBar.constraint.constraintEqualToAnchor(nil, constant: 500)
     let heightConstraint = progressBar.constraint.constraintEqualToAnchor(nil, constant: 150)
     NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])*/
    
    // Customise the progress bar here
   /* progressBar.numberOfPoints = 3
    progressBar.lineHeight = 9
    progressBar.radius = 15
    progressBar.progressRadius = 25
    progressBar.progressLineHeight = 3
    progressBar.delegate = self*/
    
    
    /*if /*self.PFMChoiceSelected == true ||*/ self.senderScreen == "band" || self.senderScreen == "onb"{
        searchNarrowView.isHidden = true
       // progressBar.isHidden = true
        if self.sender == "joinBand"{
            self.findArtistNowView.isHidden = false
            self.nowOrLaterBackground.isHidden = false
        }
    } else {
        searchNarrowView.isHidden = false
        //progressBar.isHidden = false
    }*/
    ref.child("cityData").observeSingleEvent(of: .value, with: { (snapshot) in
        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
           // self.cityNameArray.append("All")
          //  self.cityNameArray.append("Current")
            for snap in snapshots{
                self.cityNameArray.append(snap.key)
            }
            self.cityNameArray.insert("Current", at: 0)
            self.cityNameArray.insert("All", at: 0)
        }
    })
    var tempCityData = CityData()
    let tempCityDict = tempCityData.cityData
    //ref.child("wantedAds").childByAutoId()
    var tempDict = [String:Any]()
    var tempArray = [[String:Any]]()
    for city in tempCityDict{
        var newCityDict = [String:Any]()
        var cityName = String()
        for (key, val) in city{
            if (key as String) == "city" || (key as String) == "longitude" || (key as String) == "latitude" || (key as String) == "state" {
                if (key as String) == "city"{
                    cityName = val as! String
                    cityNameArray.append(cityName)
                    
                }
                newCityDict[key] = val
            }
        }
        tempDict[cityName] = newCityDict
    }
   // var uploadData = [String:Any]()
   // uploadData["cityData"] = tempDict as [String:Any]
   // self.ref.child("cityData").updateChildValues(tempDict)*/
    
   /* for (key, _) in cityDict{
        self.cityArray.append(key )
        
    }*/
    
        checkIfUserIsLoggedIn()
    tabBar.delegate = self
    tabBar.selectedItem = tabBar.items?[0]
    tabBar.tintColor = ONBPink
    self.postToBoardButton.layer.borderColor = ONBPink.cgColor
    self.postToBoardButton.layer.borderWidth = 2
    self.searchByInstrumentButton.layer.borderColor = ONBPink.cgColor
    self.searchByInstrumentButton.layer.borderWidth = 2
        noArtistsFoundLabel.isHidden = true
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        artistCollectionView.collectionViewLayout = layout
        InstrumentPicker.selectRow(menuText.count/2, inComponent: 0, animated: true)
    }
    var currentUser: String?
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleBack), with: nil, afterDelay: 0)
        } else {
            
            currentUser = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if let dictionary = snap.value as? [String: AnyObject] {
                        let artist = Artist()
                        artist.setValuesForKeys(dictionary)
                        self.artistArray.append(artist)

                    }
                }
            }
                //self.artistCollectionView.gestureRecognizers?.first?.cancelsTouchesInView = false
                self.InstrumentPicker.delegate = self
                self.InstrumentPicker.dataSource = self
                self.distancePicker.delegate = self
                self.distancePicker.dataSource = self
               // self.InstrumentPicker.selectRow(self.menuText.count/2, inComponent: 0, animated: false)
                
            }, withCancel: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == artistCollectionView{
        return artistAfterDist.count
        } else if collectionView == onbCollect{
            return onbIDArray.count
        } else{
            return bandIDArray.count
        }
    }
    var selectedONB = ONB()
    var selectedBand = Band()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == onbCollect {
            self.selectedONB = onbArray[indexPath.row]
            self.bandType = "ONB"
            
            
            
            ref.child("users").child(self.artistUID).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    let recipient = self.ref.child("users").child(self.artistUID).child("invites")
                    let currentUser = Auth.auth().currentUser?.uid
                    let tempID = recipient.childByAutoId()
                    var values = [String: Any]()
                    values["sender"] = currentUser!
                    values["bandID"] = self.onbArray[indexPath.row].onbID
                    values["instrumentNeeded"] = self.instrumentPicked
                    
                    values["date"] = self.onbArray[indexPath.row].onbDate
                    values["artistCount"] = self.onbArray[indexPath.row].onbArtists.count
                    values["bandType"] = "ONB"
                    values["bandName"] = self.onbArray[indexPath.row].onbName
                    values["inviteResponse"] = String()
                    
                    
                    tempID.updateChildValues(values, withCompletionBlock: {(err, ref) in
                     if err != nil {
                     print(err as Any)
                     return
                     }
                        let alert = UIAlertController(title: "Success!", message: "Invite sent.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                    
                    
                     })
                }
            })
            

        }
        
        if collectionView == self.bandCollect{
            self.selectedBand = self.bandArray[indexPath.row]
            self.bandType = "Band"
            ref.child("users").child(self.artistUID).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    let recipient = self.ref.child("users").child(self.artistUID).child("invites")
                    let currentUser = Auth.auth().currentUser?.uid
                    let tempID = recipient.childByAutoId()
                    var values = [String: Any]()
                    values["sender"] = currentUser!
                    values["bandID"] = self.bandArray[indexPath.row].bandID
                    values["instrumentNeeded"] = self.instrumentPicked
                    
                    values["date"] = ""
                    values["artistCount"] = self.bandArray[indexPath.row].bandMembers.count
                    values["bandType"] = "Band"
                    values["bandName"] = self.bandArray[indexPath.row].bandName
                    values["inviteResponse"] = String()
                    
                    
                    tempID.updateChildValues(values, withCompletionBlock: {(err, ref) in
                        if err != nil {
                            print(err as Any)
                            return
                        }
                        
                        
                    })
                }
            })
            

        }
        self.addBandView.isHidden = true
        //bandSelectorView.isHidden = true
        //step2Label.isHidden = false
        
    }

    
    var createInviteSuccess: Bool?
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == artistCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCardCell", for: indexPath as IndexPath) as! ArtistCardCell
        cell.delegate = self
        
        
        self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
        return cell
        } else {
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

        
    }
    
    func configureCell(_ cell: ArtistCardCell, forIndexPath indexPath: NSIndexPath) {
        cell.artistCardCellBioTextView.text = artistAfterDist[indexPath.row].bio
        cell.artistCardCellNameLabel.text = artistAfterDist[indexPath.row].name
        
        cell.artistCardCellImageView.loadImageUsingCacheWithUrlString(artistAfterDist[indexPath.row].profileImageUrl.first!)
        cell.artistUID = artistAfterDist[indexPath.row].artistUID
        /*if self.bandType == "onb"{
            cell.artistCount = self.thisONBObject.onbArtists.count
            cell.bandName = self.thisONBObject.onbName
            cell.invitedBandID = self.thisONBObject.onbID
            cell.sessionDate = self.thisONBObject.onbDate
            
        } else {
            cell.artistCount = self.thisBandObject.bandMembers.count
            cell.bandName = self.thisBandObject.bandName!
            cell.invitedBandID = self.thisBandObject.bandID
            cell.sessionDate = "n/a"
            
        }
        
        cell.bandType = self.bandType*/
        
        cell.buttonName = self.instrumentPicked
        //cell.sessionDate = self.thisSessionObject.sessionDate
        
        self.ref.child("users").child(artistAfterDist[indexPath.row].artistUID!).child("location").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                        if snap.key == "long"{
                            self.tempLong = snap.value as? CLLocationDegrees
                            
                        }else{
                            self.tempLat = snap.value as? CLLocationDegrees
                        }
                    }
                
                self.coordinateUser2 = CLLocation(latitude: self.tempLat!, longitude: self.tempLong!)
                let userID = Auth.auth().currentUser?.uid
                self.ref.child("users").child(userID!).child("location").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        
                        for snap in snapshots{
                                if snap.key == "long"{
                                    self.tempLong = snap.value as? CLLocationDegrees
                                    
                                }else{
                                    self.tempLat = snap.value as? CLLocationDegrees
                                }
                            }
                        self.coordinateUser1 = CLLocation(latitude: self.tempLat!, longitude: self.tempLong!)
                        
                        self.distanceInMeters = self.coordinateUser1?.distance(from: self.coordinateUser2!) // result is in meters
                        
                        let distanceInMiles = Double(round(10*(self.distanceInMeters! * 0.000621371))/10)
                        

                        /*if((distanceInMeters! as Double) <= 1609){
                         // under 1 mile
                         }
                         else
                         {
                         // out of 1 mile
                         }*/
                    }
                })
            }
        })
        self.ref.child("users").child(artistAfterDist[indexPath.row].artistUID!).child("instruments").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == self.instrumentPicked{
                        cell.reputationLabel.text = "Lvl: \(self.playingLevelArray[(snap.value as! [Int])[0]])"
                        cell.distanceLabel.text = "Years: \(self.playingYearsArray[(snap.value as! [Int])[1]])"
                    }
                }
                
            }
        })
    }
    
    @available(iOS 2.0, *)
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        self.fromTabBar = true
        if item == tabBar.items?[0]{
            
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "ArtistFinderToFindBand", sender: self)
            
        } else if item == tabBar.items?[2]{
            performSegue(withIdentifier: "ArtistFinderToProfile", sender: self)
        } else {
            performSegue(withIdentifier: "ArtistFinderToSessionFeed", sender: self)
        }
    }

    
    var artistCount = Int()
    var yearsArray = [String]()
    var playingYearsArray = ["1","2","3","4","5+","10+"]
    var playingLevelArray = ["Beginner", "Intermediate", "Advanced", "Expert","Pro"]
    var PFMChoiceSelected = Bool()

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == self.distancePicker{
            return cityNameArray.count
        }else{
            return menuText.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.distancePicker{
            let titleData = self.cityNameArray[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.black])
            return myTitle
        }else{
            let titleData = menuText[row]
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle

        }
    
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
    }
    func handleBack() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let sessTemp = SessionMakerViewController()
        present(sessTemp, animated: true, completion: nil)
    }

    
    
}



