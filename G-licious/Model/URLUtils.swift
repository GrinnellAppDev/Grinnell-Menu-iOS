//
//  ServerUtil.swift
//  G-licious
//
//  Created by AppDev on 11/25/15.
//  Copyright © 2015 Maijid Moujaled. All rights reserved.
//

import UIKit

class URLUtils: NSObject {

    internal static let SERVER_URL = "https://appdev.grinnell.edu/glicious/"
    
    // MARK: G-licious Server URLs
    
    class func lastDateUrl() -> NSURL {
        return NSURL(string: SERVER_URL + "last_date.json")!
    }
    
    class func menuURLForDate(date: NSDate) -> NSURL {
        let components = getComponentsFromDate(date)
        
        let dateFile = "\(components.month)-\(components.day)-\(components.year).json"
        
        return NSURL(string: SERVER_URL + dateFile)!
    }
    
    class func dishesURLForDate(date: NSDate) -> NSURL {
        let components = getComponentsFromDate(date)
        
        let dishesFile = "\(components.month)-\(components.day)-\(components.year)_dishes.json"
        
        return NSURL(string: SERVER_URL + dishesFile)!
    }
    
    // MARK: Menu Paths
    
    class func menuPlistPathForDate(date: NSDate) -> String {
        let tempDirectory = NSTemporaryDirectory() as NSString
        let components = getComponentsFromDate(date)
        
        let menuFile = "\(components.month)-\(components.day)-\(components.year).plist"
        
        return tempDirectory.stringByAppendingPathComponent(menuFile)
    }
    
    // MARK: Utilities
    
    class func getComponentsFromDate(date: NSDate) -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Year, .Month, .Day],
            fromDate: date)
    }
    
}
