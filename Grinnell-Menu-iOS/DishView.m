//
//  DishView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "DishView.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Venue.h"

@implementation DishView
@synthesize nutritionDetails, dishRow, dishSection;

- (IBAction)backToMainMenu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)toVenueView:(id)sender{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES]; 
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:dishSection];
    Dish *dish = [venue.dishes objectAtIndex:dishRow];
    nutritionDetails.text = dish.nutrition;
    self.title = dish.name;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    //Navigate to Main Menu
    UIBarButtonItem *toMainMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMainMenu:)];
    [self.navigationItem setRightBarButtonItem:toMainMenuButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
