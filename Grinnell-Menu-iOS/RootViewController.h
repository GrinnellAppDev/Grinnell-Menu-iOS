//
//  RootViewController.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
 //   IBOutlet UIDatePicker *datePicker;
}

- (IBAction)showVenues:(id)sender;
- (BOOL)networkCheck;

@property (nonatomic, strong) IBOutlet UIButton *go;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDictionary *jsonDict;


@end
