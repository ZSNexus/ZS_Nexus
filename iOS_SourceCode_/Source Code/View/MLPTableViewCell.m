//
//  MLPTableViewCell.m
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 25/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import "MLPTableViewCell.h"

@implementation MLPTableViewCell

@synthesize add1,add2,add3;
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