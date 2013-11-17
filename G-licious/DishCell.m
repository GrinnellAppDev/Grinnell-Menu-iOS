//
//  DishCell.m
//  G-licious
//
//  Created by Maijid Moujaled on 11/13/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "DishCell.h"

@implementation DishCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
