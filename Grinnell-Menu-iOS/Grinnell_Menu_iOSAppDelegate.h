//
//  Grinnell_Menu_iOSAppDelegate.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//
#import "DishViewController.h"
@class VenueViewController;
@class DatePickerViewController;

@interface Grinnell_Menu_iOSAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) VenueViewController *venueViewController;
@property (nonatomic, strong) DatePickerViewController *datePickerViewController;
@property (nonatomic, strong) NSMutableArray *allMenus;
@property BOOL passover;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (nonatomic, strong) Dish *iPadselectedDish;
@end
