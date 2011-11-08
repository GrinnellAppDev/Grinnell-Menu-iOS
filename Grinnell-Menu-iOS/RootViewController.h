//
//  RootViewController.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RootViewController : UIViewController
{
    IBOutlet UIDatePicker *datePicker;
    UIButton *today;
    UIButton *tomorrow;
    UIButton *go;
}

- (IBAction)showVenues:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *today;
@property (nonatomic, retain) IBOutlet UIButton *tomorrow;
@property (nonatomic, retain) IBOutlet UIButton *go;
@end
