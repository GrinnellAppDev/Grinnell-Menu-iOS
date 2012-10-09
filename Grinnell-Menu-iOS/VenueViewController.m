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
#import "PanelsViewController.h"
#import "PanelView.h"
#import "SamplePanelView.h"

@implementation VenueViewController
{
    NSArray *mealNamesFromJSON, *venueNamesFromJSON;
    NSMutableArray *originalMenu;
    NSString *alert;
    Grinnell_Menu_iOSAppDelegate *mainDelegate;
}

@synthesize grinnellDiningLabel, dateLabel, menuchoiceLabel, topImageView, date, mealChoice, jsonDict, availDay;

//We create a second Queue which we is in the multithreaded code when grabbing the dishes.
dispatch_queue_t requestQueue;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Do some initialization of our own
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}

- (BOOL)tcdbcheck {
    Reachability *tcdbReachability = [Reachability reachabilityWithHostname:@"http://tcdb.grinnell.edu"];
    NetworkStatus networkStatus = [tcdbReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}

//Parse through JSON data downloaded from the server and create dish Objects
-(void)getDishes {
    if (self.jsonDict == NULL){
        return;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self.date];
    NSUInteger weekday = [components weekday];
    
    NSString *emptyStr = @"";
    
    [originalMenu removeAllObjects];
    [originalMenu addObject:emptyStr];
    [originalMenu addObject:emptyStr];
    [originalMenu addObject:emptyStr];
    [originalMenu addObject:emptyStr];
    
    //mainMenu is a dictionary of ALL the menus - Breakfast, Lunch, Dinner, Outtakes.
    NSDictionary *mainMenu = self.jsonDict;
    //NSLog(@"mainMenu: %@", self.jsonDict);
    //Put data on screen
    //This is a dictionary of dictionaries. Each venue is a key in the main dictionary. Thus we will have to sort through each venue(dict) the main jsondict(dict) and create dish objects for each object that is in the venue.
    
    
    mealNamesFromJSON = [[NSArray alloc] init];
    mealNamesFromJSON = [mainMenu allKeys];
    
    NSMutableArray *mealNames = [[NSMutableArray alloc] init];
    //for each mealName, i.e each of Breakfast, Lunch, Dinner, Outtakes...
    for (NSString *mealName in mainMenu) {
        
        //When the mealName is passover, we get an error because it is expecting an NSDictionary and PASSOVER returns a string ( true or false). So we just skip over passover.
        if ([mealName isEqualToString:@"PASSOVER"])
            continue;
        
        NSDictionary *mealDict = [mainMenu objectForKey:mealName];
        //NSLog(@"mealName is %@", mealName);
        //NSLog(@"mealDict: %@", mealDict);
        [mealNames addObject:mealName];
        //We create an array to begin forming each meal's menu
        NSMutableArray *meal = [[NSMutableArray alloc] init];
        venueNamesFromJSON = [[NSArray alloc] init];
        venueNamesFromJSON = [mealDict allKeys];
        //Here we fill the venues array to contain all the venues.
        for (NSString *venuename in venueNamesFromJSON) {
            //  NSLog(@"venuenames: %@", venuename);
            Venue *gvenue = [[Venue alloc] init];
            gvenue.name = venuename;
            if ([gvenue.name isEqualToString:@"ENTREES                  "] && [mealName isEqualToString:@"LUNCH"]) {
                continue;
            }
            // NSLog(@"Adding object: %@", gvenue);
            [meal addObject:gvenue];
        }
        
        //Remove the Entree venue
        [meal removeObject:@"ENTREES"];
        //So for each Venue...
        for (Venue *gVenue in meal) {
            
            //We create a dish
            gVenue.dishes = [[NSMutableArray alloc] init];
            NSArray *dishesInVenue = [mealDict objectForKey:gVenue.name];
            
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
                if (![[actualdish objectForKey:@"gluten_free"] isEqualToString:@"false"])
                    dish.glutenFree = YES;
                if (![[actualdish objectForKey:@"nutrition"] isKindOfClass:[NSString class]]) {
                    dish.hasNutrition = YES;
                    dish.nutrition = [actualdish objectForKey:@"nutrition"];
                }
                //then finally we add this new dish to it's venue
                //NSLog(@"Dish: %@", dish);
                [gVenue.dishes addObject:dish];
            }
        }
        
        // NSLog(@"Meal: %@", meal);
        int i = 0;
        if (weekday == 1){
            if ([mealName isEqualToString:@"LUNCH"])
                i = 0;
            else if ([mealName isEqualToString:@"DINNER"])
                i = 1;
        }
        // if today isn't sunday
        else{
            if ([mealName isEqualToString:@"BREAKFAST"])
                i = 0;
            else if ([mealName isEqualToString:@"LUNCH"])
                i = 1;
            else if ([mealName isEqualToString:@"DINNER"])
                i = 2;
            else if ([mealName isEqualToString:@"OUTTAKES"] && weekday != 7)
                i = 3;
        }
        //NSLog(@"Storing meal: %@ at index: %d", mealName, i);
        [originalMenu replaceObjectAtIndex:i withObject:meal];
    }
    //NSLog(@"Allmenus: %@", mainDelegate.allMenus);
    [originalMenu removeObjectIdenticalTo:emptyStr];
    
    [self applyFilters];
    
    //NSLog(@"The menu is: %@", mainDelegate.allMenus);
    //NSLog(@"The value of self.mealChoice is %@", self.mealChoice);
    
    if ([self.mealChoice isEqualToString:@"Breakfast"])
        [super skipToOffset:0];
    else if ([self.mealChoice isEqualToString:@"Lunch"]){
        if (weekday == 1)
            [super skipToOffset:0];
        else
            [super skipToOffset:1];
    }
    else if ([self.mealChoice isEqualToString:@"Dinner"]){
        if (weekday == 1)
            [super skipToOffset:1];
        else
            [super skipToOffset:2];
    }
    else if ([self.mealChoice isEqualToString:@"Outtakes"])
        [super skipToOffset:3];
}

