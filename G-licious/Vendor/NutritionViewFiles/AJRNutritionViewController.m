//
//  AJRNutritionViewController.m
//  AJRNutritionControllerDemo
//
//  Created by Andrew Rosenblum on 2/9/13.
//  Copyright (c) 2013 On Tap Media. All rights reserved.
//
//
//Copyright (c) 2013, Andrew Rosenblum All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. Neither the name of the nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "AJRNutritionViewController.h"
#import "AJRNutritionLabelView.h"
#import "AJRBackgroundDimmer.h"
#import "AJRNutritionLabelCalculation.h"

@interface AJRNutritionViewController () {
    IBOutlet AJRNutritionLabelView *nutritionalView;
    AJRBackgroundDimmer *backgroundGradientView;
    
    __weak IBOutlet AJRNutritionLabelView *ingredientsListView;
    
    __weak IBOutlet UILabel *ingredientsViewTitleLabel;
    __weak IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *servingLabel;
    IBOutlet UILabel *caloriesLabel;
    IBOutlet UILabel *fatLabel;
    IBOutlet UILabel *saturatedFatLabel;
    IBOutlet UILabel *transFatLabel;
    IBOutlet UILabel *cholesterolLabel;

    IBOutlet UILabel *sodiumLabel;

    IBOutlet UILabel *carbsLabel;
    IBOutlet UILabel *DietaryFiberLabel;
    IBOutlet UILabel *sugarLabel;
    
    IBOutlet UILabel *proteinLabel;
    
    IBOutlet UILabel *fatDailyValueLabel;
    IBOutlet UILabel *satfatDailyValueLabel;
    IBOutlet UILabel *cholesterolDailyValueLabel;
    IBOutlet UILabel *sodiumDailyValueLabel;
    IBOutlet UILabel *carbDailyValueLabel;
    IBOutlet UILabel *dietaryFiberDailyValueLabel;
    IBOutlet UILabel *proteinDailyValueLabel;
}

@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (nonatomic, assign) BOOL nutritionViewIsCurrent;
@end

@implementation AJRNutritionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AJRNutritionViewController" bundle:nibBundleOrNil];
    if (self) {
        self.shouldDimBackground = YES;
        self.shouldAnimateOnAppear = YES;
        self.shouldAnimateOnDisappear = YES;
        self.allowSwipeToDismiss = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNutrition) name:@"DismissNutritionalView" object:nil];

    //Sets up the background of the nutrition view
    nutritionalView.layer.cornerRadius = 5.0f;
    nutritionalView.layer.masksToBounds = YES;
    nutritionalView.layer.borderColor = [UIColor whiteColor].CGColor;
    //backgroundView.layer.borderWidth = 3.0;
    
    ingredientsListView.layer.cornerRadius = 5.0f;
    ingredientsListView.layer.masksToBounds = YES;
    ingredientsListView.layer.borderColor = [UIColor whiteColor].CGColor;
    //ingredientsListView.layer.borderWidth = 3.0f;
    self.ingredientsTable.alwaysBounceVertical = NO;
    
    //Sets the labels
    servingLabel.text =  self.servingSize;
    caloriesLabel.text = [NSString stringWithFormat:@"%i", self.calories];
    fatLabel.text = [NSString stringWithFormat:@"%.1fg", self.fat];
    saturatedFatLabel.text = [NSString stringWithFormat:@"%.01fg", self.satfat];
    transFatLabel.text = [NSString stringWithFormat:@"%.1fg", self.transfat];
    cholesterolLabel.text = [NSString stringWithFormat:@"%.1fmg", self.cholesterol];
    sodiumLabel.text = [NSString stringWithFormat:@"%.01fmg", self.sodium];
    carbsLabel.text = [NSString stringWithFormat:@"%.01fg", self.carbs];
    DietaryFiberLabel.text = [NSString stringWithFormat:@"%.01fg", self.dietaryfiber];
    sugarLabel.text = [NSString stringWithFormat:@"%.01fg", self.sugar];
    proteinLabel.text = [NSString stringWithFormat:@"%.01fg", self.protein];
    
    //Calculates the % daily value for the appropiate fields
    fatDailyValueLabel.text = [AJRNutritionLabelCalculation calculateFatDailyValue:[self fat]];
    satfatDailyValueLabel.text = [AJRNutritionLabelCalculation calculateSaturatedFatDailyValue:[self satfat]];
    cholesterolDailyValueLabel.text = [AJRNutritionLabelCalculation calculateCholesterolDailyValue:[self cholesterol]];
    sodiumDailyValueLabel.text = [AJRNutritionLabelCalculation calculateSodiumDailyValue:[self sodium]];
    carbDailyValueLabel.text = [AJRNutritionLabelCalculation calculateTotalCarbDailyValue:[self carbs]];
    dietaryFiberDailyValueLabel.text = [AJRNutritionLabelCalculation calculateDietaryFiberDailyValue:[self dietaryfiber]];

    carbDailyValueLabel.text =  [AJRNutritionLabelCalculation calculateTotalCarbDailyValue:[self carbs]];
    
    titleLabel.text = self.dishTitle;
    ingredientsViewTitleLabel.text = self.dishTitle;
    
    if (self.allowSwipeToDismiss) {
        //Add a swipe gesture recognizer to dismiss the view 
        UISwipeGestureRecognizer *downwardGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDownwards)];
        [downwardGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        
        UISwipeGestureRecognizer *upwardGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissUpwards)];
        [upwardGestureRecognizer  setDirection:(UISwipeGestureRecognizerDirectionUp)];
        
        UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLeftward)];
        [leftGestureRecognizer  setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
        UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightward)];
        [rightGestureRecognizer  setDirection:(UISwipeGestureRecognizerDirectionRight)];


        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInward)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        
        [self.view addGestureRecognizer:downwardGestureRecognizer];
        [self.view addGestureRecognizer:upwardGestureRecognizer];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.view addGestureRecognizer:leftGestureRecognizer];
            [self.view addGestureRecognizer:rightGestureRecognizer];
            [self.view addGestureRecognizer:tapGestureRecognizer];
        } else {
            
        }
    }
}

