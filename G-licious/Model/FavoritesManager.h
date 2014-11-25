//
//  FavoritesManager.h
//  G-licious
//
//  Created by AppDev on 11/24/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesManager : NSObject

/**
 * Returns a shared instance of FavoritesManager
 */
+ (instancetype)sharedManager;

- (NSString *)favoritesFilePath;
- (BOOL)save;

@end
