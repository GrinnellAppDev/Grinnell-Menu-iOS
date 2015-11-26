//
//  GliciousServerManager.swift
//  G-licious
//
//  Created by Tyler Dewey on 12/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

import Foundation

public class FavoritesSummary: NSObject {
    
    public func favoriteDishesForDate(date: NSDate, completionHandler: ([Dish]?, NSError?) -> Void) {
        
        // Get the day's dishes
        retrieveDishesForDate(date) { (dishes, error) -> Void in
            if let dishes = dishes {
                let favoritesManager = FavoritesManager.sharedManager()
                var favDishes = [Dish]()
                
                for dish in dishes where favoritesManager.containsFavorite(dish){
                    favDishes.append(dish)
                }
                
                completionHandler(favDishes, nil)
            } else if let err = error {                        // Dish retrieval was unsuccessful
                NSLog("Error: \(err), \(err.userInfo)")
                
                completionHandler(nil, err)
                
            } else {
                let err = NSError(domain: "GliciousServerErrorDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])
                
                completionHandler(nil, err)
            }
        }
    }
    
    private func retrieveDishesForDate(date: NSDate, completionHandler: ([Dish]?, NSError?) -> Void) {
        
        let dishesURL = URLUtils.dishesURLForDate(date)
        
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(dishesURL) { (data, response, error) -> Void in
            if let _ = error { // there was an error downloading the dishes
                let userInfo = [NSLocalizedDescriptionKey: "Failed to download dishes data"]
                let err = NSError(domain: "GliciousServerErrorDomain", code: 1, userInfo: userInfo)
                
                completionHandler(nil, err)
                return
            }
            
            // Parse dishes array object from JSON data
            let dishesJSON: AnyObject?
            do {
                dishesJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:[] )
            } catch _ as NSError {
                let userInfo = [NSLocalizedDescriptionKey: "Failed to properly cast JSON object to dishes array"]
                let err = NSError(domain: "GliciousServerErrorDomain", code: 2, userInfo: userInfo)
                
                completionHandler(nil, err)
                return
            }
            
            var dishes = [Dish]()
            
            // Cast JSON object into array of dish dictionaries
            if let dishDicts = dishesJSON as? [[String: AnyObject]] {   // If cast succeeds
                for dishDict in dishDicts {                             // Turn dish dicts into dishes
                    dishes.append(Dish(dishDictionary:dishDict))
                }
            } else {
                let userInfo = [NSLocalizedDescriptionKey: "Failed to properly cast JSON object to dishes array"]
                let err = NSError(domain: "GliciousServerErrorDomain", code: 2, userInfo: userInfo)
                
                completionHandler(nil, err)
                return
            }
            
            NSLog("\(dishes)")
            completionHandler(dishes, nil)
        }
        
        dataTask.resume()
    } // retrieveDishesForDate(date:completionHandler:)
}
