//
//  ApproveInfoCell.h
//  CustomerManagerSystemiPad
//
//  Created by Arun Jaiswal on 24/08/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApproveInfoCell : UITableViewCell

@property (nonatomic, assign)IBOutlet UILabel * nameLabel;
@property (nonatomic, assign)IBOutlet UILabel * specialtyAndTypeLabel;
@property (nonatomic, assign)IBOutlet UIButton * notApprovedStatus;

@end
