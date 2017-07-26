//
//  ArtistCardCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 11/23/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
import FirebaseDatabase
//import Firebase
import CoreLocation
import FirebaseAuth


/*protocol LoadProperSessionProtocol {
 func loadThisSession(indexPath: IndexPath)
 }*/

protocol PerformSegueInArtistFinderController {
    func performSegueToProfile(artistUID: String)
    }


class ArtistCardCell: UICollectionViewCell {
    //var delegate: LoadProperSessionProtocol!
    var ref = Database.database().reference()
    var artistUID: String?
    var buttonName: String!
    var invitedBandID: String!
    var bandType: String!
    var artistCount: Int!
    var sessionDate: String!
    var delegate: PerformSegueInArtistFinderController!
    @IBOutlet weak var artistCardCellNameLabel: UILabel!
    @IBOutlet weak var artistCardCellBioTextView: UITextView!
    
    
    @IBOutlet weak var artistCardCellImageView: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var inviteToSession: UIButton!
    var bandName = String()
    @IBOutlet weak var artistCardCellButton: UIButton!
    
    @IBAction func artistCardButtonPressed(_ sender: AnyObject) {
        print(artistUID as Any)
        self.delegate.performSegueToProfile(artistUID: artistUID!)
    }
    @IBAction func invitePressed(_ sender: AnyObject) {
        ref.child("users").child(artistUID!).child("invites").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                    if let dictionary = snap.value as? [String: Any] {
                        if dictionary["bandID"] as! String == self.invitedBandID{
                            //ref.sessions.invitedsessionId.observe{
                            //if invitedSession.sessionartists.contains(artistUID) != true{ carry on
                            let alert = UIAlertController(title: "Whoops!", message: "Artist already has pending invite for this session.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            self.viewController()?.present(alert, animated: true, completion: nil)
                            return
                            
                        }
                        
                        
                    }
                }
            }
            let alert2 = UIAlertController(title: "Success!", message: "Invite Sent.", preferredStyle: UIAlertControllerStyle.alert)
            alert2.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.viewController()?.present(alert2, animated: true, completion: nil)
            
            let recipient = self.ref.child("users").child(self.artistUID!).child("invites")
            let currentUser = Auth.auth().currentUser?.uid
            let tempID = recipient.childByAutoId()
            var values = [String: Any]()
            //values[sessRef] = testArray //as Any?
            values["sender"] = currentUser!
            values["bandID"] = self.invitedBandID
            values["instrumentNeeded"] = self.buttonName
            values["date"] = self.sessionDate
            values["inviteKey"] = String(describing: tempID.key)
            values["bandType"] = self.bandType
            values["artistCount"] = self.artistCount
            //values["bandType"] = self.bandType
            values["bandName"] = self.bandName
            values["inviteResponse"] = String()
            
            
            tempID.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }
            })
        })
        
        
        
        

        
        
        

    }
    
    
    
    var sessionId: String?
    var coordinateUser1: CLLocation?
    var coordinateUser2: CLLocation?
    //var distance: Double?
    
    var tempLong: CLLocationDegrees?
    var tempLat: CLLocationDegrees?
    override func awakeFromNib() {
            }
    
    @IBAction func cellTouched(_ sender: AnyObject) {
        
        
    }
}
