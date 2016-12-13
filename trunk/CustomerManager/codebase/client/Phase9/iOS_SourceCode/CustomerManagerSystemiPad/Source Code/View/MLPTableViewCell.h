//
//  MLPTableViewCell.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 25/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLPTableViewCell : UITableViewCell

@property (nonatomic, assign)IBOutlet UILabel* add1;
@property (nonatomic, assign)IBOutlet UILabel* add2;
@property (nonatomic, assign)IBOutlet UILabel* add3;
@property (nonatomic, assign)IBOutlet UIButton * addTerritoryBtn;
@property (nonatomic, assign)IBOutlet UIView * imageType;
@property (nonatomic, assign)IBOutlet UILabel *responseLabel;
@property (nonatomic, assign)IBOutlet UIView *moreInfoView;
@property (nonatomic, assign)IBOutlet UILabel *successLabel;
@property (nonatomic, assign)IBOutlet UILabel *failureLabel;
@property (nonatomic, assign)IBOutlet UIButton *moreInfoButton;
@property (nonatomic, assign)IBOutlet UILabel *moreInfoLabel;
@property (nonatomic,assign)IBOutlet UIView *additionalDetailsView;

@property (weak, nonatomic) IBOutlet UILabel *primarySpeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondarySpecLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *npiLabel;
@property (weak, nonatomic) IBOutlet UILabel *npiAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *secSpeAnsLabel;

@end
