//
//  DishView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//


@interface DishViewController : UIViewController


//- (IBAction)backToMainMenu:(id)sender;
- (IBAction)toVenueView:(id)sender;

@property (nonatomic, strong) IBOutlet UITextView *nutritionDetails;
@property (nonatomic, assign) NSInteger dishSection;
@property (nonatomic, assign) NSInteger dishRow;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;

@property (weak, nonatomic) IBOutlet UITextView *backgroundImageView;


@end
