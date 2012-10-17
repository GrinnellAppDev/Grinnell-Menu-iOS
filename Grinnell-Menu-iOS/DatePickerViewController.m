//
//  RootViewController.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "DatePickerViewController.h"
#import "VenueViewController.h"
#import "Reachability.h"
#import "Grinnell_Menu_iOSAppDelegate.h"

@implementation DatePickerViewController {
    NSString *alert;
    NSURL *URLwithDate;
    BOOL notFirstTime;
}
@synthesize grinnellDiningLabel, go, go2, datePicker, jsonDict, banner, delegate;

//Fetches the data from server. jsonDict is passed on to VenueViewController. 
- (BOOL)fetchprelimdataWithURL:(NSURL *)URL {
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSError * error;
    if (data) {
        //NSJSON takes data and then gives you back a foundation object. dict or array.
        self.jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
        return YES;
    }
    else {
        UIAlertView *dataNilAlert = [[UIAlertView alloc]
                                     initWithTitle:@"An error occurred pulling in the data from the server"
                                     message:nil
                                     delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [dataNilAlert show];
        return NO;;
    }
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}

- (IBAction)showVenues:(id)sender {
    NSDate *date = [self.datePicker date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger day = [components day];    
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    //File Directories used.
    NSString *tempPath = NSTemporaryDirectory();
    NSString *daymenuplist = [NSString stringWithFormat:@"%d-%d-%d.plist", month, day, year];
    
    //either tempPath or Documentsdirectory - I went with tempPath
    NSString *path = [tempPath stringByAppendingPathComponent:daymenuplist];
    
    //Check to see if the file has previously been cached. 
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.jsonDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        // NSLog(@"Loading Json from iPhone cache");
    }
    
    //if not, go get it from server.
    else {
        if (self.networkCheck) {
            NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/%d-%d-%d.json", month, day, year];
            URLwithDate = [NSURL URLWithString:url];
            if (![self fetchprelimdataWithURL:URLwithDate])
                return;
            [jsonDict writeToFile:path atomically:YES];
        }
        //Else if there is not a network connection determined... give No Network Connection alert
        else {
            alert = @"network";
            UIAlertView *network = [[UIAlertView alloc] 
                                    initWithTitle:@"No Network Connection" 
                                    message:@"Turn on cellular data or use Wi-Fi to access new data from the server"                            delegate:self 
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil
                                    ];
            [network show];
            return;
        }
    }
    
    //At this point, we have a working jsonDict with menuitems.
    UIAlertView *mealmessage = [[UIAlertView alloc] 
                                initWithTitle:@"Select Meal" 
                                message:nil
                                delegate:self 
                                cancelButtonTitle:@"Cancel" 
                                otherButtonTitles:nil
                                ];
    
    //Create alert buttons depending on the menus available.
    if ([jsonDict objectForKey:@"BREAKFAST"]) {
        [mealmessage addButtonWithTitle:@"Breakfast"];
    }
    if ([jsonDict objectForKey:@"LUNCH"]) {
        [mealmessage addButtonWithTitle:@"Lunch"];
    }
    if ([jsonDict objectForKey:@"DINNER"]) {
        [mealmessage addButtonWithTitle:@"Dinner"];
    }
    if ([jsonDict objectForKey:@"OUTTAKES"]) {
        [mealmessage addButtonWithTitle:@"Outtakes"];
    }
    [mealmessage show];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Pick a date";
    self.grinnellDiningLabel.text = @"GrinnellDining";
    self.grinnellDiningLabel.font = [UIFont fontWithName:@"Vivaldi" size:38];
    
    ///For iPad view. Modify value to set the appropriate width and height for the content size. 
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 420.0);

}

- (void)viewWillAppear:(BOOL)animated {
    if (self.networkCheck) {
        if (!notFirstTime) {
            NSDate *now = [[NSDate alloc] init];
            [datePicker setMinimumDate:now];    
            NSCalendar *current = [NSCalendar currentCalendar];
            NSDateComponents *comps = [current components:NSHourCalendarUnit | NSWeekdayCalendarUnit fromDate:now];
            
            // If dinner is over, set date picker date to tomorrow
            if (((comps.weekday == 1 || comps.weekday >= 6) && comps.hour > 19) || comps.hour > 20)
                now = [NSDate dateWithTimeIntervalSinceNow:60*60*(24 - comps.hour)];
            
            [datePicker setDate:now animated:YES];
            
            //Gets the available days to appropriately set the datePicker
            Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            int day = mainDelegate.venueViewController.availDay;
            if (day <= 0) {
                alert = @"network";
                UIAlertView *network = [[UIAlertView alloc] 
                                        initWithTitle:@"No Menus are available" 
                                        message:@"Please check back later"
                                        delegate:self 
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil
                                        ];
                [network show];
            }
            
            int range = 24 * 60 * 60 * day;
            NSDate *max = [[NSDate alloc] initWithTimeIntervalSinceNow:range];
            
            [datePicker setMaximumDate:max];
            notFirstTime = YES;
        }
    }
    else {
        NSDate *now = [[NSDate alloc] init];
        [datePicker setDate:now animated:YES];
        [datePicker setMinimumDate:now];
        [datePicker setMaximumDate:now];
        
        alert = @"network";
        UIAlertView *network = [[UIAlertView alloc] 
                                initWithTitle:@"No Network Connection" 
                                message:@"Turn on cellular data or use Wi-Fi to access data"
                                delegate:self 
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil
                                ];
        [network show];
    }     
}

- (void)viewDidUnload {
    [self setGrinnellDiningLabel:nil];
    [super viewDidUnload];
    self.datePicker = nil;
}
/*
- (void)viewWillLayoutSubviews
{
    if (UIInterfaceOrientationIsPortrait(
                                         [UIApplication sharedApplication].statusBarOrientation))
    {
        grinnellDiningLabel.hidden = NO;
        banner.hidden = NO;
        go.hidden = NO;
        go2.hidden = YES;
    }
    else
    {
        grinnellDiningLabel.hidden = YES;
        banner.hidden = YES;
        go.hidden = YES;
        go2.hidden = NO;
    }
}*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        //We want access to the venueViewController that was created on launch. (Instead of instantiating a new  one)
        Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
        mainDelegate.venueViewController.jsonDict = self.jsonDict;
        
        mainDelegate.venueViewController.mealChoice = titlePressed;
        mainDelegate.venueViewController.date = datePicker.date;
        
        //The refresh screen methods refreshes the tableview as well as makes sure it starts from the top (instead of somewhere in the middle)
        [mainDelegate.venueViewController refreshScreen];
        [self.navigationController pushViewController:mainDelegate.venueViewController animated:YES];
        [mainDelegate.venueViewController showMealHUD];
        
    } else {
        //iPad
        //Needs to do something different for iPad. Pass in the mealchoice the jsondict to the delegate
        
        NSLog(@"It still recognizes this");
        if (self.delegate != nil) {
            [self.delegate datePickerSelectedJsonDict:self.jsonDict andMealChoice:titlePressed date:datePicker.date];
            
        }
    }
    
}

@end