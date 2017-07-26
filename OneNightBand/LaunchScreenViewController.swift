//
//  LaunchScreenViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 5/23/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    var rotateCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.animationImages = [UIImage(named: "Background-Design-Blue-Texture-Triangles-Polygon-1761175.jpg")!,UIImage(named:"Background-Design-Blue-Texture-Triangles-Polygon-1761175 2.jpg")!,UIImage(named:"Background-Design-Blue-Texture-Triangles-Polygon-1761175 3.jpg")!, UIImage(named:"Background-Design-Blue-Texture-Triangles-Polygon-1761175 4.jpg")!]
        backgroundImageView.animationDuration = 2
        backgroundImageView.animationRepeatCount = 100
        //backgroundImageView.startAnimating()
        
        rotateView(targetView: backgroundImageView)
        /*while i != 0{
            backgroundImageView.rotate360Degrees()
            i = i - 1
        }*/
        
        
            //backgroundImageView.image = UIImage(named: imageArray[i%4])
        
        /*DispatchQueue.main.async{
        
            self.performSegue(withIdentifier: "LaunchToScreen1", sender: self)
        }*/
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Rotate <targetView> indefinitely
    private func rotateView(targetView: UIView, duration: Double = 2.7) {
        if rotateCount == 5 {
            performSegue(withIdentifier: "LaunchToScreen1", sender: self)
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { finished in
            self.rotateCount = self.rotateCount + 1
            self.rotateView(targetView: targetView, duration: duration)
        }
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
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI)
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
