//
//  FindBandsViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 3/29/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth


class FindBandsViewController: UIViewController, UITabBarDelegate {

    @IBAction func searchOneNightBandsPressed(_ sender: Any) {
        self.bandType = "onb"
        performSegue(withIdentifier: "JoinBandToBandBoard", sender: self)
        
    }
    @IBAction func createNewBandPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "JoinBandToCreateBand", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindBandToProfile"{
            if let vc = segue.destination as? profileRedesignViewController{
                vc.artistID = (Auth.auth().currentUser?.uid)!
                vc.userID = (Auth.auth().currentUser?.uid)!
            }
        }
        if segue.identifier == "JoinBandToBandBoard"{
            
            if let vc = segue.destination as? BandBoardViewController{
                
                if self.bandType == "band"{
                    vc.searchType = "Bands"
                } else {
                    vc.searchType = "OneNightBands"
                }
            }
        } else if segue.identifier == "FindBandToFindMusicians"{
            if let vc = segue.destination as? ArtistFinderViewController
            {
                vc.bandID = ""
                vc.thisBandObject = Band()
                vc.bandType = "findband"
                
            }
            
            
        } else if segue.identifier == "JoinBandToCreateBand" {
            if let vc = segue.destination as? MyBandsViewController{
                vc.sender = "joinBand"
                
            }
        }

    }

    @IBOutlet weak var tabBar: UITabBar!
    
    @available(iOS 2.0, *)
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "JoinBandToPFM", sender: self)
        } else if item == tabBar.items?[1]{
            
            
        } else if item == tabBar.items?[2]{
            performSegue(withIdentifier: "FindBandToProfile", sender: self)
        } else {
            performSegue(withIdentifier: "FindBandToFeed", sender: self)
        }
    }

    var bandType = String()
    @IBAction func searchPressed(_ sender: Any) {
        self.bandType = "band"
        performSegue(withIdentifier: "JoinBandToBandBoard", sender: self)
        
        
    }
    let ONBPink = UIColor(colorLiteralRed: 201.0/255.0, green: 38.0/255.0, blue: 92.0/255.0, alpha: 1.0)

    @IBOutlet weak var bandTypePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.tintColor = ONBPink
        tabBar.selectedItem = tabBar.items?[1]
       // bandTypePicker.delegate = self
        //bandTypePicker.dataSource = self

        // Do any additional setup after loading the view.
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
