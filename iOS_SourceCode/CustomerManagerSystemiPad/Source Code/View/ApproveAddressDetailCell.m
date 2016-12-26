//
//  ApproveAddressDetailCell.m
//  CustomerManagerSystemiPad
//
//  Created by Sidhdarth Kawthekar on 24/09/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import "ApproveAddressDetailCell.h"

@implementation ApproveAddressDetailCell
@synthesize add1,add2,add3;
@synthesize approveTargetBtn;
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
