//
//  DishView.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Dish.h"

@interface DishViewController : UIViewController

- (IBAction)toVenueView:(id)sender;

@property (nonatomic, strong) Dish *selectedDish;
@property (nonatomic, weak) IBOutlet UITableView *theTableView;
@property (nonatomic, weak) IBOutlet UITextView *backgroundImageView;

@end
