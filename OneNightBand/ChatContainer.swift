//
//  ChatContainer.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 6/8/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class ChatContainer: UIViewController {
    var name = String()
    var sessionID = String()
    var userID = String()
    var bandType = String()
    

    @IBAction func backPressed(_ sender: Any) {
        if self.bandType == "onb"{
            performSegue(withIdentifier: "ChatToONB", sender: self)
        } else {
            performSegue(withIdentifier: "ChatToBand", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // (chatViewContainer.viewController() as! ChatViewController).senderName = self.name
      // (chatViewContainer.viewController() as! ChatViewController).thisSessionID = self.sessionID
        //(chatViewContainer.viewController() as! ChatViewController).senderId = userID
       // (chatViewContainer.viewController() as! ChatViewController).senderView = self.bandType

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var chatViewContainer: UIView!

    
    // MARK: - Navigation
    var sender = String()

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       // if (segue.identid)
        if (segue.identifier! as String) == "EmbeddedChat"{
            if let vc = segue.destination as? ChatViewController{
                vc.senderDisplayName = self.name
                vc.thisSessionID = self.sessionID
                vc.senderName = userID
                vc.senderView = self.bandType
                
            }
        }
        if (segue.identifier! as String) == "ChatToBand"{
            if let vc = segue.destination as? SessionMakerViewController{
                vc.sessionID = self.sessionID
                vc.sender = self.sender
                
            }
        }
        if (segue.identifier! as String) == "ChatToONB"{
            if let vc = segue.destination as? OneNightBandViewController{
                vc.onbID = self.sessionID
                vc.sender = self.sender
            }
        }

    }
    

}
