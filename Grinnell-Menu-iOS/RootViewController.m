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
@synthesize go;

- (void) venueViewDidFinish:(VenueView *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showVenues:(id)sender
{
    UIAlertView *meal = [[UIAlertView alloc] 
						  initWithTitle:@"Select Meal" 
						  message:nil 
						  delegate:self 
						  cancelButtonTitle:@"Cancel" 
                          otherButtonTitles:@"Breakfast", @"Lunch", @"Dinner", nil
                         ];
    [meal show];
    [meal release];
}


- (void)dealloc
{
    [go release];
    [super dealloc];
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
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [datePicker setMinimumDate:now];
    
    //Set the maximum date based on the number of days past the current date that can be accessed.
    int days = 7;
    int range = 24 * 60 * 60 * days;
    NSDate *max = [[NSDate alloc] initWithTimeIntervalSinceNow:range];
    
    [datePicker setMaximumDate:max];
    [now release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    VenueView *venueView = 
    [[VenueView alloc] initWithNibName:@"VenueView" bundle:nil];
    venueView.date = datePicker.date;
    if (buttonIndex == 0) {
    }
    else if (buttonIndex == 1){
        venueView.meal = @"Breakfast";
        [self.navigationController pushViewController:venueView animated:YES];
    }
    else if (buttonIndex == 2){
        venueView.meal = @"Lunch";
        [self.navigationController pushViewController:venueView animated:YES];
    }    
    else if (buttonIndex == 3){
        venueView.meal = @"Dinner";
        [self.navigationController pushViewController:venueView animated:YES];
    }
    [venueView release];
}

@end