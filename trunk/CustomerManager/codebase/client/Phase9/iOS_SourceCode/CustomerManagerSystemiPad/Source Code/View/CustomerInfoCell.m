//
//  CustomerAddressDetailCell.m
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 25/09/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "CustomerInfoCell.h"

@implementation CustomerInfoCell

@synthesize nameLabel,specialtyAndTypeLabel;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
