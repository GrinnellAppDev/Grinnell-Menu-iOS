//
//  Grinnell_Menu_iOSAppDelegate.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Grinnell_Menu_iOSAppDelegate.h"
#import "DatePickerViewController.h"
#import "VenueViewController.h"
#import "DishViewController.h"
#import "Crittercism.h"
#import "FlurryAnalytics.h"

@implementation Grinnell_Menu_iOSAppDelegate{
    NSString *alert;
}

@synthesize window, navigationController, allMenus, passover, iPadselectedDish;
@synthesize datePickerViewController, venueViewController, splitViewController;

#pragma mark -
#pragma mark Application lifecycle


//- (void)applicationDidFinishLaunching:(UIApplication *)application {
//    // Override point for customization after app launch
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.venueViewController =  [[VenueViewController alloc] initWithNibName:@"VenueViewController" bundle:nil];
//
//    UIViewController *datepickercontroller = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
//
//    self.window.rootViewController = datepickercontroller;
//
////    [window addSubview:[navigationController view]];
//    [window makeKeyAndVisible];
//    return YES;
//
////    [Crittercism initWithAppID: @"4f67e3f4b0931560c200000c"
////                        andKey:@"gznvtmrwkvkp7rupb69jn3ux1d8o"
////                     andSecret:@"hnopgnw4fotzwi0smv37dshgzkjpbmuy"];
//
//    //Development Analytics Testing. (maybe we might just disable this in the future, since we don't need analytics from development.
////    [FlurryAnalytics startSession:@"CGUQXVSN77GEBKAK2ZWL"];
//
//
//    //This is for gathering data on the live app in the appstore. Matches G-licious - Distribution on Flurry.
////    [FlurryAnalytics startSession:@"GEJ8BPK37ZJE31GQG3C9"];
//
//
//}
//
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//}
//
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.venueViewController =  [[VenueViewController alloc] initWithNibName:@"VenueViewController" bundle:nil];
        
        self.datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.datePickerViewController];
        self.venueViewController.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:self.venueViewController animated:NO];
        self.window.rootViewController = self.navigationController;
    }
    else{
        self.venueViewController = [[VenueViewController alloc] initWithNibName:@"VenueViewController" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:self.venueViewController];
        
        DishViewController *dishViewController = [[DishViewController alloc] initWithNibName:@"DishViewController" bundle:nil];
        
        UINavigationController *dishNavigationController = [[UINavigationController alloc] initWithRootViewController:dishViewController];
    	
    	venueViewController.dishViewController = dishViewController;
    	
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = dishViewController;
        NSArray *viewsArray = [[NSArray alloc] initWithObjects:masterNavigationController, dishNavigationController, nil];
        self.splitViewController.viewControllers = viewsArray;
        
        //[masterNavigationController, dishNavigationController];
        
        self.window.rootViewController = self.splitViewController;
    }
    // Set the global tint on the navigation bar - Black
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [window makeKeyAndVisible];
    
    //This is for gathering data on the live app in the appstore. Matches G-licious - Distribution on Flurry.
    //A flurry account is free. Want to see app statistics? Email me to add you to the Grinnell Appdev team on Flurry. @DrJid
    [FlurryAnalytics startSession:@"GEJ8BPK37ZJE31GQG3C9"];
    
    //Allows us to send push notification to users who experience a crash - If we want to...
    //    [Crittercism initWithAppID: @"4f67e3f4b0931560c200000c"
    //                        andKey:@"gznvtmrwkvkp7rupb69jn3ux1d8o"
    //                     andSecret:@"hnopgnw4fotzwi0smv37dshgzkjpbmuy"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
    
    //Make sure we start on the venueViewController when the app is going to be reloaded.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:self.venueViewController animated:NO];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
    [self.venueViewController loadNextMenu];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}



@end
