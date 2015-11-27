//
//  MenuCache.swift
//  G-licious
//
//  Created by AppDev on 11/27/15.
//  Copyright © 2015 Maijid Moujaled. All rights reserved.
//

import UIKit

class MenuCache: NSObject {
    
    private let cacheRoot = NSTemporaryDirectory() as NSString
    
    func hasMenuForDate(date: NSDate) -> Bool {
        let menuPath = URLUtils.menuPlistPathForDate(date)
        
        return NSFileManager.defaultManager().fileExistsAtPath(menuPath)
    }
    
    func getMenuDictForDate(date: NSDate) -> NSDictionary? {
        let menuPath = URLUtils.menuPlistPathForDate(date)
        
        return NSDictionary(contentsOfFile: menuPath)
    }
    
    // TODO: method to fully create menu: [Meal]? (figure out how to acces Meal class)
    
    func cacheMenuDict(menuDict: NSDictionary, forDate date: NSDate) -> Bool {
        let menuPath = URLUtils.menuPlistPathForDate(date)
        
        return menuDict.writeToFile(menuPath, atomically: true)
    }
}
