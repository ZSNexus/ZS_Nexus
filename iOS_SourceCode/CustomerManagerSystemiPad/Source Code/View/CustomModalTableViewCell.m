//
//  CustomModalTableViewCell.m
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/8/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "CustomModalTableViewCell.h"

@implementation CustomModalTableViewCell

@synthesize cellTitleLabel;
@synthesize cellTextField;
@synthesize clearTextFieldButton;

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
