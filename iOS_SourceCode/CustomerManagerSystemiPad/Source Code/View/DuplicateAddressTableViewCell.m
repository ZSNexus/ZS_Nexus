//
//  DuplicateAddressTableViewCell.m
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 29/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import "DuplicateAddressTableViewCell.h"

@implementation DuplicateAddressTableViewCell

@synthesize masterIdAns;
@synthesize masterId;
@synthesize address;
@synthesize addressType;
@synthesize addressTypeAns;

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
