//
//  MealViewController.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/1/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "MealViewController.h"
#import "Station.h"
#import "Dish.h"
#import "AJRNutritionViewController.h"
#import "DishCell.h"

@interface MealViewController ()
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, assign) NSInteger startContentOffset;
@end

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;


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
    
    //Push tableView contentInset so it doesn't get hidden behind the bottom toolbar.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);

    
}

- (void)sendShowToolbarNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToolBar" object:nil];
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
    Station *station = self.meal.stations[section];
    return station.dishes.count;
}

- (DishCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DishCell";
    
    DishCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[DishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DishCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Station *station = self.meal.stations[indexPath.section];
    Dish *dish = station.dishes[indexPath.row];
    
    cell.dishNameLabel.text = dish.name;
    
    // accessory type
    if (dish.hasNutrition) {
        // selection style type
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [selectedBackgroundView setBackgroundColor:[UIColor lightScarletColor]]; // set color here
        [cell setSelectedBackgroundView:selectedBackgroundView];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    [cell.favButton addTarget:self action:@selector(toggleFav:) forControlEvents:UIControlEventTouchUpInside];
    
    if (dish.fave) {
        [cell.favButton setImage:[UIImage imageNamed:@"starred.png"] forState:UIControlStateNormal];
    }
    else
        [cell.favButton setImage:[UIImage imageNamed:@"unstarred.png"] forState:UIControlStateNormal];
}

- (void)toggleFav:(UIButton *)sender {
    
    UIView *contentView = [sender superview];
    DishCell *cell = (DishCell *)[[contentView superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    Station *station = self.meal.stations[indexPath.section];
    Dish *dish = station.dishes[indexPath.row];
    
    Station *firstStation = self.meal.stations[0];

    dish.fave = !dish.fave;
    
    if (dish.fave) {
        
        //Mark dish as favorite!
        [sender setImage:[UIImage imageNamed:@"starred.png"] forState:UIControlStateNormal];

        if (![self.menuModel.favoriteDishIds containsObject:@(dish.ID)]) {
            [self.menuModel.favoriteDishIds addObject:@(dish.ID)];
        }
        
        if ([firstStation.name isEqualToString:@"Favorites"]) {
            [self scrollPositionDownwardsWithFavoritesVenueOnScreen:YES];
        } else {
            [self scrollPositionDownwardsWithFavoritesVenueOnScreen:NO];
        }
    } else {
        [sender setImage:[UIImage imageNamed:@"unstarred.png"] forState:UIControlStateNormal];
        [self.menuModel.favoriteDishIds removeObject:@(dish.ID)];
        
        if (firstStation.dishes.count == 1) {
            [self scrollPositionUpwards:YES];
        } else {
            [self scrollPositionUpwards:NO];
        }
    }
    
    
    [self.menuModel.favoriteDishIds writeToFile:[self.menuModel favoritesFilePath] atomically:YES];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"ResetFavorites" object:nil];
    
}



- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    //Get each section from the menuvenues array and change the header to match it.
    Station *station = self.meal.stations[section];
    return station.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Station *station = self.meal.stations[indexPath.section];
    Dish *dish = station.dishes[indexPath.row];
    
    //Test Make a dish a favorite.
    if (![self.menuModel.favoriteDishIds containsObject:@(dish.ID)]) {
        [self.menuModel.favoriteDishIds addObject:@(dish.ID)];
    }
        
    [self.menuModel.favoriteDishIds writeToFile:[self.menuModel favoritesFilePath] atomically:YES];

 
    
   
    if (dish.hasNutrition) {
        
        //Initalize the nutrition view
        AJRNutritionViewController *controller = [[AJRNutritionViewController alloc] init];
        
   
        //Set the various data values for the view
        // controller.servingSize = @"12 fl oz. (1 Can)";
        // controller.calories = 100;      //Type: int
        //  controller.sugar = 12;          //Type: float
        //  controller.protein = 3;         //Type: float
        controller.dishTitle = dish.name;
        controller.servingSize = [NSString stringWithFormat:@"%@", dish.servSize];
        
        controller.calories = [dish.nutrition[@"KCAL"] floatValue];
        controller.fat = [dish.nutrition[@"FAT"] floatValue];
        controller.satfat = [dish.nutrition[@"SFA"]floatValue];
        controller.transfat = [dish.nutrition[@"FATRN"]floatValue];
        controller.cholesterol = [dish.nutrition[@"CHOL"] floatValue];
        controller.sodium = [dish.nutrition[@"NA"]floatValue];
        controller.carbs = [dish.nutrition[@"CHO"] floatValue];
        controller.dietaryfiber = [dish.nutrition[@"TDFB"] floatValue];
        controller.sugar = [dish.nutrition[@"SUGR"] floatValue];
        controller.protein = [dish.nutrition[@"PRO"] floatValue];
        
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        
        verticalMotionEffect.minimumRelativeValue = @(-26);
        verticalMotionEffect.maximumRelativeValue = @(26);
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-26);
        horizontalMotionEffect.maximumRelativeValue = @(26);
        
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        [controller.view addMotionEffect:group];
        
        [controller presentInParentViewController:self.parentViewController];
    }
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



#pragma mark - Handle Scrolling Offset Values
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection = ScrollDirectionNone;
    
    int contentOffsetDifference = scrollView.contentOffset.y - self.startContentOffset;
    
    
    if (scrollView.contentOffset.y < 0 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToolBar" object:nil];
    } else if (contentOffsetDifference > 60 ) {
        scrollDirection = ScrollDirectionUp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideToolBar" object:nil];
        
        //Set tableview insets back to normal
        //self.tableView.contentInset = UIEdgeInsetsZero;
    } else if (contentOffsetDifference < -60) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToolBar" object:nil];
        //Change tableview inset
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //When scroll View grinds to a halt, reset start Content offset
    self.startContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.startContentOffset = scrollView.contentOffset.y;
}


/*
- (void)scrollPositionUpwards {
    NSLog(@"SCrolltopositioncalled");
   // for (PanelView *p in self.visiblePages) {
        
        CGPoint tableViewPositionTapped = [self.tableView contentOffset];
        tableViewPositionTapped.y -= 44;
        //NSLog(@"x: %f, y: %f", tableViewPositionTapped.x, tableViewPositionTapped.y);
        [self.tableView setContentOffset:tableViewPositionTapped animated:NO];
   // }
}


- (void)scrollPositionDownwards {
    NSLog(@"SCrolltopositioncalled");
   // for (PanelView *p in self.visiblePages) {
        
        CGPoint tableViewPositionTapped = [self.tableView contentOffset];
        tableViewPositionTapped.y += 44;
       // NSLog(@"x: %f, y: %f", tableViewPositionTapped.x, tableViewPositionTapped.y);
        [self.tableView setContentOffset:tableViewPositionTapped animated:NO];
    //}
}
*/
/*
 //TEST. DrJid
 - (void)scrollPositionUpwards:(BOOL)withCountOne {
 NSLog(@"SCrolltopositioncalled");
 for (PanelView *p in self.visiblePages) {
 
 CGPoint tableViewPositionTapped = [p.tableView contentOffset];
 //tableViewPositionTapped.y -= 44;
 //        tableViewPositionTapped.y -= 92; //for first favorite.
 //        NSLog(@"x: %f, y: %f", tableViewPositionTapped.x, tableViewPositionTapped.y);
 if (withCountOne) {
 tableViewPositionTapped.y -= 92; //for first fav
 } else {
 tableViewPositionTapped.y -= 44;
 }
 
 
 [p.tableView setContentOffset:tableViewPositionTapped animated:NO];
 }
 }
 */

- (void)scrollPositionDownwardsWithFavoritesVenueOnScreen:(BOOL)favoritesVenuePresent {
    
    CGPoint tableViewPositionTapped = [self.tableView contentOffset];
    
    if (favoritesVenuePresent) {
        tableViewPositionTapped.y += 44;
    } else {
        tableViewPositionTapped.y += 92;
        
    }
    [self.tableView setContentOffset:tableViewPositionTapped animated:NO];
    
}

/* If the first Venue (Favorites) has a count one, we scroll by a different offset */
- (void)scrollPositionUpwards:(BOOL)withCountOne {
    
    CGPoint tableViewPositionTapped = [self.tableView contentOffset];
    if (withCountOne) {
        tableViewPositionTapped.y -= 92; //for first fav
    } else {
        tableViewPositionTapped.y -= 44;
        
    }
    [self.tableView setContentOffset:tableViewPositionTapped animated:NO];
    
}

@end