//Flip over to the SettingsViewController
- (IBAction)showInfo:(id)sender {
    // Records when user goes to info Screen, records data in Flurry.
    // Log in to check data analytics at Flurry.com: If you don't have a access. Let me know! @DrJid
    [FlurryAnalytics logEvent:@"Flipped to Settings"];
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)changeMeal:(id)sender {
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

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewdidload date: %@", self.date);
    
    //NSLog(@"VenueView loaded");
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
    
    HUD.labelText = @"Grabbing Menu";
    [HUD showWhileExecuting:@selector(loadNextMenu) onTarget:self withObject:nil animated:YES];
    
    
    //I'm using UIButtons beneath the barButton so that we get the barButton be greyed out upon tapping. And more control on the size of the images. Current BarButtonItem doens't implement this...
    UIButton *cmb = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    [cmb setBackgroundImage:[UIImage imageNamed:@"changeMeal"] forState:UIControlStateNormal];
    [cmb addTarget:self action:@selector(changeMeal:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *changeMealButton =[[UIBarButtonItem alloc]  initWithCustomView:cmb];
    [self.navigationItem setRightBarButtonItem:changeMealButton];
    
    // The Calendar-Week icon is released under the Creative Commons Attribution 2.5 Canada license. You can find out more about this license by visiting http://creativecommons.org/licenses/by/2.5/ca/. from www.pixelpressicons.com.
    UIButton *cdb = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    [cdb setBackgroundImage:[UIImage imageNamed:@"Calendar-Week"] forState:UIControlStateNormal];
    [cdb addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *changeDateButton =[[UIBarButtonItem alloc]  initWithCustomView:cdb];
    self.navigationItem.leftBarButtonItem = changeDateButton;
    
    
    originalMenu = [[NSMutableArray alloc] init];
    mainDelegate.allMenus = [[NSMutableArray alloc] init];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setGrinnellDiningLabel:nil];
    [self setDateLabel:nil];
    [self setMenuchoiceLabel:nil];
    [self setTopImageView:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    //NSLog(@"VenueView Will Appear");
    [super viewWillAppear:YES];
    self.title = @"Stations";
    [self getDishes];
    menuchoiceLabel.text = self.mealChoice;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter  setDateFormat:@"EEE MMM dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.date];
    dateLabel.text = formattedDate;
    
    [super reloadAllTables];
}

#pragma mark - Added methods
//Applying the various filters to the dishes in the tableView
- (void)applyFilters {
    if (originalMenu.count == 0)
        return;
    
    [mainDelegate.allMenus removeAllObjects];
    NSString *emptyStr = @"";
    [mainDelegate.allMenus addObject:emptyStr];
    [mainDelegate.allMenus addObject:emptyStr];
    [mainDelegate.allMenus addObject:emptyStr];
    [mainDelegate.allMenus addObject:emptyStr];
    for (int i = 0; i < originalMenu.count; i++){
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [mainDelegate.allMenus replaceObjectAtIndex:i withObject:temp];
    }
    
    [mainDelegate.allMenus removeObjectIdenticalTo:emptyStr];
    NSPredicate *veganPred, *ovoPred, *gfPred, *passPred;
    BOOL ovoSwitch, veganSwitch, gfSwitch, passSwitch;
    veganSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"];
    ovoSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"];
    gfSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"GFSwitchValue"];
    passSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"PassSwitchValue"];
    for (int i = 0; i < originalMenu.count; i++){
        NSMutableArray *menu = [[NSMutableArray alloc] initWithArray:[originalMenu objectAtIndex:i]];
        for (Venue *v in menu) {
            Venue *venue = [[Venue alloc] init];
            venue.name = v.name;
            for (Dish *d in v.dishes) {
                Dish *dish = [[Dish alloc] init];
                dish.name = d.name;
                dish.venue = d.venue;
                dish.nutAllergen = d.nutAllergen;
                dish.glutenFree = d.glutenFree;
                dish.vegan = d.vegan;
                dish.ovolacto = d.ovolacto;
                dish.hasNutrition = d.hasNutrition;
                dish.nutrition = d.nutrition;
                dish.passover = d.passover;
                [venue.dishes addObject:dish];
            }
            [[mainDelegate.allMenus objectAtIndex:i] addObject:venue];
        }
        
        //Set up the filters
        BOOL filter;
        NSPredicate *compoundPred;
        NSMutableArray *preds = [[NSMutableArray alloc] init];
        if (mainDelegate.passover && passSwitch)
        {
            passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
            if (!ovoSwitch && !veganSwitch && !gfSwitch){
                [preds removeAllObjects];
                [preds addObject:passPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (ovoSwitch && gfSwitch){
                ovoPred = [NSPredicate predicateWithFormat:@"ovolacto == YES"];
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
                gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
                [preds removeAllObjects];
                [preds addObject:ovoPred];
                [preds addObject:veganPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                [preds removeAllObjects];
                [preds addObject:gfPred];
                [preds addObject:passPred];
                [preds addObject:compoundPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (veganSwitch && gfSwitch){
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
                gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
                [preds removeAllObjects];
                [preds addObject:gfPred];
                [preds addObject:veganPred];
                [preds addObject:passPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (ovoSwitch) {
                ovoPred = [NSPredicate predicateWithFormat:@"ovolacto == YES"];
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
                [preds removeAllObjects];
                [preds addObject:ovoPred];
                [preds addObject:veganPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                [preds removeAllObjects];
                [preds addObject:passPred];
                [preds addObject:compoundPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (veganSwitch) {
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
                [preds removeAllObjects];
                [preds addObject:veganPred];
                [preds addObject:passPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (gfSwitch) {
                gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
                passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
                [preds removeAllObjects];
                [preds addObject:gfPred];
                [preds addObject:passPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
        }
        else
        {
            if (!ovoSwitch && !veganSwitch && !gfSwitch){
                filter = false;
            }
            else if (ovoSwitch && gfSwitch){
                ovoPred = [NSPredicate predicateWithFormat:@"ovolacto == YES"];
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
                [preds removeAllObjects];
                [preds addObject:ovoPred];
                [preds addObject:veganPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                [preds removeAllObjects];
                [preds addObject:gfPred];
                [preds addObject:compoundPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (veganSwitch && gfSwitch){
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
                [preds removeAllObjects];
                [preds addObject:gfPred];
                [preds addObject:veganPred];
                compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (ovoSwitch) {
                ovoPred = [NSPredicate predicateWithFormat:@"ovolacto == YES"];
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                [preds removeAllObjects];
                [preds addObject:ovoPred];
                [preds addObject:veganPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (veganSwitch) {
                veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
                [preds removeAllObjects];
                [preds addObject:veganPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                filter = true;
            }
            else if (gfSwitch) {
                gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
                [preds removeAllObjects];
                [preds addObject:gfPred];
                compoundPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
                filter = true;
            }
        }
        
        //Run the filter
        if (filter && compoundPred != NULL)
            for (Venue *v in [mainDelegate.allMenus objectAtIndex:i]) {
                [v.dishes filterUsingPredicate:compoundPred];
            }
        
        //Remove empty venues if all items are filtered out of a venue
        NSMutableArray *emptyVenues = [[NSMutableArray alloc] init];
        for (Venue *v in [mainDelegate.allMenus objectAtIndex:i]) {
            if (v.dishes.count == 0){
                // NSLog(@"%@ removed", v.name);
                [emptyVenues addObject:v];
            }
        }
        [[mainDelegate.allMenus objectAtIndex:i] removeObjectsInArray:emptyVenues];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Panel view data source

- (NSInteger)numberOfPanels {
	if (jsonDict) {
        if ([super numberOfPanels] != (jsonDict.count -1))
            [super fixWeekends:jsonDict.count-1];
        NSLog(@"json count %d", jsonDict.count);
        return (jsonDict.count - 1);
    }
    else
        return 4;
}

- (UIView *)panelView:(id)panelView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section {
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    // label.font = [UIFont fontWithName:@"Vivaldi" size:32];
    label.font = [UIFont boldSystemFontOfSize:20];
    //[UIFont fontWithName:@"Vivaldi" size:38]
    
    
    if (mainDelegate.allMenus != NULL)
    {
        Venue *venue = [[mainDelegate.allMenus objectAtIndex:pageNumber] objectAtIndex:section];
        label.text = venue.name;
    }
    else
        label.text = @"";
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    return view;
}


/**
 *
 * - (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
 * set number of rows for different panel & section
 *
 */
- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section {
    if (mainDelegate.allMenus != NULL) {
        Venue *venue = [[mainDelegate.allMenus objectAtIndex:page] objectAtIndex:section];
        //NSLog(@"Count: %d",venue.dishes.count );
        return venue.dishes.count;
    }
    else
        return 0;
}

/**
 *
 *
 */
- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber {
    if (jsonDict){
        if ([[mainDelegate.allMenus objectAtIndex:pageNumber] isKindOfClass:[NSMutableArray class]])
            return [[mainDelegate.allMenus objectAtIndex:pageNumber] count];
        else return 0;
    }
    else
        return 0;
}

/**
 *
 * - (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
 * use this method to change table view cells for different panel, section, and row
 *
 */
- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
	}
    
    // Configure the cell...
    //NSLog(@"page number is: %d", indexPath.page);
    Venue *venue = [[mainDelegate.allMenus objectAtIndex:indexPath.page] objectAtIndex:indexPath.section];
    if (indexPath.row < [venue.dishes count]){
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
    }
    //Modify the colours.
    [cell setBackgroundColor:[UIColor underPageBackgroundColor]];
    
    return cell;
}


/**
 *
 * - (PanelView *)panelForPage:(NSInteger)page
 * use this method to change panel types
 * SamplePanelView should subclass PanelView
 *
 */
- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"SamplePanelView";
	SamplePanelView *panelView = (SamplePanelView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (panelView == nil)
	{
		panelView = [[SamplePanelView alloc] initWithIdentifier:identifier];
	}
	return panelView;
}

//Added implementation DrJid
-(void)panelView:(id)panelView accessoryButtonTappedForRowInPage:(NSInteger)pageNumber withIndexPath:(PanelIndexPath *)indexPath
{
    Venue *venue = [[mainDelegate.allMenus objectAtIndex:indexPath.page] objectAtIndex:indexPath.section];
    // [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DishViewController *dishView = [[DishViewController alloc] initWithNibName:@"DishViewController" bundle:nil];
    Dish *dish = [venue.dishes objectAtIndex:indexPath.row];
    dishView.selectedDish = [[Dish alloc] init];
    dishView.selectedDish = dish;
    [self.navigationController pushViewController:dishView animated:YES];
}



#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    else {
        NSString *titlePressed = [alertView buttonTitleAtIndex:buttonIndex];
        self.mealChoice = titlePressed;
        [self getDishes];
        [self refreshScreen];
        [self showMealHUD];
    }
}

- (void)loadNextMenu {
    NSDate *tempDate;
    if (self.date == Nil)
        tempDate = Nil;
    else
        tempDate = self.date;
    
    
    NSLog(@"A new menu has been loaded");
    
    //Testing Methods
    //Grab today's date so we can properly initialize selected date to today
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24];
    
    //By default, we work with today's menu.
    self.date = today;
    //Declare Date Components for today
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit fromDate:today];
    NSInteger hour = [todayComponents hour];
    NSInteger minute = [todayComponents minute];
    NSInteger weekday = [todayComponents weekday];
    //NSLog(@"hour: %d minute: %d weekday: %d", hour, minute, weekday);
    
    //Use time and weekday to intelligently set the mealChoice
    //Sunday
    
    if (weekday == 1){
        if (hour < 13 || (hour < 14 && minute < 30))
            self.mealChoice = @"Lunch";
        else if (hour < 19)
            self.mealChoice = @"Dinner";
        else{
            self.mealChoice = @"Breakfast";
            self.date = tomorrow;
        }
    }
    //Saturday
    else if (weekday == 7){
        if (hour < 10)
            self.mealChoice = @"Breakfast";
        else if (hour < 13 || (hour < 14 && minute < 30))
            self.mealChoice = @"Lunch";
        else if (hour < 19)
            self.mealChoice = @"Dinner";
        else{
            self.mealChoice = @"Lunch";
            self.date = tomorrow;
        }
    }
    //Friday
    else if (weekday == 6){
        if (hour < 10)
            self.mealChoice = @"Breakfast";
        else if (hour < 13 || (hour < 14 && minute < 30))
            self.mealChoice = @"Lunch";
        else if (hour < 19)
            self.mealChoice = @"Dinner";
        else{
            self.mealChoice = @"Breakfast";
            self.date = tomorrow;
        }
    }
    //All other days
    else{
        if (hour < 10)
            self.mealChoice = @"Breakfast";
        else if (hour < 13 || (hour < 14 && minute < 30))
            self.mealChoice = @"Lunch";
        else if (hour < 20)
            self.mealChoice = @"Dinner";
        else{
            self.mealChoice = @"Breakfast";
            self.date = tomorrow;
        }
    }
    
    if (tempDate != Nil){
        //If correct jsonDict is already stored, don't get a new one
        // Strip the time component from the two dates so they can be compared
        NSDateComponents* moreComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.date];
        self.date = [[NSCalendar currentCalendar] dateFromComponents:moreComps];
        moreComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:tempDate];
        tempDate = [[NSCalendar currentCalendar] dateFromComponents:moreComps];
        
    }
    if ([tempDate isEqualToDate:self.date] && jsonDict){
        [self getDishes];
        [self refreshScreen];
        [self showMealHUD];
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter  setDateFormat:@"EEE MMM dd"];
        NSString *formattedDate = [dateFormatter stringFromDate:self.date];
        dateLabel.text = formattedDate;
        //We need to pick the right components in the cases self.date changes.
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.date];
        NSInteger selectedDay = [components day];
        NSInteger selectedMonth = [components month];
        NSInteger selectedYear = [components year];
        
        NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/%d-%d-%d.json", selectedMonth, selectedDay, selectedYear];
        //Setting up the fading animation of the labels
        dateLabel.alpha = 0;
        menuchoiceLabel.alpha = 0;
        grinnellDiningLabel.alpha = 0;
        
        
        //You should test for a network connection before here.
        if ([self networkCheck]) {
            //Instantiate the queue we will run the downloading data process in
            requestQueue = dispatch_queue_create("edu.grinnell.glicious", NULL);
            
            //There's a network connection. Before Pulling in any real data. Let's check if there actually is any data available.
            //Using the available days json to do this. Is there a better way? Even though this works.
            NSURL *datesAvailableURL = [NSURL URLWithString:@"http://tcdb.grinnell.edu/apps/glicious/last_date.json"];
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
            NSString *dayStr = [availableDaysJson objectForKey:@"Last_Day"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM-dd-yyyy"];
            NSDate *lastDate = [df dateFromString:dayStr];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:today toDate:lastDate options:0];
            int day= [components day] + 1;
            //Store the day so the date picker can access it
            availDay = day;
            if (day <= 0) {
                alert = @"network";
                UIAlertView *network = [[UIAlertView alloc]
                                        initWithTitle:@"No Menus are available"
                                        message:@"Please check back later"
                                        delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil
                                        ];
                [network show];
                //Make sure to uncomment this return line  here for production
                return;
            }
            
            //OKAY. So at this point. We can connect to the server and there is a menu available. So let's go get it!
            //Perform downloading asynchronously on a different thread(queue) - error check throughout process
            dispatch_async(requestQueue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                NSError *error = nil;
                if (data)
                {
                    self.jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
                    NSLog(@"Downloaded new data");
                    if (error) {
                        NSLog(@"There was an error: %@", [error localizedDescription]);
                    }
                    
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
                if (jsonDict) {
                    //User interface elements can only be updated on the main thread. Hence we jump back to the main thread to reload the tableview
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getDishes];
                        [self refreshScreen];
                        [self showMealHUD];
                    });
                }
            }); //Done with multithreaded code
            
            //Finish up animations when the view is done loading...
            [UIView animateWithDuration:1 animations:^{
                dateLabel.alpha = 1;
                menuchoiceLabel.alpha = 1;
                grinnellDiningLabel.alpha = 1;
            }];
        }
        else {
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
}

- (void)changeDate {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark MBProgressHUDDelegate methods
//Remove HUD after view is loaded
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidden
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)showMealHUD {
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
    
	HUD.delegate = self;
    
    // Intelligently display selected meal (i.e. Today's Dinner or Wednesday's Outtakes)
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit fromDate:self.date];
    NSInteger selectDay = [comps day];
    NSInteger selectMonth = [comps month];
    NSInteger weekday = [comps weekday];
    NSDate *today = [[NSDate alloc] init];
    comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:today];
    NSInteger todayDay = [comps day];
    NSInteger todayMonth = [comps month];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24];
    comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:tomorrow];
    NSInteger tomorrowDay = [comps day];
    NSInteger tomorrowMonth = [comps month];
    NSString *dayStr;
    if (selectDay == todayDay && selectMonth == todayMonth)
        dayStr = @"Today";
    else if(selectDay == tomorrowDay && selectMonth == tomorrowMonth)
        dayStr = @"Tomorrow";
    else{
        switch (weekday) {
            case 1:
                dayStr = @"Sunday";
                break;
            case 2:
                dayStr = @"Monday";
                break;
            case 3:
                dayStr = @"Tuesday";
                break;
            case 4:
                dayStr = @"Wednesday";
                break;
            case 5:
                dayStr = @"Thursday";
                break;
            case 6:
                dayStr = @"Friday";
                break;
            case 7:
                dayStr = @"Saturday";
                break;
            default:
                break;
        }
    }
    NSMutableString *HUDLabel = [NSMutableString stringWithFormat:@"%@'s %@", dayStr, self.mealChoice];
	HUD.labelText = HUDLabel;
	[HUD show:YES];
	[HUD hide:YES afterDelay:0.5];
}

- (void)pushNextPage{
    [super pushNextPage];
}
- (void)jumpToPreviousPage{
    [super jumpToPreviousPage];
}

- (void) refreshScreen
{
    // NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [super reloadAllTables];
    menuchoiceLabel.text = self.mealChoice;
    // [anotherTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	//This is called after the scrolling is complete and the user actually changed the page.
	if (self.currentPage!=self.lastDisplayedPage) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self.date];
        NSUInteger weekday = [components weekday];
        
		PanelView *panelView = (PanelView*)[self.scrollView viewWithTag:TAG_PAGE+self.currentPage];
		[panelView pageDidAppear];
        //TODO - not important - but maybe.. we could have reload nicely (faded?) instead of the sudden appearance which can be surprising? Again, not THAT important.
        
        //        NSLog(@"PAgeNum loaded: %d",self.currentPage);
        
        if (weekday == 1) {
            switch (self.currentPage) {
                case 0:
                    self.mealChoice = @"Lunch";
                    break;
                case 1:
                    self.mealChoice = @"Dinner";
                    break;
                default:
                    break;
            }
        }
        else {
            switch (self.currentPage) {
                case 0:
                    self.mealChoice = @"Breakfast";
                    break;
                case 1:
                    self.mealChoice = @"Lunch";
                    break;
                case 2:
                    self.mealChoice = @"Dinner";
                    break;
                case 3:
                    self.mealChoice = @"Outtakes";
                    break;
                default:
                    break;
            }
        }
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.menuchoiceLabel.alpha = 0.0f;
                         }completion:^(BOOL finished) {
                             self.menuchoiceLabel.alpha = 1.0f;
                             self.menuchoiceLabel.text = self.mealChoice;
                         }];
        
        //Hmm where do we actually change the self.mealChoice
        [self refreshScreen];
        //This HUD takes a long time it seems?
        [self showMealHUD];
	}
	self.lastDisplayedPage = self.currentPage;
}

@end