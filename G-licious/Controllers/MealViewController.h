//
//  MealViewController.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/1/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"
#import "MenuModel.h"

@interface MealViewController : UITableViewController

@property (nonatomic, strong) MenuModel *menuModel;
@property(nonatomic, strong) Meal *meal;

@end
