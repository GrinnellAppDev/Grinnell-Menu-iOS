//
//  Dish.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Modified by Tyler Dewey on 12/14/14.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
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
@property (nonatomic, strong) NSArray *ingredientsArray;

+(instancetype)dishWithDishDictionary:(NSDictionary *)aDishDictionary;
+(instancetype)dishWithOtherDish:(Dish *)aDish;

-(instancetype)initWithDishDictionary:(NSDictionary *)aDishDictionary;
-(instancetype)initWithOtherDish:(Dish *)aDish;

@end
