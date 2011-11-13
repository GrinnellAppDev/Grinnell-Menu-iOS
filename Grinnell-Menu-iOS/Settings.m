//
//  Settings.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "Settings.h"
#import "Filter.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "VenueView.h"

@implementation Settings
@synthesize newTableView;

- (void)dealloc
{    
    [newTableView release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)settingsDelegateDidFinish:(Settings *)controller{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsDelegateDidFinish:)];
    [[self navigationItem] setLeftBarButtonItem:backButton];
    [backButton release];
    [super viewDidLoad];
    self.title = @"Settings"; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    return mainDelegate.filters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Filter *filter = [[Filter alloc] init];
    filter = [mainDelegate.filters objectAtIndex:indexPath.row];
    cell.textLabel.text = filter.name;
    if (filter.isChecked){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;}
    return cell;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Filter *filter = [[Filter alloc] init];
    filter = [mainDelegate.filters objectAtIndex:indexPath.row];
        
    if (!filter.isChecked)
    {
        // Reflect selection in data model        
        if ([filter.name isEqualToString:@"All"]){
            int temp = 0;
            while (temp < mainDelegate.filters.count){
                filter = [mainDelegate.filters objectAtIndex:temp];
                filter.isChecked = YES;
                temp++;
            }
        }
        else if ([filter.name isEqualToString:@"Vegetarian"]){
            filter.isChecked = YES;
            filter = [mainDelegate.filters objectAtIndex:(1+indexPath.row)];
            filter.isChecked = YES;
        }
        else
            filter.isChecked = YES;
    }
    else if (filter.isChecked)
    {
        filter.isChecked = NO;
        filter = [mainDelegate.filters objectAtIndex:0];
        filter.isChecked = NO;        
        // Reflect deselection in data model
    }
    [newTableView reloadData];
}


@end
