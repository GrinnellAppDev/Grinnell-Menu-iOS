//
//  Grinnell_Menu_iOSAppDelegate.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Grinnell_Menu_iOSAppDelegate.h"
#import "RootViewController.h"
#import "Settings.h"
#import "Tray.h"

@implementation Grinnell_Menu_iOSAppDelegate

@synthesize window, navigationController;
@synthesize navStyle, fromDishView, trayDishes, dishes, dishIndex, filters;

#pragma mark -
#pragma mark Application lifecycle

- (void)flipToSettings {
    Settings *settings = 
	[[Settings alloc] initWithNibName:@"Settings" bundle:nil];
	[self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

- (void)flipToTray {
 Tray *tray = 
 [[Tray alloc] initWithNibName:@"Tray" bundle:nil];
 [self.navigationController pushViewController:tray animated:YES];
 [tray release];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

 
    // Override point for customization after app launch

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [filters release];
    [dishes release];
    [trayDishes release];
	[navigationController release];
	[window release];
    [navStyle release];
    [fromDishView release];
	[super dealloc];
}

@end
