//
//  GliciousServerManager.swift
//  G-licious
//
//  Created by Tyler Dewey on 12/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

import Foundation

public class FavoritesSummary: NSObject {

    let serverURL = "http://appdev.grinnell.edu/glicious/"
    
    public func favoriteDishesForDate(date: NSDate) -> [Dish]? {
        var error: NSError?
        var favDishes = [Dish]()
        
        // Get the day's dishes
        let dishesArr = self.retrieveDishesForDate(date, error:&error)
        
        if let err = error {                    // Dish retrieval was unsuccessful
            NSLog("Error: \(err), \(err.userInfo)")
            return nil
        }
        
        let favoritesManager = FavoritesManager.sharedManager()
        
        if let dishes = dishesArr {
            for dish in dishes {
                if favoritesManager.containsFavorite(dish) {
                    favDishes.append(dish)
                }
            }
        }
        
        return favDishes
    }
    
    private func retrieveDishesForDate(date: NSDate, error: NSErrorPointer) -> [Dish]? {
        
        var jsonError: NSError?
        var dishes = [Dish]()
        
        // Retrieve the year, month, and day components from the selected day
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        
        //let dishesURL = NSURL(string: serverURL + "\(components.month)-\(components.day)-\(components.year)_dishes.json")!
        
        // test value
        let dishesURL = NSURL(string: serverURL + "\(components.month)-\(13)-\(components.year)_dishes.json")!
        
        let data = NSData(contentsOfURL:dishesURL)
        
        if (data == nil) {
            let userInfo = [NSLocalizedDescriptionKey: "Failed to download dishes data"]
            let err = NSError(domain: "GliciousServerErrorDomain", code: 1, userInfo: userInfo)
            if (error != nil) { error.memory = err }
            return nil
        }
        
        // Parse dishes array object from JSON data
        let dishesJSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options:nil , error:&jsonError)
        
        if let err = jsonError {                                // if parse failed
            if (error != nil) { error.memory = err }
            return nil
        }
        
        // Cast JSON object into array of dish dictionaries
        if let dishDicts = dishesJSON as? [[String: AnyObject]] {   // If cast succeeded
            for dishDict in dishDicts {                             // Turn dish dicts into dishes
                dishes.append(Dish(dishDictionary:dishDict))
            }
        } else {
            let userInfo = [NSLocalizedDescriptionKey: "Failed to properly cast JSON object to dishes array"]
            let err = NSError(domain: "GliciousServerErrorDomain", code: 2, userInfo: userInfo)
            if (error != nil) { error.memory = err }
            return nil
        }
        
        NSLog("\(dishes)")
        
        return dishes
    } // retrieveDishesForDate(date:)
}
