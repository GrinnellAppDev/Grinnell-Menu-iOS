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
#import "Venue.h"
#import "Settings.h"
#import "Tray.h"
@implementation VenueView 

@synthesize newTableView, alert, originalVenues, dishRow, dishSection, fromSettings;

- (IBAction)showTray:(id)sender
{    
    Tray *tray = [[Tray alloc] initWithNibName:@"Tray" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tray];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    tray.buttonTitle = self.title;
    [self presentModalViewController:navController animated:YES];
    [tray release];
}

- (IBAction)showInfo:(id)sender
{    
    fromSettings = YES;
    
    Settings *settings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
        
    [settings release];
}

- (IBAction)changeMeal:(id)sender{
    alert = @"meal";
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

- (void)viewDidLoad {
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.selectedDish = NO;
    UIBarButtonItem *changeMeal = [[UIBarButtonItem alloc] initWithTitle:@"Change Meal" style:UIBarButtonItemStyleBordered target:self action:@selector(changeMeal:)];
    [self.navigationItem setRightBarButtonItem:changeMeal];
    
    [super viewDidLoad];
    
    fromSettings = YES;
    mainDelegate.trayDishes = [[NSMutableArray alloc] init];
    originalVenues = [[NSMutableArray alloc] init];
    mainDelegate.venues = [[NSMutableArray alloc] init];
    Dish *dish;
    dish = [[Dish alloc] init];
    dish.name = @"dish1";
    dish.isChecked = NO;
    dish.venue = @"Honor Grill";
    dish.details = @"dish1 details are...";
    dish.nutrition = @"dish1 nutrition is...";
    dish.nutAllergen = YES;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    
    int j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    
    dish = [[Dish alloc] init];
    dish.name = @"dish2";
    dish.isChecked = NO;
    dish.venue = @"Honor Grill";
    dish.details = @"dish2 details are...";
    dish.nutrition = @"dish2 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = YES;
    dish.vegetarian = NO;
    dish.vegan = NO;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    
    dish = [[Dish alloc] init];
    dish.name = @"dish3";
    dish.isChecked = NO;
    dish.venue = @"Honor Grill";
    dish.details = @"dish3 details are...";
    dish.nutrition = @"dish3 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = YES;
    dish.vegan = NO;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    
    dish = [[Dish alloc] init];
    dish.name = @"dish4";
    dish.isChecked = NO;
    dish.venue = @"Desserts";
    dish.details = @"dish4 details are...";
    dish.nutrition = @"dish4 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = YES;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    
    dish = [[Dish alloc] init];
    dish.name = @"dish5";
    dish.isChecked = NO;
    dish.venue = @"Wok";
    dish.details = @"dish5 details are...";
    dish.nutrition = @"dish5 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    dish = [[Dish alloc] init];
    dish.name = @"dish6";
    dish.isChecked = NO;
    dish.venue = @"Wok";
    dish.details = @"dish6 details are...";
    dish.nutrition = @"dish6 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    dish = [[Dish alloc] init];
    dish.name = @"dish7";
    dish.isChecked = NO;
    dish.venue = @"Wok";
    dish.details = @"dish7 details are...";
    dish.nutrition = @"dish7 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = YES;
    dish.vegetarian = NO;
    dish.vegan = YES;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    dish = [[Dish alloc] init];
    dish.name = @"dish8";
    dish.isChecked = NO;
    dish.venue = @"Deli";
    dish.details = @"dish8 details are...";
    dish.nutrition = @"dish8 nutrition is...";
    dish.nutAllergen = NO;
    dish.glutenFree = NO;
    dish.vegetarian = NO;
    dish.vegan = NO;
    j=1;    
    for (Venue *x in mainDelegate.venues) {
        if ([x.name isEqualToString:dish.venue]){
            [x.dishes addObject:dish];
            j=0;
        }
    }
    if (j){
        Venue *venue = [[Venue alloc] init];
        venue.name = dish.venue;
        [venue.dishes addObject:dish];
        [mainDelegate.venues addObject:venue];
    }
    
    for (Venue *v in mainDelegate.venues) {
        Venue *venue = [[Venue alloc] init];
        venue.name = v.name;
        for (Dish *d in v.dishes) {
            Dish *dish = [[Dish alloc] init];
            dish.name = d.name;
            dish.venue = d.venue;
            dish.details = d.details;
            dish.nutrition = d.nutrition;
            dish.isChecked = d.isChecked;
            dish.nutAllergen = d.nutAllergen;
            dish.glutenFree = d.glutenFree;
            dish.vegetarian = d.vegetarian;
            dish.vegan = d.vegan;
            [venue.dishes addObject:dish];
        }
        [originalVenues addObject:venue];
        [venue release];
    }
    
    
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
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (mainDelegate.selectedDish){
        DishView *dishView = [[DishView alloc] initWithNibName:@"DishView" bundle:nil];
        for (Venue *v in mainDelegate.venues) {
            for (Dish *d in v.dishes){
                if([d.name isEqualToString:mainDelegate.dishName]){
                    dishView.dishSection = [mainDelegate.venues indexOfObject:v];
                    dishView.dishRow = [v.dishes indexOfObject:d];
                }
            }
        }
        [self.navigationController pushViewController:dishView animated:NO];
        [dishView release];
    }
    
    
    //PUT FILTERS IN ARRAY AND ITERATE THROUGH IT TO SET THEM
    BOOL allFilter, vegetFilter, veganFilter, nutFilter, wfgfFilter;
    NSPredicate *vegetPred, *veganPred, *wfgfPred, *nutPred;
    
    for (int i=0; i<mainDelegate.filters.count; i++) {
        Filter *filter = [mainDelegate.filters objectAtIndex:i];
        switch (i) {
            case 0:
                allFilter = filter.isChecked;
                break;
            case 1:
                vegetFilter = filter.isChecked;
                break;
            case 2:
                veganFilter = filter.isChecked;
                break;
            case 3:
                nutFilter = filter.isChecked;
                break;
            case 4:
                wfgfFilter = filter.isChecked;
                break;
            default:
                break;
        }
    }
    
    
    [mainDelegate.venues removeAllObjects];
    for (Venue *v in originalVenues) {
        Venue *venue = [[Venue alloc] init];
        venue.name = v.name;
        for (Dish *d in v.dishes) {
            Dish *dish = [[Dish alloc] init];
            dish.name = d.name;
            dish.venue = d.venue;
            dish.details = d.details;
            dish.nutrition = d.nutrition;
            dish.isChecked = d.isChecked;
            dish.nutAllergen = d.nutAllergen;
            dish.glutenFree = d.glutenFree;
            dish.vegetarian = d.vegetarian;
            dish.vegan = d.vegan;
            [venue.dishes addObject:dish];
        }
        [mainDelegate.venues addObject:venue];
        [venue release];
    }
    if (fromSettings){
    if (allFilter){
    }
    else if (!nutFilter && veganFilter && vegetFilter && wfgfFilter){
        nutPred = [NSPredicate predicateWithFormat:@"nutAllergen == NO"];
        for (Venue *v in mainDelegate.venues) {
            [v.dishes filterUsingPredicate:nutPred];
        }
    }
    else{
        NSMutableArray *preds = [[NSMutableArray alloc] init];
        [preds removeAllObjects];
        if (vegetFilter){
            vegetPred = [NSPredicate predicateWithFormat:@"vegetarian == YES"];
            [preds addObject:vegetPred];
        }
        if (veganFilter){
            veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
            [preds addObject:veganPred];
        }
        if (wfgfFilter){
            wfgfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
            [preds addObject:wfgfPred];
        }
        
        NSPredicate *compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
        
        for (Venue *v in mainDelegate.venues){
            [v.dishes filterUsingPredicate:compoundPred];
        }
            
        if (!nutFilter){
            nutPred = [NSPredicate predicateWithFormat:@"nutAllergen == NO"];
            for (Venue *v in mainDelegate.venues) {
                [v.dishes filterUsingPredicate:nutPred];
            }
        }
        [preds release];
    }
        fromSettings = NO;
    }
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
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];

    return mainDelegate.venues.count;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];

    Venue *venue = [mainDelegate.venues objectAtIndex:section];
    return venue.name; 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:section];
    return venue.dishes.count;
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
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:indexPath.section];
    Dish *dish = [venue.dishes objectAtIndex:indexPath.row];

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
    alert = @"servings";
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [newTableView indexPathForCell:cell];
        dishRow = indexPath.row;
        dishSection = indexPath.section;
		// do something with this action
        UIAlertView *addMultiple = [[UIAlertView alloc] initWithTitle:@"Servings?" message:nil delegate:self cancelButtonTitle:@"0" otherButtonTitles:@"1", @"2", @"3", nil];
        [addMultiple show];
        [addMultiple release];
    }
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alert isEqualToString:@"servings"])
    {
        Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
        Venue *venue = [mainDelegate.venues objectAtIndex:dishSection];
        Dish *dish = [venue.dishes objectAtIndex:dishRow];
        if (buttonIndex == 0) {
            [mainDelegate.trayDishes removeObject:dish.name];
            dish.isChecked = NO;
        }
        else{
            for (int i=0; i<buttonIndex; i++) {
                [mainDelegate.trayDishes addObject:dish.name];
            }
            dish.isChecked = YES;
        }
    }
    else if ([alert isEqualToString:@"meal"]){
        if (buttonIndex == 0) {
        }
        else{
            //get new data
        }
    }
    [newTableView reloadData];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Venue *venue = [mainDelegate.venues objectAtIndex:indexPath.section];
    Dish *dish = [venue.dishes objectAtIndex:indexPath.row];    
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
    DishView *dishView = 
	[[DishView alloc] initWithNibName:@"DishView" bundle:nil];
    dishView.dishRow = indexPath.row;
    dishView.dishSection = indexPath.section;
    

	[self.navigationController pushViewController:dishView animated:YES];
    [dishView release];
}


- (void)dealloc {
    [originalVenues release];
    [alert release];
    [newTableView release];
    [super dealloc];
}
@end