//
//  ApproveInfoCell.m
//  CustomerManagerSystemiPad
//
//  Created by Arun Jaiswal on 24/08/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import "ApproveInfoCell.h"

@implementation ApproveInfoCell

@synthesize nameLabel,specialtyAndTypeLabel,notApprovedStatus;

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
