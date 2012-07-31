//
//  VenueView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "VenueViewController.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Venue.h"
#import "SettingsViewController.h"
#import "DishViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "FlurryAnalytics.h"

@implementation VenueViewController
{
    NSArray *menuVenueNamesFromJSON;
    NSMutableArray *originalVenues;
    NSString *alert;
    Grinnell_Menu_iOSAppDelegate *mainDelegate;
    
}
@synthesize grinnellDiningLabel;
@synthesize dateLabel;
@synthesize menuchoiceLabel;
@synthesize topImageView;

@synthesize anotherTableView, date, mealChoice, jsonDict;

//We create a second Queue which we is in the multithreaded code when grabbing the dishes.
dispatch_queue_t requestQueue;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Do some initialization of our own
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return (!(networkStatus == NotReachable));
}

//Parse through JSON data downloaded from the server and create dish Objects
-(void)getDishes
{
    [originalVenues removeAllObjects];
    [mainDelegate.venues removeAllObjects];
    
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
    
    //Put data on screen
    //This is a dictionary of dictionaries. Each venue is a key in the main dictionary. Thus we will have to sort through each venue(dict) the main jsondict(dict) and create dish objects for each object that is in the venue. 
    
    menuVenueNamesFromJSON = [[NSArray alloc] init];
    menuVenueNamesFromJSON = [mainMenu allKeys];
    
    //Here we fill the venues array to contain all the venues. 
    for (NSString *venuename in menuVenueNamesFromJSON) {
      //  NSLog(@"venuenames: %@", venuename);
        Venue *gvenue = [[Venue alloc] init];
        gvenue.name = venuename;
        if ([gvenue.name isEqualToString:@"ENTREES                  "] && [key isEqualToString:@"LUNCH"]) {
                continue;
        }
       // NSLog(@"Adding object: %@", gvenue);
        [mainDelegate.venues addObject:gvenue];
    }
    
    //Remove the Entree venue
    [mainDelegate.venues removeObject:@"ENTREES"];
    
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
            if (![[actualdish objectForKey:@"passover"] isEqualToString:@"false"]) 
                dish.passover = YES;
            if (![[actualdish objectForKey:@"halal"] isEqualToString:@"false"]) 
                dish.halal = YES;
            if (![[actualdish objectForKey:@"nutrition"] isKindOfClass:[NSString class]]){
                dish.hasNutrition = YES;
                dish.nutrition = [actualdish objectForKey:@"nutrition"];
            }
            //then finally we add this new dish to it's venue
            [gVenue.dishes addObject:dish];
        }
    }
    [originalVenues setArray:mainDelegate.venues];    
    [self applyFilters];
}

