//
//  RequestInfoCell.h
//  CustomerManagerSystemiPad
//
//  Created by Shri on 16/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestInfoCell : UITableViewCell
@property(nonatomic,assign) IBOutlet UILabel *requestTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel *custNameLabel;
@property(nonatomic,assign) IBOutlet UILabel *stageOfRequestLabel;
@property(nonatomic,assign) IBOutlet UILabel *requestorLabel;
@property(strong,nonatomic) IBOutlet UIButton *alertButton;
@end
