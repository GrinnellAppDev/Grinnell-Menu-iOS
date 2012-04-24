//
//  Settings.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>



@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (void)settingsDelegateDidFinish:(SettingsViewController *)controller;
@property (weak, nonatomic) IBOutlet UISwitch *ovoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *veganSwitch;
@property (strong, nonatomic) NSArray *filtersNameArray;
@property (weak, nonatomic) IBOutlet UILabel *gotIdeasTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *tipsTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@end

