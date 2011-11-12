//
//  Tray.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//


@interface Tray : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *newTableView;
    UITextView *totalNutrition;
    NSString *editStyle;
    UIBarItem *plusButton;
    NSString *buttonTitle;
}
- (IBAction)editTable:(id)sender;
- (IBAction)clearTray:(id)sender;
- (IBAction)toVenueView:(id)sender;
- (IBAction)toLastView:(id)sender;
- (IBAction)addDish:(id)sender;
@property (nonatomic, retain) IBOutlet UITableView *newTableView;
@property (nonatomic, retain) IBOutlet UITextView *totalNutrition;
@property (nonatomic, retain) NSString *editStyle;
@property (nonatomic, retain) IBOutlet UIBarItem *plusButton;
@property (nonatomic, retain) NSString *buttonTitle;
@end