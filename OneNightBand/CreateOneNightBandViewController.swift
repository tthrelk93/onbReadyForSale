//
//  CreateOneNightBandViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/6/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftOverlays

class CreateOneNightBandViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, Dismissable {
    @IBOutlet weak var cancelPressed: UIButton!
    @IBAction func cancelPressed(_ sender: Any) {
        dismissalDelegate?.finishedShowing()
        removeAnimate()
    }
    @IBOutlet weak var createONBButton: UIButton!

    @IBOutlet weak var popupView: UIView!
    let user = Auth.auth().currentUser?.uid
    var destination = String()
    var bandPics = [String]()
    var tempArray = [String]()
    var onbID = String()
    var wantedAd = WantedAd()
    var wantedIDArray = [String]()
    var metaData: String?
    @IBAction func createONBPressed(_ sender: Any) {
        if(sessionImageView.image != nil && bandNameTextField.text != "" && onbInfoTextView.text != "tap to add a little info about the OneNightBand you are creating (songs to learn, location, etc...)."){
            SwiftOverlays.showBlockingWaitOverlayWithText("Loading Your Bands")
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("oneNightBand_images").child("\(imageName).jpg")
            
            if let sessionImage = self.sessionImageView.image, let uploadData = UIImageJPEGRepresentation(sessionImage, 0.1) {
               // storageRef.putData(uploadData)
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    //let tempURL = URL.init(fileURLWithPath: "temp")
                    self.metaData = (metadata?.downloadURL()?.absoluteString)!
                    let sessionImageUrl = self.metaData
                        self.bandPics.append(sessionImageUrl!)
                        
                        var tempArray2 = [String]()
                        var values = Dictionary<String, Any>()
                        tempArray2.append((Auth.auth().currentUser?.uid)! as String)
                        values["onbName"] =  self.bandNameTextField.text
                        values["onbArtists"] = [(Auth.auth().currentUser?.uid)!:"Session Founder"]
                        values["onbInfo"] = self.onbInfoTextView.text
                        values["onbPictureURL"] = self.bandPics
                        values["onbMedia"] = [String]()
                        values["messages"] = [String: Any]()
                        values["views"] = 0
                        values["wantedAds"] = [String]()
                        values["sessFeedMedia"] = [String]()
                        values["fanCount"] = 0
                        
                        let dateformatter = DateFormatter()
                        dateformatter.dateStyle = DateFormatter.Style.short
                        let now = dateformatter.string(from: self.datePicker.date)
                        values["onbDate"] = now
                        let ref = Database.database().reference()
                        let bandReference = ref.child("oneNightBands").childByAutoId()
                        let sessReferenceAnyObject = bandReference.key
                        values["onbID"] = sessReferenceAnyObject
                        self.onbObject.setValuesForKeys(values)
                    
                    
                    
                        self.onbID = sessReferenceAnyObject
                    

                        
                        
                        
                        bandReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err as Any)
                                return
                            }
                        })
                        
                        var tempDict = [String : Any]()
                        self.ref.child("users").child(self.user!).child("artistsONBs").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    
                                    self.tempArray.append(snap.value as! String)
                                }
                            }
                            self.tempArray.append(sessReferenceAnyObject)

                        
                        tempDict["artistsONBs"] = self.tempArray
                        let userRef = self.ref.child("users").child(self.user!)
                        userRef.updateChildValues(tempDict, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err as Any)
                                return
                            }
                            
                                    self.performSegue(withIdentifier: "CreateONBToArtistFinder", sender: self)
                                

                            
                        })
                        

                       
                        })
                    
                })
                
            }
            
            
        }else{
            self.createONBButton.isEnabled = true
            let alert = UIAlertController(title: "Error", message: "Missing Information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var onbInfoTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bandNameTextField: UITextField!
    
    weak var dismissalDelegate: DismissalDelegate?
    var ref = Database.database().reference()
    
    lazy var sessionImageViewButton: UIButton = {
        var tempButton = UIButton()
       
        tempButton.layer.borderWidth = 2
        tempButton.layer.borderColor = UIColor.lightGray.cgColor
        tempButton.backgroundColor = UIColor.clear
        tempButton.setTitle("Select\n Band\n Image", for: .normal)
        tempButton.titleLabel?.numberOfLines = 3
        tempButton.titleLabel?.textAlignment = NSTextAlignment.center
        tempButton.titleLabel?.lineBreakMode = .byWordWrapping
        tempButton.setTitleColor(UIColor.lightGray, for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightLight)
        tempButton.layer.cornerRadius = 10
        tempButton.clipsToBounds = true
        tempButton.contentMode = .scaleAspectFill
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.isEnabled = true
        tempButton.alpha = 0.6
        tempButton.addTarget(self, action: #selector(handleSelectSessionImageView), for: .touchUpInside)
        
        
        return tempButton
        
    }()
    func setupSessionImageViewButton(){
        switch UIScreen.main.bounds.width{
        case 320:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: bandNameTextField.topAnchor, constant: -12).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 125).isActive = true
            
        case 375:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: bandNameTextField.topAnchor, constant: -12).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
        case 414:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: bandNameTextField.topAnchor, constant: -12).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            
        default:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: bandNameTextField.topAnchor, constant: -12).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            
        }
        
    }
    
    let picker = UIImagePickerController()
    func handleSelectSessionImageView() {
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    lazy var sessionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        //imageView.image = UIImage(named: "icon-profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        //imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    func setupSessionImageView() {
        //need x, y, width, height constraints
        sessionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sessionImageView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        sessionImageView.widthAnchor.constraint(equalTo: sessionImageViewButton.widthAnchor).isActive = true
        sessionImageView.heightAnchor.constraint(equalTo: sessionImageViewButton.heightAnchor).isActive = true
        
        //sessionImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true

        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(sessionImageView)
        view.addSubview(sessionImageViewButton)
        setupSessionImageView()
        setupSessionImageViewButton()
        onbInfoTextView.layer.borderColor = UIColor.white.cgColor
        onbInfoTextView.layer.borderWidth = 2
        onbInfoTextView.layer.masksToBounds = false
        onbInfoTextView.delegate = self
        onbInfoTextView.textColor = UIColor.white
        
        self.onbInfoTextView.text = "tap to add a little info about the OneNightBand you are creating (songs to learn, location, etc...)."
        
        self.showAnimate()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if onbInfoTextView.textColor == UIColor.white {
            onbInfoTextView.text = nil
            onbInfoTextView.textColor = ONBPink
            
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if onbInfoTextView.text.isEmpty {
            onbInfoTextView.text = "tap to add a little info about the OneNightBand you are creating (songs to learn, location, etc...)."
            onbInfoTextView.textColor = UIColor.white
        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        SwiftOverlays.removeAllBlockingOverlays()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        print("test")
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            sessionImageViewButton.setBackgroundImage(selectedImage, for: .normal)
            //profileImageViewButton.set
            sessionImageView.image = selectedImage
            //sessionPics.append(selectedImage)
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    


    
    var sender = String()
    
    // MARK: - Navigation
    var onbObject = ONB()
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       /* if let vc = segue.destination as? OneNightBandViewController{
            vc.onbID = self.onbID
        }*/
        
        if segue.identifier == "CreateONBToProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.sender = "wantedAdCreated"
            }
            
        } else {
            if let vc = segue.destination as? ArtistFinderViewController{
                vc.bandType = "onb"
                vc.bandID = self.onbID
                vc.senderScreen = "onb"
                vc.sender = "joinBand"
                vc.thisONBObject = self.onbObject
                
                
            }
        }

    }
    

}
