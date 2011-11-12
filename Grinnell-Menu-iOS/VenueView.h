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
    NSInteger dishSection;
    NSInteger dishRow;
    BOOL fromSettings;
}

- (IBAction)showInfo:(id)sender;
- (IBAction)showTray:(id)sender;
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withDish:(Dish *)dish;

@property (nonatomic, retain) NSMutableArray *originalVenues;
@property (nonatomic, retain) IBOutlet UITableView *newTableView;
@property (nonatomic, retain) NSString *alert;
@property (nonatomic, assign) NSInteger dishSection;
@property (nonatomic, assign) NSInteger dishRow;
@property (nonatomic, assign) BOOL fromSettings;

@end
