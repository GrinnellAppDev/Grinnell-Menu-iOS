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

@interface VenueViewController : PanelsViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

- (IBAction)showInfo:(id)sender;
- (void)loadNextMenu;
- (void)refreshScreen;
- (void)showMealHUD;
- (void)getDishes;
- (void)applyFilters;
@property (nonatomic, strong) NSMutableArray *panelsArray;
@property (nonatomic, assign) int availDay;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *mealChoice;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property (nonatomic, weak) IBOutlet UILabel *grinnellDiningLabel, *dateLabel, *menuchoiceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *topImageView;

@end
