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
        NSString *dateString;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"'mon='MM'&day='d'&year='yyyy"];
        dateString = [formatter stringFromDate:date];
        
        // NSLog(@"Date String is %@", dateString);
        
        NSString *mainURL = [NSString stringWithFormat:@"http://www.cs.grinnell.edu/~knolldug/parser/menu.php?"];
        NSString *StringWithDate = [mainURL stringByAppendingString:dateString];
        URLwithDate = [NSURL URLWithString:StringWithDate];

        
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
        [network release];
    }
        
    
    //I've commented this out just to test the datePicker with Dec01-Dec15 past dates. 
    
    /*
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [datePicker setMinimumDate:now];
    
    //Set the maximum date based on the number of days past the current date that can be accessed.
    int days = 7;
    int range = 24 * 60 * 60 * days;
    NSDate *max = [[NSDate alloc] initWithTimeIntervalSinceNow:range];
    
    [datePicker setMaximumDate:max];
    [now release];
     */
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