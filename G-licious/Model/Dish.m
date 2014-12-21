//
//  Dish.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Modified by Tyler Dewey on 12/14/14.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "Dish.h"
@implementation Dish

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ vegan:%d, ovolacto: %d", self.name, self.vegan, self.ovolacto];
}

#pragma mark - Convenience Constructors

+ (instancetype)dishWithDishDictionary:(NSDictionary *)aDishDictionary {
    Dish *dish = [[Dish alloc] initWithDishDictionary:aDishDictionary];
    return dish;
}

+ (instancetype)dishWithOtherDish:(Dish *)aDish {
    Dish *dish = [[Dish alloc] initWithOtherDish:aDish];
    return dish;
}

#pragma mark - Initializers

- (instancetype)initWithDishDictionary:(NSDictionary *)aDishDictionary {
    self = [super init];
    
    if (self) {
        
        self.name = aDishDictionary[@"name"];
        self.ID = [aDishDictionary[@"ID"] intValue];
        
        if ([aDishDictionary[@"vegan"] isEqualToString:@"true"])
            self.vegan = YES;
        if ([aDishDictionary[@"ovolacto"] isEqualToString:@"true"])
            self.ovolacto = YES;
        if ([aDishDictionary[@"passover"] isEqualToString:@"true"])
            self.passover = YES;
        if ([aDishDictionary[@"gluten_free"] isEqualToString:@"true"])
            self.glutenFree = YES;
        
        if ([aDishDictionary[@"nutrition"] isKindOfClass:[NSDictionary class]]) {
            self.hasNutrition = YES;
            self.nutrition = aDishDictionary[@"nutrition"];
            self.servSize = aDishDictionary[@"ServSize"];
        }
        
        if (aDishDictionary[@"Ingredients"]) {
            self.ingredientsArray = aDishDictionary[@"Ingredients"];
        }
        
        //TODO MenuModel should tell which dishes are favorite so we can update that value here.
        /*
         if ([favoritesIDArray containsObject:[NSNumber numberWithInt:dish.ID]]) {
         dish.fave = YES;
         }
         */
        
    }
    return self;
}

- (instancetype)initWithOtherDish:(Dish *)aDish
{
    self = [super init];
    if (self) {
        self.name = aDish.name;
        self.ID = aDish.ID;
        self.venue = aDish.venue;
        self.nutAllergen = aDish.nutAllergen;
        self.glutenFree = aDish.glutenFree;
        self.vegan = aDish.vegan;
        self.ovolacto = aDish.ovolacto;
        self.hasNutrition = aDish.hasNutrition;
        self.nutrition = aDish.nutrition;
        self.passover = aDish.passover;
        self.servSize = aDish.servSize;
        self.ingredientsArray = aDish.ingredientsArray;
    }
    return self;
}

#pragma mark - Comparison

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToDish:other];
}

- (BOOL)isEqualToDish:(Dish *)aDish {
    if (self == aDish)
        return YES;
    if (![(id)[self name] isEqual:[aDish name]])
        return NO;
    if (!(self.ID == aDish.ID))
        return NO;
    
    return YES;
}

@end
