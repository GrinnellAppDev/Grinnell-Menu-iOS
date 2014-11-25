//
//  FavoritesManager.h
//  G-licious
//
//  Created by AppDev on 11/24/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dish;

@interface FavoritesManager : NSObject

/**
 * Returns a shared instance of FavoritesManager
 */
+ (instancetype)sharedManager;

- (NSString *)favoritesFilePath;
- (BOOL)save;

- (void)addFavorite:(Dish *)dishID;
- (void)removeFavorite:(Dish *)dishID;
- (BOOL)containsFavorite:(Dish *)dishID;

@end
