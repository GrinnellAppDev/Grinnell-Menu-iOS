//
//  Meal.m
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/28/13.
//
//

#import "Meal.h"
#import "Venue.h"
#import "Dish.h"

@implementation Meal

-(id)initWithMealDict:(NSDictionary *)mealDict andName:(NSString *)mealName
{
    self = [super init];
    if (self) {
        self.stations = [[NSMutableArray alloc] init];
        
        //TODO - Set the correct mealName CamelCase so we can use to set mealChoice string. 
        self.name = mealName;
        
        if ([mealName isEqualToString:@"PASSOVER"]) {
            if ([(NSString *)mealDict isEqualToString:@"true"]) {
                //TODO - set the passover delegate method to true.
                //mainDelegate.passover = true;
            }
            return nil; 
        }
        
        [mealDict enumerateKeysAndObjectsUsingBlock:^(NSString *stationName, NSArray *stationDishes, BOOL *stop) {
            
            //Create the stations
            Venue *aVenue = [[Venue alloc] init];
            aVenue.name = stationName;
            
            // TODO - This might have been fixed.
            /*
             if ([aVenue.name isEqualToString:@"ENTREES                  "] && [mealName isEqualToString:@"LUNCH"]) {
             NSLog(@"ENTREEES!");
             continue;
             }
             */
            
            [self.stations addObject:aVenue];
            
            //TODO Figure out what this is for actually.. Remove the Entree venue
            [self.stations removeObject:@"ENTREES"];
        }];
        
        [self.stations enumerateObjectsUsingBlock:^(Venue *station, NSUInteger idx, BOOL *stop) {
            //For every station, we create the dish.
            station.dishes = [[NSMutableArray alloc] init];
            NSArray *dishesInStation = mealDict[station.name];
            
            [dishesInStation enumerateObjectsUsingBlock:^(NSDictionary *actualDish, NSUInteger idx, BOOL *stop) {
                Dish *dish = [[Dish alloc] initWithDishDictionary:actualDish];
                [station.dishes addObject:dish];

            }];
        }];
    }
    return self;
}

@end
