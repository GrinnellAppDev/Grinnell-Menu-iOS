//
//  DishView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

@interface DishView : UIViewController

- (IBAction)backToMainMenu:(id)sender;
- (IBAction)toVenueView:(id)sender;

@property (nonatomic, strong) IBOutlet UITextView *nutritionDetails;
@property (nonatomic, assign) NSInteger dishSection;
@property (nonatomic, assign) NSInteger dishRow;
@end
