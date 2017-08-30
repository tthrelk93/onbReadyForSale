//
//  CreateAccountViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 9/29/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

//import Firebase
import CoreLocation
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

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate, FBSDKLoginButtonDelegate{
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
                
               // self.ONBLabel.isHidden = true
                //artistAllInfoView.isHidden = false
                //self.inputsContainerView.isHidden = false
             //   self.profileImageView.isHidden = false
              //  self.profileImageViewButton.isHidden = false
              //  self.loginRegisterSegmentedControl.isHidden = false
              /*  self.loginRegisterButton.isHidden = false
                self.createAccountLabel.isHidden = true
                self.createAccountLabelForLoginSegment.isHidden = true
                self.onbLogo.isHidden = true
              //  self.onbNameLogo.isHidden = false
                self.smallerONBLogo.isHidden = true*/

            }
        
    }


    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 0.9)

    //add skip UIbutton to skip past account login and creation
    
    let createAccountLabel: UILabel = {
        let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 0.9)
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
    var continueWithEPRect: CGRect?
    
    
    @IBAction func facebookRectPressed(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err?.localizedDescription)
                return
            
            } else if (result?.isCancelled)! {
                // Handle cancellations
            } else {
            
            //let user = Auth.auth().currentUser
            SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if let error = error {
                    print("erororororor")
                    print(error)
                    
                    return
                }
                self.user1 = user!
                
                
                Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        var userInDatabase = false
                        for snap in snapshots{
                            let snapDict = snap.value as! [String:Any]
                            if (snapDict["email"] as! String) == user?.email{
                                userInDatabase = true
                                self.fbLoginVerified(user: self.user1!)
                            }
                        }
                        if userInDatabase == false{
                            self.fbCreateAccountVerified(user: self.user1!)
                        }
                    }
                })
            })
            }
        }

    }
    @IBOutlet weak var loginRegisterButton: UIButton!
   
    @IBAction func loginRegisterPressed(_ sender: Any) {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            
            handleLogin()
        }
        else{
            
            handleRegister()
        }

    }
    @IBAction func continueWithEPPressed(_ sender: Any) {
        if continueWithEP.titleLabel?.text == "Continue with Email and Password"{
            
            orLabel.isHidden = true
            
        facebookRect.isHidden = true
        continueWithEP.frame = backButtonFrame.frame
        continueWithEP.frame.origin = backButtonFrame.frame.origin
        continueWithEP.setTitle("Back", for: .normal)
           // loginRegisterButton.frame = loginRegFrame.frame
           // loginRegisterButton.frame.origin = loginRegFrame.frame.origin
            forgotEmailOrPasswordButton.isHidden = false
            inputsContainerView.isHidden = false
            loginRegisterSegmentedControl.isHidden = false
            loginRegisterButton.isHidden = false
           // createAccountLabel.isHidden = false
           // createAccountLabelForLoginSegment.isHidden = false
            if loginRegisterSegmentedControl.selectedSegmentIndex == 1{
                smallerONBLogo.isHidden = true
                profileImageViewButton.isHidden = false
                profileImageView.isHidden = false
            } else {
                smallerONBLogo.isHidden = false
                profileImageViewButton.isHidden = true
                profileImageView.isHidden = true
            }
            
        } else {
            orLabel.isHidden = false
            facebookRect.isHidden = false
            continueWithEP.frame = continueWithEPRect!
            continueWithEP.frame.origin = continueWithEPRect!.origin
            continueWithEP.setTitle("Continue with Email and Password", for: .normal)
            smallerONBLogo.isHidden = false
            inputsContainerView.isHidden = true
            loginRegisterSegmentedControl.isHidden = true
            loginRegisterButton.isHidden = true
            createAccountLabel.isHidden = true
            createAccountLabelForLoginSegment.isHidden = true
            forgotEmailOrPasswordButton.isHidden = true
            profileImageViewButton.isHidden = true
            profileImageView.isHidden = true

        }
    
        
        
        
    }
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var continueWithEP: UIButton!
        func setupCreateAccountLabel(){
        createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountLabel.bottomAnchor.constraint(equalTo: profileImageViewButton.topAnchor, constant: -200).isActive = true
        //createAccountLabel.leadingAnchor.constraint(equalTo: view.rightAnchor, constant: 25)
        //createAccountLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //createAccountLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    let createAccountLabelForLoginSegment: UILabel = {
        let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 0.9)
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
    
    @IBAction func recoverPasswordPressed(_ sender: Any) {
        if recoveryEmailField.text?.contains("@") == false{
            let alert = UIAlertController(title: "Missing Field.", message: "Please fill in the recovery email field.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return

        } else {
        Auth.auth().sendPasswordReset(withEmail: recoveryEmailField.text!, completion: {error in
            let alert = UIAlertController(title: "Recovery password sent.", message: "Check your email for recovery password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.recoveryEmailField.text = ""
            self.recoveryEmailField.placeholderText = "Enter Recovery Email"
            self.recoverInfoView.isHidden = true
            return
        })
        }

    }
    
    func Logout(){
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    @IBOutlet weak var recoveryEmailField: UITextField!
    @IBAction func recoveryBackButtonPressed(_ sender: Any) {
        recoverInfoView.isHidden = true
    }
    @IBOutlet weak var recoverInfoView: UIView!
    let passwordTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    func forgotInfoPressed(){
        recoverInfoView.isHidden = false
           }

   

    @IBOutlet weak var backButtonFrame: UIView!
    
    
    let forgotEmailOrPasswordButton: UIButton = {
        let ONBPink = UIColor(red: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        
        //let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        let button = UIButton()
        button.alpha = 0.9
        
        button.isHidden = true
        button.setTitleColor(ONBPink, for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        button.setTitle("Forgot Password", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotInfoPressed), for: .touchUpInside)
        return button
        
    }()
    func setupForgotEmailOrPassword(){
        
        forgotEmailOrPasswordButton.isHidden = true
        forgotEmailOrPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotEmailOrPasswordButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 5).isActive = true
    }
   /* let facebookLoginButton: UIButton = {
        let customFBButton = UIButton(type: .system)
        customFBButton.backgroundColor = UIColor(colorLiteralRed: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        //customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBButton.setTitle("Continue with Facebook", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBButton.setTitleColor(.white, for: .normal)
        //view.addSubview(customFBButton)
        
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        customFBButton.translatesAutoresizingMaskIntoConstraints = false
       // button.addTarget(self, action: #selector(facebookLoginPressed), for: .touchUpInside)

    
        return customFBButton
    }()*/
    var user1: User?
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err)
                return
            }
            //let user = Auth.auth().currentUser
            
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if let error = error {
                    print("erororororor")
                    print(error)
                   
                    return
                }
                self.user1 = user!
                
            Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    var userInDatabase = false
                    for snap in snapshots{
                        let snapDict = snap.value as! [String:Any]
                       if (snapDict["email"] as! String) == user?.email{
                            userInDatabase = true
                            self.fbLoginVerified(user: self.user1!)
                        }
                    }
                    if userInDatabase == false{
                         self.fbCreateAccountVerified(user: self.user1!)
                    }
                }
            })
        })
        }
        
    }
    func fbCreateAccountVerified(user: User){
        
            print("create")
            var values = Dictionary<String, Any>()
            values["artistsBands"] = [String]()
            values["artistsONBs"] = [String]()
            
            values["name"] = user.displayName
            values["email"] = user.email
            values["instruments"] = ""
            values["password"] = ""
            values["invites"] = [String:Any]()
            
            values["artistUID"] = user.uid
            values["bio"] = ""
            values["profileImageUrl"] = [""]
            
            values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
            values["media"] = [String:Any]()
            values["wantedAdResponses"] = [String]()
            values["wantedAds"] = [String]()
            values["acceptedAudits"] = [String:Any]()
            self.user = (user.uid)
            self.account = values
            self.loginWithFacebook = true
        
            self.performSegue(withIdentifier: "AboutONBSegue", sender: self)
        
    }
    

        func fbLoginVerified(user: User){
            self.user = (user.uid)
            
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
            //print("Successfully logged in with our user: ", user ?? "")
       
       
    }
    
    @IBOutlet weak var facebookRect: UIButton!
    func setupFacebookLoginButton(){
        facebookRect.layer.cornerRadius = 10
        
       //facebookLoginButton.frame = continueWithEP.frame
        /*facebookLoginButton.frame.origin = continueWithEP.frame.origin
        //facebookLoginButton.delegate = self
        //facebookLoginButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32).isActive = true
        //facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 12).isActive = true*/
        
    }
    
    func facebookLoginPressed(){
        
        print("helllooooooooo")
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: {(result, error) in
            
            // If there is no error logging into facebook, get the accessToken string
            if error != nil {
                print("Facebook login failed with error: \(error)")
            } else {
               // var token = FBSDKAccessToken.current()
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true, completion: {(idToken, error) in
                    
                 // getTokenForcingRefresh(true) {idToken, error in
                    if let error = error {
                        // Handle error
                        return;
                    }
                    print("Successfully logged into Facebook with accessToken: \(idToken)")
                    
                    // Authenticate the facebook user to access the firebase app data
                    Auth.auth().signIn(withCustomToken: (idToken)!, completion: { (authData, error) in
                        
                        // if therer is no error logging into Firebase, save the Authetication Data to NSUserDefaults with the key 'uid'
                        if error != nil {
                            print("Login failed with error: \(error)")
                        } else {
                            print("Successful login with AuthData: \(authData)")
                            self.user = (Auth.auth().currentUser?.uid)!
                            // UserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            UserDefaults.standard.setValue(authData?.uid, forKey: "uid")
                            
                            // Segue to the next view
                            self.performSegue(withIdentifier: "LoginSegue", sender: self)
                            
                        }
                    })
                })
            }
        
        })

    }
   /* lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = self.ONBPink
        button.alpha = 0.9
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight) //boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()*/
    func setupLoginRegisterButton(){
        loginRegisterButton.layer.cornerRadius = 10
        /*loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: forgotEmailOrPasswordButton.bottomAnchor, constant:20).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: loginRegisterSegmentedControl.widthAnchor, multiplier: 1/3 ).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true*/
    }
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    func setupLoginRegisterSegmentedControl(){
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.tintColor = self.ONBPink
        loginRegisterSegmentedControl.alpha = 0.9
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
        forgotEmailOrPasswordButton.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? false : true
        self.smallerONBLogo.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? false : true
        //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        //facebookLoginButton.setTitle(loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "Login" : "Register", for: .normal)
        
        
        //making name disapear when segment control is in login mode
        if(loginRegisterSegmentedControl.selectedSegmentIndex == 1){
            //self.smallerONBLogo.isHidden = true
            picker.delegate = self
            //facebookLoginButton.setTitle("Continue with Facebook", for: .normal)
            createAccountLabel.isHidden = false
            createAccountLabelForLoginSegment.isHidden = true
            nameTextField.placeholder = "Name"
            profileImageView.isHidden = false
            profileImageViewButton.isHidden = false
            profileImageViewButton.isEnabled = true
            
            
        }
        else{
           // facebookLoginButton.setTitle("Continue with Facebook", for: .normal)
            //self.smallerONBLogo.isHidden = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        forgotEmailOrPasswordButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("hrllo")
        if (segue.identifier! as String) == "AboutONBSegue"{
            //print("AboutONBSegue")
            if let vc = segue.destination as? TutorialViewController{
                vc.account = self.account
                vc.user = self.user
                if loginWithFacebook == true{
                    vc.loginWithFacebook = true
                }
            }
            
        }
        if (segue.identifier! as String) == "LoginSegue"{
            if let vc = segue.destination as? profileRedesignViewController{
                print("artistID: \((Auth.auth().currentUser?.uid)!)")
                vc.artistID = (Auth.auth().currentUser?.uid)!
                vc.userID = (Auth.auth().currentUser?.uid)!
            }
        }
    }
    var loginWithFacebook = Bool()
    
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
                print("error: \(error as! Any)")
                if error?.localizedDescription == "The email address is already in use by another account."{
                    let alert = UIAlertController(title: "Email In Use.", message: "An account already exists under this email.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                

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
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
       /* print("hello")
        
        //print("providers: \(Auth.fetchProviders(Auth.auth()))")
        
        if let error = error {
            print(error.localizedDescription)
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            return
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            
           /* Auth.auth().createUser(withEmail: (Auth.auth().currentUser?.email)!, password: Auth.auth().currentUser?.) {
                (user, error) in
                if (error) {
                    //if error != nil
                    // If error type is `FIRAuthErrorCodeEmailAlreadyInUse`
                    // Email is already in use.
                } else {
                    // Create new user successfully
                }
            }
*/
            
        
            
            //print(Auth.auth().currentUser?.providerID)
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
             if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
                print("supp")
            //Auth.auth().currentUser?.reauthenticate(with: credential) { error in
               /* print("in reauth")
                if error != nil {
                    print("error, no account created")
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    let alert = UIAlertController(title: "Login Failed", message: "You do not have an account set up with OneNightBand. Please press the back button and select Create Account.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    
                   /* Auth.auth().createUser(withEmail: Auth.auth().currentUser?.email , password: "") {
                        (user, error) in
                        if (error) {
                            //if error != nil
                            // If error type is `FIRAuthErrorCodeEmailAlreadyInUse`
                            // Email is already in use.
                        } else {
                            // Create new user successfully
                        }
                    }*/

                    */
                    
                    Auth.auth().signIn(with: credential) { (user, error1) in
                        user?.reauthenticate(with: credential) { error in
                             print("in reauth")
                             if error != nil {
                                 print("error, no account created")
                                 let loginManager = FBSDKLoginManager()
                                 loginManager.logOut()
                                 let alert = UIAlertController(title: "Login Failed", message: "You do not have an account set up with OneNightBand. Please press the back button and select Create Account.", preferredStyle: UIAlertControllerStyle.alert)
                                 alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                                 self.present(alert, animated: true, completion: nil)
                                 return
                            }
                             else {
                                print("no error")
                            }
                        }
                                if error1 != nil {
                                print("error: \(error?.localizedDescription)")
                                if error?.localizedDescription == "auth/user-not-found"{
                                    print("error, no account created")
                                    let loginManager = FBSDKLoginManager()
                                    loginManager.logOut()
                                    let alert = UIAlertController(title: "Login Failed", message: "You do not have an account set up with OneNightBand. Please press the back button and select Create Account.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    return

                                }
                                if error?.localizedDescription == "auth/account-exists-with-different-credential"{
                                    user?.link(with: credential, completion: { (user, error) in
                                        if error != nil{
                                            print(error?.localizedDescription)
                                            return
                                        }
                                        print("login")
                                        self.user = (user?.uid)!
                                        
                                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                                    })
                                    
                                }
                                return
                            } else {
                                print("login")
                                self.user = (user?.uid)!
                            
                                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                        }
                
                
                }
            
             } else {
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print(error)
                        return
                    }

                print("create")
                var values = Dictionary<String, Any>()
                values["artistsBands"] = [String]()
                values["artistsONBs"] = [String]()
                
                values["name"] = user?.displayName
                values["email"] = user?.email
                values["instruments"] = ""
                values["password"] = ""
                values["invites"] = [String:Any]()
                
                values["artistUID"] = user?.uid
                values["bio"] = ""
                values["profileImageUrl"] = [""]
                
                values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                values["media"] = [String:Any]()
                values["wantedAdResponses"] = [String]()
                values["wantedAds"] = [String]()
                values["acceptedAudits"] = [String:Any]()
                self.user = (user?.uid)!
                self.account = values
                    self.loginWithFacebook = true
                self.performSegue(withIdentifier: "AboutONBSegue", sender: self)
                }
            }
        }
 */
    }
    
    
    
     //let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var ONBLabel: UILabel!
    let locationManager = CLLocationManager()
    var orRect: CGRect?
    override func viewDidLoad() {
                super.viewDidLoad()
        forgotEmailOrPasswordButton.isHidden = true
        self.continueWithEPRect = continueWithEP.frame
        continueWithEP.layer.cornerRadius = 10
        
        //let loginManager = FBSDKLoginManager()
       // loginManager.logOut()
        //backButton.isHidden = true
        self.orRect = orLabel.frame
        smallerONBLogo.isHidden = true
        view.addSubview(profileImageView)
        view.addSubview(profileImageViewButton)
        view.addSubview(forgotEmailOrPasswordButton)
        view.addSubview(loginRegisterSegmentedControl)
        //view.addSubview(facebookLoginButton)
        //view.addSubview(loginRegisterButton)
        view.addSubview(createAccountLabel)
        view.addSubview(createAccountLabelForLoginSegment)
        
        
        view.addSubview(inputsContainerView)
        
        facebookRect.isHidden = false
        inputsContainerView.isHidden = true
        loginRegisterSegmentedControl.isHidden = true
        loginRegisterButton.isHidden = true
        createAccountLabel.isHidden = true
        createAccountLabelForLoginSegment.isHidden = true
        
        profileImageViewButton.isHidden = true
        profileImageView.isHidden = true
        
        setupProfileImageViewButton()
        setupProfileImageView()
         setupForgotEmailOrPassword()
        setupCreateAccountLabel()
        
        setupLoginRegisterSegmentedControl()
        setupLoginRegisterButton()
        setupCreateAccountLabelForLoginSegment()
       
        setupFacebookLoginButton()
        setupInputsContainerView()
        createAccountLabelForLoginSegment.isHidden = true
        profileImageView.isHidden = false
        handleLoginRegisterChange()
        view.bringSubview(toFront: recoverInfoView)
       /*facebookLoginButton.delegate = self
        //facebookLoginButton.delegate = self
        facebookLoginButton.center = self.view.center
        //facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]*/
        
       
        
        //let login = FBSDKLoginManager()
        /*login.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: (FBSDKLoginManagerLoginResult result, NSError error)
            if (error) {
                NSLog("Process error");
            } else if (result.isCancelled) {
                NSLog("Cancelled");
            } else {
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                if user does not already have an account than do instrument selection and then the following code
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        // ...
                        return
                    }
                    // User is signed in
                    // ...
                }
                else just do the above Auth code*/
            
                
                
                /*
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
 */
    
        //facebookLoginButton.delegate.result
        //facebookLoginButton.delegate.loginButton(facebookLoginButton, didCompleteWith: FBSDKLoginManagerLoginResult, error: nil)
        
        
        
        
        
        
        //picker.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        /* if (FBSDKAccessToken.current() != nil) {
            self.user = (Auth.auth().currentUser?.uid)! //(user?.uid)!
            //self.account = values
            print("duh")
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            view.addSubview(profileImageView)
            view.addSubview(profileImageViewButton)
            view.addSubview(inputsContainerView)
            view.addSubview(loginRegisterSegmentedControl)
            view.addSubview(loginRegisterButton)
            view.addSubview(createAccountLabel)
            view.addSubview(createAccountLabelForLoginSegment)
            view.addSubview(facebookLoginButton)
            facebookLoginButton.isHidden = false
            inputsContainerView.isHidden = true
            loginRegisterSegmentedControl.isHidden = false
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
            setupFacebookLoginButton()
            createAccountLabelForLoginSegment.isHidden = true
            profileImageView.isHidden = true
            //setupProfileImageView()
            
       
            //background image blur effect
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark)) as UIVisualEffectView
            //visualEffectView.frame = CreateAccountBackground.bounds
            visualEffectView.alpha = 0.5
            //CreateAccountBackground.addSubview(visualEffectView)
        }*/
        
        
        }
    var tempDict = [String: Any]()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        var locDict = ["lat" : locValue.latitude, "long": locValue.longitude]
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //var ref = Database.database().reference.child("users").child(Auth.auth().currentUser.uid).child("location")
        //ref.updateChildValues(locDict)
    }

    //var locationManager = CLLocationManager()
    
   
    
}
