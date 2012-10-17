//
//  VenueView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PanelsViewController.h"
#import "DishViewController.h"
#import "DatePickerViewController.h"


@interface VenueViewController : PanelsViewController <MBProgressHUDDelegate, DatePickerDelegate>
{
    MBProgressHUD *HUD;
}

- (IBAction)showInfo:(id)sender;
- (void)loadNextMenu;
- (void)refreshScreen;
- (void)showMealHUD;
- (void)getDishes;
- (void)applyFilters;
@property (strong, nonatomic) DishViewController *dishViewController;
@property (nonatomic, strong) NSMutableArray *panelsArray;
@property (nonatomic, assign) int availDay;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *mealChoice;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *grinnellDiningLabel;
@property (nonatomic, weak) IBOutlet UILabel *menuchoiceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *topImageView;
@property (nonatomic, weak) IBOutlet UIToolbar *bottomBar;


//Need these so the Ipad can adequately respond to them. 
@property (nonatomic, strong) UIPopoverController *datePickerPopover;
@property (nonatomic, strong) DatePickerViewController *datePickerController;

@end
