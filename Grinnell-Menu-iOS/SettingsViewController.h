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

@property (nonatomic, weak) IBOutlet UISwitch *ovoSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *veganSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *gfSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *passSwitch;
@property (nonatomic, weak) IBOutlet UILabel *gotIdeasTextLabel;
@property (nonatomic, weak) IBOutlet UITextView *tipsTextView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, strong) NSArray *filtersNameArray;

@end
