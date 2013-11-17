//
//  Dish.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "Dish.h"
@implementation Dish


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ vegan:%d, ovolacto: %d", self.name, self.vegan, self.ovolacto];
}


-(id)initWithDishDictionary:(NSDictionary *)aDishDictionary {
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
        
        //TODO MenuModel should tell which dishes are favorite so we can update that value here.
        /*
         if ([favoritesIDArray containsObject:[NSNumber numberWithInt:dish.ID]]) {
         dish.fave = YES;
         }
         */
        
    }
    return self;
}


-(id)initWithOtherDish:(Dish *)aDish
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
    }
    return self;
}

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
    if (!(self.ID == aDish.ID)) {
        return NO;
    }
    return YES;
}



@end