- (void)presentInParentViewController:(UIViewController *)parentViewController {
    //Presents the view in the parent view controller
    
    //Disable the navigation buttons when nutritional view controller is showing.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WillShowNutritionalView" object:nil];
    
    if (self.shouldDimBackground == YES) {
        //Dims the background, unless overridden
        backgroundGradientView = [[AJRBackgroundDimmer alloc] initWithFrame:parentViewController.view.bounds];
        
        [parentViewController.view addSubview:backgroundGradientView];
        
        self.nutritionViewIsCurrent = [[NSUserDefaults standardUserDefaults] boolForKey:@"nutritionViewIsCurrent"];
        
        
        // BOTH views should be hidden in the .xib files. Else there will be wierd errors. when flipping.
        // Setting both views to hidden here as well.
        // Update: Since the ingredients view was taken out. Default to always showing the nutrition view.
        
        /*
        nutritionalView.hidden = YES;
        ingredientsListView.hidden = YES;
        
        if (self.nutritionViewIsCurrent) {
            nutritionalView.hidden = NO;
        } else {
            ingredientsListView.hidden = NO;
        }
        */
        
        nutritionalView.hidden = NO;
        
        
        UISwipeGestureRecognizer *downwardGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDownwards)];
        [downwardGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [backgroundGradientView addGestureRecognizer:downwardGestureRecognizer];
    }
    
    //Adds the nutrition view to the parent view, as a child
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
  
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
    } else {
        self.view.frame = CGRectMake(screenWidth/4, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    //Adds the bounce animation on appear unless overridden
    if (!self.shouldAnimateOnAppear)
        return;
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.7f],
                              [NSNumber numberWithFloat:1.2f],
                              [NSNumber numberWithFloat:0.9f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
    
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.334f],
                                [NSNumber numberWithFloat:0.666f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
    
    bounceAnimation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       nil];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.duration = 0.1;
    [backgroundGradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (void) dismissNutrition {
    [self dismissFromParentViewControllerDownwards:YES];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self didMoveToParentViewController:self.parentViewController];
}

- (void)dismissDownwards {
    [self dismissFromParentViewControllerDownwards:YES];
}

- (void)dismissUpwards {
    [self dismissFromParentViewControllerDownwards:NO];
}

- (void)dismissRightward {
    [self dismissFromParentViewControllerRightwards:YES];
}

- (void)dismissLeftward {
    [self dismissFromParentViewControllerRightwards:NO];
}

- (IBAction)flip:(id)sender {
    
    [UIView transitionWithView:self.view
                      duration:0.35
                       options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        if (self.nutritionViewIsCurrent) {
            nutritionalView.hidden = YES;
            ingredientsListView.hidden = NO;
        } else {
            ingredientsListView.hidden = YES;
            nutritionalView.hidden = NO;
        }
    } completion:^(BOOL finished) {
        self.nutritionViewIsCurrent = !self.nutritionViewIsCurrent;
        [[NSUserDefaults standardUserDefaults] setBool:self.nutritionViewIsCurrent forKey:@"nutritionViewIsCurrent"];
    }];
}

