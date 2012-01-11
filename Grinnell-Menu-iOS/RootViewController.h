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
    IBOutlet UIDatePicker *datePicker;
}

- (IBAction)showVenues:(id)sender;
@property (nonatomic, strong) IBOutlet UIButton *go;
@end
