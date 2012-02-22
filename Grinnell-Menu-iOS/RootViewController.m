//
//  RootViewController.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "RootViewController.h"
#import "VenueViewController.h"
#import "Reachability.h"

@implementation RootViewController {
    NSString *alert;
    NSURL *URLwithDate;
    BOOL notFirstTime;
}

@synthesize go, datePicker, jsonDict;

//Fetches the data from server. jsonDict is passed on to VenueViewController. 
-(void)fetchprelimdataWithURL:(NSURL *)URL {
    NSData *data = [NSData dataWithContentsOfURL:URL];
    
    NSError * error;
    
    //NSJSON takes data and then gives you back a foundation object. dict or array. 
    self.jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                               options:kNilOptions 
                                                 error:&error];
    if (error) {
        NSLog(@"Could not fetch data");
    }
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return (!(networkStatus == NotReachable));
}


- (IBAction)showVenues:(id)sender {
    if (self.networkCheck) {
        NSDate *date = [self.datePicker date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
        NSInteger day = [components day];    
        NSInteger month = [components month];
        NSInteger year = [components year];
        
        NSMutableString *url = [NSMutableString stringWithFormat:@"http://www.cs.grinnell.edu/~knolldug/parser/%d-%d-%d.json", month, day, year];
        URLwithDate = [NSURL URLWithString:url];

        [self fetchprelimdataWithURL:URLwithDate];
        
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
    
    //Else if there is not network connection determined... give No Network Connection alert
    else{
        alert = @"network";
        UIAlertView *network = [[UIAlertView alloc] 
                            initWithTitle:@"No Network Connection" 
                            message:@"Turn on cellular data or use Wi-Fi to access data"                            delegate:self 
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil
                            ];
        [network show];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dining Menu";
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.networkCheck) {
    if (!notFirstTime){
        NSDate *now = [[NSDate alloc] init];
        
        [datePicker setDate:now animated:YES];
       [datePicker setMinimumDate:now];    
        
        //Determines the available days to appropriately set the datePicker
        NSURL *datesURL = [NSURL URLWithString:@"http://www.cs.grinnell.edu/~knolldug/parser/available_days_json.php"];
        NSError *error;
    
        NSData *data = [NSData dataWithContentsOfURL:datesURL];
    
        
        NSDictionary *JSONdic = [[NSDictionary alloc] init];
    
        @try {
            JSONdic = [NSJSONSerialization JSONObjectWithData:data
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
        NSString *dayStr = [JSONdic objectForKey:@"days"];
        int day = dayStr.intValue;
        if (day < 0) {
            alert = @"network";
            UIAlertView *network = [[UIAlertView alloc] 
                                initWithTitle:@"No Menus Found" 
                                message:@"Please check back later"
                                delegate:self 
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil
                                ];
            [network show];
            go.enabled = NO;
        
        }
        
        int range = 24 * 60 * 60 * day;
        NSDate *max = [[NSDate alloc] initWithTimeIntervalSinceNow:range];

        [datePicker setMaximumDate:max];
        notFirstTime = YES;
    }
}
    else{
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


- (void)viewDidUnload{
    [super viewDidUnload];
    self.datePicker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alert == @"server"){
        exit(0);
    }
    VenueViewController *venueView = 
    [[VenueViewController alloc] initWithNibName:@"VenueView" bundle:nil];
    
    venueView.jsonDict = [[NSDictionary alloc] initWithDictionary:self.jsonDict];
    
    if (buttonIndex == alertView.cancelButtonIndex)    {
        return;
    }
    
    NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
    venueView.mealChoice = titlePressed;
    [self.navigationController pushViewController:venueView animated:YES];
}


@end