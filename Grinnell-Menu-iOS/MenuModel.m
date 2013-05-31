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
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/5-16-2013.json"];
    
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
            
       //     NSLog(@"Adding: %@", aMeal.name);
        }
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"scoreForSorting" ascending:YES];
    [tempArray sortUsingDescriptors:@[sortDescriptor]];
    
    self.originalMenu = [[NSArray alloc] initWithArray:tempArray];
     NSLog(@"TA: %@", tempArray);
    
    //Sending the menus. Currently just wanting the stations. 
    return self.originalMenu;
    
    //call applyFileters like at the end basically. So we should know we have this.
}

//Returns a filtered Menu depending on the values of the Filter Switches. 
-(NSArray *)applyFiltersTo:(NSArray *)originalMenu
{
    
    NSMutableArray *filteredMenu = [[NSMutableArray alloc] init];
    
    //Load Switch values
    BOOL ovoSwitchValue, veganSwitchValue, gfSwitchValue, passSwitchValue;
    veganSwitchValue = TRUE; //[[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"];
    ovoSwitchValue = TRUE; // [[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"];
    gfSwitchValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"GFSwitchValue"];
    passSwitchValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"PassSwitchValue"];
    
    NSLog(@"veganSwitch: %d, ovoSwitch: %d", veganSwitchValue, ovoSwitchValue); 
   // [self printMenu:originalMenu];
    
    
    NSPredicate *passPred = [NSPredicate predicateWithFormat:@"passover == YES"];
    NSPredicate *ovoPred = [NSPredicate predicateWithFormat:@"ovolacto == YES"];
    NSPredicate *veganPred = [NSPredicate predicateWithFormat:@"vegan == YES"];
    NSPredicate *gfPred = [NSPredicate predicateWithFormat:@"glutenFree == YES"];
    
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (ovoSwitchValue) [predicates addObject:ovoPred];
    if (veganSwitchValue) [predicates addObject:veganPred];
    if (gfSwitchValue) [predicates addObject:gfPred];
    if (passSwitchValue) [predicates addObject:passPred];
    
    [originalMenu enumerateObjectsUsingBlock:^(Meal *meal, NSUInteger idx, BOOL *stop) {
        NSMutableArray *originalMealStations = [[NSMutableArray alloc] initWithArray:meal.stations];
        
        //Create Favorite's Station and set it up TODO
        NSMutableArray *filteredStations = [[NSMutableArray alloc] init];
        
        [originalMealStations enumerateObjectsUsingBlock:^(Venue *aVenue, NSUInteger idx, BOOL *stop) {
            Venue *filteredVenue = [[Venue alloc] init];
            filteredVenue.name = aVenue.name;
            
            [aVenue.dishes enumerateObjectsUsingBlock:^(Dish *aDish, NSUInteger idx, BOOL *stop) {
                Dish *dish = [[Dish alloc] initWithOtherDish:aDish];
                
                //TODO handle favorites.
                [filteredVenue.dishes addObject:dish];
            }];
            
            [filteredStations addObject:filteredVenue];
            
            for (NSPredicate *predicate in predicates) {
                NSLog(@"Pred: %@", predicate);
                for (Venue *theVenue in filteredStations) {
                    [theVenue.dishes filterUsingPredicate:predicate];
                    
                    if (theVenue.dishes.count == 0) {
                        [filteredStations removeObject:theVenue];
                    }
                }
            }
        }];
        
        Meal *filteredMeal = [[Meal alloc] initWithStations:filteredStations andName:meal.name];
        [filteredMenu addObject:filteredMeal];
    }];

    return filteredMenu;
}


-(void)printMenu:(NSArray *)menuArray
{
    for (Meal *meal in menuArray) {
        for (Venue *venue in meal.stations) {
            NSLog(@"%@ %@",venue.name, venue.dishes);
        }
    }
}


//Takes the array of Meals and returns the array of Filtered Meals. This is what's used in our VenueViewController. The Filtered Meals.



- (BOOL)networkCheck {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}


@end
