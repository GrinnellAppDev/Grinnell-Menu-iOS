//
//  Grinnell_Menu_iOSAppDelegate.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Grinnell_Menu_iOSAppDelegate.h"
#import "RootViewController.h"
#import "Crittercism.h"
#import "FlurryAnalytics.h"

@implementation Grinnell_Menu_iOSAppDelegate{
    NSString *alert;
}

@synthesize window, navigationController, venues;

#pragma mark -
#pragma mark Application lifecycle


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Override point for customization after app launch
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
    
    [Crittercism initWithAppID: @"4f67e3f4b0931560c200000c"
                        andKey:@"gznvtmrwkvkp7rupb69jn3ux1d8o"
                     andSecret:@"hnopgnw4fotzwi0smv37dshgzkjpbmuy"];
    
    //Development Analytics Testing. (maybe we might just disable this in the future, since we don't need analytics from developement. 
    [FlurryAnalytics startSession:@"CGUQXVSN77GEBKAK2ZWL"];
    
    
    //This is for gathering data on the live app in the appstore. Matches G-licious - Distribution on Flurry. 
    //[FlurryAnalytics startSession:@"GEJ8BPK37ZJE31GQG3C9"];


}


- (void)applicationWillTerminate:(UIApplication *)application {
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
