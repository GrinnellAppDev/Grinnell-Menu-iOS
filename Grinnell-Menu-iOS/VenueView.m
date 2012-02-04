//
//  VenueView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

//FOR TESTING
#define kDiningMenu [NSURL URLWithString:@"http://www.cs.grinnell.edu/~knolldug/parser/menu.php?mon=12&day=14&year=2011"]

#import "VenueView.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Venue.h"
#import "Settings.h"
#import "DishView.h"

@implementation VenueView{
    NSArray *menuVenueNamesFromJSON;
   // NSDictionary *jsonDict;
    NSMutableArray *originalVenues;
    NSString *alert;
}

@synthesize anotherTableView, date, mealChoice, mainURL, jsonDict;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//We add this method here because when the VenueviewController is waking up. Turning on screen. We would also like to take advantage of that and do some initialization of our own. i.e loading the items
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    if ((self = [super initWithCoder:aDecoder])) {         
    }
    return self;
}

-(void)getDishes
{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [originalVenues removeAllObjects];
    [mainDelegate.venues removeAllObjects];
    
    /*
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger day = [components day];    
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://www.cs.grinnell.edu/~knolldug/parser/menu.php?year=%d&mon=%d&day=%d", year, month, day];
    
    mainURL = [NSURL URLWithString:url];
    //COMMENTED FOR TESTING SO WE GET A USABLE DATE
    //NSData *data = [NSData dataWithContentsOfURL:mainURL];
    NSData *data = [NSData dataWithContentsOfURL:kDiningMenu];

    NSError *error;
    //NSJSON takes data and then gives you back a founddation object. dict or array. 
    jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                               options:kNilOptions //if you're not only reading but going to modify the objects after reading them, you'd want to pass in the right options. (NSJSONReadingMutablecontainers.. etc
                                                 error:&error];
     */

    NSString *key = [[NSString alloc] init];
    if ([self.mealChoice isEqualToString:@"Breakfast"]) {
        key = @"BREAKFAST";
    } else if ([self.mealChoice isEqualToString:@"Lunch"]) {
        key = @"LUNCH";
    } else if ([self.mealChoice isEqualToString:@"Dinner"]) {
        key = @"DINNER";
    } else if ([self.mealChoice isEqualToString:@"Outtakes"]) {
        key = @"OUTTAKES";
    }
        
    NSDictionary *mainMenu = [self.jsonDict objectForKey:key]; 
    
    //Let's put some data on our screen
    //This is a dictionary of dictionaries. Each venue is a key in the main dictionary. Thus we will have to sort through each venue(dict) the main jsondict(dict) and create dish objects for each object that is in the venue. 
    
    menuVenueNamesFromJSON = [[NSArray alloc] init];
    menuVenueNamesFromJSON = [mainMenu allKeys];
    
    //Here we fill the venues array to contain all the venues. 
    for (NSString *venuename in menuVenueNamesFromJSON) {
        Venue *gvenue = [[Venue alloc] init];
        gvenue.name = venuename;
        [mainDelegate.venues addObject:gvenue];
    }
    
    //So for each Venue...
    for (Venue *gVenue in mainDelegate.venues) {
        //We create a dish
        gVenue.dishes = [[NSMutableArray alloc] initWithCapacity:10];
        NSArray *dishesInVenue = [mainMenu objectForKey:gVenue.name];
        
        for (int i = 0; i < dishesInVenue.count; i++) {
            Dish *dish = [[Dish alloc] init];
            //loop through for the number of dishes
            NSDictionary *actualdish = [dishesInVenue objectAtIndex:i];
            
            dish.name = [actualdish objectForKey:@"name"];
            
            if (![[actualdish objectForKey:@"vegan"] isEqualToString:@"false"]) 
                dish.vegan = YES;
            if (![[actualdish objectForKey:@"ovolacto"] isEqualToString:@"false"]) 
                dish.ovolacto = YES;
            //then finally we add this new dish to it's venue
            [gVenue.dishes addObject:dish];
        }
    }
    [originalVenues setArray:mainDelegate.venues];    
    [self applyFilters];
}

