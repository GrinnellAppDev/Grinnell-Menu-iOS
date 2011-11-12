//
//  Tray.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Tray.h"
#import "DishView.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "VenueView.h"
#import "Venue.h"

@implementation Tray

@synthesize newTableView, totalNutrition, editStyle, plusButton;

- (IBAction) editTable:(id)sender {
    editStyle = @"delete";
    if(self.editing){
        [super setEditing:NO animated:NO];
        [newTableView setEditing:NO animated:NO];
        [newTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        [super setEditing:YES animated:YES];
        [newTableView setEditing:YES animated:YES];
        [newTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([editStyle isEqualToString:@"insert"])
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
}

- (IBAction)toVenueView:(id)sender
{
    [self.navigationController popToViewController:    [self.navigationController.viewControllers objectAtIndex:1] animated:YES]; 
}

- (IBAction)clearTray:(id)sender{
    
    UIAlertView *clear = [[UIAlertView alloc] 
                         initWithTitle:@"Clear Tray?" 
                         message:nil 
                         delegate:self 
                         cancelButtonTitle:@"Clear" 
                         otherButtonTitles:@"Cancel", nil
                         ];
    [clear show];
    [clear release];
}

- (IBAction)addDish:(id)sender{
    editStyle = @"insert";
    if(self.editing){
        [super setEditing:NO animated:NO];
        [newTableView setEditing:NO animated:NO];
        [newTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        [super setEditing:YES animated:YES];
        [newTableView setEditing:YES animated:YES];
        [newTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
    }
    else {
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (mainDelegate.trayDishes.count == 0) {
        }
        else{
            [mainDelegate.trayDishes removeAllObjects];
        }
        [newTableView reloadData];
    }
}


- (void)dealloc
{
    [plusButton release];
    [editStyle release];
    [totalNutrition release];
    [newTableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{     
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    //Edit Button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editTable:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    //toVenueView
    if ([mainDelegate.trayDishes containsObject:mainDelegate.fromDishView])
    {
        UIBarButtonItem *toVenueViewButton = [[UIBarButtonItem alloc] initWithTitle:@"Venues" style:UIBarButtonItemStyleBordered target:self action:@selector(toVenueView:)];
        [self.navigationItem setLeftBarButtonItem:toVenueViewButton]; 
    }
    [super viewDidLoad];
    self.title = @"Your Tray";

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    totalNutrition.text = @"Total Nutrition is...";
    [newTableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    return mainDelegate.trayDishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [mainDelegate.trayDishes objectAtIndex:indexPath.row];
    return cell;
}

                   
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // Navigation logic may go here. Create and push another view controller.
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *dishName = [mainDelegate.trayDishes objectAtIndex:indexPath.row];
   
    for (Venue *v in mainDelegate.venues) {
        for (Dish *d in v.dishes){
            if([d.name isEqualToString:dishName]){
                mainDelegate.dishSection = [mainDelegate.venues indexOfObject:v];
                mainDelegate.dishRow = [v.dishes indexOfObject:d];
            }
        }
    }
    

    
    if ([mainDelegate.trayDishes containsObject:mainDelegate.fromDishView])
    {
        mainDelegate.navStyle = @"popped";
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        mainDelegate.navStyle = @"pushed_from_tray";
        DishView *dishView = 
        [[DishView alloc] initWithNibName:@"DishView" bundle:nil];
        [self.navigationController pushViewController:dishView animated:YES];
        [dishView release];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [mainDelegate.trayDishes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:([[NSArray alloc] initWithObjects:indexPath, nil])withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        [mainDelegate.trayDishes insertObject:[mainDelegate.trayDishes objectAtIndex:indexPath.row] atIndex:indexPath.row];
        [tableView reloadData];
    }
}


@end
