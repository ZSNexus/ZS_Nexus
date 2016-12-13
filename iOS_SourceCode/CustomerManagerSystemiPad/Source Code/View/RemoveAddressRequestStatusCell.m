//
//  RemoveAddressRequestStatusCell.m
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 31/10/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import "RemoveAddressRequestStatusCell.h"

@implementation RemoveAddressRequestStatusCell
@synthesize addressID, statusLabel;

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
