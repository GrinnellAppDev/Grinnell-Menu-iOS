//
//  Settings.h
//  Grinnell-Menu-iOS
//
//  Created by Colin Tremblay on 10/22/11.
//  Copyright 2011 __GrinnellAppDev__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Settings : UIViewController {
    UITableView *newTableView;
}

- (void)settingsDelegateDidFinish:(Settings *)controller;
@property (nonatomic, retain) IBOutlet UITableView *newTableView;
@end

