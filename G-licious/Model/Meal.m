//
//  Meal.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "Meal.h"
#import "Station.h"
#import "Dish.h"

@implementation Meal


-(id)initWithMealDict:(NSDictionary *)mealDict andName:(NSString *)mealName
{
    self = [super init];
    if (self) {
        self.stations = [[NSMutableArray alloc] init];
        
        //TODO - Set the correct mealName CamelCase so we can use to set mealChoice string.
        self.name = [mealName capitalizedString];
        
        [self setScoreForSorting];
        
        if ([mealName isEqualToString:@"PASSOVER"]) {
            if ([(NSString *)mealDict isEqualToString:@"true"]) {
                //TODO - set the passover delegate method to true.
                //mainDelegate.passover = true;
            }
            return nil;
        }
        
        [mealDict enumerateKeysAndObjectsUsingBlock:^(NSString *stationName, NSArray *stationDishes, BOOL *stop) {
            
            //Create the stations
            Station *aStation = [[Station alloc] init];
            aStation.name = stationName;
            
            // TODO - This might have been fixed.
            /*
             if ([aVenue.name isEqualToString:@"ENTREES                  "] && [mealName isEqualToString:@"LUNCH"]) {
             NSLog(@"ENTREEES!");
             continue;
             }
             */
            
            [self.stations addObject:aStation];
            
            //TODO Figure out what this is for actually.. Remove the Entree venue
            [self.stations removeObject:@"ENTREES"];
        }];
        
        [self.stations enumerateObjectsUsingBlock:^(Station *station, NSUInteger idx, BOOL *stop) {
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


-(id)initWithStations:(NSMutableArray *)theStations andName:(NSString *)mealName
{
    self = [super init];
    if (self) {
        self.stations = theStations;
        self.name = mealName;
    }
    return self;
}

-(void)setScoreForSorting
{
    if ([self.name isEqualToString:@"Breakfast"]) {
        self.scoreForSorting = 1;
    } if ([self.name isEqualToString:@"Lunch"]) {
        self.scoreForSorting = 2;
    } if ([self.name isEqualToString:@"Dinner"]) {
        self.scoreForSorting = 3;
    } if ([self.name isEqualToString:@"Outtakes"]) {
        self.scoreForSorting = 4;
    }
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Meal: %@", self.name];
}


@end
