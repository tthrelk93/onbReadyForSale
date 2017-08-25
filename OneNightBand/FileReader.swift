//
//  FileReader.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 3/19/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//


import UIKit
import Foundation


class FileReader: NSObject{
    class func readFiles() -> [String] {
        return  Bundle.main.paths(forResourcesOfType: "m4a", inDirectory: nil) as! [String]
    }
}
