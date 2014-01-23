//
//  SettingsViewController.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/2/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *veganSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *glutenFreeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ovolactoSwitch;


@property (nonatomic, assign) BOOL veganChanged;
@property (nonatomic, assign) BOOL ovolactoChanged;
@property (nonatomic, assign) BOOL glutChanged;
@property (nonatomic, assign) BOOL passoverChanged;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    DLog(@"Settings View loaded up");
}

 - (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.veganChanged =  self.glutChanged = self.ovolactoChanged = NO;
    
    [self.veganSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"]];

    [self.ovolactoSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"]];

    [self.glutenFreeSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"GFSwitchValue"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    if (self.veganChanged || self.glutChanged || self.ovolactoChanged || self.passoverChanged)
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"ResetFilters"
                                                             object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)veganSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"VeganSwitchValue"];
    self.veganChanged = !self.veganChanged;
}

- (IBAction)glutenFreeSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"GFSwitchValue"];
    self.glutChanged = !self.glutChanged;
}

- (IBAction)ovolactoSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"OvoSwitchValue"];
    self.ovolactoChanged = !self.ovolactoChanged;
}

#pragma mark - UITableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [selectedBackgroundView setBackgroundColor:[UIColor lightScarletColor]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    switch (section) {
        case 1:
            [self contactUs];
            break;
        case 2:
            [self showRateGlicious];
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)contactUs {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
       mailViewController.navigationBar.tintColor = [UIColor colorWithRed:135.f/255.f green:1/255.f blue:6/255.f alpha:1];
        
        mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [mailViewController setSubject:@"Feedback - Glicious!"];
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"appdev@grinnell.edu"]];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showRateGlicious {
    int gliciousID = 523738999;
    NSString* url = [NSString stringWithFormat: @"http://itunes.apple.com/app/id%d", gliciousID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

@end
