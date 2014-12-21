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
#import "FavoritesManager.h"
#import "AJRNutritionViewController.h"
#import "AJRNutritionViewController+GADish.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];

    //Push tableView contentInset so it doesn't get hidden behind the bottom toolbar.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)sendShowToolbarNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToolBar" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.meal.stations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Station *station = self.meal.stations[section];
    return station.dishes.count;
}

- (DishCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NutritionCellIdentifier = @"NutritionDishCell";
    static NSString *PlainCellIdentifier = @"PlainDishCell";
    DishCell *cell;
    
    Station *station = self.meal.stations[indexPath.section];
    Dish *dish = station.dishes[indexPath.row];
    
    if (dish.hasNutrition) {
        cell = [tableView dequeueReusableCellWithIdentifier:NutritionCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:PlainCellIdentifier forIndexPath:indexPath];
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
    
    if (dish.hasNutrition) {
        // selection style type
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [selectedBackgroundView setBackgroundColor:[UIColor lightScarletColor]]; // set color here
        [cell setSelectedBackgroundView:selectedBackgroundView];
        
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.favButton addTarget:self action:@selector(toggleFav:) forControlEvents:UIControlEventTouchUpInside];
    
    if (dish.fave) {
        [cell.favButton setImage:[UIImage imageNamed:@"starred_red.png"] forState:UIControlStateNormal];
    } else {
        [cell.favButton setImage:[UIImage imageNamed:@"unstarred_red.png"] forState:UIControlStateNormal];
    }
}

- (void)toggleFav:(UIButton *)sender {
    UIView *contentView = [sender superview];
    DishCell *cell;
    
    FavoritesManager *favoritesManager = [FavoritesManager sharedManager];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        cell = (DishCell *) [contentView superview];
    } else {
        cell = (DishCell *) [[contentView superview] superview];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Station *station = self.meal.stations[indexPath.section];
    Dish *dish = station.dishes[indexPath.row];
    
    Station *firstStation = self.meal.stations[0];

    dish.fave = !dish.fave;
    
    if (dish.fave) {
        //Mark dish as favorite!
        [sender setImage:[UIImage imageNamed:@"starred_red.png"] forState:UIControlStateNormal];

        if (![favoritesManager containsFavorite:dish]) {
            [favoritesManager addFavorite:dish];
        }
        
        if ([firstStation.name isEqualToString:@"Favorites"]) {
            [self scrollPositionDownwardsWithFavoritesVenueOnScreen:YES];
        } else {
            [self scrollPositionDownwardsWithFavoritesVenueOnScreen:NO];
        }
    }
    else {
        [sender setImage:[UIImage imageNamed:@"unstarred_red.png"] forState:UIControlStateNormal];
        [favoritesManager removeFavorite:dish];
        
        if (firstStation.dishes.count == 1) {
            [self scrollPositionUpwards:YES];
        } else {
            [self scrollPositionUpwards:NO];
        }
    }
    
    [self.menuModel.favoriteDishIds writeToFile:[self.menuModel favoritesFilePath] atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetFavorites" object:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //Get each section from the menuvenues array and change the header to match it.
    Station *station = self.meal.stations[section];
    return station.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Kandy Wilson says the nutrition info is outdated and wants it removed from the app for now
    
    Station *station = self.meal.stations[indexPath.section];
    Dish *dish = station.dishes[indexPath.row];
    
    //TODO:(DrJid) We should probably modigy the AJR View to take in a dish object. So all this stuff can be done by the AJRView directly..
    
    if (dish.hasNutrition) {
        
        // Initalize the nutrition view
        AJRNutritionViewController *controller = [AJRNutritionViewController controllerWithDish:dish];
        
        // Add motion effects to
        
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


#pragma mark - Handle Scrolling Offset Values
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetDifference = scrollView.contentOffset.y - self.startContentOffset;
    
    if (scrollView.contentOffset.y < 0 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToolBar" object:nil];
    } else if (contentOffsetDifference > 60 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideToolBar" object:nil];
        
        //Set tableview insets back to normal
        //self.tableView.contentInset = UIEdgeInsetsZero;
    } else if (contentOffsetDifference < -60) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToolBar" object:nil];
        //Change tableview inset
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //When scroll View grinds to a halt, reset start Content offset
    self.startContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.startContentOffset = scrollView.contentOffset.y;
}

- (void)scrollPositionDownwardsWithFavoritesVenueOnScreen:(BOOL)favoritesVenuePresent {
    CGPoint tableViewPositionTapped = [self.tableView contentOffset];
    
    if (favoritesVenuePresent)
        tableViewPositionTapped.y += 44;
    else
        tableViewPositionTapped.y += 92;
    
    [self.tableView setContentOffset:tableViewPositionTapped animated:NO];
}

/* If the first Venue (Favorites) has a count one, we scroll by a different offset */
- (void)scrollPositionUpwards:(BOOL)withCountOne {
    CGPoint tableViewPositionTapped = [self.tableView contentOffset];
    if (withCountOne)
        tableViewPositionTapped.y -= 92; //for first fav
    else
        tableViewPositionTapped.y -= 44;
    
    [self.tableView setContentOffset:tableViewPositionTapped animated:NO];
}

@end
