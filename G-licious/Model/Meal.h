//
//  Meal.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meal : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *stations;

@property (nonatomic, assign) int scoreForSorting;

-(id)initWithMealDict:(NSDictionary *)mealDict andName:(NSString *)mealName;
-(id)initWithStations:(NSMutableArray *)theStations andName:(NSString *)mealName;


@end
