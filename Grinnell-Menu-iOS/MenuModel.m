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

-(NSArray *)createMenuFromDictionary:(NSDictionary *)theMenuDictionary;
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



/* Fetches the menu for the date: self.date
 * Loads cached menu if available.
 * If not, downloads new menu from TCDB and caches it. 
 * Returns the filtered Menu
 */ 
-(NSArray *)performFetch {
    
    //Get the date Components. TODO pull this out.
    

    //We need to pick the right components in the cases self.date changes.
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.date];
    NSInteger selectedDay = [components day];
    NSInteger selectedMonth = [components month];
    NSInteger selectedYear = [components year];
    
    //File Directories used.
    NSString *tempPath = NSTemporaryDirectory();
    NSString *daymenuplist = [NSString stringWithFormat:@"%d-%d-%d.plist", selectedMonth, selectedDay, selectedYear];
    NSString *path = [tempPath stringByAppendingPathComponent:daymenuplist];
    
    //Check to see if the file has previously been cached else Get it from server. 
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.menuDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSLog(@"Loading Json from iPhone cache");
    }  else {        
        //correct version
        //NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/%d-%d-%d.json", selectedMonth, selectedDay, selectedYear];
        //testing
        NSMutableString *url = [NSMutableString stringWithFormat:@"http://tcdb.grinnell.edu/apps/glicious/5-16-2013.json"];
    
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSError *error = nil;
        if (data)
        {
            self.menuDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:&error];
            NSLog(@"Downloaded new data");
            if (error) {
                NSLog(@"There was an error: %@", [error localizedDescription]);
            }
            // Cache the menudictionary after downloading. 
            [self.menuDictionary writeToFile:path atomically:YES];
        } else {
            //TODO Handle Data Nil Error!!
        }
    }
    
    //Parses it.
    NSAssert(self.menuDictionary, nil);
    
    NSArray *originalMenu = [self createMenuFromDictionary:self.menuDictionary];
    NSArray *filteredMenu = [self applyFiltersTo:originalMenu];
    return filteredMenu;
}


/* Creates and returns the array of meals.
 * Requires the menuDictionary downloaded from tcdb. 
 */ 
-(NSArray *)createMenuFromDictionary:(NSDictionary *)theMenuDictionary
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    //Go through Menu and create a meal for each Meal available.
    [theMenuDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *mealName, NSDictionary *mealDict, BOOL *stop) {
       // NSLog(@"Mealname: %@, mealDict:", mealName);
        
        if (![mealName isEqualToString:@"PASSOVER"]) {
            //next step - create the Meal(i.e Breakfast, Lunch, etc)
            Meal *aMeal = [[Meal alloc] initWithMealDict:mealDict andName:mealName];
            [tempArray addObject:aMeal];
        }
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"scoreForSorting" ascending:YES];
    [tempArray sortUsingDescriptors:@[sortDescriptor]];
    
    self.originalMenu = [[NSArray alloc] initWithArray:tempArray];
    
    return self.originalMenu;
}

//Returns a filtered Menu depending on the values of the Filter Switches. 
-(NSArray *)applyFiltersTo:(NSArray *)originalMenu
{
    
    NSMutableArray *filteredMenu = [[NSMutableArray alloc] init];
    
    //Load Switch values
    BOOL ovoSwitchValue, veganSwitchValue, gfSwitchValue, passSwitchValue;
    veganSwitchValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"];
    ovoSwitchValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"];
    gfSwitchValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"GFSwitchValue"];
    passSwitchValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"PassSwitchValue"];
    
    
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
               // NSLog(@"Pred: %@", predicate);
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


- (BOOL)networkCheck {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}


@end
