//
//  AddCustomerCustomCellSearchTwo.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 10/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "AddCustomerCustomCellSearchTwo.h"

@implementation AddCustomerCustomCellSearchTwo
@synthesize txtLabel,txtField;
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
