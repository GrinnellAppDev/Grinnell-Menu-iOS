//
//  DiningHallHours.h
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 4/2/13.
//
//

#import <Foundation/Foundation.h>

@interface DiningHallHours : NSObject

+ (NSString *)hoursForMeal:(NSString *)mealChoice onDay:(NSDate *)date;

@end
