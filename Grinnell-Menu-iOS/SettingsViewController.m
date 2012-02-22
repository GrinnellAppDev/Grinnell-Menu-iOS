//
//  Settings.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "SettingsViewController.h"
#import "VenueViewController.h"

@implementation SettingsViewController

@synthesize filtersNameArray, veganSwitch, ovoSwitch;

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)settingsDelegateDidFinish:(SettingsViewController *)controller{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [filtersNameArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
   }

#pragma mark - View lifecycle
- (void)viewDidLoad{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsDelegateDidFinish:)];
    [[self navigationItem] setLeftBarButtonItem:backButton];
    [super viewDidLoad];
    self.title = @"Settings"; 
    
    //We set the switches to thier default values
    [veganSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"]];
    [ovoSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    //filtersNameArray contains the names of all the filters. If you want to add more filters, You can add the name to this array. Change the number of rows to be returned. And then drag in a switch into the nib file for that particular filter. 
    filtersNameArray = [NSArray arrayWithObjects:@"Vegan Filter", @"Ovolacto Filter", nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //When user clicks done, the default values of the filters are set to the values of the switches
    [[NSUserDefaults standardUserDefaults] setBool:veganSwitch.isOn forKey:@"VeganSwitchValue"];
    [[NSUserDefaults standardUserDefaults] setBool:ovoSwitch.isOn forKey:@"OvoSwitchValue"];
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

@end
