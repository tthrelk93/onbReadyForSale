//
//  AppDelegate.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 9/27/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import UserNotifications
import FBSDKCoreKit

//import Firebase

import IQKeyboardManagerSwift
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       // UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        DropDown.startListeningToKeyboard()
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.darkGray
        UIPageControl.appearance().currentPageIndicatorTintColor = ONBPink
        UIPageControl.appearance().backgroundColor = UIColor.black
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
     
        
        if (FBSDKAccessToken.current() != nil) {
            //if you are logged
            print("logged in")
            self.window?.rootViewController?.performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            //if you are not logged
        }
        
        
        
        /*Auth.auth().currentUser?.reauthenticate(with: FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString), completion: {error in
            if error != nil {
                print(error)
                //perform(#selector(handleBack), with: nil, afterDelay: 0)
                self.window?.rootViewController?.performSelector(inBackground: Selector("Logout"), with: nil)
                return
            } else {
*/
        
        /*auth.addStateDidChangeListener { [weak self] (error, user) in
            if let user = user {
                // user is already logged in
                //
              
                 print("alreadyLoggedIn")
                self?.window?.rootViewController?.performSelector(inBackground: Selector("Logout"), with: nil)
                //self?.window?.rootViewController?.performSegue(withIdentifier: "LoginSegue", sender: self)
            } else {
                // user is not logged in
                //self?.window?.rootViewController?.performSelector(inBackground: Selector("Logout"), with: nil)
                print("notLoggedIn")
            }
        }*/

        
            
            
        
        
    
    
        //F
       // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //[[FBSDKApplicationDelegate sharedInstance] application:application
           // didFinishLaunchingWithOptions:launchOptions]
        // Add any custom logic here.
    
    

        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    //Make use of the data object which will contain any data that you send from your application backend, such as the chat ID, in the messenger app example.
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    
    
}

