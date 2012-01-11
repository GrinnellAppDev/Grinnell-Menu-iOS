//
//  Venue.m
//  Grinnell-Menu-iOS
//
//  Created by Aaltan Ahmad on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"

@implementation Venue
@synthesize name, dishes;
-(id)init{
    if ((self = [super init])){
        self.dishes = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
