//
//  Dish.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dish : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *venue;
@property (nonatomic, strong) NSString *servSize;
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) BOOL nutAllergen;
@property (nonatomic, assign) BOOL glutenFree;
@property (nonatomic, assign) BOOL vegan;
@property (nonatomic, assign) BOOL ovolacto;
@property (nonatomic, assign) BOOL passover;
@property (nonatomic, assign) BOOL halal;
@property (nonatomic, assign) BOOL hasNutrition;
@property (nonatomic, assign) BOOL fave;
@property (nonatomic, strong) NSDictionary *nutrition;

-(id)initWithDishDictionary:(NSDictionary *)aDishDictionary;
-(id)initWithOtherDish:(Dish *)aDish;

@end
