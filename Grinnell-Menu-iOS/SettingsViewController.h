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

@protocol SettingsDelegate <NSObject>
@end

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (void)settingsDelegateDidFinish:(SettingsViewController *)controller;
@property (nonatomic, weak) IBOutlet UILabel *gotIdeasTextLabel;
@property (nonatomic, weak) IBOutlet UITextView *tipsTextView;
@property (nonatomic, weak) IBOutlet UIButton *contactButton;
@property (nonatomic, weak) IBOutlet UIImageView *banner;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, strong) NSArray *filtersNameArray;

@property (nonatomic, assign) id <SettingsDelegate> delegate;

- (IBAction)rateAction:(id)sender;

@end