//Flip over to the SettingsViewController
- (IBAction)showInfo:(id)sender
{
    
    // Records when user goes to info Screen, records data in Flurry.
    // Log in to check data analytics at Flurry.com: If you don't have a access. Let me know! @DrJid
    [FlurryAnalytics logEvent:@"Flipped to Settings"];
     
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)changeMeal:(id)sender{
    
    UIAlertView *mealmessage = [[UIAlertView alloc] 
                                initWithTitle:@"Select Meal" 
                                message:nil
                                delegate:self 
                                cancelButtonTitle:@"Cancel" 
                                otherButtonTitles:nil
                                ];
    
    //Removes the button from the alert view if no meal is present for that day.    
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

- (void)viewDidLoad
{
    NSLog(@"VenueView loaded");
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Grabbing Menu";
	
	[HUD showWhileExecuting:@selector(loadNextMenu) onTarget:self withObject:nil animated:YES];
    
//    [self loadNextMenu]; //Called only when the view is loaded initially
    
    
    //We should probably also find a suitable image for Change Meal
    UIBarButtonItem *changeMealButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Meal" style:UIBarButtonItemStyleBordered target:self action:@selector(changeMeal:)];
    [self.navigationItem setRightBarButtonItem:changeMealButton];
    
    
   // The Calendar-Week icon is released under the Creative Commons Attribution 2.5 Canada license. You can find out more about this license by visiting http://creativecommons.org/licenses/by/2.5/ca/. from www.pixelpressicons.com.
//
//    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 25, 25)];
//    [someButton setBackgroundImage:[UIImage imageNamed:@"Calendar-Week"] forState:UIControlStateNormal];
//    [someButton addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *changeDate =[[UIBarButtonItem alloc]  initWithCustomView:someButton];
    
    UIBarButtonItem *changeDateButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Calendar-Week"] style:UIBarButtonItemStyleBordered target:self action:@selector(changeDate)];
    
    self.navigationItem.leftBarButtonItem = changeDateButton;

    
    [super viewDidLoad];
    
    originalVenues = [[NSMutableArray alloc] init];
    mainDelegate.venues = [[NSMutableArray alloc] init];
    
    grinnellDiningLabel.font = [UIFont fontWithName:@"Vivaldi" size:35];
    
    dateLabel.font = [UIFont fontWithName:@"Vivaldi" size:20];
    menuchoiceLabel.font = [UIFont fontWithName:@"Vivaldi" size:20];
    
    //Beginning of the animation
    dateLabel.alpha = 0;
    menuchoiceLabel.alpha = 0;
    grinnellDiningLabel.alpha = 0;
    
    
    //Customize topImageview - Set the drop shadow
    self.topImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topImageView.layer.shadowOffset = CGSizeMake(0, 1.7);
    self.topImageView.layer.shadowOpacity = 0.7;
    self.topImageView.layer.shadowRadius = 1.5;

    
    //Begin Animations when the view is loaded
    [UIView animateWithDuration:1 animations:^{
        dateLabel.alpha = 1;
        menuchoiceLabel.alpha = 1;
        grinnellDiningLabel.alpha = 1;
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setGrinnellDiningLabel:nil];
    [self setDateLabel:nil];
    [self setMenuchoiceLabel:nil];
    [self setTopImageView:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"VenueView Will Appear");
    [self getDishes];
    self.title = @"Stations";
    menuchoiceLabel.text = self.mealChoice;
    
    // NSLog(@"Date: %@", date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // [dateFormatter  setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter  setDateFormat:@"EEE MMM dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    // NSLog(@"Date: %@", formattedDate);
    
    dateLabel.text = formattedDate;

    
    [self applyFilters];
    [anotherTableView reloadData];
    [super viewWillAppear:YES];
}


//Applying the various filters to the dishes in the tableView
- (void)applyFilters
{
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
            dish.nutrition = d.nutrition;
            dish.halal = d.halal;
            dish.passover = d.passover;
            
            //Duct tape fix for illegal desserts. This should be removed when we modify it in our php scripts. 
            if ([dish.name isEqualToString:@"Chocolate Chip Cookies"] ||
                [dish.name isEqualToString:@"Cookies Big Chocolate Chip"] ||
                [dish.name isEqualToString:@"Cookies Big Monster W/peanut Butter"] ||
                [dish.name isEqualToString:@"Rice Krispie Bars"] 
                ) {
                continue;
            }

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return mainDelegate.venues.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    Venue *venue = [mainDelegate.venues objectAtIndex:section];
    return venue.name; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
   // NSString *formattedSectionTitle = [sectionTitle capitalizedString];
    if (sectionTitle == nil) {
        return nil;
    }
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
   // label.font = [UIFont fontWithName:@"Vivaldi" size:32];
    label.font = [UIFont boldSystemFontOfSize:20];
    //[UIFont fontWithName:@"Vivaldi" size:38]
    
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    Venue *venue = [mainDelegate.venues objectAtIndex:section];
    return venue.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    // Configure the cell...    
    Venue *venue = [mainDelegate.venues objectAtIndex:indexPath.section];
    Dish *dish = [venue.dishes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dish.name;
    
    // Not needed when we have a tray view
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // accessory type
    if (!dish.hasNutrition){
        cell.accessoryType = UITableViewCellAccessoryNone;
        // Needed for when we have a tray view
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        // Needed for when we have a tray view
       // cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    //Modify the colours. 
    [cell setBackgroundColor:[UIColor underPageBackgroundColor]];

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DishViewController *dishView = [[DishViewController alloc] initWithNibName:@"DishViewController" bundle:nil];
    dishView.dishRow = indexPath.row;
    dishView.dishSection = indexPath.section;

	[self.navigationController pushViewController:dishView animated:YES];
}




#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    else {
        NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
        self.mealChoice = titlePressed;

        [self getDishes];
        [self showMealHUD];
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [anotherTableView reloadData];
        menuchoiceLabel.text = self.mealChoice;
        [anotherTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
}



- (void)loadNextMenu
{

    
    
    
    
    
    NSLog(@"Loading next menu - Harcoded to pick July 10th Dinner for now. - Menu on server not current at time of writing");
    //Testing Methods
    //Grab today's date
    NSDate *today = [NSDate date];
//    NSLog(@"Today is %@", today);
    
    //Pick selected date - July 10th
    NSDate *selectedate = [NSDate dateWithTimeIntervalSinceNow:-1 * 24 * 60 * 60 * 20 ];
    
//    NSLog(@"Selected date is %@", selectedate);
    self.date = selectedate;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:selectedate];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/%d-%d-%d.json", month, day, year];
    
    //Determine Time of Day in order to set the mealChoice correctly - Hardcoding Dinner for now.
    /*  TODO::
     *
     *
     *
     */
    self.mealChoice = @"Dinner";
    
    
    
    
    //BROUGHT IN FROM VIEWDIDLOAD
    
    //Beginning of the animation
    dateLabel.alpha = 0;
    menuchoiceLabel.alpha = 0;
    grinnellDiningLabel.alpha = 0;
    
    
    
    //Begin Animations when the view is loaded
    [UIView animateWithDuration:1 animations:^{
        dateLabel.alpha = 1;
        menuchoiceLabel.alpha = 1;
        grinnellDiningLabel.alpha = 1;
    }];
    
    [self getDishes];
    self.title = @"Stations";
    menuchoiceLabel.text = self.mealChoice;
    
    // NSLog(@"Date: %@", date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // [dateFormatter  setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter  setDateFormat:@"EEE MMM dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    // NSLog(@"Date: %@", formattedDate);
    
    dateLabel.text = formattedDate;
    
    
    [self applyFilters];
    [anotherTableView reloadData];
    
    
    //END OF BROUGHT IN
    
    
    
    
    
    
    //You should test for a network connection before here.
    if ([self networkCheck])
    {
        //Instantiate the queue we will run the downloading data process in
        requestQueue = dispatch_queue_create("edu.grinnell.glicious", NULL);
        
        
        //There's a network connection. Before Pulling in any real data. Let's check if there actually is any data available.
        //Using the available days json to do this. Is there a better way? Even though this works. 
        NSURL *datesAvailableURL = [NSURL URLWithString:@"http://tcdb.grinnell.edu/apps/glicious/available_days_json.php"];

        NSError *error;
        NSData *availableData = [NSData dataWithContentsOfURL:datesAvailableURL];
        
        NSDictionary *availableDaysJson = [[NSDictionary alloc] init];
        
        @try {
            availableDaysJson = [NSJSONSerialization JSONObjectWithData:availableData
                                                                options:kNilOptions
                                                                  error:&error];
        }
        @catch (NSException *e) {
            alert = @"server";
            UIAlertView *network = [[UIAlertView alloc]
                                    initWithTitle:@"Network Error"
                                    message:@"The connection to the server failed. Please check back later. Sorry for the inconvenience."
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil
                                    ];
            [network show];
            return;
        }
        
        //If the available days returned is -1, there are no menus found..
        NSString *dayStr = [availableDaysJson objectForKey:@"days"];
        int day = dayStr.intValue;
        
        if (day <= 0) {
            alert = @"network";
            UIAlertView *network = [[UIAlertView alloc]
                                    initWithTitle:@"No Menus are available"
                                    message:@"Please check back later"
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil
                                    ];
            //[network show];
            //Make sure to uncomment this return line  here for production
            //return;
        }
            
            
        //OKAY. So at this point. We can connect to the server and there is a menu available. So let's go get it! 
        //Perform downloading asynchronously on a different thread(queue) - error check throughout process
        dispatch_async(requestQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            NSError *error = nil;
            
            if (data) {
                self.jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&error];
            } else {
                //User interface elements can only be updated on the main thread. Hence we jump back to the main thread to present the alertview.
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *dataNilAlert = [[UIAlertView alloc]
                                                 initWithTitle:@"An error occurred pulling in the data"
                                                 message:nil
                                                 delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
                    [dataNilAlert show];
                });
            }
            
            if (jsonDict)
            {
                [self getDishes];
                //User interface elements can only be updated on the main thread. Hence we jump back to the main thread to reload the tableview
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [anotherTableView reloadData];
                    [self refreshScreen];
                    [self showMealHUD];
                });
            }
        }); //Done with multithreaded code
    }
    else
    {
        //Network Check Failed - Show Alert ( We could use the MBProgessHUD for this as well - Like in the Google Plus iPhone app) 
        UIAlertView *network = [[UIAlertView alloc]
                                initWithTitle:@"No Network Connection"
                                message:@"Turn on cellular data or use Wi-Fi to access new data from the server"                            delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil
                                ];
        [network show];
        return;
    }
}


- (void)changeDate
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MBProgressHUDDelegate methods
//Remove HUD after view is loaded
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidden
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)showMealHUD
{
    
    
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = @"Today's Dinner";
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:1];
}


- (void) refreshScreen
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [anotherTableView reloadData];
    menuchoiceLabel.text = self.mealChoice;
    [anotherTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

@end