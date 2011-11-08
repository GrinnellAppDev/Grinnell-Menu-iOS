//
//  VenueView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "VenueView.h"
#import "DishView.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Filter.h"

@implementation VenueView 

@synthesize newTableView, dishInd, indPath;

- (IBAction)showTray:(id)sender
{    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.fromDishView = @"No";
    [mainDelegate flipToTray];
}

- (IBAction)showInfo:(id)sender
{    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [mainDelegate flipToSettings];
}


- (void)viewDidLoad {    
    [super viewDidLoad];
    venues = [[NSArray alloc] initWithObjects:@"Honor Grill", @"8th Ave. Deli", @"Wok", @"Desserts", @"Pizza", @"Pasta", @"Plat du Jour", @"Vegan Bar", nil];
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.trayDishes = [[NSMutableArray alloc] init];
    
    mainDelegate.filters = [[NSMutableArray alloc] init];
    Filter *filter;
    filter = [[Filter alloc]  init];
    filter.name = @"All";
    filter.isChecked = YES;
    [mainDelegate.filters addObject:filter];
    filter = [[Filter alloc]  init];
    filter.name = @"Vegetarian";
    filter.isChecked = YES;
    [mainDelegate.filters addObject:filter];
    filter = [[Filter alloc]  init];
    filter.name = @"Vegan";
    filter.isChecked = YES;
    [mainDelegate.filters addObject:filter];
    filter = [[Filter alloc]  init];
    filter.name = @"Food Containing Nuts";
    filter.isChecked = YES;
    [mainDelegate.filters addObject:filter];
    filter = [[Filter alloc]  init];
    filter.name = @"Gluten Free";
    filter.isChecked = YES;
    [mainDelegate.filters addObject:filter];
    
    mainDelegate.dishes = [[NSMutableArray alloc] init];
    Dish *dish;
    dish = [[Dish alloc] init];
    dish.name = @"dish1";
    dish.isChecked = NO;
    dish.venue = @"Honor Grill";
    dish.details = @"dish1 details are...";
    dish.nutrition = @"dish1 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    [mainDelegate.dishes addObject:dish];
    
    dish = [[Dish alloc] init];
    dish.name = @"dish2";
    dish.isChecked = NO;
    dish.venue = @"Honor Grill";
    dish.details = @"dish2 details are...";
    dish.nutrition = @"dish2 nutrition is...";
    dish.nutAllergen = YES;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    [mainDelegate.dishes addObject:dish];

    dish = [[Dish alloc] init];
    dish.name = @"dish3";
    dish.isChecked = NO;
    dish.venue = @"Honor Grill";
    dish.details = @"dish3 details are...";
    dish.nutrition = @"dish3 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    [mainDelegate.dishes addObject:dish];

    dish = [[Dish alloc] init];
    dish.name = @"dish4";
    dish.isChecked = NO;
    dish.venue = @"Desserts";
    dish.details = @"dish4 details are...";
    dish.nutrition = @"dish4 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    [mainDelegate.dishes addObject:dish];

    dish = [[Dish alloc] init];
    dish.name = @"dish5";
    dish.isChecked = NO;
    dish.venue = @"Desserts";
    dish.details = @"dish5 details are...";
    dish.nutrition = @"dish5 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    [mainDelegate.dishes addObject:dish];

    self.title = @"Venues";
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [newTableView reloadData];
    [super viewWillAppear:YES];
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
    return venues.count;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
	if ( section == 0 ) return @"Honor Grill";
	if ( section == 1 ) return @"8th Ave. Deli";
	if ( section == 2 ) return @"Wok";
	if ( section == 3 ) return @"Desserts";
	if ( section == 4 ) return @"Pizza";
	if ( section == 5 ) return @"Pasta";
    if ( section == 6 ) return @"Plat du Jour";
    if ( section == 7 ) return @"Vegan Bar";
	return @"Other";
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    //FIX THIS
	if ( section == 0 ) return 3;
	if ( section == 1 ) return 0;
	if ( section == 2 ) return 0;
	if ( section == 3 ) return 2;
	if ( section == 4 ) return 0;
	if ( section == 5 ) return 0;
    if ( section == 6 ) return 0;
    if ( section == 7 ) return 0;
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UILongPressGestureRecognizer *longPressGesture =
        [[[UILongPressGestureRecognizer alloc]
          initWithTarget:self action:@selector(longPress:)] autorelease];
		[cell addGestureRecognizer:longPressGesture];
    }
    
    // Configure the cell...
    int theRow = [self getRow:indexPath.row inSection:indexPath.section];
    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //FILTERS
    Filter *allFilter = [mainDelegate.filters objectAtIndex:0];
    Filter *vegetFilter = [mainDelegate.filters objectAtIndex:1];
    Filter *veganFilter = [mainDelegate.filters objectAtIndex:2];
    Filter *nutFilter = [mainDelegate.filters objectAtIndex:3];
    Filter *glutenFilter = [mainDelegate.filters objectAtIndex:4];
    if (allFilter.isChecked){}
    else if(!vegetFilter.isChecked){
        //handle it
    }
    else if(!veganFilter.isChecked){
        //handle it
    }
    else if(!nutFilter.isChecked){
        //handle it
    }
    else if(!glutenFilter.isChecked){
        //handle it
    }

    Dish *dish = [mainDelegate.dishes objectAtIndex:theRow];

    cell.textLabel.text = dish.name;
    
    if([mainDelegate.trayDishes containsObject:dish.name]){
        dish.isChecked = YES;
    }
    else{
        dish.isChecked = NO;
    }
    
    [self configureCheckmarkForCell:cell withDish:dish];
     // accessory type
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
     
    return cell;
}


