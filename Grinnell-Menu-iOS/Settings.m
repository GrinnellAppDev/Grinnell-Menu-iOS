//
//  Settings.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Settings.h"
#import "VenueView.h"

@implementation Settings

@synthesize veganSwitch, ovoSwitch;

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)settingsDelegateDidFinish:(Settings *)controller{
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
    cell.textLabel.text = @"";
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
    
    [veganSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"VeganSwitchValue"]];
    [ovoSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"OvoSwitchValue"]];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setBool:veganSwitch.isOn forKey:@"VeganSwitchValue"];
    [[NSUserDefaults standardUserDefaults] setBool:ovoSwitch.isOn forKey:@"OvoSwitchValue"];
    [super viewWillDisappear:YES];
}
- (void)viewDidUnload{
    
    [super viewDidUnload];
}


@end
