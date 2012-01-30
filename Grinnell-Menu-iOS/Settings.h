//
//  Settings.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Settings : UIViewController

- (void)settingsDelegateDidFinish:(Settings *)controller;
@property (weak, nonatomic) IBOutlet UISwitch *ovoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *veganSwitch;
@end

