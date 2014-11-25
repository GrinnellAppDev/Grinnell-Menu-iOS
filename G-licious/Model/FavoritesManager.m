//
//  FavoritesManager.m
//  G-licious
//
//  Created by AppDev on 11/24/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import "FavoritesManager.h"
#import "Dish.h"

@interface FavoritesManager()

@property (nonatomic, strong) NSMutableArray *favoriteDishIds;

@end

@implementation FavoritesManager

- (instancetype)init {
    self = [super init];
    
    //Load up the favorites file if there is one.
    NSString *favoritesFilePath = [self favoritesFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:favoritesFilePath]) {
        self.favoriteDishIds = [[NSMutableArray alloc] initWithContentsOfFile:favoritesFilePath];
    } else {
        //We still need to allocate memory for an empty array.
        self.favoriteDishIds = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (instancetype)sharedManager {
    
    static FavoritesManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (NSString *)favoritesFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
}

- (BOOL)save {
    return [self.favoriteDishIds writeToFile:[self favoritesFilePath] atomically:YES];
}

- (void)addFavorite:(Dish *)dish {
    [self.favoriteDishIds addObject:@(dish.ID)];
}

- (void)removeFavorite:(Dish *)dish {
    [self.favoriteDishIds removeObject:@(dish.ID)];
}

- (BOOL)containsFavorite:(Dish *)dish {
    return [self.favoriteDishIds containsObject:@(dish.ID)];
}

@end
