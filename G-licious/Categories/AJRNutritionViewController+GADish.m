//
//  AJRNutritionViewController+AJRNutritionViewController_GADish.m
//  G-licious
//
//  Created by AppDev on 11/24/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import "AJRNutritionViewController+GADish.h"
#import "Dish.h"

@implementation AJRNutritionViewController (GADish)

+ (instancetype)controllerWithDish:(Dish *)dish {
    AJRNutritionViewController *controller = [[AJRNutritionViewController alloc] init];
    
    //Send the ingredients.
    controller.ingredientsArray = dish.ingredientsArray;
    
    //Set the various data values for the view
    // controller.servingSize = @"12 fl oz. (1 Can)";
    // controller.calories = 100;      //Type: int
    //  controller.sugar = 12;          //Type: float
    //  controller.protein = 3;         //Type: float
    controller.dishTitle = dish.name;
    controller.servingSize = [NSString stringWithFormat:@"%@", dish.servSize];
    
    controller.calories = [dish.nutrition[@"KCAL"] floatValue];
    controller.fat = [dish.nutrition[@"FAT"] floatValue];
    controller.satfat = [dish.nutrition[@"SFA"]floatValue];
    controller.transfat = [dish.nutrition[@"FATRN"]floatValue];
    controller.cholesterol = [dish.nutrition[@"CHOL"] floatValue];
    controller.sodium = [dish.nutrition[@"NA"]floatValue];
    controller.carbs = [dish.nutrition[@"CHO"] floatValue];
    controller.dietaryfiber = [dish.nutrition[@"TDFB"] floatValue];
    controller.sugar = [dish.nutrition[@"SUGR"] floatValue];
    controller.protein = [dish.nutrition[@"PRO"] floatValue];
    
    return controller;
}

@end

