//
//  AlignNewAddressTableViewCell.m
//  CustomerManagerSystemiPad
//
//  Created by Sidhdarth on 01/06/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import "AlignNewAddressTableViewCell.h"

@implementation AlignNewAddressTableViewCell

@synthesize add1,add2,add3;
@synthesize bpaId;
@synthesize addTerritoryBtn;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
