//
//  Grinnell_Menu_iOSAppDelegate.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Grinnell_Menu_iOSAppDelegate.h"
#import "RootViewController.h"

@implementation Grinnell_Menu_iOSAppDelegate

@synthesize window, navigationController, venues;

#pragma mark -
#pragma mark Application lifecycle


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Override point for customization after app launch
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {

    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
