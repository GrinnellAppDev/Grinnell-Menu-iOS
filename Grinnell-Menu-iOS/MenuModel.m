//
//  MenuModel.m
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/27/13.
//
//

#import "MenuModel.h"
#import "Meal.h"
#import "Grinnell_Menu_iOSAppDelegate.h"

#import "Venue.h"
#import "Reachability.h"


@interface MenuModel()
@property(nonatomic, strong) NSDictionary *menuDictionary;
@property(nonatomic, strong) NSArray *originalMenu;
@property(nonatomic, strong) Grinnell_Menu_iOSAppDelegate *mainDelegate;

@end


@implementation MenuModel


-(id)initWithDate:(NSDate *)aDate {
    self = [super init];
    if (self) {
        self.date = aDate;
         self.mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}


-(NSArray *)performFetchForDate:(NSDate *)aDate {
    
    //Goes to TCDB. Grabs the Glicious menu.
    
    //Get the date Components. TODO pull this out.
    //DateFormatting used to set the Date Label. Not needed here.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter  setDateFormat:@"EEE MMM dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.date];
    
    //We need to pick the right components in the cases self.date changes.
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.date];
    NSInteger selectedDay = [components day];
    NSInteger selectedMonth = [components month];
    NSInteger selectedYear = [components year];
    
    //correct version
    // NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/%d-%d-%d.json", selectedMonth, selectedDay, selectedYear];
    
    //testing
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/5-13-2013.json"];
    
    dispatch_queue_t requestQueue;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSError *error = nil;
    if (data)
    {
        self.menuDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
        //NSLog(@"Downloaded new data");
        if (error) {
            NSLog(@"There was an error: %@", [error localizedDescription]);
        }
    } else {
        //TODO Handle Data Nil Error!!
    }
    
    //Parses it.
    NSAssert(self.menuDictionary, nil);
    
    NSArray *originalMenu = [self createMenuFromDictionary:self.menuDictionary];
    
    NSArray *filteredMenu = [self applyFiltersTo:originalMenu];
    return filteredMenu;
}


//Returns an Array of Meals.
-(NSArray *)createMenuFromDictionary:(NSDictionary *)theMenuDictionary
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self.date];
    NSUInteger weekday = [components weekday];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    //Go through Menu and create a meal for each Meal available.
    [theMenuDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *mealName, NSDictionary *mealDict, BOOL *stop) {
        NSLog(@"Mealname: %@, mealDict:", mealName);
        
        if (![mealName isEqualToString:@"PASSOVER"]) {
            //next step - create the Meal.
            Meal *aMeal = [[Meal alloc] initWithMealDict:mealDict andName:mealName];
            
            [tempArray addObject:aMeal];
            
            NSLog(@"Adding: %@", aMeal.name);
        }
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"scoreForSorting" ascending:YES];
    [tempArray sortUsingDescriptors:@[sortDescriptor]];
    
    self.originalMenu = [[NSArray alloc] initWithArray:tempArray];
     NSLog(@"TA: %@", tempArray);
    
    //Sending the menus. Currently just wanting the stations. 
    return self.originalMenu;
    
    //call applyFileters like at the end basically. So we should know we have this.
    [self applyFilters];
}

-(NSArray *)applyFiltersTo:(NSArray *)originalMenu
{
    return originalMenu;
}


//Takes the array of Meals and returns the array of Filtered Meals. This is what's used in our VenueViewController. The Filtered Meals.

- (void)applyFilters {
 
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.mainDelegate.allMenus removeAllObjects];
    NSString *emptyStr = @"";
    [self.mainDelegate.allMenus addObject:emptyStr];
    [self.mainDelegate.allMenus addObject:emptyStr];
    [self.mainDelegate.allMenus addObject:emptyStr];
    [self.mainDelegate.allMenus addObject:emptyStr];
    
    for (int i = 0; i < self.originalMenu.count; i++){
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [self.mainDelegate.allMenus replaceObjectAtIndex:i withObject:temp];
    }
    
    [self.mainDelegate.allMenus removeObjectIdenticalTo:emptyStr];
    
    
    NSPredicate *veganPred, *ovoPred, *gfPred, *passPred;
    BOOL ovoSwitch, veganSwitch, gfSwitch, passSwitch;
    veganSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"];
    ovoSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"];
    gfSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"GFSwitchValue"];
    passSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"PassSwitchValue"];
    
    ///////
    for (int i = 0; i < self.originalMenu.count; i++) {
        Venue *faveVen = [[Venue alloc] init];
        faveVen.name = @"FAVORITES";
        [faveVen.dishes removeAllObjects];
        
    NSMutableArray *menu = [[NSMutableArray alloc] initWithArray:[[self.originalMenu objectAtIndex:i] stations]];
 
        for (Venue *v in menu) {
            Venue *venue = [[Venue alloc] init];
     
            venue.name = v.name;
            for (Dish *d in v.dishes){
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
                dish.ID = d.ID;
                dish.servSize = d.servSize;
                if (d.fave){
                    dish.fave = d.fave;
                    BOOL found = FALSE;
                    for (Dish *favesDish in faveVen.dishes) {
                        if ([favesDish.name isEqualToString:dish.name] || favesDish.ID == dish.ID){
                            found = TRUE;
                            break;
                        }
                    }
                    if (!found)
                        [faveVen.dishes addObject:dish];
                }
                [venue.dishes addObject:dish];
            }
            [[self.mainDelegate.allMenus objectAtIndex:i] addObject:venue];
        }
        [[self.mainDelegate.allMenus objectAtIndex:i] insertObject:faveVen atIndex:0];
        //Set up the filters
        BOOL filter;
        NSPredicate *compoundPred;
        NSMutableArray *preds = [[NSMutableArray alloc] init];
        if (self.mainDelegate.passover && passSwitch){
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
        else{
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
            for (Venue *v in [self.mainDelegate.allMenus objectAtIndex:i]){
                [v.dishes filterUsingPredicate:compoundPred];
            }
        
        //Remove empty venues if all items are filtered out of a venue
        NSMutableArray *emptyVenues = [[NSMutableArray alloc] init];
        for (Venue *v in [self.mainDelegate.allMenus objectAtIndex:i]){
            if (v.dishes.count == 0){
                // NSLog(@"%@ removed", v.name);
                [emptyVenues addObject:v];
            }
        }
        [[self.mainDelegate.allMenus objectAtIndex:i] removeObjectsInArray:emptyVenues];
    }
}



- (BOOL)networkCheck {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}


@end
