//
//  DishCell.h
//  G-licious
//
//  Created by Maijid Moujaled on 11/13/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

@end
