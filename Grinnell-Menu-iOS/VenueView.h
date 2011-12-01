//
//  VenueView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "Settings.h"

@interface VenueView : UIViewController {
    UITableView *newTableView;
    NSString *alert;
    NSMutableArray *originalVenues;
    NSDate *date;
    NSString *meal;
}

- (IBAction)showInfo:(id)sender;
- (void)getDishes;

@property (nonatomic, retain) NSMutableArray *originalVenues;
@property (nonatomic, retain) IBOutlet UITableView *newTableView;
@property (nonatomic, retain) NSString *alert;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *meal;
@end
