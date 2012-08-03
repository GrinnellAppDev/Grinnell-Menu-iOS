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
@synthesize grinnellDiningLabel;
@synthesize go, datePicker, jsonDict;

//Fetches the data from server. jsonDict is passed on to VenueViewController. 
- (BOOL)fetchprelimdataWithURL:(NSURL *)URL {
    NSData *data = [NSData dataWithContentsOfURL:URL];
    
    NSError * error;
    
    if (data)
    {
        //NSJSON takes data and then gives you back a foundation object. dict or array.
        self.jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
        return YES;
    }

    else
    {
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


- (IBAction)showVenues:(id)sender
{
        
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
               // NSMutableString *url = [NSMutableString stringWithFormat:@"http://www.cs.grinnell.edu/~tremblay/menu/%d-%d-%d.json", month, day, year];

             //  NSMutableString *url = [NSMutableString stringWithFormat:@"http://www.cs.grinnell.edu/~knolldug/parser/%d-%d-%d.json", month, day, year];
                NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/%d-%d-%d.json", month, day, year];

                URLwithDate = [NSURL URLWithString:url];

                if (![self fetchprelimdataWithURL:URLwithDate])
                    return;
                

              //  NSLog(@"Saving new json from server");
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pick a date";
    self.grinnellDiningLabel.text = @"GrinnellDining";
    self.grinnellDiningLabel.font = [UIFont fontWithName:@"Vivaldi" size:38];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.networkCheck) {
    if (!notFirstTime){
        NSDate *now = [[NSDate alloc] init];
        [datePicker setMinimumDate:now];    
        NSCalendar *current = [NSCalendar currentCalendar];
        NSDateComponents *currentComponents = [current components:NSHourCalendarUnit fromDate:now];
        
        // If dinner is over, set date picker date to tomorrow
        if (currentComponents.hour > 20)
            now = [NSDate dateWithTimeIntervalSinceNow:60*60*(24 - currentComponents.hour)];
        
       [datePicker setDate:now animated:YES];

        //Determines the available days to appropriately set the datePicker
        
        //TODO DONT FORGET THIS ISNT ACCESSING THE REAL JSON right now...
      //   NSURL *datesURL = [NSURL URLWithString:@"http://www.cs.grinnell.edu/~tremblay/menu/available_days_json_FAKE.php"];
     //   NSURL *datesURL = [NSURL URLWithString:@"http://www.cs.grinnell.edu/~knolldug/parser/available_days_json.php"];
       NSURL *datesURL = [NSURL URLWithString:@"http://tcdb.grinnell.edu/apps/glicious/available_days_json.php"];

        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:datesURL];
        
        NSDictionary *availableDaysJson = [[NSDictionary alloc] init];
    
        @try {
            availableDaysJson = [NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions 
                                                    error:&error];
        }
        @catch (NSException *e) {
            alert = @"server";
            UIAlertView *network = [[UIAlertView alloc] 
                                initWithTitle:@"Network Error" 
                                    message:@"The connection to the server failed. Please check back later. Sorry for the inconvenience."
                                delegate:self 
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil
                                ];
            [network show];
        }
    
    //If the available days returned is -1, there are no menus found.. 
        NSString *dayStr = [availableDaysJson objectForKey:@"days"];
        int day = dayStr.intValue;
       // NSLog(@"Available days: %@", dayStr);
       // NSLog(@"Available json: %@", availableDaysJson);

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
//            go.enabled = NO;
        }
        else
            go.enabled = YES;
        
        int range = 24 * 60 * 60 * day;
        NSDate *max = [[NSDate alloc] initWithTimeIntervalSinceNow:range];

        [datePicker setMaximumDate:max];
        notFirstTime = YES;
          
    }
}
    

    else{
        
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


- (void)viewDidUnload
{
    [self setGrinnellDiningLabel:nil];
    [super viewDidUnload];
    self.datePicker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

    //We want access to the venueViewController that was created on launch. (Instead of instantiating a new  one)
    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.venueViewController.jsonDict = self.jsonDict;

    
    if (buttonIndex == alertView.cancelButtonIndex)    
        return;
    
    
    NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
    mainDelegate.venueViewController.mealChoice = titlePressed;
    mainDelegate.venueViewController.date = datePicker.date;
    
    //The refresh screen methods refreshes the tableview as well as makes sure it starts from the top (instead of somewhere in the middle)
    [mainDelegate.venueViewController refreshScreen];
    [self.navigationController pushViewController:mainDelegate.venueViewController animated:YES];
}


@end