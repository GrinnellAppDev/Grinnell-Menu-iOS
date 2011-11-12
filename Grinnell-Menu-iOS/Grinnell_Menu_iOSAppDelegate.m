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
#import "Filter.h"

@implementation Grinnell_Menu_iOSAppDelegate

@synthesize window, navigationController;
@synthesize navStyle, fromDishView, venues, dishRow, dishSection, filters, trayDishes;

#pragma mark -
#pragma mark Application lifecycle

- (void)flipToSettings {
    Settings *settings = 
	[[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    
    [self.navigationController pushViewController:settings animated:YES];

    [settings release];
}

- (void)flipToTray {
    Tray *tray = [[Tray alloc] initWithNibName:@"Tray" bundle:nil];
    [self.navigationController pushViewController:tray animated:YES];
    [tray release];
}

- (NSString *) saveFilePath {
	NSArray *pathArray =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"savedddata.plist"];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSString *myPath = [self saveFilePath];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];

	if (fileExists)	{
		NSMutableArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
        filters = [[NSMutableArray alloc] initWithArray:values];
		[values release];
	}
    else{
        filters = [[NSMutableArray alloc] init];
        Filter *filter;
        filter = [[Filter alloc]  init];
        filter.name = @"All";
        filter.isChecked = YES;
        [filters addObject:filter];
        filter = [[Filter alloc]  init];
        filter.name = @"Vegetarian";
        filter.isChecked = YES;
        [filters addObject:filter];
        filter = [[Filter alloc]  init];
        filter.name = @"Vegan";
        filter.isChecked = YES;
        [filters addObject:filter];
        filter = [[Filter alloc]  init];
        filter.name = @"Food Containing Nuts";
        filter.isChecked = YES;
        [filters addObject:filter];
        filter = [[Filter alloc]  init];
        filter.name = @"Gluten Free";
        filter.isChecked = YES;
        [filters addObject:filter];
    }

    // Override point for customization after app launch
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	NSMutableArray *values = [[NSArray alloc] init];
    for (int i=0; i<filters.count; i++){
        [values addObject:[filters objectAtIndex:i]];
    }
	[values writeToFile:[self saveFilePath] atomically:YES];
	[values release];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [trayDishes release];
    [filters release];
    [venues release];
	[navigationController release];
	[window release];
    [navStyle release];
    [fromDishView release];
	[super dealloc];
}

@end
