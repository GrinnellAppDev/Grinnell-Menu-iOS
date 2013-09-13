//
//  MenuModel.h
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/27/13.
//
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property(nonatomic, strong) NSDate *date;


-(id)initWithDate:(NSDate *)aDate;
-(NSArray *)performFetch;

@end