- (IBAction)showInfo:(id)sender{    
    Settings *settings = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)changeMeal:(id)sender{
    
    /*
    alert = @"meal";
    UIAlertView *mealSelect = [[UIAlertView alloc] 
                               initWithTitle:@"Select Meal" 
                               message:nil 
                               delegate:self 
                               cancelButtonTitle:@"Cancel" 
                               otherButtonTitles:@"Breakfast", @"Lunch", @"Dinner", @"OutTakes", nil
                               ];
    [mealSelect show];
    
    */
    
    UIAlertView *mealmessage = [[UIAlertView alloc] 
                                initWithTitle:@"Select Meal" 
                                message:nil
                                delegate:self 
                                cancelButtonTitle:@"Cancel" 
                                otherButtonTitles:nil
                                ];
    
    //Completely remove text from JSON output when menu is not present. in other words.. Removes the button from the alert view if no meal is present for that day.    
    if ([jsonDict objectForKey:@"BREAKFAST"]) {
        [mealmessage addButtonWithTitle:@"Breakfast"];
    }
    
    if ([jsonDict objectForKey:@"LUNCH"]) {
        [mealmessage addButtonWithTitle:@"Lunch"];
    }
    if ( [jsonDict objectForKey:@"DINNER"]) {
        [mealmessage addButtonWithTitle:@"Dinner"];
    }
    if ([jsonDict objectForKey:@"OUTTAKES"]) {
        [mealmessage addButtonWithTitle:@"Outtakes"];
    }
    
    [mealmessage show];
}

- (void)viewDidLoad{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *changeMeal = [[UIBarButtonItem alloc] initWithTitle:@"Change Meal" style:UIBarButtonItemStyleBordered target:self action:@selector(changeMeal:)];
    [self.navigationItem setRightBarButtonItem:changeMeal];
    
    [super viewDidLoad];
    
    originalVenues = [[NSMutableArray alloc] init];
    mainDelegate.venues = [[NSMutableArray alloc] init];
    [self getDishes];
    self.title = @"Venues";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //NSLog(@"JsonDict is %@", jsonDict);
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
    [self applyFilters];
    [anotherTableView reloadData];
    [super viewWillAppear:YES];
}

- (void)applyFilters{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSPredicate *veganPred, *ovoPred;
    BOOL ovoSwitch, veganSwitch;
    veganSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"];
    ovoSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"];
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
            dish.ovolacto = d.ovolacto;
            dish.hasNutrition = d.hasNutrition;
            [venue.dishes addObject:dish];
        }
        [mainDelegate.venues addObject:venue];
    }
    
    if (!ovoSwitch && !veganSwitch){
    }
    
    else if (ovoSwitch){
        ovoPred = [NSPredicate predicateWithFormat:@"ovolacto == YES"];
        veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
        
        NSMutableArray *preds = [[NSMutableArray alloc] init];
        [preds removeAllObjects];
        [preds addObject:ovoPred];
        [preds addObject:veganPred];
        NSPredicate *compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
        
        for (Venue *v in mainDelegate.venues){
            [v.dishes filterUsingPredicate:compoundPred];
        }
    }
    
    else if (veganSwitch){
        veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
        for (Venue *v in mainDelegate.venues) {
            [v.dishes filterUsingPredicate:veganPred];
        }
    }
    //Remove empty venues if all items are filtered out of a venue
    NSMutableArray *emptyVenues = [[NSMutableArray alloc] init];
    for (Venue *v in mainDelegate.venues) {
        if (v.dishes.count == 0){
            [emptyVenues addObject:v];
        }
    }
    [mainDelegate.venues removeObjectsInArray:emptyVenues];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    return mainDelegate.venues.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Venue *venue = [mainDelegate.venues objectAtIndex:section];
    return venue.name; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:section];
    return venue.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    // Configure the cell...    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:indexPath.section];
    Dish *dish = [venue.dishes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dish.name;
    
    // accessory type
    if (!dish.hasNutrition){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DishView *dishView = [[DishView alloc] initWithNibName:@"DishView" bundle:nil];
    dishView.dishRow = indexPath.row;
    dishView.dishSection = indexPath.section;
    
	[self.navigationController pushViewController:dishView animated:YES];
}

#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) 
    {
        return;
    }
    else 
    {
        NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
        self.mealChoice = titlePressed;

        [self getDishes];
        [anotherTableView reloadData];
    }
}



@end