//
//  Grinnell_Menu_iOSAppDelegate.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

@interface Grinnell_Menu_iOSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    NSString *navStyle;
    NSString *fromDishView;
    NSMutableArray *venues;
    NSMutableArray *filters;
    NSInteger dishSection;
    NSInteger dishRow;
    NSMutableArray *trayDishes;
}

- (void) flipToSettings;
- (void) flipToTray;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *navStyle;
@property (nonatomic, retain) NSString *fromDishView;
@property (nonatomic, retain) NSMutableArray *venues;
@property (nonatomic, retain) NSMutableArray *filters;
@property (nonatomic, assign) NSInteger dishSection;
@property (nonatomic, assign) NSInteger dishRow;
@property (nonatomic, retain) NSMutableArray *trayDishes;
@end
