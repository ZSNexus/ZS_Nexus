//
//  ApproveAddressDetailCell.h
//  CustomerManagerSystemiPad
//
//  Created by Sidhdarth Kawthekar on 24/09/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApproveAddressDetailCell : UITableViewCell

@property (nonatomic, assign)IBOutlet UILabel* add1;
@property (nonatomic, assign)IBOutlet UILabel* add2;
@property (nonatomic, assign)IBOutlet UILabel* add3;
@property (nonatomic, assign)IBOutlet UIButton * approveTargetBtn;
@property (nonatomic, assign)IBOutlet UIButton * rejectTargetBtn;
@property (nonatomic, assign)IBOutlet UIView * imageType;
@property (nonatomic, assign)IBOutlet UILabel *responseLabel;
@property (nonatomic, assign)IBOutlet UIView *moreInfoView;
@property (nonatomic, assign)IBOutlet UILabel *successLabel;
@property (nonatomic, assign)IBOutlet UILabel *failureLabel;
@property (nonatomic, assign)IBOutlet UIButton *moreInfoButton;
@property (nonatomic, assign)IBOutlet UILabel *moreInfoLabel;
@property (nonatomic,assign)IBOutlet UIView *additionalDetailsView;

@end
