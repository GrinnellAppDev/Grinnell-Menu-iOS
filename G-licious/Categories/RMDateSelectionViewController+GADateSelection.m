//
//  RMDateSelectionViewController+GADateSelection.m
//  G-licious
//
//  Created by AppDev on 11/18/15.
//  Copyright © 2015 Maijid Moujaled. All rights reserved.
//

#import "RMDateSelectionViewController+GADateSelection.h"

@implementation RMDateSelectionViewController (GADateSelection)

/**
 * Returns a RMDateSelectionViewController configured as
 * we typically use it in this app: with a "today" action
 * and a Date-style datepicker (not date-time)
 */
+ (instancetype)configuredDateSelectionControllerWithSelectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController
                                                                actionControllerWithStyle:style
                                                                selectAction:selectAction
                                                                andCancelAction:cancelAction];
    
    dateSelectionController.view.tintColor = [UIColor scarletColor];
    
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    
    dateSelectionController.title = @"Pick a Date";
    
    [dateSelectionController addAction:[self makeTodayAction]];
    
    return dateSelectionController;
}

+ (RMAction<RMActionController<UIDatePicker *> *> *)makeTodayAction {
    
    RMAction<RMActionController<UIDatePicker *> *> *todayAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Today" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
        controller.contentView.date = [NSDate date];
    }];
    
    todayAction.dismissesActionController = NO;
    
    return todayAction;
}

@end
