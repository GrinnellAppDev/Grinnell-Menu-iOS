//
//  MenuModel.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Modified by Tyler Dewey on 11/24/14.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "MenuModel.h"
#import "Dish.h"
#import "Station.h"
#import "Meal.h"
#import "FavoritesManager.h"
#import "Reachability.h"
#import "G_licious-Swift.h"

@interface MenuModel()

@property (nonatomic, strong) MenuCache *menuCache;

@property (nonatomic, strong) NSDictionary *menuDictionary;
@property (nonatomic, strong) NSArray *originalMenu;
@property (nonatomic, assign) BOOL hasAvailableDays;

- (NSArray *)createMenuFromDictionary:(NSDictionary *)theMenuDictionary;

@end


@implementation MenuModel {
    Reachability *internetReachable;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.menuCache = [[MenuCache alloc] init];
    }
    
    return self;
}

- (instancetype)initWithDate:(NSDate *)aDate {
    self = [self init];
    
    if (self) {
        self.date = aDate;
    }
    
    return self;
}


/* Fetches the menu for the date: self.date
 * Loads cached menu if available.
 * If not, downloads new menu from TCDB and caches it.
 * Returns the filtered Menu
 */
- (NSArray *)performFetch {
    
    [self getAvailableDays];
    
    NSString *menuPath = [URLUtils menuPlistPathForDate:self.date];
    
    //Check to see if the file has previously been cached else Get it from server.
    if ([[NSFileManager defaultManager] fileExistsAtPath:menuPath]) {
        self.menuDictionary = [[NSDictionary alloc] initWithContentsOfFile:menuPath];

    } else if ([self networkCheck]) {
        //correct version
        NSURL *menuURL = [URLUtils menuURLForDate:self.date];
        
        //temp test version
        
        // TODO: use NSURLSession
        NSData *data = [NSData dataWithContentsOfURL:menuURL];
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
            [self.menuDictionary writeToFile:menuPath atomically:YES];
        } else {
            //Handle Data Nil Error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drat!" message:@"Seems there are no menus for this date available. Do check back again soon!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            return nil;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yikes!" message:@"It appears that the internet connection is offline" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    NSArray *originalMenu = [self createMenuFromDictionary:self.menuDictionary];
    NSArray *filteredMenu = [self applyFiltersTo:originalMenu];
    return filteredMenu;
}

- (void)fetchMenuForDate:(NSDate *)date completionHandler:(void (^)(NSArray *menu, NSError *error))completionHandler {

    
    [self getAvailableDaysWithCompletionHandler:^(int availableDays, NSError *availableDaysError) {
        if (availableDaysError != nil) {
            completionHandler(nil, availableDaysError);
            return;
        }
        
        if ([self.menuCache hasMenuForDate:date]) {
            NSDictionary *cachedMenuDict = [self.menuCache getMenuDictForDate:date];
            
            NSArray *originalMenu = [self createMenuFromDictionary:cachedMenuDict];
            NSArray *filteredMenu = [self applyFiltersTo:originalMenu];
            
            completionHandler(filteredMenu, nil);
            return;
        }
        
        if (![self networkCheck]) {
            NSError *networkError = [NSError errorWithDomain:@"GliciousServerError"
                                                        code:2
                                                    userInfo:@{NSLocalizedDescriptionKey: @"The internet connection is offline"}];
            completionHandler(nil, networkError);
            return;
        }
        
        NSURL *menuURL = [URLUtils menuURLForDate:date];
        
        NSURLSessionDataTask *menuDataTask = [[NSURLSession sharedSession] dataTaskWithURL:menuURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                NSError *menuError = [NSError errorWithDomain:@"GliciousServerError"
                                                         code:2
                                                     userInfo:@{NSLocalizedDescriptionKey: @"Seems there are no menus for this date available. Do check back again soon!"}];
                completionHandler(nil, menuError);
                return;
            }
            
            NSError *jsonError;
            NSDictionary *menuDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&jsonError];
            NSLog(@"Downloaded new data");
            
            [self.menuCache cacheMenuDict:menuDictionary forDate:date];
            
            NSArray *originalMenu = [self createMenuFromDictionary:menuDictionary];
            NSArray *filteredMenu = [self applyFiltersTo:originalMenu];
            
            completionHandler(filteredMenu, nil);
        }];
        
        [menuDataTask resume];
    }];
    
}

/* Creates and returns the array of meals.
 * Requires the menuDictionary downloaded from the server.
 */
- (NSArray *)createMenuFromDictionary:(NSDictionary *)theMenuDictionary {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    //Go through Menu Dictionary and create a meal for each Meal available.
    [theMenuDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *mealName, NSDictionary *mealDict, BOOL *stop) {
        //NSLog(@"Mealname: %@, mealDict:", mealName);
        
        if (![mealName isEqualToString:@"PASSOVER"]) {
            //next step - create the Meal(i.e Breakfast, Lunch, etc)
            Meal *aMeal = [[Meal alloc] initWithMealDict:mealDict andName:mealName];
            [tempArray addObject:aMeal];
        }
    }];
    
    //This sortDescriptor helps us to assure the Breakfast-Lunch-Dinner-Outtakes ordering.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"scoreForSorting" ascending:YES];
    [tempArray sortUsingDescriptors:@[sortDescriptor]];
    
    self.originalMenu = [[NSArray alloc] initWithArray:tempArray];
    return self.originalMenu;
}

