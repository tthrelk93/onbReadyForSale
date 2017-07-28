//
//  createSessionPopup.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/15/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SwiftOverlays

//import Firebase

class CreateSessionPopup: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, Dismissable{
    
    weak var dismissalDelegate: DismissalDelegate?
    var ref = Database.database().reference()
    
    lazy var sessionImageViewButton: UIButton = {
        var tempButton = UIButton()
        //tempButton.setBackgroundImage(UIImage(named: "icon-profile"), for: .normal)
        /*tempButton.contentMode = .scaleAspectFill
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.isEnabled = true*/
        tempButton.layer.borderWidth = 2
        tempButton.layer.borderColor = UIColor.darkGray.cgColor
        tempButton.backgroundColor = UIColor.clear
        tempButton.setTitle("Select\n Session\n Image", for: .normal)
        tempButton.titleLabel?.numberOfLines = 3
        tempButton.titleLabel?.textAlignment = NSTextAlignment.center
        tempButton.titleLabel?.lineBreakMode = .byWordWrapping
        tempButton.setTitleColor(UIColor.gray, for: .normal)
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
            sessionImageViewButton.bottomAnchor.constraint(equalTo: sessionNameTextField.topAnchor).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 125).isActive = true
            
        case 375:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: sessionNameTextField.topAnchor).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
        case 414:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: sessionNameTextField.topAnchor).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            
        default:
            sessionImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            sessionImageViewButton.bottomAnchor.constraint(equalTo: sessionNameTextField.topAnchor).isActive = true
            sessionImageViewButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sessionImageViewButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            
        }
        
    }
    var bandObject: Band?
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "CreateSessionToSessionMaker"{
            if let vc = segue.destination as? SessionMakerViewController
            {
                vc.sessionID = bandID
                
                
            }
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

    
    var sessionPics = [String]()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finalizeSessionButton: UIButton!
    @IBOutlet weak var sessionBioTextView: UITextView!
    @IBOutlet weak var sessionNameTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        
        self.finalizeSessionButton.isEnabled = true
        popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        popupView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        sessionBioTextView.layer.borderColor = UIColor.darkGray.cgColor
        sessionBioTextView.layer.borderWidth = 2
        sessionBioTextView.layer.masksToBounds = false
        view.addSubview(sessionImageView)
        view.addSubview(sessionImageViewButton)
        setupSessionImageView()
        setupSessionImageViewButton()
        //backgroundView.backgroundColor = UIColor.black
        //backgroundView.alpha = 0.7
        sessionBioTextView.delegate = self
        self.view.backgroundColor = UIColor.clear
        //self.view.backgroundColor?.withAlphaComponent(0.8)
        sessionBioTextView.textColor = UIColor.white
        sessionBioTextView.text = "tap to add a little info about the session you are creating (Songs played, location, etc...)."
        self.showAnimate()
        picker.delegate = self
        
        //*******************************
        //****************create ref to users active sessions and copy them all to array. Then append the new session and update the database value
        //*********************************
            
    }
    var bandID: String?
    
    /*public func textViewDidBeginEditing(_ textView: UITextView){
        
    }
    
    
    optional public func textViewDidEndEditing(_ textView: UITextView){
        
    }*/
      let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if sessionBioTextView.textColor == UIColor.white {
            sessionBioTextView.text = nil
            sessionBioTextView.textColor = ONBPink
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if sessionBioTextView.text.isEmpty {
            sessionBioTextView.text = "tap to add a little info about the session you are creating (Songs played, location, etc...)."
            sessionBioTextView.textColor = UIColor.white
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

    @IBAction func cancelTouched(_ sender: AnyObject) {
        dismissalDelegate?.finishedShowing()
        removeAnimate()
    }
    //let newSess = Session()
    var tempArray = [String]()
    @IBAction func finalizeTouched(_ sender: AnyObject) {
        if(sessionImageView.image != nil && sessionNameTextField.text != "" && sessionBioTextView.text != "tap to add a little info about the session you are creating (Songs played, location, etc...)."){
            SwiftOverlays.showBlockingWaitOverlayWithText("Session may take minute to appear")
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("session_images").child("\(imageName).jpg")
            
            if let sessionImage = self.sessionImageView.image, let uploadData = UIImageJPEGRepresentation(sessionImage, 0.1) {
                //storageRef.putData(uploadData)
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    //let tempURL = URL.init(fileURLWithPath: "temp")
                    
                    if let sessionImageUrl = metadata?.downloadURL()?.absoluteString {
                        self.sessionPics.append(sessionImageUrl)
                        
                        var tempArray2 = [String]()
                        var values = Dictionary<String, Any>()
                        tempArray2.append((Auth.auth().currentUser?.uid)! as String)
                        values["sessionName"] =  self.sessionNameTextField.text
                        values["sessionArtists"] = [(Auth.auth().currentUser?.uid)!:"Session Founder"]
                        values["sessionBio"] = self.sessionBioTextView.text
                        values["sessionPictureURL"] = self.sessionPics
                        values["sessionMedia"] = [String]()
                        values["messages"] = [String: Any]()
                        values["views"] = 0
                        values["bandID"] = self.bandID
                        values["sessFeedMedia"] = [String]()
                        values["mp3URLs"] = [String]()
                        values["mp3StorageNames"] = [String]()
                        
                        
                        
                        let dateformatter = DateFormatter()
                        
                        dateformatter.dateStyle = DateFormatter.Style.short
                        
                        //dateformatter.timeStyle = DateFormatter.Style.short
                        
                        let now = dateformatter.string(from: self.datePicker.date)
                        values["sessionDate"] = now
                        
                        
                        let ref = Database.database().reference()
                        let sessReference = ref.child("sessions").childByAutoId()
                        
                        let sessReferenceAnyObject = sessReference.key
                        values["sessionUID"] = sessReferenceAnyObject
                        
                        //self.newSess.setValuesForKeys(values)

                        
                        self.tempArray.append(sessReferenceAnyObject)
                        //print(sessReference.key)
                        //sessReference.childByAutoId()
                        sessReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err as Any)
                                return
                            }
                        })
                        let user = Auth.auth().currentUser?.uid
                        //var sessionVals = Dictionary
                        //let userSessRef = ref.child("users").child(user).child("activeSessions")
                        self.ref.child("bands").child(self.bandID!).child("bandSessions").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    self.tempArray.append(snap.value! as! String)
                                }
                            }
                            
                            ///add newest session to bandSessions
                            
                            var tempDict = [String : Any]()
                            tempDict["bandSessions"] = self.tempArray
                            let bandRef = ref.child("bands").child(self.bandID!)
                            bandRef.updateChildValues(tempDict, withCompletionBlock: {(err, ref) in
                                if err != nil {
                                    print(err as Any)
                                    return
                                }
                            })
                            self.finalizeSessionButton.isEnabled = true
                            self.dismissalDelegate?.finishedShowing()
                            self.removeAnimate()
                            //this is ridiculously stupid way to reload currentSession data. find someway to fix
                            //self.performSegue(withIdentifier: "FinalizeSessionToProfile", sender: self)
                            //self.performSegue(withIdentifier: "CreateSessionToSessionMaker", sender: self)
                        })
                    }
                })
            }

            
        }else{
            self.finalizeSessionButton.isEnabled = true
            let alert = UIAlertController(title: "Error", message: "Missing Information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        //self.navigationItem.hidesBackButton = true
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
    
       


    
}
