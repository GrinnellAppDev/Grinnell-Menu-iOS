//
//  FavoritesManager.m
//  G-licious
//
//  Created by Tyler Dewey on 11/24/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "FavoritesManager.h"
#import "Dish.h"

@interface FavoritesManager()

@property (nonatomic, strong) NSMutableSet *favoriteDishIds;

@end

@implementation FavoritesManager

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    
    // Temporary variable to read in stored favorites
    NSArray *temp;
    
    NSString *favoritesFilePath = [FavoritesManager favoritesFilePath];
    
    //Load up the favorites file if there is one.
    if ([[NSFileManager defaultManager] fileExistsAtPath:favoritesFilePath]) {
        temp = [[NSArray alloc] initWithContentsOfFile:favoritesFilePath];
        self.favoriteDishIds = [[NSMutableSet alloc] initWithArray:temp];
    } else {
        //We still need to allocate memory for an empty array.
        self.favoriteDishIds = [[NSMutableSet alloc] init];
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

#pragma mark - Persistence

+ (NSString *)favoritesFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
}

- (BOOL)save {
    NSArray *temp = [self.favoriteDishIds allObjects];
    return [temp writeToFile:[FavoritesManager favoritesFilePath] atomically:YES];
}

- (void)addFavorite:(Dish *)dish {
    if (dish == nil) return;
    
    [self.favoriteDishIds addObject:@(dish.ID)];
}

- (void)removeFavorite:(Dish *)dish {
    if (dish == nil) return;
    
    [self.favoriteDishIds removeObject:@(dish.ID)];
}

- (BOOL)containsFavorite:(Dish *)dish {
    if (dish == nil) return NO;
    
    return [self.favoriteDishIds containsObject:@(dish.ID)];
}

@end
