//
//  SendAuditionViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 4/15/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftOverlays

class SendAuditionViewController: UIViewController, UITextViewDelegate, Dismissable {
    @IBOutlet weak var auditInfoTextView2: UITextView!
    @IBOutlet weak var auditInfoTextView1: UITextView!
    weak var dismissalDelegate : DismissalDelegate?
    var bandID = String()
    var wantedAd = WantedAd()
    let userID = Auth.auth().currentUser?.uid
    @IBAction func auditionButtonPressed(_ sender: Any) {
        if auditInfoTextView1.text == "Tap here to give a little information about why you are auditioning for this band." || auditInfoTextView2.text == "Tap here to give some background on your playing style. (favorite songs, musicial influences, past playing experience, etc...)"{
            let alert = UIAlertController(title: "Whoops!", message: "Missing Information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

                    } else {
            
        print("wantedd \(wantedAd.wantedID)")
        let wantedRef = Database.database().reference().child("wantedAds").child(wantedAd.wantedID)
            wantedRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        print(snap.key)
                    }
                }
            })
        let wantedOwnerRef = Database.database().reference().child("users").child(wantedAd.senderID).child("wantedAdResponses")
        let tempID = wantedRef.child("responses").childByAutoId()
            let id = tempID.key
            print("id: \(id)")
            var snapDict = [String:Any]()
            Database.database().reference().child("wantedAds").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == self.wantedAd.wantedID{

                            let tempDict = snap.value as! [String:Any]
                            if tempDict["responses"] != nil{
                                let responseDict = tempDict["responses"] as! [String:Any]
                                for (key, value) in responseDict{
                                    snapDict[key] = value as! [String:Any]
                                }
                            } else {
                                break
                            }
                            
                        }
                    }
                }
                var values = [String:Any]()
                values["respondingArtist"] = self.userID
                values["infoText1"] = self.auditInfoTextView1.text
                values["infoText2"] = self.auditInfoTextView2.text
                snapDict[id] = values
                var values2 = [String:Any]()
                values2["responses"] = snapDict
                wantedRef.updateChildValues(values2)
                wantedOwnerRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    for snap in snapshots{
                        self.responsesArray.append(snap.value as! String)
                    }
                    if self.responsesArray.contains(self.wantedAd.wantedID) == false{
                        self.responsesArray.append(self.wantedAd.wantedID)
                    }
                    var values3 = [String:Any]()
                    values3["wantedAdResponses"] = self.responsesArray
                    Database.database().reference().child("users").child(self.wantedAd.senderID).updateChildValues(values3)
                })
            })
            
            removeAnimate()
            
            
            }
            
    }
    
    
    var responsesArray = [String]()
    @IBAction func cancelPressed(_ sender: Any) {
        //dismissalDelegate?.finishedShowing()
        removeAnimate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        auditInfoTextView1.delegate = self
        auditInfoTextView2.delegate = self
        auditInfoTextView1.textColor = UIColor.black
        auditInfoTextView2.textColor = UIColor.black
        auditInfoTextView1.text = "Tap here to give a little information about why you are auditioning for this band."
        auditInfoTextView2.text = "Tap here to give some background on your playing style. (favorite songs, musicial influences, past playing experience, etc...)"
        

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.black {
            textView.text = ""
            textView.textColor = ONBPink
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == auditInfoTextView1{
            textView.text = "Tap here to give a little information about why you are auditioning for this band."
            } else {
                textView.text = "Tap here to give some background on your playing style. (favorite songs, musicial influences, past playing experience, etc...)"
            }
            textView.textColor = UIColor.black
        }
    }
     let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