- (void)dismissFromParentViewControllerDownwards:(BOOL)downwards
{
    //Removes the nutrition view from the superview
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WillDismissNutritionalView" object:nil];
    
    [self willMoveToParentViewController:nil];
    
    //Removes the view with or without animation
    if (!self.shouldAnimateOnDisappear) {
        [self.view removeFromSuperview];
        [backgroundGradientView removeFromSuperview];
        [self removeFromParentViewController];
        return;
    }
    else {
        [UIView animateWithDuration:0.4 animations:^ {
            CGRect rect = self.view.bounds;
            if (downwards) {
                rect.origin.y += rect.size.height;
            } else
                rect.origin.y -= rect.size.height;

            self.view.frame = rect;
            backgroundGradientView.alpha = 0.0f;
            self.view.alpha = 0.0;

        }
                         completion:^(BOOL finished) {
                             [self.view removeFromSuperview];
                             [backgroundGradientView removeFromSuperview];
                             [self removeFromParentViewController];
                         }];
    }
}

- (void)dismissFromParentViewControllerRightwards:(BOOL)rightwards
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WillDismissNutritionalView" object:nil];
    
    [self willMoveToParentViewController:nil];
    
    //Removes the view with or without animation
    if (!self.shouldAnimateOnDisappear) {
        [self.view removeFromSuperview];
        [backgroundGradientView removeFromSuperview];
        [self removeFromParentViewController];
        return;
    } else {
        [UIView animateWithDuration:0.4
                         animations:^{
                             CGRect rect = self.view.bounds;
                             CGAffineTransform transform;
                             if (rightwards) {
                                 rect.origin.x += rect.size.width;
                              transform = CGAffineTransformMakeRotation(-30);
                             }  else {
                                 rect.origin.x -= rect.size.width;
                                 transform = CGAffineTransformMakeRotation(30);
                             }
                             self.view.frame = rect;
                             self.view.transform = transform;
                             self.view.alpha = 0.0;
                             backgroundGradientView.alpha = 0.0f;
                             
                         } completion:^(BOOL finished) {
                             [self.view removeFromSuperview];
                             [backgroundGradientView removeFromSuperview];
                             [self removeFromParentViewController];
                         }];
    }
    
}

- (void)dismissInward {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WillDismissNutritionalView" object:nil];

    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.25
     
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeScale(0.2, 0.2);
                         self.view.transform = transform;
                         self.view.alpha = 0.0f;
                         backgroundGradientView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [backgroundGradientView removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}


- (void)viewDidUnload {
    saturatedFatLabel = nil;
    [super viewDidUnload];
    self->nutritionalView = nil;
    self->carbDailyValueLabel = nil;
    self->fatDailyValueLabel = nil;
    NSLog(@"view did unload");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredientsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ingredient = self.ingredientsArray[indexPath.row];
    CGSize maxSize = CGSizeMake(210.0f, MAXFLOAT); //210 because that's the width of our ingredients text label on screen.
    CGRect labelRect = [ingredient boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14.0f]} context:nil];
    return  MAX(labelRect.size.height + 10.0f, 40); //10.0f for padding.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"IngredientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *ingredient = self.ingredientsArray[indexPath.row];
    cell.textLabel.text = ingredient;
    
    //Customize Cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
