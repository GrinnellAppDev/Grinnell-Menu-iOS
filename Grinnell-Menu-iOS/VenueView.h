//
//  VenueView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

@interface VenueView : UIViewController {
    NSArray *venues;
    UITableView *newTableView;
    NSInteger dishInd;
    NSIndexPath *indPath;
}
- (IBAction)showInfo:(id)sender;
- (IBAction)showTray:(id)sender;
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withDish:(Dish *)dish;
- (int)getRow:(NSInteger)row inSection:(NSInteger)section;

@property (nonatomic, retain) IBOutlet UITableView *newTableView;
@property (nonatomic, assign) NSInteger dishInd;
@property (nonatomic, retain) NSIndexPath *indPath;
@end
