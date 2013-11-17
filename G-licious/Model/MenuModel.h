//
//  MenuModel.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
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

- (id)initWithDate:(NSDate *)aDate;
- (NSArray *)performFetch;
- (void)performFetchWithCompletionBlock:(FetchCompletionBlock)completion;
- (void)getAvailableDays;
- (NSString *)favoritesFilePath;

@end
