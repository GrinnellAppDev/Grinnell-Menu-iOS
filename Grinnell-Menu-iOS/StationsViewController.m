//
//  StationsViewController.m
//  Grinnell-Menu-iOS
//
//  Created by Maijid Moujaled on 5/29/13.
//
//

#import "StationsViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "MealViewController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "MenuModel.h"
#import "Meal.h"
#import "Dish.h"

#import "AJRNutritionViewController.h"
#import "SettingsViewController.h"


@interface StationsViewController ()
@property (nonatomic, strong) MenuModel *menuModel;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (nonatomic, strong) SettingsViewController *settingsViewController;

//-(void)setDate:(NSDate *)date;

@end

@implementation StationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Stations";
        [self setBottomBar];
        [self setChangeDateButton];
        [self setChangeMealButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showNutritionalLabel:)
                                                     name:@"ShowNutritionalDetails"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetFilters)
                                                     name:@"ResetFilters"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self prepareMenu];
    
    //initial setup of the TTScrollSlidingPagesController.
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    //slider.titleScrollerHidden = YES;
    self.slider.titleScrollerHeight = 23;
    //slider.titleScrollerItemWidth=60;
    //self.slider.titleScrollerBackgroundColour = [UIColor darkGrayColor];
    //slider.disableTitleScrollerShadow = YES;
    self.slider.disableUIPageControl = YES;
    //slider.initialPageNumber = 1;
    //slider.pagingEnabled = NO;
    //slider.zoomOutAnimationDisabled = YES;
    
    //set the datasource.
    self.slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TTSlidingPagesDataSource methods
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    
    return self.menu.count;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    //UIViewController *viewController;
    
    /*
     if (index % 2 == 0){ //just an example, alternating views between one example table view and another.
     viewController = [[TabOneViewController alloc] init];
     } else {
     viewController = [[TabTwoViewController alloc] init];
     }
     */
    MealViewController *viewController = [[MealViewController alloc] init];
    viewController.meal = self.menu[index];
    
    
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}


-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    
    //Example-code use a image as the header for the first page
    //title= [[TTSlidingPageTitle alloc] initWithHeaderImage:[UIImage imageNamed:@"about-tomthorpelogo.png"]];
    
    title = [[TTSlidingPageTitle alloc] initWithHeaderText:[self.menu[index] name]];
    return title;
}

-(void)prepareMenu
{

    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * -14];
    NSLog(@"today: %@" ,today);
    //TODO initWithProperDate
    self.menuModel = [[MenuModel alloc] initWithDate:today];
    self.menu = [self.menuModel performFetch];
    
   // NSLog(@"self.origMenu: %@", self.menu);
}

-(void)showNutritionalLabel:(NSNotification *)notification
{
    
    Dish *dish = [notification object];
    
    //Set Screen details for particular dish.
    //These changes undo in AJRNutritionViewController.m "close" method when the nutrition view is dismissed.
    

    
    //Initalize the nutrition view
    AJRNutritionViewController *controller = [[AJRNutritionViewController alloc] init];
    
    //Set the various data values for the view
    // controller.servingSize = @"12 fl oz. (1 Can)";
    // controller.calories = 100;      //Type: int
    //  controller.sugar = 12;          //Type: float
    //  controller.protein = 3;         //Type: float
    
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
    
    
    //Present the View
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        self.title = dish.name;
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        [controller presentInParentViewController:self];
    }
    
    /*
     *Optional Customizations
     *
     *controller.shouldDimBackground = YES;              //Default: YES
     *controllershouldAnimateOnAppear = YES;             //Default: YES
     *controller.shouldAnimateOnDisappear = YES;         //Default: YES
     *
     *By default, the user can perform a swipe gesture (in the downward direction)
     *to dismiss the popup
     *controller.allowSwipeToDismiss = YES;              //Default: YES
     */
    


}


