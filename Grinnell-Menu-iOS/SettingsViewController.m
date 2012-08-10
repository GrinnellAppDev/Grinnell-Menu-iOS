//
//  Settings.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "SettingsViewController.h"
#import "VenueViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SettingsViewController

@synthesize gotIdeasTextLabel, tipsTextView, tipsLabel, filtersNameArray, veganSwitch, ovoSwitch;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)settingsDelegateDidFinish:(SettingsViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [filtersNameArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Tips";
    }
    else return @"Filters";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Lookout for more filters soon!";
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsDelegateDidFinish:)];
    [[self navigationItem] setLeftBarButtonItem:backButton];
    [super viewDidLoad];
    self.title = @"Settings"; 
    
    //filtersNameArray contains the names of all the filters. If you want to add more filters, You can add the name to this array. Change the number of rows to be returned. And then drag in a switch into the nib file for that particular filter. 
    filtersNameArray = [NSArray arrayWithObjects:@"Vegan Filter", @"Ovolacto Filter", nil];
    
    //We set the switches to thier default values
    [veganSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"]];
    [ovoSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"]];
}

-(void)viewWillAppear:(BOOL)animated {
    //Customise tips Label
    tipsLabel.textColor = [UIColor colorWithRed:0.298 green:0.337 blue:0.424 alpha:1.0];
    gotIdeasTextLabel.textColor = [UIColor colorWithRed:0.298 green:0.337 blue:0.424 alpha:1.0];
    [tipsTextView setBackgroundColor:[UIColor whiteColor]];
    //[tipsTextView setFont:[UIFont boldSystemFontOfSize:16.0]];
    [tipsTextView setTextAlignment:UITextAlignmentLeft];
    [tipsTextView setEditable:NO];
    // For the border and rounded corners
    [[tipsTextView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[tipsTextView layer] setBorderWidth:2.3];
    [[tipsTextView layer] setCornerRadius:15];
    [tipsTextView setClipsToBounds: YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    //When user clicks done, the default values of the filters are set to the values of the switches
    [[NSUserDefaults standardUserDefaults] setBool:veganSwitch.isOn forKey:@"VeganSwitchValue"];
    [[NSUserDefaults standardUserDefaults] setBool:ovoSwitch.isOn forKey:@"OvoSwitchValue"];
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload {
    [self setTipsTextView:nil];
    [self setTipsLabel:nil];
    [self setGotIdeasTextLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Added methods
- (IBAction)contactUs:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setSubject:@"Feedback - Glicious!"];
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"appdev@grinnell.edu"]];
        
        [self presentModalViewController:mailViewController animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
