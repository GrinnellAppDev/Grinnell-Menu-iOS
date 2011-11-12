//
//  Dish.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Dish : NSObject {
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *venue;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *nutrition;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, assign) BOOL nutAllergen;
@property (nonatomic, assign) BOOL glutenFree;
@property (nonatomic, assign) BOOL vegetarian;
@property (nonatomic, assign) BOOL vegan;

@end
