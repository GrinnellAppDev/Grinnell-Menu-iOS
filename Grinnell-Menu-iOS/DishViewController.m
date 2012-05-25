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

@implementation DishViewController
@synthesize nutritionDetails, dishRow, dishSection;

- (IBAction)backToMainMenu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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
    nutritionDetails.text = @"Calories %@\nTotal Fat %@g\n\tSaturated Fat %@g\n\tTrans Fat %@g\nCholesterol %@mg\nSodium %@mg\nPotassium %@mg\nTotal Carbohydrate %@g\n\tDietary Fiber %@g\n\tSugars %@g\nProtein %@g\nPOLY %@g\nMONO %@g\n\nVitamin A (IU):%@\tVitamin C %@mg\nVitamin B6:%@\tVitamin B12 %@mcg\nZinc %@mg\tIron %@mg\nCalcium %@mg", 
        [dish.nutrition objectForKey:@"KCAL"], 
        [dish.nutrition objectForKey:@"FAT"],
        [dish.nutrition objectForKey:@"SFA"],
        [dish.nutrition objectForKey:@"FATRN"], 
        [dish.nutrition objectForKey:@"CHOL"], 
        [dish.nutrition objectForKey:@"NA"], 
        [dish.nutrition objectForKey:@"K"], 
        [dish.nutrition objectForKey:@"CHO"], 
        [dish.nutrition objectForKey:@"TDFB"],
        [dish.nutrition objectForKey:@"SUGR"],
        [dish.nutrition objectForKey:@"PRO"], 
        [dish.nutrition objectForKey:@"POLY"], 
        [dish.nutrition objectForKey:@"MONO"], 
        [dish.nutrition objectForKey:@"VITAIU"], 
        [dish.nutrition objectForKey:@"VITC"],
        [dish.nutrition objectForKey:@"B6"],
        [dish.nutrition objectForKey:@"B12"], 
        [dish.nutrition objectForKey:@"ZN"], 
        [dish.nutrition objectForKey:@"FE"], 
        [dish.nutrition objectForKey:@"CA"];
    self.title = dish.name;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    //Main Menu button
    UIBarButtonItem *toMainMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMainMenu:)];
    [self.navigationItem setRightBarButtonItem:toMainMenuButton];
    
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
