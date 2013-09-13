//
//  StationsViewController.h
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/29/13.
//
//

#import <UIKit/UIKit.h>
#import "TTSlidingPagesDataSource.h"

@interface StationsViewController : UIViewController <TTSlidingPagesDataSource>

@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) TTScrollSlidingPagesController *slider;

@property (nonatomic, strong) NSDate *date; 
@end
