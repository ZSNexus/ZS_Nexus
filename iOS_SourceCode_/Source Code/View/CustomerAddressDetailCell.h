//
//  CustomerAddressDetailCell.h
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 25/09/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerAddressDetailCell : UITableViewCell

@property (nonatomic, assign)IBOutlet UILabel* add1;
@property (nonatomic, assign)IBOutlet UILabel* add2;
@property (nonatomic, assign)IBOutlet UILabel* add3;
@property (nonatomic, assign)IBOutlet UIButton * addTerritoryBtn;
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
