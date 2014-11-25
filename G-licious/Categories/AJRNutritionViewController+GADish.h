//
//  AJRNutritionViewController+AJRNutritionViewController_GADish.h
//  G-licious
//
//  Created by AppDev on 11/24/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import "AJRNutritionViewController.h"

@class Dish;

@interface AJRNutritionViewController (GADish)

/**
 * Returns an ARJNutritionViewController instance configured with
 * information from a given dish.
 */
+ (instancetype)controllerWithDish:(Dish *)dish;

@end
