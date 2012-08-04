//
//  DishView.m
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import "DishViewController.h"
#import "Grinnell_Menu_iOSAppDelegate.h"
#import "Dish.h"
#import "Venue.h"
#import <QuartzCore/QuartzCore.h>
#import "TDBadgedCell.h"

@implementation DishViewController
{
    UIColor *EvenbadgeColor;
    UIColor *OddbadgeColor;
}
@synthesize theTableView;
@synthesize backgroundImageView;
@synthesize dishRow, dishSection;

- (IBAction)toVenueView:(id)sender{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES]; 
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:dishSection];
    Dish *dish = [venue.dishes objectAtIndex:dishRow];
    
    self.title = dish.name;
    
    [super viewWillAppear:animated];
    
//    self.backgroundImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.backgroundImageView.layer.shadowOffset = CGSizeMake(0, 1);
//    self.backgroundImageView.layer.shadowOpacity = 1;
//    self.backgroundImageView.layer.shadowRadius = 1;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    OddbadgeColor = [UIColor colorWithRed:0.192 green:0.512 blue:0.792 alpha:1.0];
    EvenbadgeColor = [UIColor colorWithRed:0.192 green:0.432 blue:0.792 alpha:1];
    OddbadgeColor = [UIColor blackColor];
}

- (void)viewDidUnload{
    [self setBackgroundImageView:nil];
    [self setTheTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //I wanted the padding so it centered... so i put a tab =] Feel free to do this better...
   return @"     Nutritional Information";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    // NSString *formattedSectionTitle = [sectionTitle capitalizedString];
    if (sectionTitle == nil) {
        return nil;
    }
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    // label.font = [UIFont fontWithName:@"Vivaldi" size:32];
    label.font = [UIFont boldSystemFontOfSize:20];
    //[UIFont fontWithName:@"Vivaldi" size:38]
    
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";    
    
    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    Grinnell_Menu_iOSAppDelegate *mainDelegate = (Grinnell_Menu_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Venue *venue = [mainDelegate.venues objectAtIndex:dishSection];
    Dish *dish = [venue.dishes objectAtIndex:dishRow];
    

    if (indexPath.row == 0) {
        cell.textLabel.text = @"Calories";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badge.radius = 9;
        cell.badgeString = [NSString stringWithFormat:@"%@", [dish.nutrition objectForKey:@"KCAL"]];
    }
    
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Saturated Fat"; 
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badgeString = [NSString stringWithFormat:@"%@g", [dish.nutrition objectForKey:@"SFA"]];
        cell.badge.radius = 9;
    }
    
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"Trans Fat";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badgeString = [NSString stringWithFormat:@"%@g", [dish.nutrition objectForKey:@"FATRN"]];
        cell.badge.radius = 9;
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"Sodium";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badgeString = [NSString stringWithFormat:@"%@mg", [dish.nutrition objectForKey:@"NA"]];
        cell.badge.radius = 9;
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"Sugar";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badgeString = [NSString stringWithFormat:@"%@g", [dish.nutrition objectForKey:@"SUGR"]];
        cell.badge.radius = 9;
    }
    else if (indexPath.row == 5) {
        cell.textLabel.text = @"Dietary Fiber";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badgeString = [NSString stringWithFormat:@"%@g", [dish.nutrition objectForKey:@"TDFB"]];
        cell.badge.radius = 9;
    }
    else if (indexPath.row == 6) {
        cell.textLabel.text = @"Cholesterol";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.badgeString = [NSString stringWithFormat:@"%@mg", [dish.nutrition objectForKey:@"CHOL"]];
        cell.badge.radius = 9;
    }
    
    if (indexPath.row % 2) {
        [cell setBackgroundColor:[UIColor colorWithRed:0.93 green:0.9 blue:0.9 alpha:1]];
        cell.badgeColor = EvenbadgeColor;
    }
    else {
        [cell setBackgroundColor:[UIColor underPageBackgroundColor]];
        cell.badgeColor = OddbadgeColor;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
