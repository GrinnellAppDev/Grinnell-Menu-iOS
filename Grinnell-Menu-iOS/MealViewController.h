//
//  MealViewController.h
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/29/13.
//
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@interface MealViewController : UITableViewController


@property(nonatomic, strong) Meal *meal;


-(void)insert;

@end
