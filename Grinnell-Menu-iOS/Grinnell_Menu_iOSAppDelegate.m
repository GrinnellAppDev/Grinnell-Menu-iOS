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
#import "Filter.h"

@implementation Grinnell_Menu_iOSAppDelegate

@synthesize window, navigationController;
@synthesize venues, filters;

#pragma mark -
#pragma mark Application lifecycle

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
        filter.name = @"Vegan";
        filter.isChecked = NO;
        [filters addObject:filter];
        filter = [[Filter alloc]  init];
        filter.name = @"Ovolacto";
        filter.isChecked = NO;
        [filters addObject:filter];/*
        filter = [[Filter alloc]  init];
        filter.name = @"Wheat/Gluten";
        filter.isChecked = YES;
        [filters addObject:filter];
        filter = [[Filter alloc]  init];
        filter.name = @"Vegetarian";
        filter.isChecked = YES;
        [filters addObject:filter];*/
        [filter release];
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
    [filters release];
    [venues release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
