//
//  MealViewController.m
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/29/13.
//
//

#import "MealViewController.h"
#import "Venue.h" 
#import "Dish.h"

#import "AJRNutritionViewController.h"


@interface MealViewController ()
@end

@implementation MealViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return self.meal.stations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Venue *venue = self.meal.stations[section];
    return venue.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = self.meal.stations[indexPath.section];
    Dish *dish = venue.dishes[indexPath.row];
    
    cell.textLabel.text = dish.name;
    
    
    // accessory type
    if (dish.hasNutrition) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else cell.accessoryType = UITableViewCellAccessoryNone;
    
    // selection style type
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
   // NSString *tappedContent = self.meals.stations[indexPath.row];
    
  
 
    Venue *venue = self.meal.stations[indexPath.section];
    Dish *dish = venue.dishes[indexPath.row];
    
    
    
    if (dish.hasNutrition) {
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"ShowNutritionalDetails"
                                                             object:dish];
    }
     
 //   [self insert];
    
    
    
/*
    [venue.dishes addObject:dish];
    [self.meal.stations addObject:venue];
    
    //Create an array of indexPaths
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] initWithCapacity:3];

        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    
  //  [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
 */ 
    
    
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    //Get each section from the menuvenues array and change the header to match it.
 /*
    Venue * grinvenue = [filteredArray objectAtIndex:section];
    if (grinvenue.dishes.count > 0) {
        return grinvenue.name;
    }
  */
    Venue *venue = self.meal.stations[section];
    return venue.name;    
}

-(void)insert
{

  //  [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    
    
    Dish *dish = [[Dish alloc] init];
    dish.name = @"hahahah";
    
    [[self.meal.stations[0] dishes] addObject:dish];
    
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.meal.stations count]-1 inSection:1]];
    [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    
    
    
 

}

@end
