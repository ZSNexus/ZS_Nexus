//
//  RequestStatusCell.m
//  CustomerManagerSystemiPad
//
//  Created by Shri on 16/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "RequestStatusCell.h"

@implementation RequestStatusCell

@synthesize requestTypeLabel, statusLabel, actionDateLabel;

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
