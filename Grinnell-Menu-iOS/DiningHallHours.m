//
//  DiningHallHours.m
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 4/2/13.
//
//

/* Weekday Key:
1 - Sun
2 - Mon
3 - Tue
4 - Wed
5 - Thurs
6 - Fri
7 - Sat
*/




#import "DiningHallHours.h"

@implementation DiningHallHours

+ (NSString *)hoursForMeal:(NSString *)mealChoice onDay:(NSDate *)selectedDate {
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit fromDate:selectedDate];
    NSInteger weekday = [dateComponents weekday];
    
    NSString *tmpString;
    
    //Breakfast
    if ([mealChoice isEqualToString:@"Breakfast"]) {
        
        switch (weekday) {
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                tmpString = @"7:00am - 10:00am";
                break;
            
            case 7:
                tmpString = @"9:00am - 10:00am";
            default:
                break;
        }
    }
    
    else if ([mealChoice isEqualToString:@"Lunch"]) {
        //Lunch
        switch (weekday) {
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                tmpString = @"11:00am - 1:30pm";
                break;
                
            case 7:
            case 1:
                tmpString = @"11:30am - 1:30pm";
            default:
                break;
        }
    }
    
    else if ([mealChoice isEqualToString:@"Dinner"]) {
        switch (weekday) {
            case 2:
            case 3:
            case 4:
            case 5:
                tmpString = @"5:00pm - 8:00pm";
                break;
                
            case 6:
            case 7:
            case 1:
                tmpString = @"5:00pm - 7:00pm";
            default:
                break;
        }
    }
    
    else if ([mealChoice isEqualToString:@"Outtakes"]) {
        switch (weekday) {
            case 2:
            case 3:
            case 4:
            case 5:
                tmpString = @"9:45 - 12:30 | 2:00 - 4:30 | 8:45 - 10:00";
                break;
                
            case 6:
            case 7:
            case 1:
                tmpString = @"9:45am - 12:30pm | 2:00pm - 4:30pm";
                
            default:
                break;
        }
    }

    return tmpString;
}

@end
