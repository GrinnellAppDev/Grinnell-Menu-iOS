//
//  VenueView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface VenueViewController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;

}

- (IBAction)showInfo:(id)sender;
- (void)loadNextMenu;

- (void)getDishes;
- (void)applyFilters;


@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *mealChoice;
@property (nonatomic, strong) IBOutlet UITableView *anotherTableView;
@property (nonatomic, strong) NSDictionary *jsonDict;

@property (weak, nonatomic) IBOutlet UILabel *grinnellDiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuchoiceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;



@end
