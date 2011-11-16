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
    NSMutableArray *venues;
    NSMutableArray *filters;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *venues;
@property (nonatomic, retain) NSMutableArray *filters;


@end
