//
//  AlignNewAddressTableViewCell.h
//  CustomerManagerSystemiPad
//
//  Created by Sidhdarth on 01/06/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlignNewAddressTableViewCell : UITableViewCell
@property (nonatomic, assign)IBOutlet UILabel* add1;
@property (nonatomic, assign)IBOutlet UILabel* add2;
@property (nonatomic, assign)IBOutlet UILabel* add3;
@property (nonatomic, assign)IBOutlet UILabel* bpaId;
@property (nonatomic, assign)IBOutlet UIButton * addTerritoryBtn;
@property (nonatomic, assign)IBOutlet UIView * imageType;
@property (nonatomic, assign)IBOutlet UILabel *responseLabel;
@property (nonatomic, assign)IBOutlet UIView *moreInfoView;
@property (nonatomic, assign)IBOutlet UILabel *successLabel;
@property (nonatomic, assign)IBOutlet UILabel *failureLabel;
@property (nonatomic, assign)IBOutlet UIButton *moreInfoButton;
@property (nonatomic, assign)IBOutlet UILabel *moreInfoLabel;
@property (nonatomic, assign)IBOutlet UIView *additionalDetailsView;

@end
