//
//  CustomerAddressDetailCell.m
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 25/09/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "CustomerAddressDetailCell.h"

@implementation CustomerAddressDetailCell

@synthesize add1,add2,add3;
@synthesize addTerritoryBtn;
@synthesize rejectTargetBtn;
@synthesize imageType;
@synthesize responseLabel;
@synthesize moreInfoView;
@synthesize successLabel;
@synthesize failureLabel;
@synthesize moreInfoButton;
@synthesize moreInfoLabel;
@synthesize additionalDetailsView;

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
