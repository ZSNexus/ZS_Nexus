//
//  MLPAddressViewController.h
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

@protocol DuplicateAddressRemovalProtocol <NSObject>

-(void) getDuplicateAddressRemovalReasonWithString:(NSString *)removalReasonString;
-(void) getDuplicateAddressRemovalReasonWithString:(NSString *)removalReasonString andAddressArrays:(NSMutableArray*)bpaArray;

@end

@protocol CDFFlagForMLPProtocol <NSObject>

-(void) setUpCDFFLagScreenwithName:(NSString *)name primarySpeciality:(NSString *)primarySpe secondarySpeciality:(NSString *)secondarySpe masterID:(NSString *)bpaId andNPI:(NSString *)npiValue;
-(void)affiliateMLPRequestWithString:(NSString*)masterID;

@end

@protocol MLPSearchPageProtocol <NSObject>

-(void)dismissSearchPage;
@end

@interface MLPAddressViewController : UIViewController<MLPFlagProtocol,MLPAffiliatedProtocol,UIAlertViewDelegate>
{
    IBOutlet UIView      *topBarView;
    BOOL selectAllFlag;
    NSInteger selectedAddressItems;
    NSInteger allAddressItems;
}

@property (nonatomic, strong) id<DuplicateAddressRemovalProtocol> duplicateAddressDataDelegate;
@property (nonatomic, strong) id<CDFFlagForMLPProtocol> cdfProtocolDataDelegate;
@property (nonatomic, strong) id<MLPSearchPageProtocol> mlpSearchPDelegate;
@property(nonatomic,retain) CDFFlagModalViewController *cdfFlagModalviewController;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic ,strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *selectAllButton;
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
@property(nonatomic,strong) NSMutableArray * responseArrayForCDF;
@property(nonatomic,strong) NSString * allFlagsDMessage;
@property(nonatomic, assign) BOOL isAllFlagD;

@property (nonatomic, strong) IBOutlet MLPModalTableTableViewController *customTableViewController;

- (IBAction)click_search:(id)sender;
-(IBAction)click_SelectAll:(id)sender;
//-(IBAction)click_Reset:(id)sender;
-(IBAction) click_Cancel:(id)sender;

-(void)displayErrorMessage:(NSString*)errorMsg;

-(void)getDataFromMLPTable;
-(void)showCDFFLagScreenWithArray:(NSArray*)respArray;
@end

