//
//  Settings.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController

- (void)settingsDelegateDidFinish:(SettingsViewController *)controller;
@property (weak, nonatomic) IBOutlet UISwitch *ovoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *veganSwitch;
@property (strong, nonatomic) NSArray *filtersNameArray;
@end

