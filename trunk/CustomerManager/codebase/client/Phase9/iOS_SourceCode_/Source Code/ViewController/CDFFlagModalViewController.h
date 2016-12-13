//
//  CDFFlagModalViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 07/10/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CDFFlagModalTableViewController.h"

@protocol MLPAffiliatedProtocol <NSObject>

-(void)affiliateMLP;

@end

@interface CDFFlagModalViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UIView      *topBarView;
}
@property (nonatomic, strong) id<MLPAffiliatedProtocol> mlpAffiliateProtocolDataDelegate;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic ,strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
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

@property (nonatomic, strong) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) IBOutlet UILabel *mlpLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdNamelabel;
@property (nonatomic, strong) IBOutlet UILabel *mdNameAnsLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdPrimarySpeLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdPrimarySpeAnsLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdAddressLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdSecondarySpeLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdSecondarySpeAnsLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdMasterIdLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdMAsterIdAnsLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdNpiLabel;
@property (nonatomic, strong) IBOutlet UILabel *mdNpiAnsLabel;

@property (nonatomic, strong) IBOutlet UILabel *dFlagsMessageLabel;


@property (nonatomic, strong) IBOutlet CDFFlagModalTableViewController *customTableViewController;

-(IBAction) click_Cancel:(id)sender;
-(IBAction) click_BackBtn:(id)sender;
-(void)displayErrorMessage:(NSString*)errorMsg;

@end
