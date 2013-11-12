//
//  StationsViewController.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/1/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "StationsViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "MealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RMDateSelectionViewController.h"
#import "MenuModel.h"
#import "DiningHallHours.h"
#import "UIColor+GAColor.h"
#import <NSCalendar+equalWithGranularity.h>


@interface StationsViewController () <RMDateSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) TTScrollSlidingPagesController *slider;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RMDateSelectionViewController *dateSelectionViewController;
@property (nonatomic, strong) MenuModel *menuModel;
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int availableDays;

@property (weak, nonatomic) IBOutlet UILabel *navigationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dateBarButton;

@end

@implementation StationsViewController
{
    int _currentPage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"haha"); 
}

- (void)dealloc
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.date = [NSDate date];
    DLog(@"date: %@", self.date);
    [self setCurrentPage];
    DLog(@"currentPage = %d", _currentPage);
    [self prepareMenu];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideToolBar) name:@"HideToolBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToolBar) name:@"ShowToolBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageControlChangedPage:) name:@"PageControlChangedPage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetFilters)
                                                 name:@"ResetFilters"
                                               object:nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetStations) name:@"ResetStationsView" object:nil];
    
    
    //Set up the slider Control
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    //self.slider.hideStatusBarWhenScrolling = YES;
    //self.slider.titleScrollerHidden = YES;
    self.slider.titleScrollerHeight = 30;
    //slider.titleScrollerItemWidth=60;
    self.slider.titleScrollerBackgroundColour = [UIColor colorWithWhite:0.125 alpha:1.0f];
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.disableUIPageControl = YES;
    //slider.initialPageNumber = 1;
    //slider.pagingEnabled = NO;
    //self.slider.zoomOutAnimationDisabled = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        //self.slider.hideStatusBarWhenScrolling = YES;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    //set the datasource.
    self.slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    
    //Change Z position of toolbar so it is always on top
    [self.view bringSubviewToFront:self.toolbar];
    [self.slider scrollToPage:_currentPage animated:NO];
    
    //Download the menu
    //MenuModel *model = [[MenuModel alloc] initWithDate:[NSDate date]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)prepareMenu
{
    //TODO initWithProperDate
    self.menuModel = [[MenuModel alloc] initWithDate:self.date];
    
    /*
    [self.menuModel performFetchWithCompletionBlock:^(NSArray *filteredMenu, NSError *error) {
        self.menu = filteredMenu;
        DLog(@"Self.menu; %@", filteredMenu);
        DLog(@"start relading");
        [self.slider reloadPages];
        DLog(@"end reloading");
    }];
    */
    
    
    self.menu = [self.menuModel performFetch];
    DLog(@"sm: %@", self.menu);

    self.availableDays = self.menuModel.availableDays;
    [self updateNavigationDateLabel];
    
    //set date
    //[self.slider scrollToPage:1 animated:YES];
   // DLog(@"Self.menu aD %d", self.availableDays);
    [self showHudForDate:self.date];

}



- (void)updateNavigationDateLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter  setDateFormat:@"EEE, MMM dd"];
    NSString *formattedDateString = [dateFormatter stringFromDate:self.date];
    self.navigationDateLabel.text = formattedDateString;
    
    self.dateBarButton.title = formattedDateString;
}

- (IBAction)changeDate:(id)sender {
    
    if (!self.dateSelectionViewController) {
        self.dateSelectionViewController = [RMDateSelectionViewController dateSelectionController];
        self.dateSelectionViewController.delegate = self;
        self.dateSelectionViewController.view.tintColor = [UIColor scarletColor];
    }
    
    [self.dateSelectionViewController show];
    [self.dateSelectionViewController.datePicker setMinimumDate:[NSDate date]];
    int range = 24 * 60 * 60 * self.availableDays;
    NSDate *maxDate = [[NSDate alloc] initWithTimeIntervalSinceNow:range];
    self.dateSelectionViewController.datePicker.maximumDate = maxDate;

}

