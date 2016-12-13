//
//  DuplicateAddressTableViewCell.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 29/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuplicateAddressTableViewCell : UITableViewCell

@property (nonatomic, assign)IBOutlet UILabel* masterIdAns;
@property (nonatomic, assign)IBOutlet UILabel* addressTypeAns;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *addressType;
@property (weak, nonatomic) IBOutlet UILabel *masterId;


@end
