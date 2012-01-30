//
//  RootViewController.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "RootViewController.h"
#import "VenueView.h"

@implementation RootViewController
{
    NSString *alert;
  //  NSDictionary *jsonDict;
    NSURL *URLwithDate;
}

@synthesize go, datePicker, jsonDict;


-(void)fetchprelimdataWithURL:(NSURL *)URL
{
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


- (BOOL)networkCheck
{
    //CHECK NETWORK
    NSString *urlStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSASCIIStringEncoding error:NULL];
    return (urlStr != NULL);
}

/*
 Need this? 
- (void) venueViewDidFinish:(VenueView *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}
 */

- (IBAction)showVenues:(id)sender
{
    if (self.networkCheck) 
    {
        
        NSDate *date = [self.datePicker date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
        NSInteger day = [components day];    
        NSInteger month = [components month];
        NSInteger year = [components year];
        
        NSMutableString *url = [NSMutableString stringWithFormat:@"http://www.cs.grinnell.edu/~knolldug/parser/menu.php?year=%d&mon=%d&day=%d", year, month, day];
        URLwithDate = [NSURL URLWithString:url];

        [self fetchprelimdataWithURL:URLwithDate];
        
        UIAlertView *mealmessage = [[UIAlertView alloc] 
                                    initWithTitle:@"Select Meal" 
                                    message:nil
                                    delegate:self 
                                    cancelButtonTitle:@"Cancel" 
                                    otherButtonTitles:nil
                                    ];
        
        
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
    
    //Else if there is not network connection determined... 
    else
    {
        alert = @"network";
        UIAlertView *network = [[UIAlertView alloc] 
                            initWithTitle:@"No Network Connection" 
                            message:nil
                            delegate:self 
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil
                            ];
        [network show];

    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //setDate:(NSDate *)date animated:YES;
    self.title = @"Dining Menu";
}


- (void)viewWillAppear:(BOOL)animated{
    
    if(!self.networkCheck)
    {
        alert = @"network";
        UIAlertView *network = [[UIAlertView alloc] 
                                initWithTitle:@"No Network Connection" 
                                message:nil
                                delegate:self 
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil
                                ];
        [network show];
    }
        
        
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [datePicker setMinimumDate:now];
    
    //Set the maximum date based on the number of days past the current date that can be accessed
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    int day;
    
    switch (weekday) {
            //sunday
        case 1:
            day = 6;
            break;
            //monday
        case 2:
            day = 5;
            break;
            //tuesday
        case 3:
            day = 4;
            break;
            //wednesday
        case 4:
            day = 3;
            break;
            //thursday
        case 5:
            day = 2;
            break;
            //friday
        case 6:
            day = 1;
            break;
        case 7:
            //saturday
            day = 7;
            break;
        default:
            break;
    }
    
    int range = 24 * 60 * 60 * day;
    NSDate *max = [[NSDate alloc] initWithTimeIntervalSinceNow:range];

    [datePicker setMaximumDate:max];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.datePicker = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if ([alert isEqualToString:@"mealmessage"]){
        
    VenueView *venueView = 
    [[VenueView alloc] initWithNibName:@"VenueView" bundle:nil];
   // venueView.date = [[NSDate alloc] init];
   // venueView.date = datePicker.date;
    

    venueView.jsonDict = [[NSDictionary alloc] initWithDictionary:self.jsonDict];
    
     
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        return;
    }
    
    
    NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
    venueView.mealChoice = titlePressed;
    [self.navigationController pushViewController:venueView animated:YES];

    

}


@end