#pragma mark - TTSlidingPageController delegate methods
- (int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source
{
    return self.menu.count;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MealViewController *mealViewController = [storyboard instantiateViewControllerWithIdentifier:@"MealViewController"];
    mealViewController.meal = self.menu[index];
    
    /*
     MealViewController *viewController = [[MealViewController alloc] init];
     viewController.meal = self.menu[index];
     
     
     return [[TTSlidingPage alloc] initWithContentViewController:viewController];
     */ 
    
//    MealViewController *mealViewController = [[MealViewController alloc] init];
    return [[TTSlidingPage alloc] initWithContentViewController:mealViewController];


}

- (void)pageControlChangedPage:(NSNotification *)notification
{
    int index =  [notification.object intValue];
    _currentPage = index;
    NSString *meal = [self.menu[index] name];
    NSString *hoursString = [DiningHallHours hoursForMeal:meal onDay:self.date];
    //DLog(@"meal: %@", hoursString);
    self.hoursLabel.text = [NSString stringWithFormat:@"Hours: %@",  hoursString ];
    
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    

    TTSlidingPageTitle *title = [[TTSlidingPageTitle alloc] initWithHeaderText:[self.menu[index] name]];
    return title;
}

- (void)hideToolBar
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.toolbar.alpha = 0.0f;
                     }];
}


- (void)showToolBar
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.toolbar.alpha = 1.0f;
                         self.toolbar.transform = CGAffineTransformIdentity;
                     }];
}

#pragma mark - RMDateSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    //Do something
    DLog(@"date Selection picked: %@", aDate);
    self.menuModel = [[MenuModel alloc] initWithDate:aDate];
    self.date = aDate;
    [self prepareMenu];
    
    //Disable the zoom out animation to prevent it from crashing when displaying a menu with less pages.
    self.slider.zoomOutAnimationDisabled = YES;
    [self.slider reloadPages];
    self.slider.zoomOutAnimationDisabled = NO;
  //  [self showHudForDate:aDate];
}

- (void)showHudForDate:(NSDate *)date {
    NSString *selectedDateString = [self selectedDateStringFromDate:date];
    
    //Show HUD
    [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor colorWithWhite:0.8f alpha:0.4]];
    
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@'s Menu", selectedDateString]];
}

- (NSString *)selectedDateStringFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    if  ( [calendar ojf_isDate:date equalToDate:today withGranularity:NSDayCalendarUnit] ) {
        return @"Today";
    } else if( [calendar ojf_isDate:date equalToDate:tomorrow withGranularity:NSDayCalendarUnit] ) {
        return @"Tomorrow";
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE"];
        NSString *dateString = [dateFormat stringFromDate:date];
        return dateString;
    }
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    //Do something else
}

#pragma mark - Reset Filters
- (void)resetFilters
{
    [self prepareMenu];
    [self.slider reloadPages];
    
    //Scroll to the page that was previously on display
    [self.slider scrollToPage:_currentPage animated:NO];
}


#pragma mark - Determine Current Page
/* Sets the page value that the Stations view should scroll to depending on the time
 * of the day G-licious was accessed
 */
- (void)setCurrentPage
{
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit fromDate:self.date];
    
    NSDate *tomorrow = [[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:self.date];
    
    DLog(@"Today: %@" , self.date);
    DLog(@"Tomorrow: %@", tomorrow);
    
    NSInteger hour = [todayComponents hour];
    NSInteger minute = [todayComponents minute];
    NSInteger weekday = [todayComponents weekday];
    
    //Sunday
    if (weekday == 1){
        if (hour < 13 || (hour < 14 && minute < 30))
            //self.mealChoice = @"Lunch";
            _currentPage = 0;
        else if (hour < 19)
            _currentPage = 1;
        //self.mealChoice = @"Dinner";
        else {
            //self.mealChoice = @"Breakfast";
            _currentPage = 0;
            self.date = tomorrow;
        }
    }
    
    //Saturday
    else if (weekday == 7){
        if (hour < 10)
            _currentPage = 0;
        else if (hour < 13 || (hour < 14 && minute < 30))
            _currentPage = 1;
        else if (hour < 19)
            _currentPage = 2;
        else{
            _currentPage = 0;
            self.date = tomorrow;
        }
    }
    //Friday
    else if (weekday == 6){
        if (hour < 10)
            _currentPage = 0;
        else if (hour < 13 || (hour < 14 && minute < 30))
            _currentPage = 1;
        else if (hour < 19)
            _currentPage = 2;
        else{
            _currentPage = 1;
            self.date = tomorrow;
        }
    }
    //All other days
    else{
        if (hour < 10)
            _currentPage = 0;
        else if (hour < 13 || (hour < 14 && minute < 30))
            _currentPage  = 1;
        else if (hour < 20)
            _currentPage = 2;
        else {
            _currentPage  = 0;
            self.date = tomorrow;
        }
    }
}
@end