//Returns a filtered Menu depending on the values of the Filter Switches.
- (NSArray *)applyFiltersTo:(NSArray *)originalMenu {
    //TODO - Might be able to put this somwhere else.
    FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
    
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
        
        //Create Favorite's Station and set it up FTODO
        __block Station *favStation = [[Station alloc] init];
        favStation.name = @"Favorites";
        favStation.dishes = [[NSMutableArray alloc] init];
       // NSMutableSet *tmpFavSet = [[NSMutableSet alloc] init];
        
        
        NSMutableArray *filteredStations = [[NSMutableArray alloc] init];
        
        [originalMealStations enumerateObjectsUsingBlock:^(Station *aStation, NSUInteger idx, BOOL *stop) {
            Station *filteredStation = [[Station alloc] init];
            filteredStation.name = aStation.name;
            
            [aStation.dishes enumerateObjectsUsingBlock:^(Dish *aDish, NSUInteger idx, BOOL *stop) {
                Dish *dish = [[Dish alloc] initWithOtherDish:aDish];
                
                //Check if dish is a favorite. And add it to the favorites Station. (Each Meal has a favorite station)
                //DLog(@"fdid: %@", self.favoriteDishIds);
                
                if ( [favoritesManager containsFavorite:dish] ) {
                    dish.fave = YES;
                    //DLog(@"dish %@ was a favorite", dish.name);
                    if (![favStation.dishes containsObject:dish]) {
                        [favStation.dishes addObject:dish];
                    }
                   // [tmpFavSet addObject:dish];
                }
                
                [filteredStation.dishes addObject:dish];
            }];
            
            //favStation.dishes = [NSMutableArray arrayWithArray:[tmpFavSet allObjects]];
            [filteredStations addObject:filteredStation];

            
            for (NSPredicate *predicate in predicates) {
                // NSLog(@"Pred: %@", predicate);
                for (Station *theStation in filteredStations) {
                    [theStation.dishes filterUsingPredicate:predicate];
                    
                    if (theStation.dishes.count == 0) {
                        [filteredStations removeObject:theStation];
                    }
                }
            }
        }];
        
        //We now have a favoritesStation but we need to filter that out as well...
        if (predicates.count == 0) {
            //DLog(@"there are: %@", predicates);
            if (favStation.dishes.count > 0) {
                [filteredStations insertObject:favStation atIndex:0];
            }
        } else {
            for (NSPredicate *predicate in predicates) {
                //NSLog(@"Pred: %@", predicate);
                [favStation.dishes filterUsingPredicate:predicate];
            }
            if (favStation.dishes.count > 0 ) {
                [filteredStations insertObject:favStation atIndex:0];
            }
        }
        //DLog(@"FAV STATION: %@", favStation.dishes);
        //DLog(@"filteredStations: %@", filteredStations);
        
        Meal *filteredMeal = [[Meal alloc] initWithStations:filteredStations andName:meal.name];
        [filteredMenu addObject:filteredMeal];
    }];
    
    return filteredMenu;
}

- (void)printMenu:(NSArray *)menuArray {
    for (Meal *meal in menuArray) {
        for (Station *station in meal.stations) {
            NSLog(@"%@ %@",station.name, station.dishes);
        }
    }
}

- (void)getAvailableDays {
    if (!self.hasAvailableDays) {
        //requestQueue = dispatch_queue_create("edu.grinnell.glicious", NULL);
        
        //There's a network connection. Before Pulling in any real data. Let's check if there actually is any data available.
        //Using the last_date json to do this.
        NSURL *datesAvailableURL = [URLUtils lastDateUrl];
        NSError *error;
        NSData *availableData = [NSData dataWithContentsOfURL:datesAvailableURL]; // TODO: use NSURLSession
        NSDictionary *availableDaysJson;
        
        if (availableData != nil) {
            availableDaysJson = [NSJSONSerialization JSONObjectWithData:availableData
                                                                options:kNilOptions
                                                                  error:&error];
            
            NSString *dayString = availableDaysJson[@"Last_Day"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MM-dd-yyyy"];
            NSDate *lastDate = [df dateFromString:dayString];
            
            // get the difference between two dates
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date] toDate:lastDate options:0];
            self.availableDays = (int) [components day] + 1;
            self.hasAvailableDays = YES;
        } else {
            //Available Data is nil which means, the server may be down or there is something else interfering.
            //App will not run.
            //[self performSelectorOnMainThread:@selector(showNoServerAlert) withObject:nil waitUntilDone:YES];
            //return;
            
            //Handle ERROR! Server Error:
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No menus available! " message:@"Looks like there are no menus available right now... Do check back later!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

- (void)getAvailableDaysWithCompletionHandler:(void (^)(int availableDays, NSError *error))completionHandler {
    if (self.hasAvailableDays) {
        completionHandler(self.availableDays, nil);
        return;
    }
    
    NSURL *datesAvailableURL = [URLUtils lastDateUrl];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:datesAvailableURL
                                                                 completionHandler:^(NSData * _Nullable data,
                                                                                     NSURLResponse * _Nullable response,
                                                                                     NSError * _Nullable dataTaskError) {
        
        if (dataTaskError != nil) {
            NSError *error = [NSError errorWithDomain:@"GliciousServerError"
                                                 code:1
                                             userInfo:@{NSLocalizedDescriptionKey: @"Unable to get available days"}];
            completionHandler(-1, error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *availableDaysJson = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&jsonError];
        
        
        NSString *dayString = availableDaysJson[@"Last_Day"];
        NSDateFormatter *formatter = [self dateFormatter];
        
        NSDate *lastDate = [formatter dateFromString:dayString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date] toDate:lastDate options:0];
        self.availableDays = (int) [components day] + 1; // TODO: decide if int or NSNumber would be better suited here
        self.hasAvailableDays = YES;
        
        completionHandler(self.availableDays, nil);
        
        
    }];
    
    [dataTask resume];
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd-yyyy"];
    }
    
    return formatter;
}

@end
