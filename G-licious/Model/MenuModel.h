//
//  MenuModel.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Modified by Tyler Dewey on 11/24/14.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchCompletionBlock) (NSArray *filteredMenu, NSError *error);

//typedef void (^BCCaseHistoryReadCompletionBlock) (NSError *error);
//typedef void (^BCFetchPagedCasesCompletionBlock) (NSArray *cases, int totalPages, NSError *error);


@interface MenuModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *favoriteDishIds;
@property (nonatomic, assign) int availableDays;
@property (nonatomic, assign) int page;

- (instancetype)init;
- (instancetype)initWithDate:(NSDate *)aDate;
- (NSArray *)performFetch;
- (void)fetchMenuForDate:(NSDate *)date completionHandler:(void (^)(NSArray *menu, NSError *error))completionHandler;
- (void)getAvailableDays;
- (void)getAvailableDaysWithCompletionHandler:(void (^)(int availableDays, NSError *error))completionHandler;

@end
