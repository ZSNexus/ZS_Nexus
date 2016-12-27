//
//  MLPModalViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 25/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CustomTableViewController.h"
#import "MLPModalTableTableTableViewController.h"
#import "CDFFlagModalViewController.h"

@protocol DuplicateAddressRemovalOfMLPModalViewProtocol <NSObject>

-(void) getDuplicateAddressRemovalReasonWithString:(NSString *)removalReasonString;

@end

@protocol CDFFlagForMLPOfMLPModalViewProtocol <NSObject>

-(void) setUpCDFFLagScreenwithName:(NSString *)name primarySpeciality:(NSString *)primarySpe secondarySpeciality:(NSString *)secondarySpe masterID:(NSString *)bpaId andNPI:(NSString *)npiValue;
-(void)affiliateMLPRequestWithString:(NSString*)masterID;

@end

@protocol MLPSearchPageOfMLPModalViewProtocol <NSObject>

-(void)dismissSearchPage;
@end

@interface MLPModalViewController : UIViewController<MLPFlagProtocol,MLPAffiliatedProtocol,UIAlertViewDelegate>
{
    IBOutlet UIView      *topBarView;
}

@property (nonatomic, strong) id<DuplicateAddressRemovalOfMLPModalViewProtocol> duplicateAddressDataOfMLPModalViewDelegate;
@property (nonatomic, strong) id<CDFFlagForMLPOfMLPModalViewProtocol> cdfProtocolDataOfMLPModalViewDelegate;
@property (nonatomic, strong) id<MLPSearchPageOfMLPModalViewProtocol> mlpSearchPOfMLPModalViewDelegate;
@property(nonatomic,retain) CDFFlagModalViewController *cdfFlagModalviewController;
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

@property (nonatomic, strong) IBOutlet UILabel *addressLabel;


@property (nonatomic, strong) IBOutlet MLPModalTableTableViewController *customTableViewController;

@property(nonatomic,strong) NSMutableArray * responseArrayForCDF;

@property(nonatomic,strong) NSString * allFlagsDMessage;
@property(nonatomic, assign) BOOL isAllFlagD;

-(IBAction) click_Cancel:(id)sender;
-(void)displayErrorMessage:(NSString*)errorMsg;

-(void)getDataFromMLPTable;
-(void)showCDFFLagScreenWithArray:(NSArray*)respArray;
@end

