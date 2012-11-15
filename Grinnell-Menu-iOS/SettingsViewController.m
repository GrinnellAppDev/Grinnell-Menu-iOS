//
//  Settings.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "SettingsViewController.h"
#import "VenueViewController.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation SettingsViewController{
    Grinnell_Menu_iOSAppDelegate *mainDelegate;
    BOOL veganChanged;
    BOOL ovolactoChanged;
    BOOL glutChanged;
    BOOL passoverChanged;
}

@synthesize gotIdeasTextLabel, tipsTextView, tipsLabel, banner, contactButton, filtersNameArray, delegate;

//Do some initialization of our own
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

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
    if (mainDelegate.passover)
        return 4;
    else
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [filtersNameArray objectAtIndex:indexPath.row];
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    switch (indexPath.row) {
        case 0:
            [switchView setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"]];
            [switchView addTarget:self action:@selector(veganSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case 1:
            [switchView setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"]];
            [switchView addTarget:self action:@selector(ovoSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case 2:
            [switchView setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"GFSwitchValue"]];
            [switchView addTarget:self action:@selector(gfSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case 3:
            [switchView setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"PassSwitchValue"]];
            [switchView addTarget:self action:@selector(passoverSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        default:
            break;
    }
    return cell;
}

- (void) veganSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"VeganSwitchValue"];
    veganChanged = !veganChanged;
}
- (void) ovoSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"OvoSwitchValue"];
    ovolactoChanged = !ovolactoChanged;
}
- (void) gfSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"GFSwitchValue"];
    glutChanged = !glutChanged;
}
- (void) passoverSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"PassSwitchValue"];
    passoverChanged = !passoverChanged;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Filters";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsDelegateDidFinish:)];
    [[self navigationItem] setLeftBarButtonItem:backButton];
    [super viewDidLoad];
    self.title = @"Settings"; 
    
    //filtersNameArray contains the names of all the filters. If you want to add more filters, You can add the name to this array. Change the number of rows to be returned. And then programmatically create a new switch for that particular filter.
    if (mainDelegate.passover)
        filtersNameArray = [NSArray arrayWithObjects:@"Vegan Filter", @"Ovolacto Filter", @"Gluten Free Filter", @"Passover Filter", nil];
    else
        filtersNameArray = [NSArray arrayWithObjects:@"Vegan Filter", @"Ovolacto Filter", @"Gluten Free Filter", nil];
    
    ///For iPad view. Modify value to set the appropriate width and height for the content size.
    self.contentSizeForViewInPopover = CGSizeMake(280.0, 400.0);
    
 
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
    
    veganChanged =  glutChanged = ovolactoChanged = passoverChanged = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    if (veganChanged || glutChanged || ovolactoChanged || passoverChanged) {
        [mainDelegate.venueViewController applyFilters];
        [mainDelegate.venueViewController refreshScreen];
    }
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
        
        mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [mailViewController setSubject:@"Feedback - Glicious!"];
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"appdev@grinnell.edu"]];
        
        [self presentModalViewController:mailViewController animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)rateAction:(id)sender {
    int myAppID = 523738999;

    NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", myAppID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
}
@end
