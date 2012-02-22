//
//  DishView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "DishViewController.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Venue.h"

@implementation DishViewController
@synthesize nutritionDetails, dishRow, dishSection;

- (IBAction)backToMainMenu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)toVenueView:(id)sender{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES]; 
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
    //Main Menu button
    UIBarButtonItem *toMainMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMainMenu:)];
    [self.navigationItem setRightBarButtonItem:toMainMenuButton];
    
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
