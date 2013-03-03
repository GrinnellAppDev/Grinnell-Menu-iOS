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
    return self.name;
}

@end
