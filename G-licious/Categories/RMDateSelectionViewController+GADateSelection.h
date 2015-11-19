//
//  RMDateSelectionViewController+GADateSelector.h
//  G-licious
//
//  Created by Tyler Dewey on 11/18/15.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <RMDateSelectionViewController/RMDateSelectionViewController.h>

@interface RMDateSelectionViewController (GADateSelection)

/**
 * Returns a RMDateSelectionViewController configured as
 * we typically use it in this app: with a "today" action
 * and a Date-style datepicker (not date-time)
 */
+ (instancetype)configuredDateSelectionControllerWithSelectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction;

+ (RMAction<RMActionController<UIDatePicker *> *> *)makeTodayAction;

@end
