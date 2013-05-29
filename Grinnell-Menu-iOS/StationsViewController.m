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


@interface StationsViewController ()

@end

@implementation StationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray *breakfast = @[@"Bread", @"Margarine", @"Lettuce"];
        NSArray *lunch = @[@"pig", @"Turkey", @"Beef"];
        NSArray *dinner = @[@"Cheese", @"Pizza", @"Carrot"];
       // self.originalMenu = @[breakfast, lunch, dinner];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showNutritionalLabel:)
                                                     name:@"ShowNutritionalDetails"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareMenu];
    
    //initial setup of the TTScrollSlidingPagesController.
    TTScrollSlidingPagesController *slider = [[TTScrollSlidingPagesController alloc] init];
    
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    //slider.titleScrollerHidden = YES;
    //slider.titleScrollerHeight = 100;
    //slider.titleScrollerItemWidth=60;
    //slider.titleScrollerBackgroundColour = [UIColor darkGrayColor];
    //slider.disableTitleScrollerShadow = YES;
    //slider.disableUIPageControl = YES;
    //slider.initialPageNumber = 1;
    //slider.pagingEnabled = NO;
    //slider.zoomOutAnimationDisabled = YES;
    
    //set the datasource.
    slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    slider.view.frame = self.view.frame;
    [self.view addSubview:slider.view];
    [self addChildViewController:slider];
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
    NSLog(@"v meals: %@", viewController.meal);
    
    NSLog(@"%s index:%d", __PRETTY_FUNCTION__, index);
    
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
    //TODO initWithProperDate
    MenuModel *menuModel = [[MenuModel alloc] initWithDate:[NSDate date]];
    self.menu = [menuModel performFetchForDate:[NSDate date]];
    
    NSLog(@"self.origMenu: %@", self.menu);
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

@end
