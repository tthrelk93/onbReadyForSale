//
//  CreateBandViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 3/15/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import SwiftOverlays
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CreateBandViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, Dismissable{
    var myBands = [String]()
    var wantedAd = WantedAd()

    let ref = Database.database().reference()
    var currentUser = Auth.auth().currentUser?.uid
    var wantedIDArray = [String]()
    var thisBand = Band()
    
    @IBOutlet weak var popupView: UIView!
    @IBAction func createPressed(_ sender: Any) {
            if(sessionImageView.image != nil && bandNameTextField.text != "" && bandBioTextView.text != "tap to add a little info about the type of session you are trying to create."){
                SwiftOverlays.showBlockingWaitOverlayWithText("Creating...")//showBlockingTextOverlay("Creating Musicians Wanted Ad")

            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("session_images").child("\(imageName).jpg")
            
            if let sessionImage = self.sessionImageView.image, let uploadData = UIImageJPEGRepresentation(sessionImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    //let tempURL = URL.init(fileURLWithPath: "temp")
                    if let bandImageUrl = metadata?.downloadURL()?.absoluteString {
                        var tempArray = [String]()
                        var tempArray2 = [String]()
                        var values = Dictionary<String, Any>()
                        tempArray2.append((Auth.auth().currentUser?.uid)! as String)
                        values["bandName"] =  self.bandNameTextField.text
                        values["bandMembers"] = [(Auth.auth().currentUser?.uid)!:"-"]
                        values["bandBio"] = self.bandBioTextView.text
                        values["bandPictureURL"] = [bandImageUrl]
                        values["bandMedia"] = [""]
                        values["messages"] = [String: Any]()
                        values["fanPicks"] = 0
                        values["sessionsOnFeed"] = [""]
                        values["wantedAds"] = [String]()
                        values["fanCount"] = 0
                        //values["messages"] = [String: Any]()
                        
                        
                        
                        let bandReference = self.ref.child("bands").childByAutoId()
                        
                        let bandReferenceAnyObject = bandReference.key
                        values["bandID"] = bandReferenceAnyObject
                        self.bandID = bandReferenceAnyObject
                        
                        self.thisBand.setValuesForKeys(values)
                        let ref = Database.database().reference()
                       
                        bandReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err as Any)
                                return
                            }
                        })
                        let user = Auth.auth().currentUser?.uid
                        
                        //var sessionVals = Dictionary
                        //let userSessRef = ref.child("users").child(user).child("activeSessions")
                        
                        self.ref.child("users").child(user!).child("artistsBands").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    
                                    tempArray.append(snap.value as! String)
                                }
                            }
                            tempArray.append(bandReferenceAnyObject)
                            var tempDict = [String : Any]()
                            tempDict["artistsBands"] = tempArray
                            let userRef = self.ref.child("users").child(user!)
                            userRef.updateChildValues(tempDict, withCompletionBlock: {(err, ref) in
                                if err != nil {
                                    print(err as Any)
                                    return
                                }
                                
                                    self.segueFunc()
                            })
                            //self.finalizeSessionButton.isEnabled = true
                            //self.performSegue(withIdentifier: "CreateBandToBandVC", sender: self)
                            //this is ridiculously stupid way to reload currentSession data. find someway to fix
                            //self.performSegue(withIdentifier: "FinalizeSessionToProfile", sender: self)
                           // self.performSegue(withIdentifier: "FinalizeToMyBands", sender: self)
                        })
                    }
                })
            }
            
            
        }else{
            //self.finalizeSessionButton.isEnabled = true
            let alert = UIAlertController(title: "Error", message: "Missing Information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    var sender = String()
    weak var dismissalDelegate: DismissalDelegate?
    func segueFunc(){
        
            performSegue(withIdentifier: "CreateBandToArtistFinder", sender: self)
        

    }

    var destination = String()
    @IBOutlet weak var bandBioTextView: UITextView!
    @IBOutlet weak var bandNameTextField: UITextField!
    lazy var sessionImageViewButton: UIButton = {
        var tempButton = UIButton()
        //tempButton.setBackgroundImage(UIImage(named: "icon-profile"), for: .normal)
        /*tempButton.contentMode = .scaleAspectFill
         tempButton.translatesAutoresizingMaskIntoConstraints = false
         tempButton.isEnabled = true*/
        tempButton.layer.borderWidth = 2
        tempButton.layer.borderColor = UIColor.white.cgColor
        tempButton.backgroundColor = UIColor.clear
        tempButton.setTitle("Select\n Band\n Image", for: .normal)
        tempButton.titleLabel?.numberOfLines = 3
        tempButton.titleLabel?.textAlignment = NSTextAlignment.center
        tempButton.titleLabel?.lineBreakMode = .byWordWrapping
        tempButton.setTitleColor(UIColor.white, for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightLight)
        tempButton.layer.cornerRadius = 10
        tempButton.clipsToBounds = true
        tempButton.contentMode = .scaleAspectFill
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.isEnabled = true
        tempButton.alpha = 0.6
        tempButton.addTarget(self, action: #selector(handleSelectBandImageView), for: .touchUpInside)
        
        
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
    @IBAction func cancelTouched(_ sender: Any) {
        dismissalDelegate?.finishedShowing()
        removeAnimate()
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
        sessionImageView.bottomAnchor.constraint(equalTo: sessionImageViewButton.bottomAnchor).isActive = true
        sessionImageView.widthAnchor.constraint(equalTo: sessionImageViewButton.widthAnchor).isActive = true
        sessionImageView.heightAnchor.constraint(equalTo: sessionImageViewButton.heightAnchor).isActive = true
        
        //sessionImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    let picker = UIImagePickerController()
    func handleSelectBandImageView(){
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        //self.createButton.isEnabled = true
        popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        popupView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        bandBioTextView.layer.borderColor = UIColor.lightGray.cgColor
        bandBioTextView.layer.borderWidth = 2
        bandBioTextView.layer.masksToBounds = false
        view.addSubview(sessionImageView)
        view.addSubview(sessionImageViewButton)
        setupSessionImageView()
        setupSessionImageViewButton()
        //backgroundView.backgroundColor = UIColor.black
        //backgroundView.alpha = 0.7
        bandBioTextView.delegate = self
        self.view.backgroundColor = UIColor.clear
        //self.view.backgroundColor?.withAlphaComponent(0.8)
        bandBioTextView.textColor = UIColor.lightGray
        bandBioTextView.text = "Tap here to add a little bio about your band."
        self.showAnimate()
        picker.delegate = self
        


        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
         SwiftOverlays.removeAllBlockingOverlays()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.view.superview?.reloadInputViews()
                self.view.removeFromSuperview()
                SwiftOverlays.removeAllBlockingOverlays()
                
            }
        });
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
            //sessionImageView.isHidden = false
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if bandBioTextView.textColor == UIColor.lightGray {
            bandBioTextView.text = nil
            bandBioTextView.textColor = ONBPink
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if bandBioTextView.text.isEmpty {
            bandBioTextView.text = "tap to add a little info about the type of session you are trying to create."
            bandBioTextView.textColor = UIColor.lightGray
        }
    }


    
    // MARK: - Navigation
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    var bandID = String()

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       /* if let vc = segue.destination as? SessionMakerViewController{
            vc.sessionID = self.bandID
        }*/
        if segue.identifier == "CreateBandToProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.sender = "wantedAdCreated"
               
            }
            
        } else {
            if let vc = segue.destination as? ArtistFinderViewController{
                vc.bandType = "band"
                vc.bandID = self.bandID
                vc.senderScreen = "band"
                vc.sender = "joinBand"
                vc.thisBandObject = self.thisBand
                
            }
        }
    }
    

}