-(void)setChangeDateButton
{
    UIButton *cdb = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    [cdb setBackgroundImage:[UIImage imageNamed:@"Calendar-Week"] forState:UIControlStateNormal];
    [cdb addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *changeDateButton =[[UIBarButtonItem alloc]  initWithCustomView:cdb];
    self.navigationItem.leftBarButtonItem = changeDateButton;
}

-(void)setChangeMealButton
{
    UIButton *cmb = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    [cmb setBackgroundImage:[UIImage imageNamed:@"changeMeal"] forState:UIControlStateNormal];
    [cmb addTarget:self action:@selector(changeMeal) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *changeMealButton =[[UIBarButtonItem alloc]  initWithCustomView:cmb];
    [self.navigationItem setRightBarButtonItem:changeMealButton];
}

-(void)setBottomBar
{
    [self.view bringSubviewToFront:self.bottomToolBar];

  //  UIBarButtonItem *hoursLabelItem = [[UIBarButtonItem alloc] initWithCustomView:self.hoursLabel];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    

    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        NSArray *toolbarItems = [NSArray arrayWithObjects: spaceItem, hoursLabelItem, spaceItem, nil];
        [bottomToolBar setItems:toolbarItems animated:YES];
    } else {
      */
    
        UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        NSArray *toolbarItems = [NSArray arrayWithObjects: spaceItem, /*hoursLabelItem,*/  spaceItem, infoBarButtonItem,  nil];
        [self.bottomToolBar setItems:toolbarItems animated:YES];
   // }
}

- (void)changeDate {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    /*
    else {
        //It's iPad.
        if (self.datePickerViewController == nil) {
            self.datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
            self.datePickerViewController.delegate = self;
            self.datePickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.datePickerViewController];
        }
        if ([self.datePickerPopover isPopoverVisible]) {
            [self.datePickerPopover dismissPopoverAnimated:YES];
        } else {
            if ([self.settingsPopover isPopoverVisible])
                [self.settingsPopover dismissPopoverAnimated:YES];
            [self.datePickerPopover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
     */
    
}

- (void)changeMeal {
    
    
    
    UIAlertView *mealmessage = [[UIAlertView alloc]
                                initWithTitle:@"Select Meal"
                                message:nil
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:nil
                                ];
    
   [self.menu enumerateObjectsUsingBlock:^(Meal *meal, NSUInteger idx, BOOL *stop) {
       [mealmessage addButtonWithTitle:meal.name];
   }];
    [mealmessage show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    else {
        [self.slider scrollToPage:buttonIndex-1 animated:YES];
    }
}

//Flip over to the SettingsViewController
- (IBAction)showInfo:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // Records when user goes to info Screen, records data in Flurry.
        // Log in to check data analytics at Flurry.com: If you don't have a access. Let me know! @DrJid
     //   [FlurryAnalytics logEvent:@"Flipped to Settings"];
        SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
        navController.navigationBar.barStyle = UIBarStyleBlack;
        navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:navController animated:YES completion:nil];
    }
    /*
    else {
        //It's iPad.
        if (self.settingsViewController == nil) {
            self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            //self.settingsViewController.delegate = self;
            self.settingsPopover = [[UIPopoverController alloc] initWithContentViewController:self.settingsViewController];
        }
        
        if ([self.settingsPopover isPopoverVisible]) {
            [self.settingsPopover dismissPopoverAnimated:YES];
        } else {
            if ([self.datePickerPopover isPopoverVisible])
                [self.datePickerPopover dismissPopoverAnimated:YES];
            [self.settingsPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
     */ 
}

-(void)resetFilters
{
    [self prepareMenu];
    [self.slider reloadPages];
}

/*
-(void)setDate:(NSDate *)date
{
    _date = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * -14];
}
 */

/*
 //DateFormatting used to set the Date Label. Might be needed here. TODO
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter  setDateFormat:@"EEE MMM dd"];
 NSString *formattedDate = [dateFormatter stringFromDate:self.date];
 */

@end
