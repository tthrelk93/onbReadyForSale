//
//  ALRadialMenuButton.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 10/11/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

//
//  ALRadialMenuButton.swift
//  ALRadialMenu
//
//  Created by Alex Littlejohn on 2015/04/26.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

public typealias ALRadialMenuButtonAction = () -> Void
protocol PerformSegueInRootProtocol {
    func createSessionButtonSelected()
    func currentSessionsButtonSelected()
    func sessionInvitesButtonSelected()
    func sessionFeedButtonSelected()
    func findArtistsButtonSelected()
    func noButtonTouched()
}
protocol PerformSegueInArtistFinder{
    func buttonOneTouched(name: String)
}
public class ALRadialMenuButton: UIButton {
    public var index: Int?
    public var home: String?
    public var homeScreenSize: Double?
    public var name: String?
    
    
    //var inviteLabel: UILabel?
    var newCenter: CGPoint?
    var delegate: PerformSegueInRootProtocol!
    var artistDelegate: PerformSegueInArtistFinder!
    //var invitesDelegate: PerformSegueInArtistFinder!
    
    
    open var action: ALRadialMenuButtonAction? {
        didSet {
            
            configureAction()
        }
    }
    
    fileprivate func configureAction() {
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    internal func performAction() {
        if let a = action {
            a()
        }
        
    }
}
