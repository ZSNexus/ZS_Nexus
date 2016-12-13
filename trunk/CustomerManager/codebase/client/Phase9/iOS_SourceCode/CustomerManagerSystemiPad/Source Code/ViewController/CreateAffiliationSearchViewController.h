//
//  CreateAffiliationSearchViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 20/10/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CustomTableViewController.h"

@interface CreateAffiliationSearchViewController : UIViewController <TextFiledEventsProtocol>
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

@property (nonatomic,strong) IBOutlet UILabel *NPIAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *NPILabel;
@property (nonatomic,strong) IBOutlet UILabel *masterIDAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *masterIDLabel;
@property (nonatomic,strong) IBOutlet UILabel *secSpeAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *secSpeLabel;
@property (nonatomic,strong) IBOutlet UILabel *primarySpeAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameLbl;
@property (nonatomic,strong) IBOutlet UILabel *primarySpeLabel;
@property (nonatomic,strong) IBOutlet UILabel * searchDescriptionText;

@property (nonatomic,strong) IBOutlet UIView *detailsView;

@property (nonatomic, strong) IBOutlet CustomTableViewController *customTableViewController;

-(IBAction) click_Cancel:(id)sender;

-(void)displayErrorMessage:(NSString*)errorMsg;


@end
