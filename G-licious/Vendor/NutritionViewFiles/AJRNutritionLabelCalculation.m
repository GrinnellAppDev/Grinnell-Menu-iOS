//
//  AJRNutritionLabelCalculation.m
//  AJRNutritionControllerDemo
//
//  Created by Andrew Rosenblum on 2/9/13.
//  Copyright (c) 2013 On Tap Media. All rights reserved.
//
//
//Copyright (c) 2013, Andrew Rosenblum All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. Neither the name of the nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "AJRNutritionLabelCalculation.h"

@implementation AJRNutritionLabelCalculation
//These calculations are all based off a 2000 calorie diet. Perhaps, down the road, we could offer the ability to change the amount of diet for every Grinnellian? Will make it more personalized. We'll see.. The recommendations for a 2000 calorie diet values can be found at the bottom of most food labels. @DrJid

//Returns a formatted string with the daily fat % -65g
+ (NSString *)calculateFatDailyValue:(float)fat {
    NSString *tmpString = [NSString stringWithFormat:@"%.1f", (fat / 65) * 100];
    tmpString = [tmpString stringByAppendingString:@"%"];
    return tmpString;
}

//Returns a formatted string with the daily saturated fat % - 20g
+ (NSString *)calculateSaturatedFatDailyValue:(float)satfat {
    NSString *tmpString = [NSString stringWithFormat:@"%.1f", (satfat / 20) * 100];
    tmpString = [tmpString stringByAppendingString:@"%"];
    return tmpString;
}


//Returns a formatted string with the daily cholesterol % - 300mg
+ (NSString *)calculateCholesterolDailyValue:(float)chol {
    NSString *tmpString = [NSString stringWithFormat:@"%.1f", (chol / 300) * 100];
    tmpString = [tmpString stringByAppendingString:@"%"];
    return tmpString;
}

//Returns a formatted string with the daily sodium % - 2400mg
+ (NSString *)calculateSodiumDailyValue:(float)na {
    NSString *tmpString = [NSString stringWithFormat:@"%.1f", (na / 2400) * 100];
    tmpString = [tmpString stringByAppendingString:@"%"];
    return tmpString;
}

//Returns a formatted string with the daily carb % - 300g
+ (NSString *)calculateTotalCarbDailyValue:(float)carbs {
    NSString *tmpString = [NSString stringWithFormat:@"%.1f", (carbs / 300) * 100];
    tmpString = [tmpString stringByAppendingString:@"%"];
    return tmpString;
}

//Returns a formatted string with the daily dietary fiber % - 25g
+ (NSString *)calculateDietaryFiberDailyValue:(float)tdfb {
    NSString *tmpString = [NSString stringWithFormat:@"%.1f", (tdfb / 300) * 100];
    tmpString = [tmpString stringByAppendingString:@"%"];
    return tmpString;
}



@end
