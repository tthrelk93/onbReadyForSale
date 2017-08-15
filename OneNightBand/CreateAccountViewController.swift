//
//  CreateAccountViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 9/29/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

//import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Foundation
import UIKit
import QuartzCore
import CoreLocation
import SwiftOverlays
import FBSDKCoreKit
import FBSDKLoginKit

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var smallerONBLogo: UIImageView!
    
    //@IBOutlet weak var shadeView: UIView!
   // @IBOutlet weak var triangleBackground: UIImageView!
   // @IBOutlet weak var onbNameLogo: UIImageView!
    @IBOutlet weak var onbLogo: UIImageView!
  //  @IBOutlet weak var CreateAccountBackground: UIImageView!
    var rotateCount = 0
    private func rotateView(targetView: UIView, duration: Double = 3.0) {
       // if rotateCount == 4 {
        
       // } else {
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
            }) { finished in
                //performSegue(withIdentifier: "LaunchToScreen1", sender: self)
                
                self.ONBLabel.isHidden = true
                //artistAllInfoView.isHidden = false
                self.inputsContainerView.isHidden = false
                self.profileImageView.isHidden = false
                self.profileImageViewButton.isHidden = false
                self.loginRegisterSegmentedControl.isHidden = false
                self.loginRegisterButton.isHidden = false
                self.createAccountLabel.isHidden = true
                self.createAccountLabelForLoginSegment.isHidden = true
                self.onbLogo.isHidden = true
              //  self.onbNameLogo.isHidden = false
                self.smallerONBLogo.isHidden = true

            }
        
    }


    

    //add skip UIbutton to skip past account login and creation
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    let createAccountLabel: UILabel = {
        let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        switch UIScreen.main.bounds.width{
        case 320:
            var tempLabel = UILabel()
            tempLabel.text = "OneNightBand"
            tempLabel.font = UIFont.systemFont(ofSize: 45.0, weight: UIFontWeightThin)
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.textColor = ONBPink
            tempLabel.numberOfLines = 1
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
            return tempLabel
            
        case 375:
            var tempLabel = UILabel()
            tempLabel.text = "OneNightBand"
            tempLabel.font = UIFont.systemFont(ofSize: 50.0, weight: UIFontWeightThin)
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.textColor = ONBPink
            tempLabel.numberOfLines = 1
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
             return tempLabel
            
        case 414:
            var tempLabel = UILabel()
            tempLabel.text = "OneNightBand"
            tempLabel.font = UIFont.systemFont(ofSize: 55.0, weight: UIFontWeightThin)
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.textColor = ONBPink
            tempLabel.numberOfLines = 1
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
             return tempLabel
            
            
        default:
            var tempLabel = UILabel()
            tempLabel.text = "OneNightBand"
            tempLabel.font = UIFont.systemFont(ofSize: 55.0, weight: UIFontWeightThin)
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.textColor = ONBPink
            tempLabel.numberOfLines = 1
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
            return tempLabel
           
            
            
            
        }
        
        
       
    }()
        func setupCreateAccountLabel(){
        createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountLabel.bottomAnchor.constraint(equalTo: profileImageViewButton.topAnchor, constant: -200).isActive = true
        //createAccountLabel.leadingAnchor.constraint(equalTo: view.rightAnchor, constant: 25)
        //createAccountLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //createAccountLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    let createAccountLabelForLoginSegment: UILabel = {
        let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        var tempLabel = UILabel()
        tempLabel.text = "OneNightBand"
        tempLabel.font = UIFont.systemFont(ofSize: 50.0, weight: UIFontWeightThin)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.textColor = ONBPink
        tempLabel.numberOfLines = 2
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return tempLabel
    }()

    func setupCreateAccountLabelForLoginSegment(){
        createAccountLabelForLoginSegment.centerXAnchor.constraint(equalTo: profileImageViewButton.centerXAnchor).isActive = true
        createAccountLabelForLoginSegment.bottomAnchor.constraint(equalTo: profileImageViewButton.bottomAnchor, constant: -70).isActive = true
        createAccountLabelForLoginSegment.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        createAccountLabelForLoginSegment.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }


    
    lazy var profileImageViewButton: UIButton = {
        var tempButton = UIButton()
        //tempButton.setBackgroundImage(UIImage(named: "icon-profile"), for: .normal)
        tempButton.layer.borderWidth = 2
        tempButton.layer.borderColor = UIColor.white.cgColor
        tempButton.backgroundColor = UIColor.clear
        tempButton.setTitle("Select\n Profile\n Image", for: .normal)
        tempButton.titleLabel?.numberOfLines = 3
        tempButton.titleLabel?.textAlignment = NSTextAlignment.center
        tempButton.titleLabel?.lineBreakMode = .byWordWrapping
        tempButton.setTitleColor(UIColor.white, for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: UIFontWeightLight)
        tempButton.layer.cornerRadius = 10
        tempButton.clipsToBounds = true
        tempButton.contentMode = .scaleAspectFill
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.isEnabled = true
        tempButton.alpha = 0.6
        tempButton.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
        
        
        return tempButton
        
    }()
    func setupProfileImageViewButton(){
        profileImageViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageViewButton.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -50).isActive = true
        profileImageViewButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageViewButton.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    let picker = UIImagePickerController()
    func handleSelectProfileImageView() {
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }

    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "icon-profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }

    
    
    let inputsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
        
    }()
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView(){
        
        //adding subviews
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //inputsContainerView x, y, width, height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        //nameTextField x, y, width, height
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //name separator line x, y, width, height
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //emailTextField x, y, width, height
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //email separator line x, y, width, height
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        //passwordTextField x, y, width, height
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(self.ONBPink, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant:12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    func setupLoginRegisterSegmentedControl(){
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.tintColor = self.ONBPink
        loginRegisterSegmentedControl.alpha = 0.7
        loginRegisterSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.normal)
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
    }
   
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of inputsContainerView 
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        //making name disapear when segment control is in login mode
        if(loginRegisterSegmentedControl.selectedSegmentIndex == 1){
            self.smallerONBLogo.isHidden = true
            picker.delegate = self
            createAccountLabel.isHidden = false
            createAccountLabelForLoginSegment.isHidden = true
            nameTextField.placeholder = "Name"
            profileImageView.isHidden = false
            profileImageViewButton.isHidden = false
            profileImageViewButton.isEnabled = true
            
            
        }
        else{
            self.smallerONBLogo.isHidden = false
            createAccountLabel.isHidden = true
            //setupCreateAccountLabelForLoginSegment()
            createAccountLabelForLoginSegment.isHidden = true
            nameTextField.placeholder = ""
            nameTextField.text = ""
            profileImageView.isHidden = true
            profileImageViewButton.isHidden = true
            profileImageViewButton.isEnabled = false
            
                    }

        //change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        

    }
    var user = String()
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile...")
        guard let email = emailTextField.text, let password = passwordTextField.text
            else{
                SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (user: User?, error) in
            
            if error != nil{
                SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            else{
                self.user = (user?.uid)!
                print("Successful Login")
                
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }

        })
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        //SwiftOverlays.removeAllBlockingOverlays()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("hrllo")
        if (segue.identifier! as String) == "AboutONBSegue"{
            //print("AboutONBSegue")
            if let vc = segue.destination as? TutorialViewController{
                vc.account = self.account
                vc.user = self.user
            }
            
        }
        if (segue.identifier! as String) == "LoginSegue"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.artistID = self.user
                vc.userID = self.user
            }
        }
    }
    
    
    func handleRegister(){
        SwiftOverlays.showBlockingWaitOverlayWithText("Creating Account...")
        guard let email = emailTextField.text, let password = passwordTextField.text, let profileImage = profileImageView.image
            else{
                SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information and chose a profile picture.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
        }
      // SwiftOverlays.showBlockingWaitOverlayWithText("Loading Session Feed")
        let name = nameTextField.text
        
       
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                SwiftOverlays.removeAllBlockingOverlays()
                print(error as Any)
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                

                return
            }
            self.user = (user?.uid)!
            guard let uid = user?.uid else{
                
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
                if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    
                    //storageRef.putData(uploadData)
                
                
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                        if error != nil {
                            print(error as Any)
                            return
                        }
                    
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                            var values = Dictionary<String, Any>()
                            values["artistsBands"] = [String]()
                            values["artistsONBs"] = [String]()
                            
                            values["name"] = name
                            values["email"] = email
                            values["instruments"] = ""
                            values["password"] = password
                            values["invites"] = [String:Any]()
                            
                            values["artistUID"] = Auth.auth().currentUser?.uid
                            values["bio"] = ""
                            values["profileImageUrl"] = [profileImageUrl]
                            
                            values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                            values["media"] = [String:Any]()
                            values["wantedAdResponses"] = [String]()
                            values["wantedAds"] = [String]()
                            values["acceptedAudits"] = [String:Any]()
                            
                            self.account = values
                            
                        self.performSegue(withIdentifier: "AboutONBSegue", sender: self)
                            //self.registerUserIntoDatabaseWithUID(uid, values: values as [String : Any])
                            
                            
                        }
                    })
                }
            
            
        })
    }
    var account = [String: Any]()
    
    
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        print("test")
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            profileImageViewButton.setBackgroundImage(selectedImage, for: .normal)
            //profileImageViewButton.set
            profileImageView.image = selectedImage

        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
     //let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var ONBLabel: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
                super.viewDidLoad()
        
        //
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.center = self.view.center
        
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        
        
        picker.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        //rotateView(targetView: CreateAccountBackground)
        //var timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: Selector(("updateCounter")), userInfo: nil, repeats: true)
        
       /* while timer.timeInterval < 10.0{
            print
        }*/
        
        ONBLabel.isHidden = false
        DispatchQueue.main.async {
            sleep(4)
            
           // self.triangleBackground.isHidden = false
           // self.shadeView.isHidden = false
            self.ONBLabel.isHidden = true
            //artistAllInfoView.isHidden = false
            self.inputsContainerView.isHidden = false
            self.profileImageView.isHidden = false
            self.profileImageViewButton.isHidden = false
            self.loginRegisterSegmentedControl.isHidden = false
            self.loginRegisterButton.isHidden = false
            self.createAccountLabel.isHidden = true
            self.createAccountLabelForLoginSegment.isHidden = true
            self.onbLogo.isHidden = true
           // self.onbNameLogo.isHidden = false
            self.smallerONBLogo.isHidden = true

        }
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        } else {
            view.addSubview(profileImageView)
            view.addSubview(profileImageViewButton)
            view.addSubview(inputsContainerView)
            view.addSubview(loginRegisterSegmentedControl)
            view.addSubview(loginRegisterButton)
            view.addSubview(createAccountLabel)
            view.addSubview(createAccountLabelForLoginSegment)
            inputsContainerView.isHidden = true
            loginRegisterSegmentedControl.isHidden = true
            loginRegisterButton.isHidden = true
            createAccountLabel.isHidden = true
            createAccountLabelForLoginSegment.isHidden = true
           
            profileImageViewButton.isHidden = true
            
            setupProfileImageViewButton()
            setupProfileImageView()
            setupCreateAccountLabel()
            setupInputsContainerView()
            setupLoginRegisterSegmentedControl()
            setupLoginRegisterButton()
            setupCreateAccountLabelForLoginSegment()
            createAccountLabelForLoginSegment.isHidden = true
            profileImageView.isHidden = true
            //setupProfileImageView()
            
       
            //background image blur effect
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark)) as UIVisualEffectView
            //visualEffectView.frame = CreateAccountBackground.bounds
            visualEffectView.alpha = 0.5
            //CreateAccountBackground.addSubview(visualEffectView)
        }
        
        
    }
    var tempDict = [String: Any]()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //tempDict = ["lat":locValue.latitude, "long": locValue.longitude]
        
        
    }
  }
