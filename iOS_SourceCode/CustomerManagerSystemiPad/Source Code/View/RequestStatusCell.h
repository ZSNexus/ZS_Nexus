//
//  RequestStatusCell.h
//  CustomerManagerSystemiPad
//
//  Created by Shri on 16/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestStatusCell : UITableViewCell
@property(nonatomic,assign) IBOutlet UILabel *requestTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel *statusLabel;
@property(nonatomic,assign) IBOutlet UILabel *actionDateLabel;
//@property(nonatomic,assign) IBOutlet UILabel *resolutionDescription;
//@property(nonatomic,assign) IBOutlet UIButton *resolutionDesc;
@end