-(void)configureCheckmarkForCell:(UITableViewCell *)cell withDish:(Dish *)dish
{
    UIImage *checkmark = [UIImage imageNamed:@"checkmark.png"];
    UIImage *checkmark_blank = [UIImage imageNamed:@"checkmark_blank.png"];
    if (dish.isChecked) {
        cell.imageView.image = checkmark;
    }
    else{
        cell.imageView.image = checkmark_blank;
    }
}
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [newTableView indexPathForCell:cell];
        int theRow = [self getRow:indexPath.row inSection:indexPath.section];

        dishInd = theRow;
        indPath = indexPath;
		// do something with this action
        UIAlertView *addMultiple = [[UIAlertView alloc] initWithTitle:@"Servings?" message:nil delegate:self cancelButtonTitle:@"0" otherButtonTitles:@"1", @"2", @"3", nil];
        [addMultiple show];
        [addMultiple release];
    }
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Dish *dish = [mainDelegate.dishes objectAtIndex:dishInd];

    if (buttonIndex == 0) {
        [mainDelegate.trayDishes removeObject:dish.name];
        dish.isChecked = NO;
    }
    else if (buttonIndex == 1){
        [mainDelegate.trayDishes addObject:dish.name];
        dish.isChecked = YES;
    }    
    else if (buttonIndex == 2){
        [mainDelegate.trayDishes addObject:dish.name];
        [mainDelegate.trayDishes addObject:dish.name];
        dish.isChecked = YES;
    }
    else if (buttonIndex == 3){
        [mainDelegate.trayDishes addObject:dish.name];
        [mainDelegate.trayDishes addObject:dish.name];
        [mainDelegate.trayDishes addObject:dish.name];
        dish.isChecked = YES;
    }
    UITableViewCell *cell = [newTableView cellForRowAtIndexPath:indPath];
    [self configureCheckmarkForCell:cell withDish:dish];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int theRow = [self getRow:indexPath.row inSection:indexPath.section];
    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Dish *dish = [mainDelegate.dishes objectAtIndex:theRow];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (dish.isChecked)
    {
        dish.isChecked = NO;
        [mainDelegate.trayDishes removeObject:dish.name];
    }
    else
    {
        dish.isChecked = YES;
        [mainDelegate.trayDishes addObject:dish.name];
    }
    [self configureCheckmarkForCell:cell withDish:dish];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Configure the cell...
    int theRow = [self getRow:indexPath.row inSection:indexPath.section];

    
	Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.dishIndex = theRow;
    mainDelegate.navStyle = @"pushed_from_venue";

    DishView *dishView = 
	[[DishView alloc] initWithNibName:@"DishView" bundle:nil];
	[self.navigationController pushViewController:dishView animated:YES];
    [dishView release];
}


- (void)dealloc {
    [indPath release];
    [newTableView release];
    [venues release];
    [super dealloc];
}

- (int)getRow:(NSInteger)row inSection:(NSInteger)section{
    int theRow = row;
    if ( section == 1 ) theRow += 3;
    if ( section == 2 ) theRow += 3;
    if ( section == 3 ) theRow += 3;
    if ( section == 4 ) theRow += 3;
    if ( section == 5 ) theRow += 5;
    if ( section == 6 ) theRow += 5;
    if ( section == 7 ) theRow += 5;
    return theRow;
}
@end