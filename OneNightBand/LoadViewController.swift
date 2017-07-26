//
//  LoadViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 2/10/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("load")
        self.performSegue(withIdentifier: "LoadToMain", sender: self)
        //segue()

        // Do any additional setup after loading the view.
    }
    //func segue(){
        //self.performSegue(withIdentifier: "LoadToMain", sender: self)
   // }

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
