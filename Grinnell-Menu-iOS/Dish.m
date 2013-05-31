//
//  Dish.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Dish.h"

@implementation Dish
@synthesize name, venue, nutAllergen, glutenFree, vegan, passover, halal, ovolacto, hasNutrition, nutrition, ID, servSize, fave;

- (NSString *)description {
//    return self.name
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

@end
