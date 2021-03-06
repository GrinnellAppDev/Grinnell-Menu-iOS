//
//  AppDelegate.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/1/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "AppDelegate.h"
#import "G_licious-Swift.h"
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *strings_private = [[NSBundle mainBundle] pathForResource:@"strings_private" ofType:@"strings"];
    NSDictionary *keysDict = [NSDictionary dictionaryWithContentsOfFile:strings_private];
    
    [Crashlytics startWithAPIKey:[keysDict objectForKey:@"CrashlyticsAPIKey"]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f]} forState:UIControlStateNormal];
    
    // Set Parse installation
#if DEBUG == 1 // If we're running on a dev machine, use dev keys
    
    [Parse setApplicationId:[keysDict objectForKey:@"ParseAppIdDev"]
                  clientKey:[keysDict objectForKey:@"ParseClientKeyDev"]];
    
#else // otherwise use prod keys
    
    [Parse setApplicationId:[keysDict objectForKey:@"ParseAppIdProd"]
                  clientKey:[keysDict objectForKey:@"ParseClientKeyProd"]];
    
#endif
    
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   // [[NSNotificationCenter defaultCenter]  postNotificationName:@"ResetStationsView" object:nil];
   // NSLog(@"App Entering Foreground");
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //StationsViewController *stationsViewController = [storyboard instantiateViewControllerWithIdentifier:@"StationsViewController"];
    //DLog(@"svc: %@", self.stationsViewController);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
