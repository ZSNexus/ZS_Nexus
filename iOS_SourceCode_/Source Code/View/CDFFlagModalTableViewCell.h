//
//  CDFFlagModalTableViewCell.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 07/10/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDFFlagModalTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, assign) IBOutlet UILabel *cellTextField;
@property (nonatomic, strong) IBOutlet UIButton *clearTextFieldButton;
@property (nonatomic, strong) IBOutlet NSString *mdCDFlagString;

@end
