//
//  Station.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "Station.h"

@implementation Station

-(id)init {
    if ((self = [super init])) {
        self.dishes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Station: %@",self.name];
}

@end
