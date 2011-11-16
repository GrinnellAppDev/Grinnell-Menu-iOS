//
//  VenueView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "VenueView.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Filter.h"
#import "Venue.h"
#import "Settings.h"

@implementation VenueView 

@synthesize newTableView, alert, originalVenues;


- (IBAction)showInfo:(id)sender
{    
   
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
    UIBarButtonItem *changeMeal = [[UIBarButtonItem alloc] initWithTitle:@"Change Meal" style:UIBarButtonItemStyleBordered target:self action:@selector(changeMeal:)];
    [self.navigationItem setRightBarButtonItem:changeMeal];
    
    [super viewDidLoad];
 
    originalVenues = [[NSMutableArray alloc] init];
    mainDelegate.venues = [[NSMutableArray alloc] init];
    Dish *dish;
    dish = [[Dish alloc] init];
    dish.name = @"dish1";
    dish.venue = @"Honor Grill";
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
    dish.venue = @"Honor Grill";
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
    dish.venue = @"Honor Grill";
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
    dish.venue = @"Desserts";
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
    dish.venue = @"Wok";
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
    dish.venue = @"Wok";
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
    dish.venue = @"Wok";
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
    dish.venue = @"Deli";
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
            dish.nutAllergen = d.nutAllergen;
            dish.glutenFree = d.glutenFree;
            dish.vegetarian = d.vegetarian;
            dish.vegan = d.vegan;
            [venue.dishes addObject:dish];
        }
        [mainDelegate.venues addObject:venue];
        [venue release];
    }

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
    
    //Remove empty venues if all items are filtered out of a venue
    int i;
    for (i=0; i<mainDelegate.venues.count; i++) {
        Venue *v = [[Venue alloc] init];
        v = [mainDelegate.venues objectAtIndex:i];
        if (v.dishes.count == 0) {
            [mainDelegate.venues removeObjectAtIndex:i];
        }
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    // Configure the cell...    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:indexPath.section];
    Dish *dish = [venue.dishes objectAtIndex:indexPath.row];

    cell.textLabel.text = dish.name;
       
     // accessory type
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
    return cell;
}



#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
          if (buttonIndex == 0) {
        }
        else{
            //get new data
        }
    [newTableView reloadData];
}

- (void)dealloc {
    [originalVenues release];
    [alert release];
    [newTableView release];
    [super dealloc];
}
@end