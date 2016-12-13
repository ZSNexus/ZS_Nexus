//
//  CustomModalViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/4/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CustomTableViewController.h"

@interface CustomModalViewController : UIViewController
{
    IBOutlet UIView      *topBarView;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic ,strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UILabel *errorMessageLabel;

@property (nonatomic, strong) IBOutlet CustomTableViewController *customTableViewController;

-(IBAction) click_Cancel:(id)sender;

-(void)displayErrorMessage:(NSString*)errorMsg;
@end
