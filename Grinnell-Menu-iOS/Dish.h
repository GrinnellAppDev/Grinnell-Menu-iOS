//
//  Dish.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dish : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *venue;
@property (nonatomic, assign) BOOL nutAllergen;
@property (nonatomic, assign) BOOL glutenFree;
@property (nonatomic, assign) BOOL vegetarian;
@property (nonatomic, assign) BOOL vegan;
@property (nonatomic, assign) BOOL ovolacto;
@property (nonatomic, assign) BOOL hasNutrition;
@property (nonatomic, strong) NSString *nutrition;
@end
