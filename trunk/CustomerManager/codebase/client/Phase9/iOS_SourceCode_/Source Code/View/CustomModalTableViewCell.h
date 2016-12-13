//
//  CustomModalTableViewCell.h
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/8/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomModalTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, assign) IBOutlet UITextField *cellTextField;
@property (nonatomic, strong) IBOutlet UIButton *clearTextFieldButton;
@end
