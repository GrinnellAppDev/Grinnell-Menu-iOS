//
//  RootViewController.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController

- (IBAction)showVenues:(id)sender;
- (BOOL)networkCheck;

@property (nonatomic, strong) IBOutlet UIButton *go, *go2;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property (nonatomic, weak) IBOutlet UILabel *grinnellDiningLabel;
@property (nonatomic, weak) IBOutlet UIImageView *banner;

@end
