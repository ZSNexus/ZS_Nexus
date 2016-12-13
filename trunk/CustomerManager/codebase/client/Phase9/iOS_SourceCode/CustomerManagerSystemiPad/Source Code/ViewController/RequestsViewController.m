
//
//  RequestsViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 13/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "RequestsViewController.h"
#import "Themes.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "RequestObject.h"
#import "RequestStatusHistoryObject.h"
#import "DummyData.h"
#import "OrganizationObject.h"
#import "DataManager.h"
#import "Constants.h"
#import "CustomModalViewController.h"
#import "CustomModalViewBO.h"
#import "ModalDataLoader.h"
#import "Utilities.h"
#import "RequestInfoCell.h"
#import "PopOverContentViewController.h"
#import "ErrroPopOverContentViewController.h"
#import "TicketIdContentViewController.h"
#import "RequestAddressCell.h"
#import "RequestStatusCell.h"
#import "MLPModalViewController.h"
#import "RemoveAddressRequestStatusCell.h"
#import "DealignBPA.h"

@interface RequestsViewController ()
{
    CustomModalViewController *customModalViewController;
    
    BOOL isConnectionInProgress;
    BOOL isApproverTerritory;
    NSString *connectionUrl;
    NSString *latestConnectionIdentifier;
    CGFloat requestDetailsOriginalYPos;
    BOOL shouldLoadRemoveAddress;
    NSString *addressRemovalRequestType;
    int requestIndex;
    NSMutableArray *customerAddressArray;
    NSMutableArray *removedAddressArray;
    NSMutableArray *alignedAddressArray;
    NSMutableArray *responseArrayforDuplicateAddress;
    NSArray *approverDetailArray;
    NSMutableArray *completeDuplicateAddressArray;
    NSMutableArray *removalBPAIDArray;
    NSString *addressString;
    NSString *bpaIdString;
    NSString *nameString;
    NSString *bpaidtext;
    NSString *descriptionString;
    NSString *removalBPID;
    NSString *removalBPAID;
    NSString *removalTicketNumber;
    NSString *ticketNumberForDuplicateAddress;
    NSString *moreInfoTicketIdAns;
    NSMutableArray *completeDuplicateAddressArrayForRemoveAddress;
    int track;
    NSInteger selectedAddressIndex;
}

@property(nonatomic,retain) NSMutableArray *indvRequestsData;
@property(nonatomic,retain) NSMutableArray *orgRequestsData;
@property(nonatomic,retain) NSMutableArray *alignedAddressArray;
@property(nonatomic,assign) IBOutlet UITableView * requestListTable;
@property(nonatomic,assign) IBOutlet UITableView * addressTable;
@property(nonatomic,assign) IBOutlet UITableView * addressTableOrg;
@property(nonatomic,assign) IBOutlet UITableView * addressTableRemoveAddress;
@property(nonatomic,assign) IBOutlet UITableView * otherAlignedAdressTableView;
@property(nonatomic,assign) IBOutlet UITableView * requestStatusTableOrg;
@property(nonatomic,assign) IBOutlet UITableView * requestStatusTable;
@property(nonatomic,assign) IBOutlet UITableView * requestStatusTableRemoveAddress;
@property(nonatomic,retain)UIPopoverController*  infoPopOver;
@property(nonatomic,assign) IBOutlet UIButton * infoBtn;
@property(nonatomic,assign) IBOutlet UILabel * addressLbl;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressAddressLbl;
@property(nonatomic,assign) IBOutlet UILabel * statusLbl;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressStatusLbl;
@property(nonatomic,assign) NSUInteger selectedRequestListIndex;
@property(assign) NSUInteger receivedAlignAddressIndex;
@property(nonatomic,retain)  UIPopoverController * listPopOverController;
@property(nonatomic,assign) IBOutlet UILabel * nameText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressnameText;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressPrimarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddresssecondarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * professionalText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressProfessionalText;
@property(nonatomic,assign) IBOutlet UILabel * BPIDText;
@property(nonatomic,assign) IBOutlet UILabel * reomveAddressBPIDText;
@property(nonatomic,assign) IBOutlet UILabel * NPIText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressNPIText;
@property(nonatomic,assign) IBOutlet UILabel * CustTypeText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressCustTypeText;
@property(nonatomic,assign) IBOutlet UILabel * CustTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressCustTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel * subClassificationText;
@property(nonatomic,assign) IBOutlet UILabel * orgValidationStatusText;
@property(nonatomic,assign) IBOutlet UILabel *  serverResponseLabel;
@property(nonatomic,assign) IBOutlet UILabel * orgBPIDText;
@property(nonatomic,assign) IBOutlet UILabel * organizationTypeText;
@property(nonatomic,assign) IBOutlet UILabel * orgNameText;
@property(nonatomic,assign) IBOutlet UIButton * withdrawRequestBtn;
@property(nonatomic,assign) IBOutlet UIButton * removeAddressWithdrawRequestBtn;
@property(nonatomic,assign) IBOutlet UIButton * removeAddressApproveBtn;
@property(nonatomic,assign) IBOutlet UIButton * moreInfoTicketId;
@property(nonatomic,assign) IBOutlet UIButton * remAddressTicketId;
@property(nonatomic,assign) IBOutlet UIButton * removeAddressRejectBtn;
@property(nonatomic,assign) IBOutlet UIButton * removeAddressWithdrawRequestBtn2;
@property(nonatomic,assign) IBOutlet UIButton * removeAddressAlignApproveBtn;
@property(nonatomic,assign) IBOutlet UISegmentedControl *indvidualOrganisationSegmentControl;
@property(nonatomic,assign) IBOutlet UIButton * withdrawRequestBtnOrg;
@property(nonatomic,assign) IBOutlet UILabel * addressLblOrg;
@property(nonatomic,assign) IBOutlet UILabel * statusLblOrg;
@property(nonatomic,assign) IBOutlet UIView * detailViewOrg;
@property(nonatomic,assign) IBOutlet UIView * detailView;
@property(nonatomic,assign) IBOutlet UIView * removeAddressDetailView;
@property(nonatomic,retain) UIButton * changeTerritoryBtn;
@property(nonatomic,retain) NSMutableDictionary* indvSearchParameters;
@property(nonatomic,retain) NSMutableDictionary* orgSearchParameters;
@property(nonatomic,retain) NSMutableDictionary *populate;
@property(nonatomic,assign) IBOutlet UITableView * searchParameterTable;
@property(nonatomic,assign) IBOutlet UILabel *reasonLabel;
@property(nonatomic,assign) IBOutlet UILabel *removeAddressReasonLabel;
@property(nonatomic,retain) IBOutlet UILabel *reasonTextLabel;
@property(nonatomic,retain) IBOutlet UILabel *removeAddressReasonTextLabel;
@property(nonatomic,assign) IBOutlet UILabel *reasonLabelOrg;
@property(nonatomic,assign) IBOutlet UILabel *reasonTextLabelOrg;
@property(nonatomic,assign) IBOutlet UIView *reasonMoreInfoView;
@property(nonatomic,assign) IBOutlet UIView *RemoveAddressReasonMoreInfoView;
@property(nonatomic,assign) IBOutlet UIView *reasonMoreInfoViewOrg;
@property(nonatomic,assign) IBOutlet UILabel *infoLabelOrg;
@property(nonatomic,assign) IBOutlet UIView * leftView;
@property(nonatomic,assign) IBOutlet UILabel * nameLabel;
@property(nonatomic,assign) IBOutlet UILabel * RemoveAddressnameLabel;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressPrimarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressSecondarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * professionalLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressProfessionalLabel;
@property(nonatomic,assign) IBOutlet UILabel * BPIDLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressBPIDLabel;
@property(nonatomic,assign) IBOutlet UILabel * NPILabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressNPILabel;
@property(nonatomic,assign) IBOutlet UILabel * ticketNOLbl;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressTicketNOLbl;
@property(nonatomic,assign) IBOutlet UILabel *infoLabel;
@property(nonatomic,assign) IBOutlet UILabel *removeAddressinfoLabel;
@property(nonatomic,assign) IBOutlet UILabel * nameLabelOrg;
@property(nonatomic,assign) IBOutlet UILabel * organizationTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel * subClassificationLabel;
@property(nonatomic,assign) IBOutlet UILabel * orgValidationStatusLabel;
@property(nonatomic,assign) IBOutlet UILabel * BPIDLabelOrg;
@property(nonatomic,assign) IBOutlet UILabel * ticketNOLblOrg;
@property(nonatomic,retain) NSString *latestSuccessfulIndvSearchUrl;
@property(nonatomic,retain) NSString *latestSuccessfulOrgSearchUrl;

@property(nonatomic,assign) IBOutlet UILabel *otherAlignedAddressesLabel;
@property(nonatomic,assign) IBOutlet UIScrollView * removeAddressScrollView;

@property(nonatomic,assign) IBOutlet UILabel * removeAddressRequestDetailsLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressRequestorLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressRequestorText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressReqDateLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressReqDateText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressReqTerLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressReqTerText;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressRemReasonLabel;
@property(nonatomic,assign) IBOutlet UILabel * removeAddressRemReasonText;
@property(nonatomic,assign) IBOutlet UIButton * viewDupAddressButton;
@property(nonatomic,retain) NSMutableArray *removeAddressResponseArray;
@property(nonatomic,retain) NSArray *jsonDataArrayOfObjects;
@property(nonatomic,retain) NSMutableArray *jsonDataArray;
@property(nonatomic,assign) IBOutlet UILabel * noAlignedAddressMessage;
@property(nonatomic,assign) IBOutlet UILabel * noRemovalAddressMessage;

@property(nonatomic,assign) IBOutlet UILabel * requestStatusLabel;
@property(nonatomic,assign) IBOutlet UILabel * requestStatusText;
@property(nonatomic,retain) NSArray *custData;
@property(nonatomic,retain) MLPModalViewController *mlpModalviewController;

@property(nonatomic,retain) AlignNewAddressViewController *alignmentViewController;
@property(nonatomic) NSArray *searchedCustDataFromServer;
@property(nonatomic,retain) NSMutableArray * selectedCustDetailAddress;
@property(nonatomic , retain) IBOutlet UILabel *requestDetailsLabel_RemoveAddress;
@property(nonatomic , retain) IBOutlet UILabel *requestDetailsLabelText_RemoveAddress;
@property(nonatomic , retain) IBOutlet UILabel *requestDetailsLabel_RemoveCustomer;
@property(nonatomic , retain) IBOutlet UILabel *requestDetailsLabelText_RemoveCustomer;


//for remove address request


-(void)clickLogOut;
-(void)refreshRequestDetailsOfIndex:(NSInteger)index;
-(IBAction)clickInfo:(id)sender;
-(IBAction)valueChangedSegmentControl:(UISegmentedControl *)segment;
-(IBAction)clickRequestSearch:(id)sender;
-(IBAction)clickWithdrawRequest:(id)sender;
-(IBAction)clickMoreInfo:(id)sender;
-(IBAction)clickRemoveAddressWithdraw:(id)sender;
-(IBAction)clickRemoveAddressApprove:(id)sender;
-(IBAction)clickRemoveAddressReject:(id)sender;
-(IBAction)clickViewDuplicateAddress:(id)sender;
// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView;

@end

@implementation RequestsViewController
@synthesize requestListTable,infoBtn,changeTerritoryBtn,infoPopOver,BPIDText,nameText,withdrawRequestBtn,organizationTypeText,orgBPIDText,orgNameText,orgValidationStatusText,subClassificationText,CustTypeText,NPIText,professionalText,primarySpecialtyText,secondarySpecialtyText,indvRequestsData,orgRequestsData,indvidualOrganisationSegmentControl,requestStatusTable,addressTable,selectedRequestListIndex,receivedAlignAddressIndex,addressLbl,statusLbl,withdrawRequestBtnOrg,addressLblOrg,statusLblOrg,addressTableOrg,requestStatusTableOrg,detailViewOrg,detailView,listPopOverController, indvSearchParameters, orgSearchParameters,alignedAddressArray,serverResponseLabel,CustTypeLabel, searchParameterTable, latestSuccessfulIndvSearchUrl, latestSuccessfulOrgSearchUrl,reasonLabel,reasonTextLabel,reasonLabelOrg,reasonTextLabelOrg,reasonMoreInfoView,reasonMoreInfoViewOrg,leftView,nameLabel,primarySpecialtyLabel,secondarySpecialtyLabel,professionalLabel,BPIDLabel,NPILabel,ticketNOLbl,infoLabel,nameLabelOrg,organizationTypeLabel,subClassificationLabel,orgValidationStatusLabel,infoLabelOrg,BPIDLabelOrg,ticketNOLblOrg,addressTableRemoveAddress,requestStatusTableRemoveAddress, removeAddressAddressLbl, removeAddressApproveBtn,removeAddressBPIDLabel,removeAddressCustTypeLabel,removeAddressCustTypeText,removeAddressDetailView,removeAddressinfoLabel,RemoveAddressnameLabel,removeAddressnameText,removeAddressNPILabel,removeAddressNPIText,removeAddressPrimarySpecialtyLabel,removeAddressPrimarySpecialtyText,removeAddressProfessionalLabel,removeAddressProfessionalText,removeAddressReasonLabel,RemoveAddressReasonMoreInfoView,removeAddressReasonTextLabel,removeAddressRejectBtn,removeAddressSecondarySpecialtyLabel,removeAddresssecondarySpecialtyText,removeAddressStatusLbl,removeAddressTicketNOLbl,removeAddressWithdrawRequestBtn,reomveAddressBPIDText,otherAlignedAddressesLabel,otherAlignedAdressTableView,removeAddressScrollView, removeAddressRequestDetailsLabel, removeAddressRequestorLabel, removeAddressRequestorText, removeAddressReqDateLabel, removeAddressReqDateText, removeAddressReqTerLabel, removeAddressReqTerText, removeAddressRemReasonLabel, removeAddressRemReasonText, viewDupAddressButton,removeAddressResponseArray, noAlignedAddressMessage,requestStatusText,requestStatusLabel,mlpModalviewController, custData, noRemovalAddressMessage,selectedCustDetailAddress,populate,moreInfoTicketId,remAddressTicketId;

@synthesize alignmentViewController,jsonDataArrayOfObjects,jsonDataArray,searchedCustDataFromServer,removeAddressAlignApproveBtn,removeAddressWithdrawRequestBtn2, requestDetailsLabel_RemoveAddress, requestDetailsLabel_RemoveCustomer,requestDetailsLabelText_RemoveAddress, requestDetailsLabelText_RemoveCustomer;

#pragma mark - Initialization: View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarThemeAndColor];
    
    //Selected Index as -1
    selectedRequestListIndex=-1;
    
    [self setCustomFontToUIComponent];
    [self setBorderAndBackground];
    
    [detailViewOrg setHidden:TRUE];
    [detailView setHidden:TRUE];
    [moreInfoTicketId setHidden:TRUE];
    [remAddressTicketId setHidden:TRUE];
    [removeAddressDetailView setHidden:TRUE];
    [removeAddressScrollView setHidden:TRUE];
    [removeAddressScrollView addSubview:removeAddressDetailView];
    removeAddressScrollView.contentSize = CGSizeMake(724, 1046);
    //removeAddressScrollView.bounces = NO;
    
    //Hiding Align&Approve Button
    [removeAddressWithdrawRequestBtn2 setHidden:YES];
    [removeAddressAlignApproveBtn setHidden:YES];
    
    //Load data for individual
    [[DataManager sharedObject] setIsDefaultRequestForRequests:TRUE];
    isConnectionInProgress = FALSE;
    latestConnectionIdentifier = @"";
    [[DataManager sharedObject] setIsIndividualSegmentSelectedForRequest:YES];
    
    //Save original Y position of reason label
    requestDetailsOriginalYPos = CGRectGetMinY(reasonLabel.frame);
    
    //self.removeAddressScrollView.contentSize = CGSizeMake(self.removeAddressDetailView.frame.size.width, self.removeAddressScrollView.frame.size.height);
    //NSLog(@"scollview height = %f", self.removeAddressScrollView.frame.size.height);
    
    addressRemovalRequestType = [[NSString alloc] init];
    
    removeAddressResponseArray = [[NSMutableArray alloc] init];
    customerAddressArray = [[NSMutableArray alloc] init];
    approverDetailArray = [[NSArray alloc] init];
    removedAddressArray = [[NSMutableArray alloc] init];
    alignedAddressArray = [[NSMutableArray alloc] init];
    removalBPAIDArray = [[NSMutableArray alloc] init];;
    populate = [[NSMutableDictionary alloc] init];
    
    jsonDataArray = [[NSMutableArray alloc] init];
    
    viewDupAddressButton.hidden = YES;
    bpaidtext = [[NSString alloc] init];
    removalBPID = [[NSString alloc] init];
    removalBPAID = [[NSString alloc] init];
    removalTicketNumber = [[NSString alloc] init];
    ticketNumberForDuplicateAddress = [[NSString alloc] init];
    completeDuplicateAddressArrayForRemoveAddress = [[NSMutableArray alloc] init];
    track = 0;
    
    selectedCustDetailAddress = [[NSMutableArray alloc] init];
    
    //[requestListTable reloadData];
    [self selectFirstItemFromList];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setBorderAndBackground
{
    leftView.layer.borderWidth=2.0f;
    leftView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [leftView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    NSInteger deviceVersion = [[UIDevice currentDevice] systemVersion].integerValue;
    if(deviceVersion >= 7)
    {
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:13], UITextAttributeFont,
                                    [UIColor colorWithRed:15.0/255.0 green:68.0/255.0 blue:146.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                    nil];
        [indvidualOrganisationSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [indvidualOrganisationSegmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
        
        indvidualOrganisationSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
        indvidualOrganisationSegmentControl.tintColor = [UIColor colorWithRed:6.0 / 255.0 green:86.0 / 255.0 blue:161.0 / 255.0 alpha:1.0];
    }
    indvidualOrganisationSegmentControl.frame= CGRectMake(10, 10, 280, 35);
    
    requestListTable.layer.borderWidth=2.0f;
    requestListTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    detailView.layer.borderWidth=1.0f;
    detailView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right.png"]]];
    
    removeAddressDetailView.layer.borderWidth=1.0f;
    removeAddressDetailView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    //[removeAddressDetailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right.png"]]];
    [removeAddressDetailView setBackgroundColor:[UIColor whiteColor]];
    
    detailViewOrg.layer.borderWidth=1.0f;
    detailViewOrg.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    addressTable.layer.borderWidth=2.0f;
    addressTable.layer.cornerRadius=8.0;
    addressTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    requestStatusTable.layer.borderWidth=2.0f;
    requestStatusTable.layer.cornerRadius=8.0;
    requestStatusTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    addressTableRemoveAddress.layer.borderWidth=2.0f;
    addressTableRemoveAddress.layer.cornerRadius=8.0;
    addressTableRemoveAddress.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    requestStatusTableRemoveAddress.layer.borderWidth=2.0f;
    requestStatusTableRemoveAddress.layer.cornerRadius=8.0;
    requestStatusTableRemoveAddress.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    otherAlignedAdressTableView.layer.borderWidth=2.0f;
    otherAlignedAdressTableView.layer.cornerRadius=8.0;
    otherAlignedAdressTableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    
    
    addressTableOrg.layer.borderWidth=2.0f;
    addressTableOrg.layer.cornerRadius=8.0;
    addressTableOrg.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    requestStatusTableOrg.layer.borderWidth=2.0f;
    requestStatusTableOrg.layer.cornerRadius=8.0;
    requestStatusTableOrg.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
}
-(void)setNavigationBarThemeAndColor
{
    //Set Navigation Bar Themes
    self.navigationController.navigationBar.tintColor=THEME_COLOR;
    self.navigationItem.titleView=[Themes setNavigationBarNormal:REQUESTS_TAB_TITLE_STRING ofViewController:@"Requests"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024.png"] forBarMetrics:UIBarMetricsDefault];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar. frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.navigationController.navigationBar addSubview:navBorder];
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //Add Touch Up event to Log out button
    for(UIButton* btn in self.navigationItem.titleView.subviews)
    {
        //Log out btn Tag is 1
        if(btn.tag==1)
        {
            [btn addTarget:self action:@selector(clickLogOut) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(btn.tag==3)
        {
            //Change Territory Btn
            [btn addTarget:self action:@selector(clickChangeTerritory) forControlEvents:UIControlEventTouchUpInside];
            changeTerritoryBtn=btn;
        }
        //Go to BU, Team and Terriotary selection page
        else if (btn.tag==1101)
        {
            [btn addTarget:self action:@selector(loadBuTeamTerrSelectionView) forControlEvents:UIControlEventTouchUpInside];
//            changeTerritoryBtn=btn;
        }

    }
}

-(void)setCustomFontToUIComponent
{
    [nameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [nameText setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [primarySpecialtyLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [primarySpecialtyText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [secondarySpecialtyLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [secondarySpecialtyText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [professionalLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [professionalText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [BPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [BPIDText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [NPILabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [NPIText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [ticketNOLbl setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    [CustTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [CustTypeText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [reasonLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [reasonTextLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [infoLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [addressLbl setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [nameLabelOrg setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [orgNameText setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [organizationTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [organizationTypeText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [subClassificationLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [subClassificationText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgValidationStatusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgValidationStatusText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [reasonLabelOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [reasonTextLabelOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [infoLabelOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [BPIDLabelOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgBPIDText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [ticketNOLblOrg setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    [addressLblOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [serverResponseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
    [statusLbl setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [statusLblOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    
    [RemoveAddressnameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [removeAddressnameText setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [removeAddressPrimarySpecialtyLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressPrimarySpecialtyText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressSecondarySpecialtyLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddresssecondarySpecialtyText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressProfessionalLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [noAlignedAddressMessage setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [noRemovalAddressMessage setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressProfessionalText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressBPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [reomveAddressBPIDText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressNPILabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressNPIText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressTicketNOLbl setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    [removeAddressCustTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressCustTypeText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressReasonLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressReasonTextLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressinfoLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressAddressLbl setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressStatusLbl setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [otherAlignedAddressesLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    
    [removeAddressRequestDetailsLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressRequestorLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressRequestorText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressReqDateLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressReqDateText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressReqTerLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressReqTerText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressRemReasonLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [removeAddressRemReasonText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [requestStatusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [requestStatusText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //If connection is already in progress then do not execute new request
    if(isConnectionInProgress)
    {
        //double check for connection in progress status
        if([ConnectionClass isConnectionInProgressForIdentifier:latestConnectionIdentifier])
        {
            return;
        }
        else
        {
            isConnectionInProgress = FALSE;
        }
    }
    
    if(!isConnectionInProgress)
    {
        [Utilities removeSpinnerFromView:self.view];
    }
    
    if([[DataManager sharedObject] isDefaultRequestForRequests])
    {
        //Clear previous data
        [self clearSearchData];
    }
    
    //Clear previous success/error message if any
    [self updateServerResponseLabelWithText:@"" forIdentifier:nil successOrFailure:YES];
    
    //Refresh Territory field on navigation bar
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //If modal view is present then remove it
    if(customModalViewController && [self.view.subviews containsObject:customModalViewController.view])
    {
        [self removeCustomModalViewController];
    }
    
    //Check for latest successful URL
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        if(self.latestSuccessfulIndvSearchUrl.length == 0)
        {
            [[DataManager sharedObject] setIsDefaultRequestForRequests:TRUE];
        }
    }
    else
    {
        if(self.latestSuccessfulOrgSearchUrl.length == 0)
        {
            [[DataManager sharedObject] setIsDefaultRequestForRequests:TRUE];
        }
    }
    
    //Request last search result
    if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForRequests])
    {
        [self refreshPreviousSearchResult];
    }
    
    //Default call should be after "Request last search result"
    if([[DataManager sharedObject] isDefaultRequestForRequests] && !isConnectionInProgress)
    {
        [self valueChangedSegmentControl:indvidualOrganisationSegmentControl];
    }
    self.indvidualOrganisationSegmentControl.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;//Fixed onTrack 510
    //[self selectFirstItemFromList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark -

#pragma mark UI Actions
-(void)valueChangedSegmentControl:(UISegmentedControl *)segment
{
    
    if(indvidualOrganisationSegmentControl.selectedSegmentIndex == 0)
    {
        requestStatusTableRemoveAddress.userInteractionEnabled = YES;
        removeAddressWithdrawRequestBtn.userInteractionEnabled = YES;
        removeAddressApproveBtn.userInteractionEnabled = YES;
        removeAddressRejectBtn.userInteractionEnabled = YES;
        //viewDupAddressButton.userInteractionEnabled = YES;
    }
    else
    {
        requestStatusTableRemoveAddress.userInteractionEnabled = NO;
        removeAddressWithdrawRequestBtn.userInteractionEnabled = NO;
        removeAddressApproveBtn.userInteractionEnabled = NO;
        removeAddressRejectBtn.userInteractionEnabled = NO;
        //viewDupAddressButton.userInteractionEnabled = NO;
    }
    
    //Clear server response label
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
    
    if(segment==indvidualOrganisationSegmentControl)
    {
        [[DataManager sharedObject] setIsIndividualSegmentSelectedForRequest:(indvidualOrganisationSegmentControl.selectedSegmentIndex == 0 ? YES : NO)];
    }
    
    [searchParameterTable reloadData];
    [requestListTable reloadData];
    //[self selectFirstItemFromList];
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
    {
        if(shouldLoadRemoveAddress)
        {
            [detailView setHidden:YES];
            [detailViewOrg setHidden:YES];
            [removeAddressDetailView setHidden:NO];
            [removeAddressScrollView setHidden:NO];
            
        }
        else
        {
            [detailView setHidden:NO];
            [detailViewOrg setHidden:YES];
            [removeAddressDetailView setHidden:YES];
            [removeAddressScrollView setHidden:YES];
        }
        
        if([[DataManager sharedObject] isDefaultRequestForRequests] || !indvSearchParameters || indvSearchParameters.count==0)// || !indvRequestsData.count)   //Pass default values for first time server call
        {
            if(indvSearchParameters==nil)
                indvSearchParameters = [[NSMutableDictionary alloc] init];
            
            [self getDataFromServer];
        }
        else
        {
            //Request last search result
            if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForRequests])
            {
                [self refreshPreviousSearchResult];
            }
        }
    }
    else    //Organization
    {
        if(shouldLoadRemoveAddress)
        {
            [detailView setHidden:YES];
            [detailViewOrg setHidden:YES];
            [removeAddressDetailView setHidden:NO];
            [removeAddressScrollView setHidden:NO];
        }
        else
        {
            [detailView setHidden:YES];
            [detailViewOrg setHidden:NO];
            [removeAddressDetailView setHidden:YES];
            [removeAddressScrollView setHidden:YES];
        }
        
        if([[DataManager sharedObject] isDefaultRequestForRequests] || !orgSearchParameters || orgSearchParameters.count==0)
        {
            if(orgSearchParameters==nil)
                orgSearchParameters = [[NSMutableDictionary alloc] init];
            
            [self getDataFromServer];
        }
        else
        {
            //Request last search result
            if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForRequests])
            {
                [self refreshPreviousSearchResult];
            }
        }
    }
}

-(IBAction)clickAlertInfoAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger row = button.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self refreshRequestDetailsOfIndex:indexPath.row];
    [self.requestListTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //Get cell frame rect for popover
    RequestInfoCell *cell = (RequestInfoCell*)[self.requestListTable cellForRowAtIndexPath:indexPath];
    CGRect rect = CGRectMake(cell.bounds.origin.x+33.0, cell.bounds.origin.y-cell.bounds.size.height/2.0, 258.0, 114.0);
    
    PopOverContentViewController *infoViewController;
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverAlertViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", HCP_MSG_STRING]];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(258, 134);
    infoPopOver.backgroundColor = [UIColor blackColor];
    [infoPopOver presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


-(IBAction)clickRequestSearch:(id)sender
{
    //Clear server response label
//    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    
    customModalViewController = [[CustomModalViewController alloc] initWithNibName:@"CustomModalViewController" bundle:nil];
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    
    //Set Customer Data Delegate Delegate
    customModalViewController.customTableViewController.customerDataDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForRequest];
    
    //Do any UI changes after frame set
    CustomModalViewBO *customBO;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest] == YES)
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualCustomersRequestWithParametrs:indvSearchParameters];
        customModalViewController.customTableViewController.callBackIdentifier = @"RefineRequestSearchForIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationsRequestWithParametrs:orgSearchParameters];
        customModalViewController.customTableViewController.callBackIdentifier = @"RefineRequestSearchForOrganization";
    }
    
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    [customModalViewController.titleLabel setText:REQUEST_TAB_REFINE_SEARCH_TITLE_STRING];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
    
    //Animate view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, customModalViewController.view.frame.origin.y-offset-64, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)clickWithdrawRequest:(id)sender
{
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:WITHDRAW_STRING message:WITHDRAW_REQUEST_ALERT_MSG_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:YES_STRING,NO_STRING, nil];
    [alt show];
}

-(IBAction)clickRemoveAddressWithdraw:(id)sender
{
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:nil message:WITHDRAW_ADDRESS_REQUEST_ALERT_MSG_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:CONFIRM_STRING,CANCEL_STRING, nil];
    [alt show];
}

-(IBAction)clickRemoveAddressApprove:(id)sender
{
    if(noAlignedAddressMessage.hidden == YES || alignedAddressArray.count >0)
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:nil message:APPROVE_REQUEST_ALERT_MSG_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:CONFIRM_STRING,CANCEL_STRING, nil];
        [alt show];
    }
    else
    {
        //approval against last address in territory
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:nil message:HCP_ALERT_MSG_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:APPROVE_STRING,ALIGN_APPROVE_STRING,CANCEL_STRING, nil];
        [alt show];
    }
}

-(IBAction)clickRemoveAddressReject:(id)sender
{
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:nil message:REJECT_REQUEST_ALERT_MSG_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:CONFIRM_STRING,CANCEL_STRING, nil];
    [alt show];
}

-(IBAction)clickMoreInfoForTicketId:(id)sender
{
    UIButton *button = (UIButton*)sender;
    CGRect buttonFrameToSelf = [button convertRect:button.bounds toView:self.view];
    //NSString *stringNo = @"1234567890";
    NSString *string = [NSString stringWithFormat:@"Nexus Ticket Id: %@",moreInfoTicketIdAns];
    [self presentMoreInfoForTicketIdPopoverFromRect:buttonFrameToSelf inView:self.view withMoreInfo:string];
}

-(IBAction)clickMoreInfo:(id)sender
{
    RequestObject *reqObj;
    
    UIButton *button = (UIButton *)sender;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
    }
    else
    {
        reqObj = [orgRequestsData objectAtIndex:selectedRequestListIndex];
    }
    
    if(reqObj.reason.length)
    {
        NSString *str;
        if([reqObj.reason rangeOfString:@"||"].location != NSNotFound)
        {
            NSArray *subArray=[reqObj.reason componentsSeparatedByString:@"||"];
            
            if (subArray.count>1) {
                str=[subArray objectAtIndex:1];
                str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                str=[str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
            }
            else
            {
                str=[reqObj.reason stringByReplacingOccurrencesOfString:@"||" withString:@""];
                str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                str=[str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
            }
        }
        else
        {
            //str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
            str = reqObj.reason;
        }
        
        CGRect buttonFrameToSelf = [button convertRect:button.bounds toView:self.view];
        [self presentMoreInfoPopoverFromRect:buttonFrameToSelf inView:self.view withMoreInfo:str];
    }
}

-(IBAction)clickInfo:(id)sender
{
    PopOverContentViewController *infoViewController;
    
    //INFO button is shown only if 25 search results are received
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverContentViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", TOP_50_RESULTS_STRING]];
    
    CGRect infoBtnFrameModified = CGRectMake(infoBtn.frame.origin.x, infoBtn.frame.origin.y, infoBtn.frame.size.width, infoBtn.frame.size.height);
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(200, 130);
    infoPopOver.backgroundColor = [UIColor blackColor];
    [infoPopOver presentPopoverFromRect:infoBtnFrameModified inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


-(IBAction)clickViewDuplicateAddress:(id)sender;
{
    //---implement method on clickViewDuplicateAddress
    
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    //Form URL
    NSMutableString *cdfFlagDetailsUrl = [[NSMutableString alloc] initWithString:VIEW_DUPLICATE_ADDRESSES_OF_BP_URL];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *connectionIdentifier = nil;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])   //Individuals
    {
        [cdfFlagDetailsUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [cdfFlagDetailsUrl appendFormat:@"&requestId=%@", ticketNumberForDuplicateAddress];
        
        //
        //        [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        //        [cdfFlagDetailsUrl appendFormat:@"&bp_id=576694"];
        //        [cdfFlagDetailsUrl appendFormat:@"&childBp_id=288"];
        //        [cdfFlagDetailsUrl appendFormat:@"&terr_id=162444"];
        
        connectionIdentifier = @"ViewDuplicateAddressOfBPIdentifier";
    }
    else    //Organizations
    {
        [cdfFlagDetailsUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [cdfFlagDetailsUrl appendFormat:@"&requestId=%@", ticketNumberForDuplicateAddress];
        //            [removeAddressUrl appendFormat:@"&removal_reason=%@", selectedReasonForRemoval];
        
        connectionIdentifier = @"ViewDuplicateAddressOfBPIdentifier";
    }
    
    //form connection
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"GET" forKey:@"request_type"];
    
    
    ConnectionClass *connection = [ConnectionClass sharedSingleton];
    //Protocol : getDuplicateAddressesOfBP
    [connection fetchDataFromUrl:[cdfFlagDetailsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
     {
         //CallBack Block
         if(!error)
         {
             [self receiveDataFromServer:data ofCallIdentifier:identifier];
         }
         else
         {
             [self failWithError:error ofCallIdentifier:identifier];
         }
     }];
    
    latestConnectionIdentifier = connectionIdentifier;
}

-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];
    listViewController.delegate=self;
    listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor blackColor];
    listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    [listPopOverController presentPopoverFromRect:CGRectMake(changeTerritoryBtn.frame.origin.x+5+14
                                                             , changeTerritoryBtn.frame.origin.y-50, changeTerritoryBtn.frame.size.width, changeTerritoryBtn.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
}

-(void)clickLogOut
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate Logout];
}

// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate displayHOUserHomePage];
}


#pragma mark -

#pragma mark View Data Handlers
-(void)saveLatestSearchUrl:(NSString*)searchUrl
{
    //Conection dentifier should alway be that of default search
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        self.latestSuccessfulIndvSearchUrl = searchUrl;
    }
    else
    {
        self.latestSuccessfulOrgSearchUrl = searchUrl;
    }
}

-(void)getDataFromServer
{
    [[DataManager sharedObject] setIsDefaultRequestForRequests:FALSE];
    isConnectionInProgress = TRUE;
    
    //Add spineer
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    //Default search parameters
    NSMutableDictionary *searchParameters;// = [NSMutableDictionary dictionaryWithObjects:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersValues] forKeys:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersKeys]];
    if ([[DataManager sharedObject] isIndividualSegmentSelectedForRequest]==YES) {
        searchParameters = [NSMutableDictionary dictionaryWithObjects:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersValues] forKeys:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersKeys]];
    }
    else
    {
        searchParameters = [NSMutableDictionary dictionaryWithObjects:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersValuesForOrg] forKeys:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersKeys]];
    }
    
    NSMutableArray *searchBySectionRows = [[NSMutableArray alloc] init];
    [searchBySectionRows addObjectsFromArray:[[JSONDataFlowManager sharedInstance]defaultRequestSearchParametersKeys]];
    [searchParameters setObject:searchBySectionRows forKey:SEARCH_FORM_FIELDS_SEQUENCE];
    
    [self refreshSearchParametersView:searchParameters];
    
    if(iSLiveApp)
    {
        NSUserDefaults * defualts=[NSUserDefaults standardUserDefaults];
        NSMutableString * requestSearchUrl= [[NSMutableString alloc]initWithString:REQUESTS_DETAILS_URL];
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest]==YES) // Individual
        {
            [requestSearchUrl appendFormat:@"personnel_id=%@&terr_id=%@&cust_type=indv&requestor=%@&status=%@",[[defualts objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],[defualts objectForKey:@"SelectedTerritoryId"], [[[JSONDataFlowManager sharedInstance] requesterKeyValues] objectForKey:[searchParameters objectForKey:REQUESTOR_KEY]], [[[JSONDataFlowManager sharedInstance] stageOfRequestsKeyValues] objectForKey:[searchParameters objectForKey:REQ_STAGE_KEY]]];
        }
        else //Organization
        {
            [requestSearchUrl appendFormat:@"personnel_id=%@&terr_id=%@&cust_type=org&requestor=%@&status=%@",[[defualts objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],[defualts objectForKey:@"SelectedTerritoryId"], [[[JSONDataFlowManager sharedInstance] requesterKeyValues] objectForKey:[searchParameters objectForKey:REQUESTOR_KEY]], [[[JSONDataFlowManager sharedInstance] stageOfRequestsKeyValues] objectForKey:[searchParameters objectForKey:REQ_STAGE_KEY]]];
        }
        noAlignedAddressMessage.hidden = YES;
        noRemovalAddressMessage.hidden = YES;
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        //Protocol : getRequest
        [connection fetchDataFromUrl:[requestSearchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"RequestsDetails" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
         {
             //CallBack Block
             if(!error)
             {
                 [self receiveDataFromServer:data ofCallIdentifier:identifier];
             }
             else
             {
                 [self failWithError:error ofCallIdentifier:identifier];
             }
         }];
        
        //Save search URL
        connectionUrl = requestSearchUrl;
        latestConnectionIdentifier = @"RequestsDetails";
    }
    else
    {
        NSString * customerType=[[NSString alloc]init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            customerType =INDIVIDUALS_KEY;
            indvRequestsData=[DummyData requestsDataWithCustomerType:customerType andRequestStatus:[defaults objectForKey:@"selectedStage"]];
        }
        else
        {
            customerType =ORGANIZATIONS_KEY;
            orgRequestsData=[DummyData requestsDataWithCustomerType:customerType andRequestStatus:[defaults objectForKey:@"selectedStage"]];
        }
        
        [requestListTable reloadData];
        [self selectFirstItemFromList];
        
        //Remove Spinner
        [Utilities removeSpinnerFromView:self.view];
    }
}

-(void)refreshPreviousSearchResult
{
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        if(self.latestSuccessfulIndvSearchUrl.length)
        {
            //Set connectionInProgress flag
            isConnectionInProgress = TRUE;
            
            //Add spinner
            [Utilities addSpinnerOnView:self.view withMessage:nil];
            ConnectionClass *connection = [ConnectionClass sharedSingleton];
            noAlignedAddressMessage.hidden = YES;
            noRemovalAddressMessage.hidden = YES;
            [connection fetchDataFromUrl:[self.latestSuccessfulIndvSearchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"RequestsDetails" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
             {
                 //CallBack Block
                 if(!error)
                 {
                     [self receiveDataFromServer:data ofCallIdentifier:identifier];
                 }
                 else
                 {
                     [self failWithError:error ofCallIdentifier:identifier];
                 }
             }];
            connectionUrl = self.latestSuccessfulIndvSearchUrl;
            latestConnectionIdentifier = @"RequestsDetails";
        }
        else    //This should never get executed, added just for failsafe
        {
            [self getDataFromServer];
        }
    }
    else
    {
        if(self.latestSuccessfulOrgSearchUrl.length)
        {
            //Set connectionInProgress flag
            isConnectionInProgress = TRUE;
            
            //Add spinner
            [Utilities addSpinnerOnView:self.view withMessage:nil];
            ConnectionClass *connection = [ConnectionClass sharedSingleton];
            noAlignedAddressMessage.hidden = YES;
            noRemovalAddressMessage.hidden = YES;
            [connection fetchDataFromUrl:[self.latestSuccessfulOrgSearchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"RequestsDetails" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
             {
                 //CallBack Block
                 if(!error)
                 {
                     [self receiveDataFromServer:data ofCallIdentifier:identifier];
                 }
                 else
                 {
                     [self failWithError:error ofCallIdentifier:identifier];
                 }
             }];
            connectionUrl = self.latestSuccessfulOrgSearchUrl;
            latestConnectionIdentifier = @"RequestsDetails";
        }
        else    //This should never get executed, added just for failsafe
        {
            [self getDataFromServer];
        }
    }
}

-(IBAction) searchOtherAddressesForAlignment
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];
    
    NSMutableString * url=[[NSMutableString alloc]init];
    [url appendFormat:@"%@",SEARCH_INDIVIDUAL_FOR_AR];
    
    NSString *msgString = @"";
    if(removalBPID!=nil && ![removalBPID isEqualToString:@""])
    {
        [url appendFormat:@"bp_id=%@&",removalBPID];
        msgString = @"Searching Addresses...";
        [defaults setObject:BP_ID_QUICK_SEARCH forKey:@"quickSearchType"];
    }
    [url appendFormat:@"search_type=reg"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
    [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
    
    //Web URL requested
   
    [Utilities addSpinnerOnView:self.view withMessage:msgString];
    isConnectionInProgress = TRUE;
    
    ConnectionClass * connection= [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchIndividualAddressesForAlignment" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
     {
         //CallBack Block
         if(!error)
         {
             [self receiveDataFromServer:data ofCallIdentifier:identifier];
             [Utilities removeSpinnerFromView:self.view];
         }
         else
         {
             [self failWithError:error ofCallIdentifier:identifier];
             [Utilities removeSpinnerFromView:self.view];
         }
     }];
    
    latestConnectionIdentifier = @"SearchIndividualAddressesForAlignment";
}

-(IBAction) showAlignNewAddressScreen:(NSArray*)data
{
    if(alignmentViewController)
    {
        alignmentViewController = nil;
    }
    alignmentViewController = [[AlignNewAddressViewController alloc] initWithNibName:@"AlignNewAddressViewController" bundle:nil];
    
    alignmentViewController.view.frame = CGRectMake(0, 768, 1024, 655);
    alignmentViewController.alignAddDelegate = self;
    alignmentViewController.nameAnsLabel.text = nameString;
    alignmentViewController.masterIDAnsLabel.text = bpaidtext;
    alignmentViewController.addressLabel.text = addressString;
    alignmentViewController.doneButton.enabled = NO;
    alignmentViewController.customerData = [data objectAtIndex:0];
    alignmentViewController.selectedCustDetailAddress = [[NSMutableArray alloc] init];
    
    [alignmentViewController.selectedCustDetailAddress removeAllObjects];
    for(AddressObject* addObj in alignmentViewController.customerData.custAddress)
    {
        [self.alignmentViewController.selectedCustDetailAddress addObject:addObj];
    }
    
    [self addChildViewController:alignmentViewController];
    [self.view addSubview:alignmentViewController.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        alignmentViewController.view.frame = CGRectMake(alignmentViewController.view.frame.origin.x,
                                                        alignmentViewController.view.frame.origin.y - 768,
                                                        alignmentViewController.view.frame.size.width,
                                                        alignmentViewController.view.frame.size.height);
    }];
}

- (void)showDucplicateAddressScreen
{
    //Implement duplicate Address Screen here
    //[self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    // NSArray * duplicateArray = selectedCustDetailAddress;
    
    if(mlpModalviewController)
    {
        mlpModalviewController = nil;
    }
    
    mlpModalviewController = [[MLPModalViewController alloc] initWithNibName:@"MLPModalViewController" bundle:nil];
    self.mlpModalviewController.duplicateAddressDataDelegate = (id)self;
    
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + mlpModalviewController.view.frame.size.height;
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    
    mlpModalviewController.nameAnsLabel.text = removeAddressnameText.text;
    mlpModalviewController.secSpeLabel.hidden = YES;
    mlpModalviewController.secSpeAnsLabel.hidden= YES;
    mlpModalviewController.NPILabel.hidden = NO;
    mlpModalviewController.NPIAnsLabel.hidden = NO;
    mlpModalviewController.primarySpeAnsLabel.hidden = YES;
    mlpModalviewController.primarySpeLabel.hidden = YES;
    mlpModalviewController.addressLabel.hidden = NO;
    
    //NSDictionary *selectedItem = [[NSDictionary alloc] init];
    NSDictionary *selectedItem = [removedAddressArray objectAtIndex:0];
    
    
    if([selectedItem objectForKey:@"bpaId"])
    {
        //[requestCell.BPIDLabel setText:[NSString stringWithFormat:@"%@",addObj.BPA_ID]];
        mlpModalviewController.masterIDAnsLabel.text = [NSString stringWithFormat:@"%@", [selectedItem objectForKey:@"bpaId"]];
        
    }
    
    if([selectedItem objectForKey:@"city"])
    {
        mlpModalviewController.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@",[selectedItem objectForKey:@"addrLine1"], [selectedItem objectForKey:@"city"], [selectedItem objectForKey:@"state"], [selectedItem objectForKey:@"zip"]];
    }
    if([selectedItem objectForKey:@"addrUsageType"])
    {
        mlpModalviewController.NPILabel.text = @"Address Type:";
        mlpModalviewController.NPIAnsLabel.text = [selectedItem objectForKey:@"addrUsageType"];
    }
    
    
    //Set data
    mlpModalviewController.customTableViewController.customerDataDelegate = self;
    mlpModalviewController.customTableViewController.isIndividual = [[DataManager sharedObject]
                                                                     isIndividualSegmentSelectedForAddCustomer];
    mlpModalviewController.customTableViewController.dataArray = [[NSArray alloc] init];
    
    //hardcode value for time being
    
    mlpModalviewController.customTableViewController.popUpScreenTitle = VIEW_DUPLICATE_ADDRESS_SCREEN;
    mlpModalviewController.customTableViewController.dataArray = completeDuplicateAddressArrayForRemoveAddress;
    
    mlpModalviewController.cancelButton.hidden = YES;
    
    
    
    [mlpModalviewController.titleLabel setText:@"View Duplicate Address"];
    
    [self addChildViewController:mlpModalviewController];
    [self.view addSubview:mlpModalviewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, mlpModalviewController.view.frame.origin.y-offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    
    if(track==1)
    {
        track=0;
    }
    
    NSDictionary *jsonDataObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
    jsonDataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if([identifier isEqualToString:@"AlignNewAddressToTerritory"])
    {
        
        NSInteger requestedIndex = selectedRequestListIndex;
        if(jsonDataObjects==nil)
        {
            //Error Align Teritory
            NSIndexPath* index=[NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
            AlignNewAddressTableViewCell * cell = (AlignNewAddressTableViewCell*)[self.alignmentViewController.alignNewAddressTableView cellForRowAtIndexPath:index];
            UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
            errorLabel.textColor = [UIColor redColor];
            errorLabel.text=[NSString stringWithFormat:ERROR_ADD_TO_TERRITORY_FAILED];
            AddressObject *addObj= [self.alignmentViewController.selectedCustDetailAddress objectAtIndex:index.row];
            addObj.errorlLabel=errorLabel.text;
            [self.alignmentViewController.selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
        }
        else //there is some JSON received, parse it and use it
        {
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([dataString rangeOfString:@"requireSearch"].location == NSNotFound)
            {
                if([Utilities parseJsonAndCheckStatus:jsonDataObjects]) //Success
                {
                    //Align Territory Success
                    NSIndexPath* index=[NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
                    AlignNewAddressTableViewCell * cell = (AlignNewAddressTableViewCell*)[self.alignmentViewController.alignNewAddressTableView cellForRowAtIndexPath:index];
                    cell.addTerritoryBtn.enabled = NO;
                    UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
                    errorLabel.textColor = THEME_COLOR;
                    errorLabel.text = [NSString stringWithFormat:@"%@", [jsonDataObjects objectForKey:@"reasonCode"]];
                    
                    AddressObject *addObj = [self.alignmentViewController.selectedCustDetailAddress objectAtIndex:index.row];
                    addObj.errorlLabel=errorLabel.text;
                    addObj.isAddedToTerritory = @"Yes";
                    [self.alignmentViewController.selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
                    [self.alignmentViewController.alignNewAddressTableView reloadData];
                    
                    RequestObject* reqObj = [indvRequestsData objectAtIndex:requestedIndex];
                    [reqObj.customerInfo.custAddress addObject:addObj];
                    [self.requestListTable reloadData];
                    
                    //Assigning 0 length string
                    if(addObj.street == nil)addObj.street = @"";
                    NSArray *objects =[NSArray arrayWithObjects:
                                       addObj.addr_usage_type,
                                       addObj.city,
                                       addObj.BPA_ID,
                                       addObj.zip,
                                       addObj.addressLineOne,
                                       addObj.state,
                                       addObj.street, nil];
                    
                    NSArray *keys = [NSArray arrayWithObjects:
                                     @"addrUsageType",
                                     @"city",
                                     @"bpaId",
                                     @"zip",
                                     @"addrLine1",
                                     @"state",
                                     @"street", nil];
                    
                    NSDictionary *addItem = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                    
                    if(requestedIndex < removeAddressResponseArray.count)
                    {
                        NSMutableDictionary *item = [removeAddressResponseArray objectAtIndex:selectedRequestListIndex];
                        NSMutableDictionary * customerDictionary = [item objectForKey:@"customer"];
                        NSMutableArray* customerAddArray = [customerDictionary objectForKey:@"address"];
                        
                        [customerAddArray addObject:addItem];
                        [customerDictionary setObject:customerAddArray forKey:@"address"];
                        [item setObject:customerDictionary forKey:@"customer"];
                        [removeAddressResponseArray setObject:item atIndexedSubscript:requestedIndex];
                    }
                    [self refreshRequestDetailsOfIndex:selectedRequestListIndex];
                    //[self.alignedAddressArray addObject:addItem];
                    [self.requestListTable reloadData];
                    [self.otherAlignedAdressTableView reloadData];
                    
                    //enable approve button to remove requested address
                    self.alignmentViewController.doneButton.enabled = YES;
                }
                else //Failure
                {
                    if(![[jsonDataObjects objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        //Error Alighn Teritory
                        NSIndexPath* index=[NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
                        AlignNewAddressTableViewCell * cell = (AlignNewAddressTableViewCell*)[self.alignmentViewController.alignNewAddressTableView cellForRowAtIndexPath:index];
                        cell.addTerritoryBtn.enabled = NO;
                        UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
                        errorLabel.textColor = [UIColor redColor];
                        errorLabel.text=[NSString stringWithFormat:@"%@",[jsonDataObjects objectForKey:@"reasonCode"]];
                        
                        AddressObject *addObj= [self.alignmentViewController.selectedCustDetailAddress objectAtIndex:index.row];
                        addObj.errorlLabel = errorLabel.text;
                        addObj.isAddedToTerritory = @"No";
                        [self.alignmentViewController.selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
                        [self.alignmentViewController.alignNewAddressTableView reloadData];
                    }
                }
            }
            else
            {
                NSError *e = nil;
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                if (!jsonArray) {
                    NSLog(@"Error parsing JSON: %@", e);
                }
                else
                {
                    //currently keeping prescriber screen off the flow
                    //[self showSearchPrescriberScreen];
                }
            }
        }
        return;
    }
    
    jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if(![identifier isEqualToString:@"RemovalRequestType"] && ![identifier isEqualToString:@"WithdrawRequest"] && ![identifier isEqualToString:@"WithdrawAlignmentRequest"] && ![identifier isEqualToString:@"ViewDuplicateAddressOfBPIdentifier"] && ![identifier isEqualToString:@"SearchIndividualAddressesForAlignment"])
    {
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([dataString rangeOfString:@"No results found"].location == NSNotFound && [dataString rangeOfString:@"Failure"].location == NSNotFound)
        {
            removeAddressResponseArray = (NSMutableArray*)jsonArray;
        }
        else
        {
            [self selectFirstItemFromList];
        }
        if(jsonArray.count == 0)
        {
            [Utilities removeSpinnerFromView:self.view];
            [self updateServerResponseLabelWithText:@"No results found. Please modify your search criteria and try again." forIdentifier:identifier successOrFailure:NO];
            return;
        }
    }
   
    
    //response is supposed to be an Array
    if(jsonDataArrayOfObjects && ![jsonDataArrayOfObjects isKindOfClass:[NSArray class]])
    {
        jsonDataArrayOfObjects = [NSArray arrayWithObject:jsonDataArrayOfObjects];
    }
    
    DebugLog(@"[Request View Controller : receiveDataFromServer : JSON received : \n%@ \nIdentifier: %@",jsonDataArrayOfObjects ,identifier);
    //Parse Data for search response
    if(jsonDataArrayOfObjects!=nil)
    {
        if([identifier isEqualToString:@"RequestsDetails"])
        {
            BOOL isValidDataReceived = FALSE;
            if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
            {
                NSMutableArray * serverData=[[Utilities parseJsonGetRequests:jsonDataArrayOfObjects] mutableCopy];
                if([serverData count]>0)
                {
                    indvRequestsData=serverData;
                    isValidDataReceived = [indvRequestsData count]>0;
                }
                selectedRequestListIndex=0;
                NSInteger count;
                if (indvRequestsData.count>0)
                {
                    RequestObject *reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
                    count =[reqObj.dealignedBPAInfoArray count];
                }
                
                [requestListTable reloadData];
                [searchParameterTable reloadData];
                
                if(shouldLoadRemoveAddress)
                {
                    if (count >1) {
                        [requestStatusTableRemoveAddress setContentSize:CGSizeMake(requestStatusTableRemoveAddress.frame.size.width, count *150)];
                    }
                    [addressTableRemoveAddress reloadData];
                    [requestStatusTableRemoveAddress reloadData];
                    [otherAlignedAdressTableView reloadData];
                }
                else
                {
                    
                    [addressTable reloadData];
                    [requestStatusTable reloadData];
                }
            }
            else    //Organization
            {
                NSMutableArray * serverData=[[Utilities parseJsonGetRequests:jsonDataArrayOfObjects] mutableCopy];
                if([serverData count]>0)
                {
                    orgRequestsData=serverData;
                    isValidDataReceived = [orgRequestsData count]>0;
                }
                
                [requestListTable reloadData];
                [searchParameterTable reloadData];
                [addressTableOrg reloadData];
                [requestStatusTableOrg reloadData];
            }
            
            if(isValidDataReceived)
            {
                [self selectFirstItemFromList];
                //On success, clear response label
                [self updateServerResponseLabelWithText:@"" forIdentifier:identifier successOrFailure:YES];
                
                //Save search URL and Identifier
                [self saveLatestSearchUrl:connectionUrl];
            }
            else//Display error label
            {
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    //Handle error response
                    if(jsonDataArrayOfObjects.count)
                    {
                        [self updateServerResponseLabelWithText:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:NO];
                    }
                    else
                    {
                        [self updateServerResponseLabelWithText:ERROR_UNABLE_TO_LOAD_REQUESTS forIdentifier:identifier successOrFailure:NO];
                    }
                }
            }
        }
        else  if([identifier isEqualToString:@"RefineRequestSearchForOrganization"] || [identifier isEqualToString:@"RefineRequestSearchForIndividual"])
        {
            BOOL isValidDataReceived = FALSE;
            //NSMutableArray * serverData = [[NSMutableArray alloc] initWithArray:jsonDataArrayOfObjects];
            NSMutableArray * serverData = [[Utilities parseJsonGetRequests:jsonDataArrayOfObjects] mutableCopy];
            if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
            {
                if([serverData count]>0)
                {
                    indvRequestsData=serverData;
                    isValidDataReceived = [indvRequestsData count]>0;
                }
                selectedRequestListIndex=0;
                RequestObject *reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
                NSInteger count =[reqObj.dealignedBPAInfoArray count];
                [requestListTable reloadData];
                [searchParameterTable reloadData];
                
                if(shouldLoadRemoveAddress)
                {
                    if (count >1) {
                        [requestStatusTableRemoveAddress setContentSize:CGSizeMake(requestStatusTableRemoveAddress.frame.size.width, count *150)];
                    }
                    
                    [addressTableRemoveAddress reloadData];
                    [requestStatusTableRemoveAddress reloadData];
                    [otherAlignedAdressTableView reloadData];
                }
                else
                {
                    [addressTable reloadData];
                    [requestStatusTable reloadData];
                }
            }
            else    //Organization
            {
                if([serverData count]>0)
                {
                    orgRequestsData=serverData;
                    isValidDataReceived = [orgRequestsData count]>0;
                }
                
                [requestListTable reloadData];
                [searchParameterTable reloadData];
                [addressTableOrg reloadData];
                [requestStatusTableOrg reloadData];
            }
            
            if(isValidDataReceived)
            {
                [self selectFirstItemFromList];
                //On success, clear response label
                
                //Refresh search parameters view
                [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
                
                //Remove modal view with animation
                [self removeCustomModalViewController];
                
                [self updateServerResponseLabelWithText:@"" forIdentifier:identifier successOrFailure:YES];
                
                //Save search URL and Identifier
                [self saveLatestSearchUrl:connectionUrl];
            }
            else//Display error label
            {
                
                if(jsonDataArrayOfObjects.count > 0)
                {
                    if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        //Handle error response
                        if(jsonDataArrayOfObjects.count)
                        {
                            [self displayErrorMessage:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]];
                            [self selectFirstItemFromList];
                        }
                        else
                        {
                            [self displayErrorMessage:ERROR_UNABLE_TO_LOAD_REQUESTS];
                        }
                    }
                    else
                    {
                        [self removeCustomModalViewController];
                    }
                }
            }
        }
        else if ([identifier isEqualToString:@"WithdrawAlignmentRequest"])
        {
            if([Utilities parseJsonAndCheckStatus:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]])//Success
            {
                if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
                {
                    [self.withdrawRequestBtn setEnabled:NO];
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:YES];
                    [indvRequestsData removeObjectAtIndex:selectedRequestListIndex];
                    [self.requestListTable reloadData];
                    if([indvRequestsData count]==0)
                    {
                        track = 1;
                        [Utilities addSpinnerOnView:self.view withMessage:nil];
                        selectedRequestListIndex=-1;
                        [self getDataFromServer];
                    }
                    else
                    {
                        if([[indvSearchParameters objectForKey:REQ_STAGE_KEY] isEqualToString:REQUEST_STATUS_PENDING])
                        {
                            //[self selectFirstItemFromList];
                        }
                        else
                        {
                            if(self.latestSuccessfulIndvSearchUrl.length)
                            {
                                //[self refreshPreviousSearchResult];
                                return;
                            }
                        }
                    }
                }
            }
            else //Error-Failure
            {
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:NO];
                }
            }
        }
        else if ([identifier isEqualToString:@"WithdrawRequest"])
        {
            if([Utilities parseJsonAndCheckStatus:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]])//Success
            {
                if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
                {
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:YES];
                    [indvRequestsData removeObjectAtIndex:selectedRequestListIndex];
                    [self.requestListTable reloadData];
                    if([indvRequestsData count]==0)
                    {
                        track = 1;
                        [Utilities addSpinnerOnView:self.view withMessage:nil];
                        selectedRequestListIndex=-1;
                        [self getDataFromServer];
                    }
                    else
                    {
                        if([[indvSearchParameters objectForKey:REQ_STAGE_KEY] isEqualToString:REQUEST_STATUS_PENDING])
                        {
                            [self selectFirstItemFromList];
                        }
                        else
                        {
                            if(self.latestSuccessfulIndvSearchUrl.length)
                            {
                                [self refreshPreviousSearchResult];
                                return;
                            }
                        }
                    }
                }
                else//Org
                {
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:YES];
                    [orgRequestsData removeObjectAtIndex:selectedRequestListIndex];
                    [self.requestListTable reloadData];
                    if([orgRequestsData count]==0)
                    {
                        selectedRequestListIndex=-1;
                        [self getDataFromServer];
                    }
                    else
                    {
                        if([[orgSearchParameters objectForKey:REQ_STAGE_KEY] isEqualToString:REQUEST_STATUS_PENDING])
                        {
                            [self selectFirstItemFromList];
                        }
                        else
                        {
                            if(self.latestSuccessfulOrgSearchUrl.length)
                            {
                                [self refreshPreviousSearchResult];
                                return;
                            }
                        }
                    }
                }
            }
            else //Erroor
            {
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:NO];
                }
            }
        }
        else if([identifier isEqualToString:@"ViewDuplicateAddressOfBPIdentifier"] || [identifier isEqualToString:@"ViewDuplicateAddressOfBPIdentifier"])
        {
            NSError *e = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
            //completeDuplicateAddressArray = [[NSMutableArray alloc] init];
            if(jsonArray.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No records found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                [Utilities removeSpinnerFromView:self.view];
                return;
            }
            if (!jsonArray) {
                NSLog(@"Error parsing JSON: %@", e);
                [self updateServerResponseLabelWithText:ERROR_NO_RESULTS_FOUND_TRY_AGAIN forIdentifier:identifier successOrFailure:FALSE];
            }
            else
            {
                [completeDuplicateAddressArrayForRemoveAddress removeAllObjects];
                completeDuplicateAddressArrayForRemoveAddress = nil;
                completeDuplicateAddressArrayForRemoveAddress = [[NSMutableArray alloc] init];
                for(NSDictionary *item in jsonArray) {
                    NSMutableDictionary *addressItem = [[NSMutableDictionary alloc] init];
                    NSString * bpaId =  [NSString stringWithFormat:@"%@",[item objectForKey:@"bpaId"]];
                    [addressItem setObject:bpaId forKey:@"bpaId"];
                    
                    NSString *addressType = [item objectForKey:@"addrUsageType"];
                    
                    [addressItem setObject:addressType forKey:@"addrUsageType"];
                    
                    NSString *city = [item objectForKey:@"city"];
                    NSString *state = [item objectForKey:@"state"];
                    NSString *zip = [item objectForKey:@"zip"];
                    NSString *addressLine1 = [item objectForKey:@"addrLine1"];
                    
                    addressString = [NSString stringWithFormat:@" %@ %@\n%@ %@", addressLine1 ,city, state, zip];
                    
                    NSString * addressInLine = [NSString stringWithFormat:@" %@ %@, %@ %@", addressLine1 ,city, state, zip];
                    [addressItem setObject:addressInLine forKey:@"address"];
                    [completeDuplicateAddressArrayForRemoveAddress addObject:addressItem];
                    
                    
                }
                if(removedAddressArray.count > 0)
                {
                    [self showDucplicateAddressScreen];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No records found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                    [Utilities removeSpinnerFromView:self.view];
                    return;
                }
            }
        }
        else if( [identifier isEqualToString:@"SearchIndividualAddressesForAlignment"])
        {
            if(jsonDataArray.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No records found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                [Utilities removeSpinnerFromView:self.view];
                return;
            }
            if (!jsonDataArray) {
                NSLog(@"Error parsing JSON...");
                [self updateServerResponseLabelWithText:ERROR_NO_RESULTS_FOUND_TRY_AGAIN forIdentifier:identifier successOrFailure:FALSE];
            }
            else
            {
                NSString *string1,*string2;
                
                //Storing 1 Customer Object in searchCustDataServer
                searchedCustDataFromServer= [Utilities parseJsonSearchIndividual:jsonDataArray];
                
                CustomerObject *custObj = [searchedCustDataFromServer objectAtIndex:0];
                string1 = [NSString stringWithFormat:@"%@",removalBPAID];
                for (NSInteger i = 0; i < [[[searchedCustDataFromServer objectAtIndex:0] custAddress] count]; i++) {
                    string2 = [NSString stringWithFormat:@"%@",[[custObj.custAddress objectAtIndex:i] BPA_ID]];
                    if([string1 isEqualToString:string2]){
                        
                        //Removing RemovalBPAID from searched addresses
                        [custObj.custAddress removeObjectAtIndex:i];
                        break;
                    }
                }
                if(searchedCustDataFromServer!=nil && searchedCustDataFromServer.count > 0)
                {
                    [self showAlignNewAddressScreen:[NSArray arrayWithArray:searchedCustDataFromServer]];
                }
            }
        }
        else if ([identifier isEqualToString:@"RemovalRequestType"])//-- make changes in implementation as required
        {
            
            
            if([Utilities parseJsonAndCheckStatus:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]])//Success
            {
                if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
                {
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:YES];
                    [indvRequestsData removeObjectAtIndex:selectedRequestListIndex];
                    [self.requestListTable reloadData];
                    if([indvRequestsData count]==0)
                    {
                        track = 1;
                        selectedRequestListIndex=-1;
                        removeAddressWithdrawRequestBtn.enabled = NO;
                        removeAddressApproveBtn.enabled = NO;
                        removeAddressRejectBtn.enabled = NO;
                        [Utilities addSpinnerOnView:self.view withMessage:nil];
                        [self getDataFromServer];
                    }
                    else
                    {
                        
                        track = 1;
                        if([[indvSearchParameters objectForKey:REQ_STAGE_KEY] isEqualToString:REQUEST_STATUS_PENDING])
                        {
                            [self refreshPreviousSearchResult];
                            removeAddressWithdrawRequestBtn.enabled = NO;
                            removeAddressApproveBtn.enabled = NO;
                            removeAddressRejectBtn.enabled = NO;
                            [self selectFirstItemFromList];
                            [Utilities addSpinnerOnView:self.view withMessage:nil];
                        }
                        else
                        {
                            if(self.latestSuccessfulIndvSearchUrl.length)
                            {
                                removeAddressWithdrawRequestBtn.enabled = NO;
                                removeAddressApproveBtn.enabled = NO;
                                removeAddressRejectBtn.enabled = NO;
                                
                                [Utilities addSpinnerOnView:self.view withMessage:nil];
                                [self refreshPreviousSearchResult];
                                [self selectFirstItemFromList];
                                //[self refreshRequestDetailsOfIndex:0];
                                return;
                            }
                        }
                        
                    }
                }
                else//Org
                {
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:YES];
                    [orgRequestsData removeObjectAtIndex:selectedRequestListIndex];
                    [self.requestListTable reloadData];
                    if([orgRequestsData count]==0)
                    {
                        selectedRequestListIndex=-1;
                        [self getDataFromServer];
                    }
                    else
                    {
                        if([[orgSearchParameters objectForKey:REQ_STAGE_KEY] isEqualToString:REQUEST_STATUS_PENDING])
                        {
                            [self selectFirstItemFromList];
                        }
                        else
                        {
                            if(self.latestSuccessfulOrgSearchUrl.length)
                            {
                                [self refreshPreviousSearchResult];
                                return;
                            }
                        }
                    }
                }
            }
            else //Erroor
            {
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    
                    [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:NO];
                }
            }
        }
    }
    else
    {
        //Handle error response
        if([identifier isEqualToString:@"RefineRequestSearchForOrganization"] ||
           [identifier isEqualToString:@"RefineRequestSearchForIndividual"])
        {
            //Display error on modal view
            [self displayErrorMessage:ERROR_UNABLE_TO_LOAD_REQUESTS];
        }
        else
        {
            //Update server response label
            
            
            [self updateServerResponseLabelWithText:ERROR_UNABLE_TO_LOAD_REQUESTS forIdentifier:identifier successOrFailure:NO];
            
        }
        
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ErrorLog(@"Request Customer Class | Connection Data - %@ | Identifier - %@",myString ,identifier);
    }
    
    //Reset connection in progress flag
    isConnectionInProgress = FALSE;
    
    //Remove Spinner
    if(track!=1)
        [Utilities removeSpinnerFromView:self.view];
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    ErrorLog(@"Login Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    //Handle error response
    if([identifier isEqualToString:@"RefineRequestSearchForIndividual"] ||
       [identifier isEqualToString:@"RefineRequestSearchForOrganization"])
    {
        //Display error on modal view
        [self displayErrorMessage:error];
    }
    else
    {
        //Update server response label
        [self updateServerResponseLabelWithText:error forIdentifier:identifier successOrFailure:NO];
    }
    
    //Reset connection in progress flag
    isConnectionInProgress = FALSE;
    
    //Remove Spinner
    [Utilities removeSpinnerFromView:self.view];
}
#pragma mark -

#pragma mark Customer Data Delegate


-(void)processCustomerData:(NSMutableArray *)data forIdentifier:(NSString *)identifier
{
    RequestObject *requestObject = (RequestObject*)[data objectAtIndex:0];
    NSUserDefaults * defualts=[NSUserDefaults standardUserDefaults];
    NSString *connectionIdentifier = @"";
    
    if(iSLiveApp)
    {
        //Set connectionInProgress flag
        isConnectionInProgress = TRUE;
        
        //Add spinner on view
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        
        NSMutableString * requestSearchUrl= [[NSMutableString alloc]initWithString:REQUESTS_DETAILS_URL];
        [requestSearchUrl appendFormat:@"personnel_id=%@&terr_id=%@",[[defualts objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],[defualts objectForKey:@"SelectedTerritoryId"]];
        
        //Requestor
        if(requestObject.requesterType !=nil && requestObject.requesterType.length!=0)
        {
            [requestSearchUrl appendFormat:@"&requestor=%@",requestObject.requesterType];
        }
        
        //Request type
        if(requestObject.requestType !=nil && requestObject.requestType.length!=0)
        {
            [requestSearchUrl appendFormat:@"&request_type=%@",requestObject.requestType];
        }
        
        //Request status
        //Request stage is passed as 'status'
        if(requestObject.requestStage !=nil && requestObject.requestStage.length!=0)
        {
            [requestSearchUrl appendFormat:@"&status=%@",[[[JSONDataFlowManager sharedInstance]stageOfRequestsKeyValues] objectForKey:requestObject.requestStage]];
        }
        
        //Ticket number
       
        if(requestObject.ticketNo !=nil && requestObject.ticketNo.length!=0)
        {
            //showing ticket id here
            NSLog(@"ticket no::::%@",requestObject.ticketNo);
            [requestSearchUrl appendFormat:@"&ticket_no=%@",requestObject.ticketNo];
        }
        
        //Creation date
        if(requestObject.requestCreationDate !=nil && requestObject.requestCreationDate.length!=0)
        {
            [requestSearchUrl appendFormat:@"&create_date=%@",requestObject.requestCreationDate];
        }
        //Add specific parameters to URL depending on Type: INDV/ORG
        if([identifier isEqualToString:@"RefineRequestSearchForIndividual"])
        {
            connectionIdentifier = @"RefineRequestSearchForIndividual";
            
            //Customer type
            [requestSearchUrl appendFormat:@"&cust_type=%@",@"indv"];
            
            //Customer Info
            if(requestObject.customerInfo.custFirstName !=nil && requestObject.customerInfo.custFirstName.length!=0)
            {
                [requestSearchUrl appendFormat:@"&fname=%@",requestObject.customerInfo.custFirstName];
            }
            if(requestObject.customerInfo.custLastName !=nil && requestObject.customerInfo.custLastName.length!=0)
            {
                [requestSearchUrl appendFormat:@"&lname=%@",requestObject.customerInfo.custLastName];
            }
            if(requestObject.customerInfo.custBPID !=nil && requestObject.customerInfo.custBPID.length!=0)
            {
                [requestSearchUrl appendFormat:@"&bp_id=%@",requestObject.customerInfo.custBPID];
            }
            
            //Address
            AddressObject *customerAddress = [requestObject.customerInfo.custAddress objectAtIndex:0];
            if(customerAddress.state !=nil && customerAddress.state.length!=0)
            {
                [requestSearchUrl appendFormat:@"&state=%@",customerAddress.state];
            }
            if(customerAddress.city !=nil && customerAddress.city.length!=0)
            {
                [requestSearchUrl appendFormat:@"&city=%@",customerAddress.city];
            }
            if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
            {
                [requestSearchUrl appendFormat:@"&zip=%@",customerAddress.zip];
            }
        }
        else if([identifier isEqualToString:@"RefineRequestSearchForOrganization"])
        {
            connectionIdentifier = @"RefineRequestSearchForOrganization";
            
            [requestSearchUrl appendFormat:@"&cust_type=%@",@"org"];
            
            //Organization info
            if(requestObject.organizationInfo.orgName !=nil && requestObject.organizationInfo.orgName.length!=0)
            {
                [requestSearchUrl appendFormat:@"&org_name=%@",requestObject.organizationInfo.orgName];
            }
            if(requestObject.organizationInfo.orgBPID !=nil && requestObject.organizationInfo.orgBPID.length!=0)
            {
                [requestSearchUrl appendFormat:@"&bp_id=%@",requestObject.organizationInfo.orgBPID];
            }
            
            if(requestObject.organizationInfo.orgType !=nil && requestObject.organizationInfo.orgType.length!=0 && [[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:requestObject.organizationInfo.orgType].count)
            {
                [requestSearchUrl appendFormat:@"&org_type=%@",[[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:requestObject.organizationInfo.orgType] objectAtIndex:0]];
            }
            
            //Address
            AddressObject *customerAddress = [requestObject.organizationInfo.orgAddress objectAtIndex:0];
            if(customerAddress.state !=nil && customerAddress.state.length!=0)
            {
                [requestSearchUrl appendFormat:@"&state=%@",customerAddress.state];
            }
            if(customerAddress.city !=nil && customerAddress.city.length!=0)
            {
                [requestSearchUrl appendFormat:@"&city=%@",customerAddress.city];
            }
            if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
            {
                [requestSearchUrl appendFormat:@"&zip=%@",customerAddress.zip];
            }
        }
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        noAlignedAddressMessage.hidden = YES;
        noRemovalAddressMessage.hidden = YES;
        //Protocol: getRequest
        [connection fetchDataFromUrl:[requestSearchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
         {
             //CallBack Block
             if(!error)
             {
                 [self receiveDataFromServer:data ofCallIdentifier:identifier];
             }
             else
             {
                 [self failWithError:error ofCallIdentifier:identifier];
             }
         }];
        
        //Save search URL
        connectionUrl = requestSearchUrl;
        latestConnectionIdentifier = connectionIdentifier;
    }
}

-(void)displayErrorMessage:(NSString *)errorMsg
{
    [customModalViewController displayErrorMessage:errorMsg];
}
#pragma mark -

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==searchParameterTable)
    {
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
        {
            return (indvSearchParameters.count ? [[indvSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] count] : 0);
        }
        else
        {
            return (orgSearchParameters.count ? [[orgSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] count] : 0);
        }
    }
    else if(tableView==requestListTable)
    {
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
        {
            if(indvRequestsData.count>0)
            {
                //Show info button only if data received is for more than 25
                if(indvRequestsData.count>=MAX_SEARCH_RESULT_COUNT)
                {
                    [infoBtn setHidden:NO];
                }
                else
                {
                    [infoBtn setHidden:YES];
                }
                
                //[withdrawRequestBtn setEnabled:YES];
                //---[removeAddressWithdrawRequestBtn setEnabled:YES];
                //[removeAddressApproveBtn setEnabled:YES];
                //[removeAddressRejectBtn setEnabled:YES];
                selectedRequestListIndex = 0;
            }
            else
            {
                [infoBtn setHidden:YES];
                //[withdrawRequestBtn setEnabled:NO];
                
                //Clear prvious data
                [self refreshRequestDetailsOfIndex:-1];
                //[self clearSearchData];
            }
            
            return indvRequestsData.count;
        }
        else
        {
            if(orgRequestsData.count>0)
            {
                //Show info button only if data received is for more than 25
                if(orgRequestsData.count>=MAX_SEARCH_RESULT_COUNT)
                {
                    [infoBtn setHidden:NO];
                }
                else
                {
                    [infoBtn setHidden:YES];
                }
                
                [withdrawRequestBtnOrg setEnabled:YES];
                selectedRequestListIndex = 0;
            }
            else
            {
                [infoBtn setHidden:YES];
                [withdrawRequestBtnOrg setEnabled:NO];
                
                //Clear prvious data
                [self refreshRequestDetailsOfIndex:-1];
                //[self clearSearchData];
            }
            
            return orgRequestsData.count;
        }
    }
    else if(tableView==addressTable)    //Individual address table
    {
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            RequestObject *reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
            if(reqObj)
            {
                return (reqObj.customerInfo.custAddress.count ? reqObj.customerInfo.custAddress.count : 0);
            }
            else
            {
                return 0;
            }
        }
        
    }
    else if(tableView == addressTableRemoveAddress)    //Individual address table
    {
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            //RequestObject *reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
            if(removedAddressArray.count > 0)
            {
                //return (reqObj.customerInfo.custAddress.count ? reqObj.customerInfo.custAddress.count : 0);
                noRemovalAddressMessage.hidden = YES;
                return removedAddressArray.count;
            }
            else
            {
                noRemovalAddressMessage.hidden = YES;
                return 0;
            }
        }
        
    }
    else if(tableView==otherAlignedAdressTableView)    //Individual address table
    {
        //--- for now data same as above
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            //RequestObject *reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
            if(alignedAddressArray.count > 0)
            {
                //return (reqObj.customerInfo.custAddress.count ? reqObj.customerInfo.custAddress.count : 0);
                noAlignedAddressMessage.hidden = YES;
                return alignedAddressArray.count;
            }
            else
            {
                noAlignedAddressMessage.hidden = NO;
                return 0;
            }
        }
    }
    else if(tableView==requestStatusTable)  //Individual status table
    {
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            RequestObject* reqObj=nil;
            reqObj=(indvRequestsData.count ? [indvRequestsData objectAtIndex:selectedRequestListIndex] : nil);
            
            return [reqObj.requestStatusHistory count];
        }
    }
    else if(tableView == requestStatusTableRemoveAddress)  //Individual status table
    {
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            RequestObject* reqObj=nil;
            reqObj=(indvRequestsData.count ? [indvRequestsData objectAtIndex:selectedRequestListIndex] : nil);
            NSMutableArray *dealignBPArray = [reqObj dealignedBPAInfoArray];
            
            if([dealignBPArray count] > 0)
            {
                //return (reqObj.customerInfo.custAddress.count ? reqObj.customerInfo.custAddress.count : 0);
                //noAlignedAddressMessage.hidden = YES;
                return [dealignBPArray count];
            }
            else
            {
                //noAlignedAddressMessage.hidden = NO;
                return 0;
            }
        }
    }
    else if(tableView==addressTableOrg)     //Org address table
    {
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            RequestObject *reqObj = [orgRequestsData objectAtIndex:selectedRequestListIndex];
            if(reqObj)
            {
                return (reqObj.organizationInfo.orgAddress.count ? reqObj.organizationInfo.orgAddress.count : 0);
            }
            else
            {
                return 0;
            }
        }
    }
    else if(tableView==requestStatusTableOrg)   //org status table
    {
        if(selectedRequestListIndex==-1)
        {
            return 0;
        }
        else
        {
            RequestObject* reqObj=nil;
            reqObj=(orgRequestsData.count ? [orgRequestsData objectAtIndex:selectedRequestListIndex] : nil);
            
            return [reqObj.requestStatusHistory count];
        }
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchParameterTable)
    {
        static NSString *simpleTableIdentifier;
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            simpleTableIdentifier = @"ParametersInd";
        }
        else
        {
            simpleTableIdentifier = @"ParametersOrg";
        }
        UITableViewCell *cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cellTemp == nil) {
            cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        else
        {
            cellTemp.textLabel.text = @"";
        }
        
        cellTemp.tag=indexPath.row;
        cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
        cellTemp.clipsToBounds = NO;
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [cellTemp.textLabel setTextColor:THEME_COLOR];
        
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
        {
            NSString *rowName = [[self.indvSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] objectAtIndex:indexPath.row];
            
            //Request creation date
            if([rowName isEqualToString:REQ_CREATION_DATE_KEY])
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:DATE_FORMATTER_STYLE];
                NSDate *selectedDate = [dateFormatter dateFromString:[self.indvSearchParameters objectForKey:rowName]];
                
                //Change date to required format
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [dateFormatter stringFromDate:selectedDate]]];
                //                if(![dateFormatter stringFromDate:selectedDate])
                //                {
                //                    [cellTemp.textLabel setText:[NSString stringWithFormat:@""]];
                //                }
            }
            else
            {
                [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [self.indvSearchParameters objectForKey:rowName]]];
            }
        }
        else
        {
            NSString *rowName = [[self.orgSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] objectAtIndex:indexPath.row];
            
            //Request creation date
            if([rowName isEqualToString:REQ_CREATION_DATE_KEY])
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:DATE_FORMATTER_STYLE];
                NSDate *selectedDate = [dateFormatter dateFromString:[self.orgSearchParameters objectForKey:rowName]];
                
                //Change date to required format
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [dateFormatter stringFromDate:selectedDate]]];
                //                if(![dateFormatter stringFromDate:selectedDate])
                //                {
                //                    [cellTemp.textLabel setText:[NSString stringWithFormat:@""]];
                //                }
            }
            else{
                [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [self.orgSearchParameters objectForKey:rowName]]];
            }
        }
        return cellTemp;
    }
    else if(tableView==requestListTable)
    {
        static NSString *simpleTableIdentifier = @"RequestList";
        NSInteger numberOfAddress = 0;
//        NSInteger alignedAddressCount = 0;
        BOOL isAddressRemoval;
        
        if(indexPath.row == 6)      //to make first selection for requestListTable
            [self refreshRequestDetailsOfIndex:0];
        
        RequestInfoCell *requestCell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestCell == nil) {
            requestCell = [[[NSBundle mainBundle] loadNibNamed:@"RequestInfoCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [requestCell.requestTypeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
        [requestCell.custNameLabel  setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [requestCell.stageOfRequestLabel  setFont:[UIFont fontWithName:@"Roboto-Regular" size:10.0]];
        [requestCell.requestorLabel  setFont:[UIFont fontWithName:@"Roboto-Regular" size:10.0]];
        
        requestCell.tag=indexPath.row;
        requestCell.selectionStyle = UITableViewCellSelectionStyleGray;
        [requestCell setAccessoryType:UITableViewCellAccessoryNone];
        
        RequestObject* reqObj=nil;
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
        {
            reqObj=[indvRequestsData objectAtIndex:indexPath.row];
            numberOfAddress = [reqObj.customerInfo.custAddress count];
        }
        else
        {
            reqObj=[orgRequestsData objectAtIndex:indexPath.row];
        }
        
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            CustomerObject* custObj=reqObj.customerInfo;
            NSMutableArray *nameArray = [[NSMutableArray alloc] init];
            
            if(custObj.custTitle!=nil && custObj.custTitle.length)
            {
                [nameArray addObject:[NSString stringWithFormat:@"%@.", custObj.custTitle]];
            }
            if(custObj.custFirstName!=nil && custObj.custFirstName.length)
            {
                [nameArray addObject:custObj.custFirstName];
            }
            if(custObj.custMiddleName!=nil && custObj.custMiddleName.length)
            {
                [nameArray addObject:custObj.custMiddleName];
            }
            if(custObj.custLastName!=nil && custObj.custLastName.length)
            {
                [nameArray addObject:custObj.custLastName];
            }
            if(custObj.custSuffix!=nil && custObj.custSuffix.length)
            {
                [nameArray addObject:custObj.custSuffix];
            }
            requestCell.custNameLabel.text=[nameArray componentsJoinedByString:@" "];
        }
        else    //org
        {
            OrganizationObject* custObj=reqObj.organizationInfo;
            
            if(custObj.orgName!=nil)
            {
                [requestCell.custNameLabel setText:[NSString stringWithFormat:@"%@",custObj.orgName]];
            }
        }
        
        if([requestCell.requestTypeLabel.text isEqualToString:@"Remove address"])
        {
            isAddressRemoval = YES;
            shouldLoadRemoveAddress = YES;
        }
        else
        {
            isAddressRemoval = NO;
            shouldLoadRemoveAddress = NO;
        }
        if(reqObj.requestType != nil)
        {
            if([[[[JSONDataFlowManager sharedInstance]withdrawRequestTypeKeyValues] allKeys] containsObject:reqObj.requestType])
            {
                NSDictionary * dict=[[JSONDataFlowManager sharedInstance]withdrawRequestTypeKeyValues];
                [requestCell.requestTypeLabel setText:[NSString stringWithFormat:@"%@",[dict objectForKey:[NSString stringWithFormat:@"%@",reqObj.requestType]]]];
                
                if(indexPath.row == 0)
                {
                    if([requestCell.requestTypeLabel.text isEqualToString:@"Remove address"])
                    {
                        shouldLoadRemoveAddress = YES;
                    }
                    else
                    {
                        shouldLoadRemoveAddress = NO;
                    }
                }
                if([requestCell.requestTypeLabel.text isEqualToString:@"Remove address"])
                {
                    isAddressRemoval = YES;
                }
                else
                {
                    isAddressRemoval = NO;
                }
            }
        }
        if(reqObj.requestStatus!=nil)
        {
            //Need to modify
            if([[[JSONDataFlowManager sharedInstance] completedRequestStatusArray] containsObject:[reqObj.requestStatus lowercaseString]])
            {
                [requestCell.stageOfRequestLabel setText:[NSString stringWithFormat:@"%@: %@", STATUS_STRING, reqObj.requestStatus]];
            }
            else
            {
                [requestCell.stageOfRequestLabel setText:[NSString stringWithFormat:@"%@: %@", STATUS_STRING, reqObj.requestStatus]];
                
            }
        }
        
        if(reqObj.requesterType!=nil)
        {
            if([[[[JSONDataFlowManager sharedInstance]requesterKeyValues] allKeysForObject:reqObj.requesterType] count])
            {
                [requestCell.requestorLabel setText:[NSString stringWithFormat:@"%@: %@", REQUESTOR_STRING, [[[[JSONDataFlowManager sharedInstance]requesterKeyValues] allKeysForObject:reqObj.requesterType] objectAtIndex:0]]];
            }
        }
        
        //Set Normal Color Color
        UIView *bgColorNormalView = [[UIView alloc] init];
        //Change background of View Fill Gradient
        CAGradientLayer *gradient1 = [CAGradientLayer layer];
        gradient1.frame = requestCell.bounds;
        gradient1.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0] CGColor], nil];
        [bgColorNormalView.layer insertSublayer:gradient1 atIndex:0];
        [requestCell setBackgroundView:bgColorNormalView];
        
        //Set Selection Color
        UIView *bgColorView = [[UIView alloc] init];
        //Change background of View Fill Gradient
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = requestCell.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:253.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:201.0/255.0 green:235.0/255.0 blue:252.0/255.0 alpha:1.0] CGColor], nil];
        [bgColorView.layer insertSublayer:gradient atIndex:0];
        [requestCell setSelectedBackgroundView:bgColorView];
        
        NSDictionary *item;
        NSString *territoryId = [[NSString alloc] init];
        NSString *string = [[NSString alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(indexPath.row < removeAddressResponseArray.count)
        {
            item = [removeAddressResponseArray objectAtIndex:indexPath.row];
        }
        
        if([item objectForKey:@"requesterTerrId"])
            territoryId =[NSString stringWithFormat:@"%@", [item objectForKey:@"requesterTerrId"]];
        
        if([item objectForKey:@"status"])
            string = [NSString stringWithFormat:@"%@", [item objectForKey:@"status"]] ;
        if ([string rangeOfString:@"Withdrawn"].location != NSNotFound)
        {
            //removeAddressApproveBtn.enabled = NO;
            isApproverTerritory = NO;
        }
        else if (([string rangeOfString:@"Approved"].location != NSNotFound) || ([string rangeOfString:@"Rejected"].location != NSNotFound) || ([string rangeOfString:@"Completed"].location != NSNotFound))
        {
            // NSLog(@"string contains bla!");
            //removeAddressApproveBtn.enabled = NO;
            isApproverTerritory = NO;
        }
        else if([string rangeOfString:@"Pending"].location != NSNotFound)
        {
            if([territoryId isEqualToString:[defaults objectForKey:@"SelectedTerritoryId"]])
            {
                //removeAddressApproveBtn.enabled = NO;
                isApproverTerritory = NO;
            }
            else
            {
                //removeAddressApproveBtn.enabled = YES;
                isApproverTerritory = YES;
            }
        }
        
        /////// Changes: alignedAddressCount not required
//        alignedAddressCount = (long)[alignedAddressArray count];
        //NSLog(@"row:%d: {n(Add):%d},{isAprvr:%d},{removeAd:%d},{peding:%d}",(int)indexPath.row,(numberOfAddress == 1),isApproverTerritory,isAddressRemoval,[reqObj.requestStatus isEqualToString:@"Pending Approval"]);
        if((numberOfAddress == 1)       &&
           (isAddressRemoval)           &&
           (isApproverTerritory)        &&
           [reqObj.requestStatus isEqualToString:@"Pending Approval"] &&
           (indvidualOrganisationSegmentControl.selectedSegmentIndex==0))
        {
            [requestCell.alertButton setHidden:NO];
            [requestCell.alertButton setTag:indexPath.row];
            [requestCell.alertButton addTarget:self action:@selector(clickAlertInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return requestCell;
    }
    else  if(tableView==addressTable)
    {
        static NSString *simpleTableIdentifier = @"AddressList";
        
        RequestAddressCell *requestCell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestCell == nil) {
            requestCell = [[[NSBundle mainBundle] loadNibNamed:@"RequestAddressCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [requestCell.BPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestCell.typeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestCell.nameLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        requestCell.tag=indexPath.row;
        requestCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [requestCell setAccessoryType:UITableViewCellAccessoryNone];
        addressTable.separatorColor=[UIColor clearColor];
        
        
        RequestObject* reqObj=nil;
        if(indvRequestsData!=nil)
        {
            reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
        }
        
        AddressObject* addObj;
        if(reqObj!=nil)
        {
            addObj=[reqObj.customerInfo.custAddress objectAtIndex:indexPath.row];
        }
        
        if(addObj.BPA_ID!=nil)
        {
            [requestCell.BPIDLabel setText:[NSString stringWithFormat:@"%@",addObj.BPA_ID]];
        }
        if(addObj.addr_usage_type!=nil)
        {
            NSString *addressUsageType = [addObj.addr_usage_type stringByReplacingOccurrencesOfString:@"," withString:@", "];
            [requestCell.typeLabel setText:[NSString stringWithFormat:@"%@",addressUsageType]];
        }
        
        NSString * add1Str=@"";
        NSMutableArray *addressLineArray = [[NSMutableArray alloc] init];
        NSMutableArray *addressLineArray2 = [[NSMutableArray alloc] init];
        if(addObj.addressLineOne!=nil && addObj.addressLineOne.length)
        {
            [addressLineArray addObject:addObj.addressLineOne];
            [addressLineArray2 addObject:addObj.addressLineOne];
        }
        if(addObj.addressLineTwo!=nil && addObj.addressLineTwo.length)
        {
            [addressLineArray addObject:addObj.addressLineTwo];
            //[addressLineArray2 addObject:addObj.addressLineTwo];
        }
        if(addObj.city!=nil && addObj.city.length)
        {
            [addressLineArray addObject:addObj.city];
            [addressLineArray2 addObject:addObj.city];
        }
        if(addObj.state!=nil && addObj.state.length)
        {
            [addressLineArray addObject:addObj.state];
            [addressLineArray2 addObject:@"\n"];
            [addressLineArray2 addObject:addObj.state];
        }
        if(addObj.zip!=nil && addObj.zip.length)
        {
            [addressLineArray addObject:addObj.zip];
            [addressLineArray2 addObject:addObj.zip];
        }
        add1Str = [addressLineArray componentsJoinedByString:@", "];
        addressString = [addressLineArray2 componentsJoinedByString:@" "];
        requestCell.nameLabel.text= add1Str;
        
        
        return requestCell;
    }
    else  if(tableView==addressTableRemoveAddress)
    {
        
        static NSString *simpleTableIdentifier = @"AddressList";
        
        RequestAddressCell *requestCell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestCell == nil) {
            requestCell = [[[NSBundle mainBundle] loadNibNamed:@"RequestAddressCell" owner:self options:nil] objectAtIndex:0];
        }
        if(shouldLoadRemoveAddress == YES)
        {
            [requestCell.BPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            [requestCell.typeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            [requestCell.nameLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            
            requestCell.tag=indexPath.row;
            requestCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [requestCell setAccessoryType:UITableViewCellAccessoryNone];
            addressTable.separatorColor=[UIColor clearColor];
            
            
            RequestObject* reqObj=nil;
            if(indvRequestsData!=nil)
            {
                reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
            }
            
            //NSDictionary *item = [[NSDictionary alloc] init];
            NSDictionary *item = [removedAddressArray objectAtIndex:indexPath.row];
            
            AddressObject* addObj;
            if(reqObj!=nil)
            {
                addObj=[reqObj.customerInfo.custAddress objectAtIndex:indexPath.row];
            }
            
            if(addObj.BPA_ID!=nil)
            {
                requestCell.BPIDLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"bpaId"]];
                
            }
            if(addObj.addr_usage_type!=nil)
            {
     
                requestCell.typeLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"addrUsageType"]];
                
            }
            
            NSString * add1Str=@"";
            NSMutableArray *addressLineArray = [[NSMutableArray alloc] init];
            if(addObj.addressLineOne!=nil && addObj.addressLineOne.length)
            {
                [addressLineArray addObject:addObj.addressLineOne];
            }
            if(addObj.addressLineTwo!=nil && addObj.addressLineTwo.length)
            {
                [addressLineArray addObject:addObj.addressLineTwo];
            }
            if(addObj.city!=nil && addObj.city.length)
            {
                [addressLineArray addObject:addObj.city];
            }
            if(addObj.state!=nil && addObj.state.length)
            {
                [addressLineArray addObject:addObj.state];
            }
            if(addObj.zip!=nil && addObj.zip.length)
            {
                [addressLineArray addObject:addObj.zip];
            }
            //add1Str = [addressLineArray componentsJoinedByString:@", "];
            add1Str = [NSString stringWithFormat:@"%@, %@, %@, %@",[item objectForKey:@"addrLine1"], [item objectForKey:@"city"], [item objectForKey:@"state"], [item objectForKey:@"zip"]];
            requestCell.nameLabel.text= add1Str;
        }
        
        return requestCell;
    }
    else  if(tableView==otherAlignedAdressTableView)
    {
        //--- for now same as address table . See what data to display
        static NSString *simpleTableIdentifier = @"AddressList";
        
        RequestAddressCell *requestCell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestCell == nil) {
            requestCell = [[[NSBundle mainBundle] loadNibNamed:@"RequestAddressCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [requestCell.BPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestCell.typeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestCell.nameLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        requestCell.tag=indexPath.row;
        requestCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [requestCell setAccessoryType:UITableViewCellAccessoryNone];
        addressTable.separatorColor=[UIColor clearColor];
        
        //NSDictionary *item = [[NSDictionary alloc] init];
        NSDictionary *item = [alignedAddressArray objectAtIndex:indexPath.row];
        //AddressObject *addObj = [alignedAddressArray objectAtIndex:indexPath.row];
        
        if([item objectForKey:@"bpaId"])
        {
            //[requestCell.BPIDLabel setText:[NSString stringWithFormat:@"%@",addObj.BPA_ID]];
            
            requestCell.BPIDLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"bpaId"]];
            
        }
        if([item objectForKey:@"addrUsageType"])
        {
            //NSString *addressUsageType = [addObj.addr_usage_type stringByReplacingOccurrencesOfString:@"," withString:@", "];
            //[requestCell.typeLabel setText:[NSString stringWithFormat:@"%@",addressUsageType]];
            requestCell.typeLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"addrUsageType"]];
        }
        
        NSString * add1Str=@"";
        
        add1Str = [NSString stringWithFormat:@"%@, %@, %@, %@",[item objectForKey:@"addrLine1"], [item objectForKey:@"city"], [item objectForKey:@"state"], [item objectForKey:@"zip"]];
        requestCell.nameLabel.text= add1Str;
        
        return requestCell;
    }
    else  if(tableView==requestStatusTable)
    {
        static NSString *simpleTableIdentifier = @"RequestStatusCell";
        
        RequestStatusCell *requestStatusCell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestStatusCell == nil) {
            requestStatusCell = [[[NSBundle mainBundle] loadNibNamed:@"RequestStatusCell" owner:self options:nil] objectAtIndex:0];
        }
        [requestStatusCell.requestTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestStatusCell.actionDateLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestStatusCell.statusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        //   [requestStatusCell.resolutionDescription setNumberOfLines:0];
        //   [requestStatusCell.resolutionDescription sizeToFit];
        //   [requestStatusCell.resolutionDescription setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        
        
        requestStatusCell.tag=indexPath.row;
        requestStatusCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [requestStatusCell setAccessoryType:UITableViewCellAccessoryNone];
        requestStatusTable.separatorColor=[UIColor clearColor];
        requestStatusTableRemoveAddress.separatorColor = [UIColor clearColor];
        
        RequestObject* reqObj=nil;
        if(indvRequestsData!=nil)
        {
            reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
        }
        
        RequestStatusHistoryObject* histObj;
        if(reqObj.requestStatusHistory!=nil && reqObj.requestStatusHistory.count>0)
        {
            histObj=[reqObj.requestStatusHistory objectAtIndex:indexPath.row];
        }
        
        ////////Changes: descriptionStr var is not required
//        NSString *descriptionStr;
//        if(descriptionStr != nil)
//            descriptionStr = [NSString stringWithFormat:@"%@",reqObj.resolutionDescription];
        
        if(histObj.requestType!=nil)
        {
            if(tableView == requestStatusTableRemoveAddress)
            {
                [requestStatusCell.requestTypeLabel setText:[NSString stringWithFormat:@"%@",[[[JSONDataFlowManager sharedInstance]withdrawRequestTypeKeyValues] objectForKey:[NSString stringWithFormat:@"%@",histObj.requestType]]]];
            }
            else
            {
                [requestStatusCell.requestTypeLabel setText:[NSString stringWithFormat:@"%@",[[[JSONDataFlowManager sharedInstance]withdrawRequestTypeKeyValues] objectForKey:[NSString stringWithFormat:@"%@",histObj.requestType]]]];
            }
        }
        if(histObj.actionDate!=nil)
        {
            [requestStatusCell.actionDateLabel setText:[NSString stringWithFormat:@"%@",histObj.actionDate]];
          
        }
        if(histObj.status!=nil)
        {
            [requestStatusCell.statusLabel setText:[NSString stringWithFormat:@"%@",histObj.status]];
        }
        if( reqObj.resolutionDescription != nil && indexPath.row==0)
        {
            CGSize maximumLabelSize = CGSizeMake(180, 150);
            CGRect textRect = [reqObj.resolutionDescription boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
            ////            CGRect temp=  requestStatusCell.resolutionDescription.frame;
            UILabel *descriptionLabel = [[UILabel alloc] init];
            descriptionLabel.frame=CGRectMake(445, 11, 180, textRect.size.height+10);
            descriptionLabel.text=reqObj.resolutionDescription;
            descriptionLabel.textColor = requestStatusCell.statusLabel.textColor ;
            descriptionLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:14.0];
            descriptionLabel.numberOfLines=0;
            [descriptionLabel sizeToFit];
            descriptionLabel.backgroundColor=[UIColor clearColor];
            
            [requestStatusCell addSubview:descriptionLabel];
            
            
        }
        
        //Disable withdraw button if request status is from completed status LOVs
        if([[[JSONDataFlowManager sharedInstance]completedRequestStatusArray] containsObject:[reqObj.requestStatus lowercaseString]])
        {
            if(tableView==requestStatusTableRemoveAddress)
            {
                //---[removeAddressWithdrawRequestBtn setEnabled:NO];
                //---[removeAddressApproveBtn setEnabled:NO];
                //---[removeAddressRejectBtn setEnabled:NO];
            }
            else
            {
                [withdrawRequestBtn setEnabled:NO];
            }
        }
        else
        {
            if(tableView==requestStatusTableRemoveAddress)
            {
                //---[removeAddressWithdrawRequestBtn setEnabled:YES];
                //---[removeAddressApproveBtn setEnabled:YES];
                //---[removeAddressRejectBtn setEnabled:YES];
            }
            else
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if([reqObj.reason isEqualToString:@"Deceased"] || [reqObj.reason isEqualToString:@"Retired"] || [reqObj.requestStatus isEqualToString:@"Scheduled - BMS Customer Master Synch"] || [[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
                    [withdrawRequestBtn setEnabled:NO];
                else{
                    [withdrawRequestBtn setEnabled:YES];
                }
                
            }
        }
        
        return requestStatusCell;
        
    }
    else  if(tableView==requestStatusTableRemoveAddress)
    {
        static NSString *simpleTableIdentifier = @"RequestStatusCell";
        
        RemoveAddressRequestStatusCell *requestStatusCell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestStatusCell == nil) {
            requestStatusCell = [[[NSBundle mainBundle] loadNibNamed:@"RemoveAddressRequestStatusCell" owner:self options:nil] objectAtIndex:0];
        }
        if(shouldLoadRemoveAddress == YES)
        {
            [requestStatusCell.addressID setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            
            [requestStatusCell.statusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            
            requestStatusCell.tag=indexPath.row;
            requestStatusCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [requestStatusCell setAccessoryType:UITableViewCellAccessoryNone];
            requestStatusTable.separatorColor=[UIColor clearColor];
            requestStatusTableRemoveAddress.separatorColor = [UIColor redColor];
            
            
            RequestObject* reqObj=nil;
            if(indvRequestsData!=nil)
            {
                reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
                NSMutableArray *dealignBPArray = [reqObj dealignedBPAInfoArray];
                
                DealignBPA *infoObj=[dealignBPArray objectAtIndex:indexPath.row];
                
                
                CGSize maximumLabelSize = CGSizeMake(155, 999);
                NSString *str= [self getAppendedAddressForDealignBPA:indexPath.row];
                CGRect textRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
                for (UILabel *label in [requestStatusCell subviews]) {
                    if (label.tag==200) {
                        [label removeFromSuperview];
                    }
                }
                
                UILabel *addressLabel = [[UILabel alloc] init];
                addressLabel.frame=CGRectMake(151, 4, 145, textRect.size.height+10);
                addressLabel.text=[self getAppendedAddressForDealignBPA:indexPath.row];
                addressLabel.textColor = requestStatusCell.statusLabel.textColor ;
                addressLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:14.0];
                addressLabel.numberOfLines=0;
                addressLabel.tag = 200;
                [addressLabel sizeToFit];
                addressLabel.backgroundColor=[UIColor clearColor];
                
                [requestStatusCell addSubview:addressLabel];
                
                
                
                addressLabel= nil;
                requestStatusCell.addressID.text= infoObj.bpaId;
                
                requestStatusCell.statusLabel.text = infoObj.status;
                requestStatusCell.statusLabel.numberOfLines=3;
                [requestStatusCell.statusLabel sizeToFit];
                
                if (infoObj.ticketId.length>0) {
                    CGSize maximumLabelSize = CGSizeMake(190, 999);
                    NSString *str= infoObj.ticketId;
                    CGRect textRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
                    
                    /////
                    
                    for (UILabel *label in [requestStatusCell subviews]) {
                        if (label.tag==300) {
                            [label removeFromSuperview];
                        }
                    }
                    UILabel *ticketIDLabel = [[UILabel alloc] init];
                    ticketIDLabel.frame=CGRectMake(475, 4, 190, textRect.size.height+10);
                    ticketIDLabel.text=str;
                    ticketIDLabel.textColor = requestStatusCell.statusLabel.textColor ;
                    ticketIDLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:14.0];
                    ticketIDLabel.numberOfLines=0;
                    ticketIDLabel.tag = 300;
                    [ticketIDLabel sizeToFit];
                    ticketIDLabel.backgroundColor=[UIColor clearColor];
                    
                    [requestStatusCell addSubview:ticketIDLabel];
                    
                    /////
                    
                }
                
            }
            
            //Disable withdraw button if request status is from completed status LOVs
            if([[[JSONDataFlowManager sharedInstance]completedRequestStatusArray] containsObject:[reqObj.requestStatus lowercaseString]])
            {
                if(tableView==requestStatusTableRemoveAddress){
                    
                }
                else{
                    //[withdrawRequestBtn setEnabled:NO];
                }
            }
            else
            {
                if(tableView==requestStatusTableRemoveAddress)
                {
                    //---[removeAddressWithdrawRequestBtn setEnabled:YES];
                    //---[removeAddressApproveBtn setEnabled:YES];
                    //---[removeAddressRejectBtn setEnabled:YES];
                }
                else
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if([reqObj.reason isEqualToString:@"Deceased"] || [reqObj.reason isEqualToString:@"Retired"] || [[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
                        [withdrawRequestBtn setEnabled:NO];
                    else
                        [withdrawRequestBtn setEnabled:YES];
                }
            }
        }
        return requestStatusCell;
    }
    else  if(tableView==addressTableOrg)
    {
        static NSString *simpleTableIdentifier = @"AddressListOrg";
        
        RequestAddressCell *requestAddressCellOrg=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestAddressCellOrg == nil) {
            requestAddressCellOrg = [[[NSBundle mainBundle] loadNibNamed:@"RequestAddressCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [requestAddressCellOrg.BPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestAddressCellOrg.nameLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestAddressCellOrg.typeLabel setHidden:YES];
        CGRect frame=requestAddressCellOrg.nameLabel.frame;
        frame.origin.x=requestAddressCellOrg.typeLabel.frame.origin.x;
        frame.size.width=requestAddressCellOrg.nameLabel.frame.size.width+requestAddressCellOrg.typeLabel.frame.size.width;
        
        [requestAddressCellOrg.nameLabel setFrame:frame];
        
        requestAddressCellOrg.tag=indexPath.row;
        requestAddressCellOrg.selectionStyle = UITableViewCellSelectionStyleNone;
        [requestAddressCellOrg setAccessoryType:UITableViewCellAccessoryNone];
        addressTableOrg.separatorColor=[UIColor clearColor];
        
        RequestObject* reqObj=nil;
        if(orgRequestsData!=nil)
        {
            reqObj=[orgRequestsData objectAtIndex:selectedRequestListIndex];
        }
        
        AddressObject* addObj;
        if(reqObj!=nil)
        {
            addObj=[reqObj.organizationInfo.orgAddress objectAtIndex:indexPath.row];
        }
        if(addObj.BPA_ID!=nil)
        {
            [requestAddressCellOrg.BPIDLabel setText:[NSString stringWithFormat:@"%@",addObj.BPA_ID]];
        }
        NSString * add1Str=@"";
        NSMutableArray *addressLineArray = [[NSMutableArray alloc] init];
        if(addObj.addressLineOne!=nil && addObj.addressLineOne.length)
        {
            [addressLineArray addObject:addObj.addressLineOne];
        }
        if(addObj.addressLineTwo!=nil && addObj.addressLineTwo.length)
        {
            [addressLineArray addObject:addObj.addressLineTwo];
        }
        if(addObj.city!=nil && addObj.city.length)
        {
            [addressLineArray addObject:addObj.city];
        }
        if(addObj.state!=nil && addObj.state.length)
        {
            [addressLineArray addObject:addObj.state];
        }
        if(addObj.zip!=nil && addObj.zip.length)
        {
            [addressLineArray addObject:addObj.zip];
        }
        add1Str = [addressLineArray componentsJoinedByString:@", "];
        requestAddressCellOrg.nameLabel.text= add1Str;
        return requestAddressCellOrg;
        
    }
    else  if(tableView==requestStatusTableOrg)
    {
        static NSString *simpleTableIdentifier = @"RequestAddressCellOrg";
        
        RequestStatusCell *requestStatusOrg=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (requestStatusOrg == nil) {
            requestStatusOrg = [[[NSBundle mainBundle] loadNibNamed:@"RequestStatusCell" owner:self options:nil] objectAtIndex:0];
        }
        [requestStatusOrg.requestTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestStatusOrg.actionDateLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [requestStatusOrg.statusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        requestStatusOrg.tag=indexPath.row;
        requestStatusOrg.selectionStyle = UITableViewCellSelectionStyleNone;
        [requestStatusOrg setAccessoryType:UITableViewCellAccessoryNone];
        [requestStatusTableOrg setSeparatorColor:[UIColor clearColor]];
        
        RequestObject* reqObj=nil;
        if(orgRequestsData!=nil)
        {
            reqObj=[orgRequestsData objectAtIndex:selectedRequestListIndex];
        }
        
        RequestStatusHistoryObject* histObj;
        if(reqObj.requestStatusHistory!=nil && reqObj.requestStatusHistory.count>0)
        {
            histObj=[reqObj.requestStatusHistory objectAtIndex:indexPath.row];
        }
        if(histObj.requestType!=nil)
        {
            [requestStatusOrg.requestTypeLabel setText:[NSString stringWithFormat:@"%@",[[[JSONDataFlowManager sharedInstance]withdrawRequestTypeKeyValues] objectForKey:[NSString stringWithFormat:@"%@",histObj.requestType]]]];
        }
        if(histObj.actionDate!=nil)
        {
            [requestStatusOrg.actionDateLabel setText:[NSString stringWithFormat:@"%@",histObj.actionDate]];
        }
        if(histObj.status!=nil)
        {
            [requestStatusOrg.statusLabel setText:[NSString stringWithFormat:@"%@",histObj.status]];
        }
        
        //Disable withdraw button if request status is from completed status LOVs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[[JSONDataFlowManager sharedInstance]completedRequestStatusArray] containsObject:[reqObj.requestStatus lowercaseString]] ||[[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
        {
            [withdrawRequestBtnOrg setEnabled:NO];
        }
        else
        {
            [withdrawRequestBtnOrg setEnabled:YES];
        }
        return requestStatusOrg;
    }
    
    
    return nil;
}

#pragma mark-

#pragma Get appended Address for Dealign BPA

-(NSString*)getAppendedAddressForDealignBPA:(NSInteger)index
{
    RequestObject* reqObj=nil;
    if(indvRequestsData!=nil)
    {
        reqObj=[indvRequestsData objectAtIndex:selectedRequestListIndex];
    }
    DealignBPA *obj= [reqObj.dealignedBPAInfoArray objectAtIndex:index];
    NSString *finalAddress, *addLine1, *state, *city, *zip;
    
    if (![obj.addressLine1 isEqualToString:@"(null)"]) {
        addLine1=obj.addressLine1;
    }
    if (![obj.addressState isEqualToString:@"(null)"]) {
        state=obj.addressState;
    }
    if (![obj.addressCity isEqualToString:@"(null)"]) {
        city=obj.addressCity;
    }
    if (![obj.addressZip isEqualToString:@"(null)"]) {
        zip=obj.addressZip;
    }
    finalAddress = [NSString stringWithFormat:@"%@, %@, %@, %@",addLine1, state, city, zip];
    return finalAddress;
    
}
#pragma mark -

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==requestListTable)
    {
        //Clear previous success/error message
        RequestInfoCell * cell = (RequestInfoCell*) [tableView cellForRowAtIndexPath:indexPath];
        requestIndex = (int)indexPath.row;
        
        if ([cell.requestTypeLabel.text isEqualToString:@"Remove address"] )
        {
            shouldLoadRemoveAddress = YES;
            //process for remove address
        }
        else
        {
            shouldLoadRemoveAddress = NO;
            
        }
        [self updateServerResponseLabelWithText:@"" forIdentifier:nil successOrFailure:YES];
        [self refreshRequestDetailsOfIndex:indexPath.row];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchParameterTable)
    {
        return 19.0;
    }
    else if(tableView==requestListTable)
    {
        return 60.0f;
    }
    else if (tableView==requestStatusTable)
    {
        if(descriptionString != nil)
        {
        return 65;
        }
        else
            return 55;
    }
    else if (tableView == requestStatusTableRemoveAddress)
    {
        NSString *str= [self getAppendedAddressForDealignBPA:indexPath.row];
        if (str.length>0) {
            return 80;
        }
        else
        {
            return 44;
        }
    }
    else
    {
        return 44.0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==addressTable || tableView==addressTableRemoveAddress || tableView==addressTableOrg || tableView==requestStatusTable || tableView==requestStatusTableRemoveAddress || tableView==requestStatusTableOrg|| tableView==otherAlignedAdressTableView)
    {
        return 44;
    }
    else
    {
        return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 665, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    if(tableView==addressTable || tableView==addressTableRemoveAddress)
    {
        
        //Add BPAID
        UILabel *bpaIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, headerView.frame.size.height-10)];
        [bpaIdLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [bpaIdLabel setTextColor:[UIColor grayColor]];
        [bpaIdLabel setText:[NSString stringWithFormat:BPAID_KEY]];
        [bpaIdLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:bpaIdLabel];
        
        //Add address Type
        UILabel *addressTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 120, headerView.frame.size.height-10)];
        [addressTypeLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [addressTypeLabel setTextColor:[UIColor grayColor]];
        [addressTypeLabel setText:[NSString stringWithFormat:@"%@", ADDRESS_TYPE_STRING]];
        [addressTypeLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:addressTypeLabel];
        
        //Add address Name
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(290, 5, 335, headerView.frame.size.height-10)];
        [addressLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [addressLabel setTextColor:[UIColor grayColor]];
        [addressLabel setText:[NSString stringWithFormat:ADDRESS_STRING]];
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:addressLabel];
    }
    if(tableView==otherAlignedAdressTableView)
    {
        //---for now same as address table, change for correct data
        
        //Add BPAID
        UILabel *bpaIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, headerView.frame.size.height-10)];
        [bpaIdLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [bpaIdLabel setTextColor:[UIColor grayColor]];
        [bpaIdLabel setText:[NSString stringWithFormat:BPAID_KEY]];
        [bpaIdLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:bpaIdLabel];
        
        //Add address Type
        UILabel *addressTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 120, headerView.frame.size.height-10)];
        [addressTypeLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [addressTypeLabel setTextColor:[UIColor grayColor]];
        [addressTypeLabel setText:[NSString stringWithFormat:@"%@", ADDRESS_TYPE_STRING]];
        [addressTypeLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:addressTypeLabel];
        
        //Add address Name
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(290, 5, 335, headerView.frame.size.height-10)];
        [addressLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [addressLabel setTextColor:[UIColor grayColor]];
        [addressLabel setText:[NSString stringWithFormat:ADDRESS_STRING]];
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:addressLabel];
    }
    else if (tableView==addressTableOrg)
    {
        //Add BPAID
        UILabel *bpaIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, headerView.frame.size.height-10)];
        [bpaIdLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [bpaIdLabel setTextColor:[UIColor grayColor]];
        [bpaIdLabel setText:[NSString stringWithFormat:BPAID_KEY]];
        [bpaIdLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:bpaIdLabel];
        
        //Add address Name
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 455, headerView.frame.size.height-10)];
        [addressLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [addressLabel setTextColor:[UIColor grayColor]];
        [addressLabel setText:[NSString stringWithFormat:ADDRESS_STRING]];
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:addressLabel];
        
    }
    else if (tableView==requestStatusTable || tableView==requestStatusTableOrg)
    {
        UILabel *reqTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,5, 130, headerView.frame.size.height-10)];
        [reqTypeLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [reqTypeLabel setTextColor:[UIColor grayColor]];
        [reqTypeLabel setText:REQUEST_TYPE_KEY];
        [reqTypeLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:reqTypeLabel];
        
        //Add action date
        UILabel *actionDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(143,5, 160, headerView.frame.size.height-10)];
        [actionDateLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [actionDateLabel setTextColor:[UIColor grayColor]];
        [actionDateLabel setText:ACTION_DATE_STRING];
        [actionDateLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:actionDateLabel];
        
        //Add status
        UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(310, 5, 180, headerView.frame.size.height-10)];
        [statusLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [statusLabel setTextColor:[UIColor grayColor]];
        [statusLabel setText:REQ_STATUS_KEY];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:statusLabel];
        
        RequestObject *reqObject;
        if(selectedRequestListIndex < indvRequestsData.count)
            reqObject = [indvRequestsData objectAtIndex:selectedRequestListIndex];
        if(tableView==requestStatusTable && reqObject.resolutionDescription != nil){
            //Add resolution description
            UILabel *resolutionDescription=[[UILabel alloc]initWithFrame:CGRectMake(445, 5, 160, headerView.frame.size.height-10)];
            [resolutionDescription setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
            [resolutionDescription setTextColor:[UIColor grayColor]];
            [resolutionDescription setText:RESOLUTION_DESC_KEY];
            [resolutionDescription setBackgroundColor:[UIColor clearColor]];
            [headerView addSubview:resolutionDescription];
        }
    }
    else if (tableView==requestStatusTableRemoveAddress)
    {
        UILabel *reqTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,5, 130, headerView.frame.size.height-10)];
        [reqTypeLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [reqTypeLabel setTextColor:[UIColor grayColor]];
        //[reqTypeLabel setText:APPROVER_NAME_KEY];
        [reqTypeLabel setText:MASTER_ADDRESS_ID_STRING];
        [reqTypeLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:reqTypeLabel];
        
        //Add action date
        UILabel *actionDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(170,5, 120, headerView.frame.size.height-10)];
        [actionDateLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [actionDateLabel setTextColor:[UIColor grayColor]];
        //[actionDateLabel setText:ACTION_DATE_KEY];
        [actionDateLabel setText:ADDRESS_STRING];
        [actionDateLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:actionDateLabel];
        
        //Add status
        UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(320, 5, 100, headerView.frame.size.height-10)];
        [statusLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [statusLabel setTextColor:[UIColor grayColor]];
        //[statusLabel setText:APPROVAL_STATUS_KEY];
        [statusLabel setText:STATUS_STRING];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:statusLabel];
        
        UILabel *territoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(480, 5, 280, headerView.frame.size.height-10)];
        [territoryLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [territoryLabel setTextColor:[UIColor grayColor]];
        //[territoryLabel setText:TERRITTORY];
        [territoryLabel setText:REQUEST_TICKET_ID_STRING];
        [territoryLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:territoryLabel];
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView==addressTable || tableView==addressTableOrg || tableView==addressTableRemoveAddress)
    {
        RequestObject *reqObj=nil;
        NSInteger numberOfAddress = 0;
        
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
        {
            if(indvRequestsData.count==0)
                return 0;
            
            reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
            if(reqObj)
            {
                numberOfAddress = reqObj.customerInfo.custAddress.count;
            }
        }
        else
        {
            if(orgRequestsData.count==0)
                return 0;
            
            reqObj = [orgRequestsData objectAtIndex:selectedRequestListIndex];
            if(reqObj)
            {
                numberOfAddress = reqObj.organizationInfo.orgAddress.count;
            }
        }
        
        if(reqObj)
        {
            //Show footer only if
            //Request Type = "Remove customer"
            //Request status = "Completed"
            //No addresses
            if([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove customer"] && [[reqObj.requestStatus lowercaseString] isEqualToString:@"completed"] && numberOfAddress==0)
            {
                CGRect labelFrame = tableView.frame;
                labelFrame.size.height -= 44;
                
                return labelFrame.size.height;
            }
        }
    }
    else     if(tableView==otherAlignedAdressTableView)
    {
        RequestObject *reqObj=nil;
        NSInteger numberOfAddress = 0;
        
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
        {
            if(indvRequestsData.count==0)
                return 0;
            
            reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
            if(reqObj)
            {
                numberOfAddress = reqObj.customerInfo.custAddress.count;
            }
        }
        else
        {
            if(orgRequestsData.count==0)
                return 0;
            
            reqObj = [orgRequestsData objectAtIndex:selectedRequestListIndex];
            if(reqObj)
            {
                numberOfAddress = reqObj.organizationInfo.orgAddress.count;
            }
        }
        
        if(reqObj)
        {
            //Show footer only if
            //Request Type = "Remove customer"
            //Request status = "Completed"
            //No addresses
            if([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove customer"] && [[reqObj.requestStatus lowercaseString] isEqualToString:@"completed"] && numberOfAddress==0)
            {
                CGRect labelFrame = tableView.frame;
                labelFrame.size.height -= 44;
                
                return labelFrame.size.height;
            }
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(tableView.frame)-44)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    if(tableView==addressTable || tableView==addressTableOrg || tableView==addressTableRemoveAddress)
    {
        UILabel *noAddressesAvailable = [[UILabel alloc] initWithFrame:footerView.frame];
        [noAddressesAvailable setText:ALL_ALIGNED_ADDRESSES_HAVE_BEEN_REMOVED_STRING];
        [noAddressesAvailable setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [noAddressesAvailable setTextAlignment:NSTextAlignmentCenter];
        [noAddressesAvailable setTextColor:[UIColor lightGrayColor]];
        [noAddressesAvailable setBackgroundColor:[UIColor clearColor]];
        
        [footerView addSubview:noAddressesAvailable];
    }
    else if(tableView==otherAlignedAdressTableView)
    {
        UILabel *noAddressesAvailable = [[UILabel alloc] initWithFrame:footerView.frame];
        [noAddressesAvailable setText:ALL_ALIGNED_ADDRESSES_HAVE_BEEN_REMOVED_STRING];
        [noAddressesAvailable setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [noAddressesAvailable setTextAlignment:NSTextAlignmentCenter];
        [noAddressesAvailable setTextColor:[UIColor lightGrayColor]];
        [noAddressesAvailable setBackgroundColor:[UIColor clearColor]];
        
        [footerView addSubview:noAddressesAvailable];
    }
    
    return footerView;
}
#pragma mark -

#pragma mark List View Custom Delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    [listPopOverController dismissPopoverAnimated:NO];
    [listPopOverController dismissPopoverAnimated:NO];
    listPopOverController = nil;
    
    if([listType isEqualToString:CHANGE_TERRITORY])
    {
        //Reset state of change territory button
        [changeTerritoryBtn setSelected:NO];
        
        BOOL isTerritoryChanged = [Utilities changeSelectedTerritoryTo:value];
        if(isTerritoryChanged)
        {
            //Close all connections
            isConnectionInProgress = FALSE;
            [Utilities removeSpinnerFromView:self.view];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate resetAppForTerritoryChange];
        }
    }
}
#pragma mark - Withdraw Approve Reject

-(void)makeWithdrawOrApproveOrrejectRequest
{
    
    NSString *addressRemovalStatusType = [[NSString alloc] init];
    if([addressRemovalRequestType isEqualToString:REQUEST_TYPE_WITHDRAW])
    {
        addressRemovalStatusType = @"withdrawn";
    }
    else if([addressRemovalRequestType isEqualToString:REQUEST_TYPE_APPROVE])
    {
        addressRemovalStatusType = @"approved";
    }
    else if ([addressRemovalRequestType isEqualToString:REQUEST_TYPE_REJECT])
    {
        addressRemovalStatusType = @"rejected";
    }
    
    // Implement backend call for withdraw, approve and reject request
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
    
    //Set connectionInProgress flag
    isConnectionInProgress = TRUE;
    
    //Add spinner on view
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:@"POST" forKey:@"request_type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * postBody=nil;
    
    
    postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\", \"requestId\":\"%@\", \"territoryId\":\"%@\", \"status\":\"%@\", \"bpId\":\"%@\",\"bpaId\":\"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"], removalTicketNumber, [defaults objectForKey:@"SelectedTerritoryId"], addressRemovalStatusType, removalBPID, removalBPAID];
    [parameters setObject:postBody forKey:@"post_body"];
    
    ConnectionClass * connection= [ConnectionClass sharedSingleton];
    noAlignedAddressMessage.hidden = YES;
    noRemovalAddressMessage.hidden = YES;
    
    //Protocol : changeAddressRemovalStatus
    [connection fetchDataFromUrl:[REMOVE_ADDRESS_REQUEST_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"RemovalRequestType" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
     {
         //CallBack Block
         if(!error)
         {
             [self receiveDataFromServer:data ofCallIdentifier:identifier];
             [Utilities removeSpinnerFromView:self.view];
         }
         else
         {
             [self failWithError:error ofCallIdentifier:identifier];
             [Utilities removeSpinnerFromView:self.view];
         }
     }];
    
    latestConnectionIdentifier = @"RemovalRequestType";
    
}

#pragma mark - Align New Address Delegate

-(void)clickAddToTerritory:(NSInteger)index
{
    //Web Service Call for Align
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    //Set connectionInProgress flag
    isConnectionInProgress = TRUE;
    
    NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:@"POST" forKey:@"request_type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * postBody=nil;
    
    selectedAddressIndex = index;
    //searchedCustDataFromServer possess only one object i.e. CustomerObject
    CustomerObject * custObj=[searchedCustDataFromServer objectAtIndex:0];
    AddressObject * addObj=[custObj.custAddress objectAtIndex:index];
    
    if([addObj BPA_ID] != nil && [custObj custBPID] != nil && [custObj custType] != nil)
    {
        postBody = [NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"bpTypeCd\":\"INDV\",\"bpClasfnCd\":\"%@\",\"bpaId\": \"%@\",\"bpId\": \"%@\",\"territoryId\": \"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],custObj.custType,addObj.BPA_ID,custObj.custBPID,[defaults objectForKey:@"SelectedTerritoryId"]];
        
        [parameters setObject:postBody forKey:@"post_body"];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        //Protocol : alignToTerritory
        [connection fetchDataFromUrl:[ALIGN_TO_TERRITORY_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AlignNewAddressToTerritory" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
         {
             //CallBack block
             if(!error)
             {
                 [self receiveDataFromServer:data ofCallIdentifier:identifier];
                 [Utilities removeSpinnerFromView:self.alignmentViewController.view];
             }
             else
             {
                 [self failWithError:error ofCallIdentifier:identifier];
                 [Utilities removeSpinnerFromView:self.alignmentViewController.view];
             }
         }];
    }
    //[Utilities removeSpinnerFromView:self.view];
}

-(void) alignAndApproveAddress
{
    //if(isApproverTerritory)
    //{
    addressRemovalRequestType = REQUEST_TYPE_APPROVE;
    if(removalBPID != nil && removalBPAID != nil){
        [self makeWithdrawOrApproveOrrejectRequest];
    }
    //}
}

#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0 && [alertView.title isEqualToString:@"Withdraw"]) // Yes
    {
        RequestObject *reqObj=nil;
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
        {
            reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
        }
        
        if(shouldLoadRemoveAddress)
        {
            addressRemovalRequestType = REQUEST_TYPE_WITHDRAW;
            [self makeWithdrawOrApproveOrrejectRequest];
        }
        else if((reqObj != nil) && [reqObj.requestType isEqualToString:@"3"])
        {
            //Clear server response label
            [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
            
            //Set connectionInProgress flag
            isConnectionInProgress = TRUE;
            
            //Add spinner on view
            [Utilities addSpinnerOnView:self.view withMessage:nil];
            
            NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
            [parameters setObject:@"POST" forKey:@"request_type"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * postBody=nil;
            
            RequestObject *reqObj=nil;
            if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
            {
                reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
                postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\", \"ticketNo\":\"%@\", \"requestTypeId\":\"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"], reqObj.ticketNo, reqObj.requestType];
                [parameters setObject:postBody forKey:@"post_body"];
                
                
                ConnectionClass * connection= [ConnectionClass sharedSingleton];
                noAlignedAddressMessage.hidden = YES;
                noRemovalAddressMessage.hidden = YES;
                //Protocol : withdrawAlignmentReq
                [connection fetchDataFromUrl:[WITHDRAW_ALIGNMENT_REQUEST_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"WithdrawAlignmentRequest" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
                 {
                     //CallBack Block
                     if(!error)
                     {
                         [self receiveDataFromServer:data ofCallIdentifier:identifier];
                     }
                     else
                     {
                         [self failWithError:error ofCallIdentifier:identifier];
                     }
                 }];
            }
            latestConnectionIdentifier = @"WithdrawAlignmentRequest";
        }
        else
        {
            //Clear server response label
            [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
            
            //Set connectionInProgress flag
            isConnectionInProgress = TRUE;
            
            //Add spinner on view
            [Utilities addSpinnerOnView:self.view withMessage:nil];
            
            NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
            [parameters setObject:@"POST" forKey:@"request_type"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * postBody=nil;
            
            RequestObject *reqObj=nil;
            if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
            {
                reqObj = [indvRequestsData objectAtIndex:selectedRequestListIndex];
            }
            else    //Organization
            {
                reqObj = [orgRequestsData objectAtIndex:selectedRequestListIndex];
            }
            
            postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\", \"ticketNo\":\"%@\", \"requestTypeId\":\"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"], reqObj.ticketNo, reqObj.requestType];
            [parameters setObject:postBody forKey:@"post_body"];
            
            ConnectionClass * connection= [ConnectionClass sharedSingleton];
            noAlignedAddressMessage.hidden = YES;
            noRemovalAddressMessage.hidden = YES;
            //Protocol : withdrawRequest
            [connection fetchDataFromUrl:[WITHDRAW_REQUEST_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"WithdrawRequest" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
             {
                 //CallBack Block
                 if(!error)
                 {
                     [self receiveDataFromServer:data ofCallIdentifier:identifier];
                 }
                 else
                 {
                     [self failWithError:error ofCallIdentifier:identifier];
                 }
             }];
            
            latestConnectionIdentifier = @"WithdrawRequest";
        }
    }
    else if((buttonIndex==0 && [alertView.message isEqualToString:APPROVE_REQUEST_ALERT_MSG_STRING]) || (buttonIndex==0 && [alertView.message isEqualToString:HCP_ALERT_MSG_STRING]) ) // Yes
    {
        if(shouldLoadRemoveAddress)
        {
            addressRemovalRequestType = REQUEST_TYPE_APPROVE;
            [self makeWithdrawOrApproveOrrejectRequest];
        }
        //implement the backend call for approve similar to the top code for withdraw
    }
    else if(buttonIndex==0 && [alertView.message isEqualToString:REJECT_REQUEST_ALERT_MSG_STRING]) // Yes
    {
        if(shouldLoadRemoveAddress)
        {
            addressRemovalRequestType = REQUEST_TYPE_REJECT;
            [self makeWithdrawOrApproveOrrejectRequest];
        }
        //implement the backend call for reject similar to the top code for withdraw
    }
    else if(buttonIndex==0 && [alertView.message isEqualToString:WITHDRAW_ADDRESS_REQUEST_ALERT_MSG_STRING]) // Yes
    {
        if(shouldLoadRemoveAddress)
        {
            addressRemovalRequestType = REQUEST_TYPE_WITHDRAW;
            [self makeWithdrawOrApproveOrrejectRequest];
        }
        //implement the backend call for reject similar to the top code for withdraw
    }
    else if(buttonIndex==1 && [alertView.message isEqualToString:HCP_ALERT_MSG_STRING] && (alignedAddressArray.count == 0)) // Yes
    {
        if(shouldLoadRemoveAddress)
        {
            addressRemovalRequestType = ALIGN_NEW_ADDRESS;
            [self searchOtherAddressesForAlignment];
        }
    }
}
#pragma mark -

#pragma mark Popover Controller Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [changeTerritoryBtn setSelected:NO];
}
#pragma mark -

#pragma mark View Handlers
-(void)refreshRequestDetailsOfIndex:(NSInteger)index
{
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    
    selectedRequestListIndex = (int)index;
    
    //Clear pervious request details
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        //Individual
        if(shouldLoadRemoveAddress)
        {
            removeAddressnameText.text =@"";
            removeAddressPrimarySpecialtyText.text = @"";
            removeAddresssecondarySpecialtyText.text = @"";
            reomveAddressBPIDText.text = @"";
            removeAddressNPIText.text = @"";
            
            removeAddressCustTypeText.text = @"";
            removeAddressProfessionalText.text = @"";
            removeAddressTicketNOLbl.text = @"";
            removeAddressReasonTextLabel.text = @"";
            
            removeAddressRequestorText.text = @"";
            removeAddressReqDateText.text = @"";
            removeAddressReqTerText.text = @"";
            removeAddressRemReasonText.text = @"";
            requestStatusText.text = @"";
            
            removeAddressCustTypeText.hidden = TRUE;
            removeAddressCustTypeLabel.hidden = TRUE;
            
            [removeAddressReasonLabel setHidden:YES];
            [RemoveAddressReasonMoreInfoView setHidden:YES];
            
        }
        else
        {
            nameText.text = @"";
            primarySpecialtyText.text = @"";
            secondarySpecialtyText.text = @"";
            BPIDText.text = @"";
            NPIText.text = @"";
            
            CustTypeText.text = @"";
            professionalText.text = @"";
            ticketNOLbl.text = @"";
            reasonTextLabel.text=@"";
            
            //Hide Individual Type label as login rules are aplicable for it
            CustTypeText.hidden=TRUE;
            CustTypeLabel.hidden=TRUE;
            
            //Show reason label only if reason received in response
            [reasonLabel setHidden:YES];
            [reasonMoreInfoView setHidden:YES];
        }
    }
    else
    {
        //Org
        organizationTypeText.text = @"";
        orgNameText.text = @"";
        orgBPIDText.text = @"";
        orgValidationStatusText.text = @"";
        subClassificationText.text = @"";
        
        ticketNOLblOrg.text = @"";
        reasonTextLabelOrg.text=@"";
        
        //Show reason label only if reason received in response
        [reasonLabelOrg setHidden:YES];
        [reasonMoreInfoViewOrg setHidden:YES];
    }
    
    //Return if index is out of bounds
    //Index=-1 is used to clear previous data
    if(index<0)
    {
        selectedRequestListIndex = -1;
        return;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    RequestInfoCell * cell = (RequestInfoCell*) [requestListTable cellForRowAtIndexPath:path];
    if ([cell.requestTypeLabel.text isEqualToString:@"Remove address"] )
    {
        shouldLoadRemoveAddress = YES;
    }
    else
    {
        shouldLoadRemoveAddress = NO;
    }
    
    selectedRequestListIndex=index;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        RequestObject *reqObj=[[RequestObject alloc] init];
        reqObj= [indvRequestsData objectAtIndex:index];
        if(reqObj.resolutionDescription != nil)
            descriptionString = [NSString stringWithFormat:@"%@",reqObj.resolutionDescription];
        
        CustomerObject* selectedCustObject=reqObj.customerInfo;
//        CGFloat reasonLabelYPosition=0.0;
        
        //Showing ticketId popup
        //Check if ticketId is nil, then show ticketNo in the label, else show both, ticketId in the label and ticketNo in the popup
        if(reqObj.ticketId != nil)
        {
            self.moreInfoTicketId.hidden = NO;
            self.remAddressTicketId.hidden = NO;
            moreInfoTicketIdAns = [NSString stringWithFormat:@"%@",reqObj.ticketNo];
            
        }
        else
        {
            self.remAddressTicketId.hidden = YES;
            self.moreInfoTicketId.hidden = YES;
        }
        //Hide Cust Type When User is no Sales
        if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
        {
            if(shouldLoadRemoveAddress)
            {
                //removeAddressCustTypeText.hidden = FALSE;
                //removeAddressCustTypeLabel.hidden = FALSE;
            }
            else
            {
                CustTypeText.hidden=true;
                CustTypeLabel.hidden=true;
            }
//            reasonLabelYPosition = requestDetailsOriginalYPos;
        }
        else
        {
            if(shouldLoadRemoveAddress)
            {
                removeAddressCustTypeText.hidden = TRUE;
                removeAddressCustTypeLabel.hidden = TRUE;
//                reasonLabelYPosition = CGRectGetMinY(removeAddressCustTypeLabel.frame);
            }
            else
            {
                CustTypeText.hidden=TRUE;
                CustTypeLabel.hidden=TRUE;
//                reasonLabelYPosition = CGRectGetMinY(CustTypeLabel.frame);
            }
            
        }
        
        //Adjust frame of reasonLabel, reasonTextLabel, reasonMoreInfoView
        //If Cust Type is hidden then move request details up
        //        CGRect requestDetailsLabelFame;
        //        CGRect requestDetailsTextFame;
        //        CGRect reasonMoreInfoViewFrame;
        
        if(shouldLoadRemoveAddress)
        {
            //            requestDetailsLabelFame = removeAddressReasonLabel.frame;
            //            requestDetailsLabelFame.origin.y = reasonLabelYPosition;
            //            removeAddressReasonLabel.frame = requestDetailsLabelFame;
            //
            //            requestDetailsTextFame = removeAddressReasonTextLabel.frame;
            //            requestDetailsTextFame.origin.y = reasonLabelYPosition;
            //            removeAddressReasonTextLabel.frame = requestDetailsTextFame;
            //
            //            reasonMoreInfoViewFrame = RemoveAddressReasonMoreInfoView.frame;
            //            reasonMoreInfoViewFrame.origin.y = reasonLabelYPosition;
            //            RemoveAddressReasonMoreInfoView.frame = reasonMoreInfoViewFrame;
        }
        else
        {
            //            requestDetailsLabelFame = reasonLabel.frame;
            //            requestDetailsLabelFame.origin.y = reasonLabelYPosition;
            //            reasonLabel.frame = requestDetailsLabelFame;
            //
            //            requestDetailsTextFame = reasonTextLabel.frame;
            //            requestDetailsTextFame.origin.y = reasonLabelYPosition;
            //            reasonTextLabel.frame = requestDetailsTextFame;
            //
            //            reasonMoreInfoViewFrame = reasonMoreInfoView.frame;
            //            reasonMoreInfoViewFrame.origin.y = reasonLabelYPosition;
            //            reasonMoreInfoView.frame = reasonMoreInfoViewFrame;
        }
        
        //Set Customer Details
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        
        if(selectedCustObject.custTitle!=nil && selectedCustObject.custTitle.length)
        {
            [nameArray addObject:[NSString stringWithFormat:@"%@.", selectedCustObject.custTitle]];
        }
        if(selectedCustObject.custFirstName!=nil && selectedCustObject.custFirstName.length)
        {
            [nameArray addObject:selectedCustObject.custFirstName];
        }
        if(selectedCustObject.custMiddleName!=nil && selectedCustObject.custMiddleName.length)
        {
            [nameArray addObject:selectedCustObject.custMiddleName];
        }
        if(selectedCustObject.custLastName!=nil && selectedCustObject.custLastName.length)
        {
            [nameArray addObject:selectedCustObject.custLastName];
        }
        if(selectedCustObject.custSuffix!=nil && selectedCustObject.custSuffix.length)
        {
            [nameArray addObject:selectedCustObject.custSuffix];
        }
        //Name
        if([nameArray count])
        {
            if(shouldLoadRemoveAddress)
            {
                removeAddressnameText.text = [nameArray componentsJoinedByString:@" "];
            }
            else
            {
                nameText.text=[nameArray componentsJoinedByString:@" "];
            }
            nameString = [nameArray componentsJoinedByString:@" "];
            
        }
        else
        {
            if(shouldLoadRemoveAddress)
            {
                removeAddressnameText.text = nil;
            }
            else
            {
                nameText.text = nil;
            }
            //assign name here..
            
        }
        
        NSMutableArray *primarySpeciltyArray = [[NSMutableArray alloc] init];
        if(selectedCustObject.custPrimarySpecialtyCode!=nil && [[selectedCustObject.custPrimarySpecialtyCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
        {
            [primarySpeciltyArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custPrimarySpecialtyCode]];
        }
        
        if(selectedCustObject.custPrimarySpecialty!=nil && [[selectedCustObject.custPrimarySpecialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
        {
            [primarySpeciltyArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custPrimarySpecialty]];
        }
        if(shouldLoadRemoveAddress)
        {
            removeAddressPrimarySpecialtyText.text = [primarySpeciltyArray componentsJoinedByString:@" - "];
            removeAddressProfessionalLabel.hidden = NO;
            //            NSString *autoApproveDate = @"2014-10-20";
            //            removeAddressProfessionalLabel.text = [NSString stringWithFormat:@"If not rejected the request wil be automatically approved on %@, and the address will be removed from your territory.", autoApproveDate];
            noAlignedAddressMessage.text = NO_ALIGNED_REMOVAL_ADDRESS_MSG;
            noAlignedAddressMessage.textColor = [UIColor redColor];
            noRemovalAddressMessage.text = NO_REMOVAL_ADDRESS_MSG;
            noRemovalAddressMessage.textColor = [UIColor redColor];
        }
        else
        {
            primarySpecialtyText.text = [primarySpeciltyArray componentsJoinedByString:@" - "];
        }
        NSMutableArray *secondarySpeciltyArray = [[NSMutableArray alloc] init];
        if(selectedCustObject.custSecondarySpecialtyCode!=nil && [[selectedCustObject.custSecondarySpecialtyCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
        {
            [secondarySpeciltyArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custSecondarySpecialtyCode]];
        }
        
        if(selectedCustObject.custSecondarySpecialty!=nil && [[selectedCustObject.custSecondarySpecialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
        {
            [secondarySpeciltyArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custSecondarySpecialty]];
        }
        
        //For Removal address requests-------
        if(shouldLoadRemoveAddress)
        {
            removeAddresssecondarySpecialtyText.text = [secondarySpeciltyArray componentsJoinedByString:@" - "];
            //NSDictionary *item = [[NSDictionary alloc] init];
            NSDictionary *item;
            if(index < removeAddressResponseArray.count)
            {
                item = [removeAddressResponseArray objectAtIndex:index];
            }
            
            NSDictionary * customerDictionary = [[NSDictionary alloc] init];
            if([item objectForKey:@"customer"])
                customerDictionary = [item objectForKey:@"customer"];
            if([customerDictionary objectForKey:@"priSpecNm"])
                removeAddressPrimarySpecialtyText.text = [NSString stringWithFormat:@"%@", [customerDictionary objectForKey:@"priSpecNm"]];
            if([customerDictionary objectForKey:@"secSpecNm"])
                removeAddresssecondarySpecialtyText.text =[NSString stringWithFormat:@"%@", [customerDictionary objectForKey:@"secSpecNm"]];
            
            if([customerDictionary objectForKey:@"bpId"])
                removalBPID = [NSString stringWithFormat:@"%@",[customerDictionary objectForKey:@"bpId"]];
            
            //remove address type
            //            if([item objectForKey:@"ticketId"] != nil)
            //            {
            //                self.moreInfoTicketId.hidden = NO;
            //                self.moreInfoTicketId.enabled = YES;
            //                moreInfoTicketIdAns = (NSString*)[item objectForKey:@"ticketId"];
            //            }
            
            if([item objectForKey:@"ticketNo"])
                removalTicketNumber = [item objectForKey:@"ticketNo"];
            
            if([item objectForKey:@"autoApprovalDate"])
            {
                NSString *autoApproveDate = [NSString stringWithFormat:@"%@", [item objectForKey:@"autoApprovalDate"]];
                removeAddressProfessionalLabel.text = [NSString stringWithFormat:@"If not rejected by you or any other approver, this request will be considered as approved and the address will be removed from your  CTU database  on %@.", autoApproveDate];
            }
            bpaidtext = [[NSString alloc] init];
            [removalBPAIDArray removeAllObjects];
            for (NSString *addrStr in [item objectForKey:@"bpaToDealign"]) {
                [removalBPAIDArray addObject:[NSString stringWithFormat:@"%@",addrStr]];
            }
            //            if([item objectForKey:@"bpaToDealign"])
            //            {
            //                NSString *result = [NSString stringWithFormat:@"%@",[item objectForKey:@"bpaToDealign"]];
            //                NSCharacterSet *trimString = [NSCharacterSet characterSetWithCharactersInString:@"(\n\\n) ;"];
            //                bpaidtext = [[result componentsSeparatedByCharactersInSet:trimString] componentsJoinedByString:@""];
            //                removalBPAID = bpaidtext;
            //                NSLog(@"%@", bpaidtext);
            //            }
            
            if([customerDictionary objectForKey:@"bpId"])
                reomveAddressBPIDText.text = [NSString stringWithFormat:@"%@",[customerDictionary objectForKey:@"bpId"]];
            if([customerDictionary objectForKey:@"npi"])
                removeAddressNPIText.text = [NSString stringWithFormat:@"%@",[customerDictionary objectForKey:@"npi"]];
            
            //remove address type
            //            if([item objectForKey:@"ticketId"])
            //            {
            //                self.moreInfoTicketId.hidden = NO;
            //                self.moreInfoTicketId.enabled = YES;
            //                moreInfoTicketIdAns = (NSString*)[item objectForKey:@"ticketId"];
            //            }
            
            //remove address ticket id & ticket no
            if([item objectForKey:@"ticketId"]!= nil){
                removeAddressTicketNOLbl.hidden = NO;
                removeAddressTicketNOLbl.text = [NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, [item objectForKey:@"ticketId"]];
                self.remAddressTicketId.hidden = NO;
                if([item objectForKey:@"ticketNo"]!=nil)
                    moreInfoTicketIdAns = [NSString stringWithFormat:@"%@",[item objectForKey:@"ticketNo"]];
            }
            else{
                removeAddressTicketNOLbl.hidden = NO;
                removeAddressTicketNOLbl.text = [NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, [item objectForKey:@"ticketNo"]];
                self.remAddressTicketId.hidden = YES;
            }
            if([item objectForKey:@"requesterRequestId"])
            {
                ticketNumberForDuplicateAddress = [NSString stringWithFormat:@"%@",[item objectForKey:@"requesterRequestId"]];
            }
            //NSUserDefaults * defualts=[NSUserDefaults standardUserDefaults];
            //            NSString *personalId = [[NSString alloc] init];
            //terrId terrId
            //
            customerAddressArray = [customerDictionary objectForKey:@"address"];
            [alignedAddressArray removeAllObjects];
            alignedAddressArray = nil;
            alignedAddressArray = [[NSMutableArray alloc] init];
            [removedAddressArray removeAllObjects];
            removedAddressArray = nil;
            removedAddressArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<customerAddressArray.count;i++)
            {
                NSDictionary *Addressitem = [customerAddressArray objectAtIndex:i];
                [alignedAddressArray addObject:Addressitem];
                for (NSString *string in removalBPAIDArray){
                    if ([string isEqualToString:[NSString stringWithFormat:@"%@",[Addressitem objectForKey:@"bpaId"]]]) {
                        [removedAddressArray addObject:Addressitem];
                        break;
                    }
                }
            }
            if (removedAddressArray.count != customerAddressArray.count){
                for(int i=0; i<customerAddressArray.count; i++)
                {
                    NSDictionary *Addressitem = [customerAddressArray objectAtIndex:i];
                    if([removedAddressArray containsObject:Addressitem]){
                        [alignedAddressArray removeObject:Addressitem];
                    }
                }
            }
            else
            {
                [alignedAddressArray removeAllObjects];
            }
            //NSLog(@"removed:%@",removedAddressArray);
            //NSLog(@"aligned:%@",alignedAddressArray);
            //below code for reading territory id for W/A/R button enabling logic
            NSString *territoryId = [[NSString alloc] init];
            if([item objectForKey:@"requesterTerrId"])
                territoryId =[NSString stringWithFormat:@"%@", [item objectForKey:@"requesterTerrId"]];
            //            if([item objectForKey:@"createdBy"])
            //                personalId =[NSString stringWithFormat:@"%@", [item objectForKey:@"createdBy"]];//[[defualts objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"];
            NSString *string = [[NSString alloc] init];
            if([item objectForKey:@"status"])
                string = [NSString stringWithFormat:@"%@", [item objectForKey:@"status"]] ;
            
            if ([string rangeOfString:@"Withdrawn"].location != NSNotFound)
            {
                // NSLog(@"string does not contain bla");
                removeAddressWithdrawRequestBtn.enabled = NO;
                removeAddressApproveBtn.enabled = NO;
                removeAddressRejectBtn.enabled = NO;
                
                removeAddressProfessionalLabel.hidden = YES;
                [removeAddressWithdrawRequestBtn setHidden:NO];
                [removeAddressApproveBtn setHidden:NO];
                [removeAddressAlignApproveBtn setHidden:YES];
                [removeAddressWithdrawRequestBtn2 setHidden:YES];
                
            }
            else if (([string rangeOfString:@"Approved"].location != NSNotFound) || ([string rangeOfString:@"Rejected"].location != NSNotFound) || ([string rangeOfString:@"Completed"].location != NSNotFound))
            {
                // NSLog(@"string contains bla!");
                removeAddressWithdrawRequestBtn.enabled = NO;
                removeAddressApproveBtn.enabled = NO;
                removeAddressRejectBtn.enabled = NO;
                
                //removeAddressProfessionalLabel.hidden = YES;
                [removeAddressWithdrawRequestBtn setHidden:NO];
                [removeAddressApproveBtn setHidden:NO];
                [removeAddressAlignApproveBtn setHidden:YES];
                [removeAddressWithdrawRequestBtn2 setHidden:YES];
            }
            else if([string rangeOfString:@"Pending"].location != NSNotFound)
            {
                if([territoryId isEqualToString:[defaults objectForKey:@"SelectedTerritoryId"]])
                {
                    removeAddressWithdrawRequestBtn.enabled = YES;
                    removeAddressApproveBtn.enabled = NO;
                    removeAddressRejectBtn.enabled = NO;
                    [removeAddressAlignApproveBtn setHidden:YES];
                    [removeAddressWithdrawRequestBtn2 setHidden:YES];
                    [removeAddressWithdrawRequestBtn setHidden:NO];
                    [removeAddressWithdrawRequestBtn setEnabled:NO];
                    [removeAddressApproveBtn setHidden:NO];
                    
                }
                else
                {
                    removeAddressWithdrawRequestBtn.enabled = NO;
                    removeAddressApproveBtn.enabled = YES;
                    removeAddressRejectBtn.enabled = YES;
                    
                    if(([alignedAddressArray count]==0) &&
                       ([removedAddressArray count]==1) &&
                       (removeAddressApproveBtn.enabled == YES))
                    {
                        [removeAddressAlignApproveBtn setHidden:NO];
                        [removeAddressWithdrawRequestBtn2 setHidden:NO];
                        [removeAddressWithdrawRequestBtn2 setEnabled:NO];
                        [removeAddressWithdrawRequestBtn setHidden:YES];
                        [removeAddressApproveBtn setHidden:YES];
                    }
                    else
                    {
                        [removeAddressAlignApproveBtn setHidden:YES];
                        [removeAddressWithdrawRequestBtn2 setHidden:YES];
                        [removeAddressWithdrawRequestBtn setHidden:NO];
                        [removeAddressApproveBtn setHidden:NO];
                    }
                }
                removeAddressProfessionalLabel.hidden = NO;
            }
            
            approverDetailArray = [item objectForKey:@""]; //--- change to approvers list
            
            if(selectedCustObject.custBPID!=nil)
            {
                // reomveAddressBPIDText.text=[NSString stringWithFormat:@"%@", selectedCustObject.custBPID];
                reomveAddressBPIDText.text = [NSString stringWithFormat:@"%@",[customerDictionary objectForKey:@"bpId"]];
                //removeAddressPrimarySpecialtyText.text = [customerDictionary objectForKey:@"primarySpec"];
                //-- for now
                if([item objectForKey:@"requestorName"])
                    removeAddressRequestorText.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"requestorName"]];
                if([item objectForKey:@"createdOn"])
                    removeAddressReqDateText.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"requestDate"]];
                if([item objectForKey:@"requestorsTerr"])
                {
                    [removeAddressReqTerText setFrame:CGRectMake(removeAddressReqTerText.frame.origin.x, removeAddressReqTerText.frame.origin.y, 250, removeAddressReqTerText.frame.size.height)];

                     removeAddressReqTerText.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"requestorsTerr"]];
                    [removeAddressReqTerText setNumberOfLines:0];
                    [removeAddressReqTerText sizeToFit];
                }
                if([item objectForKey:@"reason"] && ![[item objectForKey:@"reason"]isEqualToString:@"(null)"])
                {
                    NSString *str=[NSString stringWithFormat:@"%@",[item objectForKey:@"reason"]];
                    if([str length] < 30)
                        removeAddressRemReasonText.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"reason"]];
                    else{
                        
                        CGSize sizeText=CGSizeMake(110, 75);
                        CGRect requiredRect= [str boundingRectWithSize:sizeText options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
                        removeAddressRemReasonText.text=str;
                        CGRect newFrame = removeAddressRemReasonText.frame;
                        newFrame.size.height = requiredRect.size.height +5;
                        removeAddressRemReasonText.numberOfLines=0;
                        [removeAddressRemReasonText sizeToFit];
                    }
                }
                
                if([item objectForKey:@"requesterStatus"])
                    requestStatusText.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"requesterStatus"]];
               
                if(shouldLoadRemoveAddress && ([[item objectForKey:@"requesterStatus"] rangeOfString:@"Home Office processing"].length > 0))
                {
                    //NSLog(@"perfect case");
                    requestStatusText.text = @"Pending Approval";
                }
                
                
                [removeAddressReqTerLabel setNumberOfLines:0];
                [removeAddressReqTerLabel sizeToFit];
                [removeAddressRequestorLabel setNumberOfLines:0];
                [removeAddressRequestorLabel sizeToFit];
                
                /*
                 if([removeAddressRemReasonText.text isEqualToString:@"Moved out of territory"])
                 {
                 //viewDupAddressButton.hidden = NO;
                 }
                 else
                 {
                 //viewDupAddressButton.hidden = YES;
                 }*/
            }
            if(selectedCustObject.custNPI!=nil)
            {
                removeAddressNPIText.text=[NSString stringWithFormat:@"%@", selectedCustObject.custNPI];
                removeAddressNPIText.text = [NSString stringWithFormat:@"%@",[customerDictionary objectForKey:@"npi"]];;
            }
            
            if(selectedCustObject.custType!=nil)
            {
                removeAddressCustTypeText.text = selectedCustObject.custType;
            }
            if(selectedCustObject.custProfessionalDesignation!=nil)
            {
                removeAddressProfessionalText.text=[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] objectForKey:selectedCustObject.custProfessionalDesignation];
            }
            if(reqObj.ticketId!=nil)
            {
                //removeAddressTicketNOLbl.text=[NSString stringWithFormat:@"%@. %d", TICKET_NUMBER_STRING, [reqObj.ticketNo intValue]];
                removeAddressTicketNOLbl.text = [NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, [item objectForKey:@"ticketId"]];
                removeAddressTicketNOLbl.hidden=NO;
                if([item objectForKey:@"requesterRequestId"])
                {
                    ticketNumberForDuplicateAddress = [NSString stringWithFormat:@"%@",[item objectForKey:@"requesterRequestId"]];
                }
                
            }
            else{
                removeAddressTicketNOLbl.text = [NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, [item objectForKey:@"ticketNo"]];
                 removeAddressTicketNOLbl.hidden=NO;
            }
            if (reqObj.reason!=nil) {
                
                if ([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove customer"])
                {
                    [removeAddressReasonLabel setText:[NSString stringWithFormat:@"%@:", REASON_FOR_REMOVAL_STRING]];
                }
                
                [removeAddressReasonLabel setHidden:NO];
                [RemoveAddressReasonMoreInfoView setHidden:YES];
                
                CGSize sizeText=CGSizeMake(300, 75);
          
                CGRect requiredRect= [reqObj.reason boundingRectWithSize:sizeText options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
                removeAddressReasonTextLabel.text= reqObj.reason;
                CGRect newFrame = CGRectMake(removeAddressReasonTextLabel.frame.origin.x, removeAddressReasonLabel.frame.origin.y+3, 300, removeAddressReasonTextLabel.frame.size.height ) ;
                newFrame.size.height = requiredRect.size.height +5;
                removeAddressReasonTextLabel.frame=newFrame;
                removeAddressReasonTextLabel.numberOfLines=0;
                [removeAddressReasonTextLabel sizeToFit];
       
                [RemoveAddressReasonMoreInfoView setHidden:YES];
                [removeAddressReasonLabel setHidden:NO];
                [removeAddressReasonTextLabel setHidden:NO];
                
                
                //                if(size.width > removeAddressReasonTextLabel.frame.size.width)
                //                {
                //                    [RemoveAddressReasonMoreInfoView setHidden:YES];
                //                    [removeAddressReasonTextLabel setHidden:NO];
                //
                //                }
                //                else
                //                {
                //                    [RemoveAddressReasonMoreInfoView setHidden:YES];
                //                    [removeAddressReasonLabel setHidden:YES];
                //                    [removeAddressReasonTextLabel setHidden:NO];
                //                    removeAddressReasonTextLabel.text=[NSString stringWithFormat:@"%@",reqObj.reason];
                //                }
                
            }
            else
            {
                [removeAddressReasonLabel setHidden:YES];
                [RemoveAddressReasonMoreInfoView setHidden:YES];
            }
            
            if (reqObj.requestDetails!=nil && (reqObj.requestDetails.length>0)) {
                requestDetailsLabel_RemoveAddress.font= [UIFont fontWithName:@"Roboto-Regular" size:14.0];
                requestDetailsLabel_RemoveAddress.textColor=reasonLabel.textColor;
                requestDetailsLabelText_RemoveAddress.textColor=reasonLabel.textColor;
                requestDetailsLabel_RemoveAddress.hidden=NO;
                requestDetailsLabelText_RemoveAddress.hidden= NO;
                
                requestDetailsLabelText_RemoveAddress.text=reqObj.requestDetails;
                requestDetailsLabelText_RemoveAddress.numberOfLines=3;
                [requestDetailsLabelText_RemoveAddress sizeToFit];
                
                [requestDetailsLabel_RemoveAddress setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
                
            } else {
                requestDetailsLabel_RemoveAddress.hidden=YES;
                requestDetailsLabelText_RemoveAddress.hidden= YES;
                
                //                for (UILabel *subview in [removeAddressScrollView subviews]) {
                //
                //                    if (subview.tag == 100){
                //
                //                        subview.text=@"";
                //
                //                    }
                
                //                }
            }
            
            //[removeAddressReasonLabel setHidden:YES];
            [RemoveAddressReasonMoreInfoView setHidden:YES];
            
        }
        //For all other requests RemoveCustomer,AddCustomer,AddAddress,AlignCustomer
        else
        {
            
            secondarySpecialtyText.text = [secondarySpeciltyArray componentsJoinedByString:@" - "];
            
            if(selectedCustObject.custBPID!=nil)
            {
                BPIDText.text=[NSString stringWithFormat:@"%@", selectedCustObject.custBPID];;
            }
            if(selectedCustObject.custNPI!=nil)
            {
                NPIText.text=[NSString stringWithFormat:@"%@", selectedCustObject.custNPI];
            }
            
            if(selectedCustObject.custType!=nil)
            {
                //phase8 edit start for OnTrack: 499
                //Added the condition to enable customer type for "Add new customer" only. and setting the y position of next label
                int spaceBetweenLabels = 28;
                if ([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Add new customer"]) {
                    CustTypeText.hidden = NO;
                    CustTypeLabel.hidden = NO;
                    [reasonLabel setFrame:CGRectMake(reasonLabel.frame.origin.x, CustTypeLabel.frame.origin.y+spaceBetweenLabels, reasonLabel.frame.size.width, reasonLabel.frame.size.height)];
                }
                else
                    [reasonLabel setFrame:CGRectMake(reasonLabel.frame.origin.x, professionalLabel.frame.origin.y+spaceBetweenLabels, reasonLabel.frame.size.width, reasonLabel.frame.size.height)];
                //phase8 edit end
                CustTypeText.text = selectedCustObject.custType;
            }
            if(selectedCustObject.custProfessionalDesignation!=nil)
            {
                professionalText.text=[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] objectForKey:selectedCustObject.custProfessionalDesignation];
            }
            //// changed from reqObj.TicketId to reqObj.ticketNo
            
            if(reqObj.ticketId!= nil){
                ticketNOLbl.hidden = NO;
                ticketNOLbl.text=[NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, reqObj.ticketId];
                moreInfoTicketId.hidden = NO;
                if(reqObj.ticketNo!=nil)
                    moreInfoTicketIdAns = [NSString stringWithFormat:@"%@",reqObj.ticketNo];
            }
            else{
                ticketNOLbl.hidden = NO;
                ticketNOLbl.text=[NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, reqObj.ticketNo];
                moreInfoTicketId.hidden = YES;
            }
            // Showing Ticket No incase of customer removal with reason RR
            if(reqObj.ticketNo!= nil && [reqObj.reason isEqualToString:@"Recommended for removal"]){
                ticketNOLbl.hidden = NO;
                ticketNOLbl.text=[NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING, reqObj.ticketNo];
            }
            
            //remove address type else block
            //            if(reqObj.ticketId != nil)
            //            {
            //                self.moreInfoTicketId.hidden = NO;
            //                self.moreInfoTicketId.enabled = YES;
            //                moreInfoTicketIdAns = reqObj.ticketId;
            
            if (reqObj.reason!=nil)
            {
                if ([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove customer"])//from server we are getting customer instead of Customer.
                {
                    [reasonLabel setText:[NSString stringWithFormat:@"%@:", REASON_FOR_REMOVAL_STRING]];
                }
                else
                {
                    [reasonLabel setText:[NSString stringWithFormat:@"%@:", REQUEST_DETAILS_STRING]];
                }
                
                [reasonLabel setHidden:NO];
                [reasonMoreInfoView setHidden:NO];
                
                //Commenting deprecated method and replacing with sizeWithAttributes:
                //CGSize size = [reqObj.reason sizeWithFont:reasonTextLabelOrg.font];
                CGSize size = [reqObj.reason sizeWithAttributes:@{NSFontAttributeName:reasonTextLabel.font}];
                
                if(size.width > reasonTextLabel.frame.size.width)
                {
                    [reasonMoreInfoView setHidden:NO];
                    // Y position of reason label was different than reason more infoview
                    [reasonMoreInfoView setFrame:CGRectMake(reasonMoreInfoView.frame.origin.x, reasonLabel.frame.origin.y, reasonMoreInfoView.frame.size.width, reasonMoreInfoView.frame.size.height)];

                    [reasonTextLabel setHidden:YES];
                }
                else
                {
                    [reasonMoreInfoView setHidden:YES];
                    [reasonLabel setHidden:NO];
                    [reasonTextLabel setHidden:NO];
                    [reasonTextLabel setFrame:CGRectMake(reasonTextLabel.frame.origin.x, reasonLabel.frame.origin.y, reasonTextLabel.frame.size.width, reasonTextLabel.frame.size.height)];
                    reasonTextLabel.text=[NSString stringWithFormat:@"%@",reqObj.reason];
                }
            }
            else
            {
                [reasonLabel setHidden:YES];
                [reasonMoreInfoView setHidden:YES];
            }
            
            
            //            }q
//            if(reqObj.reason!=nil) {
//                
////                NSString *string = [NSString stringWithFormat:@"%@",reqObj.reason];
//                if ([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove Customer"])
//                {
//                    
//                    [reasonLabel setText:[NSString stringWithFormat:@"%@:", REASON_FOR_REMOVAL_STRING]];
//                    reasonLabel.hidden=NO;
//                     reasonTextLabel.hidden=NO;
//                
//                    reasonTextLabel.text=reqObj.reason;
//                 
//                    reasonTextLabel.textColor=reasonLabel.textColor;
//                    
//                    //                    if(![string isEqualToString:@"Deceased"] && ![string isEqualToString:@"Retired"] && ![string isEqualToString:@"Recommended for Removal"]){
//                    //                        [reasonLabel setText:[NSString stringWithFormat:@"%@:", REQUEST_DETAILS_STRING]];
//                    //                    }
//                }
//                else
//                {
////                    [reasonLabel setText:[NSString stringWithFormat:@"%@:", REQUEST_DETAILS_STRING]];
//                    [reasonLabel setHidden:YES];
//                    /////////////////////////***********
////                    requestDetailsLabelText_RemoveCustomer.text=string;
//                }
//                //Check if alignment msg fits in resonse label
//                
//                //     ----------------------------------------------------------------------------
//                
//                
//                
////                [reasonLabel setHidden:NO];
//                //  [reasonMoreInfoView setHidden:NO];
//                //                CGSize size = [reqObj.reason sizeWithAttributes:@{NSFontAttributeName:reasonLabel.font}];
//                //NSLog(@"%@,%.2f,%.2f",reqObj.reason,size.width,reasonTextLabel.frame.size.width);
//                //                if(fsize.size.width > reasonTextLabel.frame.size.width)
//                //                {
//                // [reasonMoreInfoView setHidden:NO];
//                
//                
////                [reasonTextLabel setHidden:NO];
////                if ([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove customer"])
////                {
////                    if(![string isEqualToString:@"Deceased"] && ![string isEqualToString:@"Retired"] && ![string isEqualToString:@"Recommended for Removal"])
////                    {
////                        [reasonMoreInfoView setHidden:YES];
////                        [reasonTextLabel setHidden:NO];
////                        reasonTextLabel.text=[NSString stringWithFormat:@"%@",reqObj.reason];
////                        reasonLabel.hidden=NO;
////                    }
////                }
////                else
////                {
////                    reasonLabel.hidden=YES;
////                }
//                
//            }
//            else
//            {
//                [reasonTextLabel setHidden:YES];
//                [reasonLabel setHidden:YES];
//                [reasonMoreInfoView setHidden:YES];
//            }
            
            if ((reqObj.requestDetails!=nil) && (reqObj.requestDetails.length>0)) {
                
                requestDetailsLabel_RemoveCustomer.font=[UIFont fontWithName:@"Roboto-Regular" size:14.0];
                requestDetailsLabel_RemoveCustomer.textColor=reasonLabel.textColor;
                requestDetailsLabelText_RemoveCustomer.textColor= reasonLabel.textColor;
                requestDetailsLabel_RemoveCustomer.hidden=NO;
                requestDetailsLabelText_RemoveCustomer.hidden = NO;
                
                requestDetailsLabelText_RemoveCustomer.text=reqObj.requestDetails;
                requestDetailsLabelText_RemoveCustomer.numberOfLines=3;
                [requestDetailsLabelText_RemoveCustomer sizeToFit];
                //                [requestDetailsLabelText_RemoveCustomer sizeThatFits:label.frame.size];
                
                //                 [detailView addSubview:label];
                
            }
            else {
                requestDetailsLabel_RemoveCustomer.hidden=YES;
                requestDetailsLabelText_RemoveCustomer.hidden = YES;
                //                for (UILabel *subview in [detailView subviews]) {
                //
                //                    if (subview.tag == 100){
                //
                //                       subview.text=@"";
                //
                //                    }
                //
                //                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([reqObj.reason isEqualToString:@"Deceased"] ||
                   [reqObj.reason isEqualToString:@"Retired"]){
                    
                    self.withdrawRequestBtn.enabled = NO;
                }
            });
       
        }
        
        //--- load the remove address view if remove address enabled
        if(shouldLoadRemoveAddress)
        {
            [detailView setHidden:TRUE];
            [detailViewOrg setHidden:TRUE];
            [removeAddressDetailView setHidden:FALSE];
            [removeAddressScrollView setHidden:FALSE];
            // set hidden false for the remove address view
            [addressTable reloadData];
            [requestStatusTable reloadData];
            [addressTableRemoveAddress reloadData];
            [requestStatusTableRemoveAddress reloadData];
            [otherAlignedAdressTableView reloadData];
        }
        else
        {
            [detailViewOrg setHidden:TRUE];
            [detailView setHidden:FALSE];
            [removeAddressDetailView setHidden:TRUE];
            [removeAddressScrollView setHidden:TRUE];
            //set hidden true for remove address view
            [addressTable reloadData];
            [requestStatusTable reloadData];
            [addressTableRemoveAddress reloadData];
            [requestStatusTableRemoveAddress reloadData];
            [otherAlignedAdressTableView reloadData];
        }
        
    }
    else
    {
        RequestObject* reqObj=[orgRequestsData objectAtIndex:index];
        OrganizationObject* selectedOrgObject=reqObj.organizationInfo;
        
        if(selectedOrgObject.orgType!=nil)
        {
            organizationTypeText.text=[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] objectForKey:selectedOrgObject.orgType];
        }
        if(selectedOrgObject.orgName!=nil)
        {
            orgNameText.text=selectedOrgObject.orgName;
        }
        if(selectedOrgObject.orgBPID!=nil)
        {
            orgBPIDText.text=selectedOrgObject.orgBPID;
        }
        if(selectedOrgObject.orgValidationStatus!=nil)
        {
            orgValidationStatusText.text=selectedOrgObject.orgValidationStatus;
        }
        if(selectedOrgObject.orgBPClassification!=nil)
        {
            subClassificationText.text=selectedOrgObject.orgBPClassification;
        }
        
        //// changed from reqObj.TicketNo to reqObj.ticketId
        if(reqObj.ticketNo!=nil)
        {
            //Fixed ontrack 524
            ticketNOLblOrg.text=[NSString stringWithFormat:@"%@. %@", TICKET_NUMBER_STRING,reqObj.ticketNo];
        }
        
        if (reqObj.reason!=nil)
        {
            if ([[[[JSONDataFlowManager sharedInstance] withdrawRequestTypeKeyValues] objectForKey:reqObj.requestType] isEqualToString:@"Remove customer"])
            {
                [reasonLabelOrg setText:[NSString stringWithFormat:@"%@:", REASON_FOR_REMOVAL_STRING]];
            }
            else
            {
                [reasonLabelOrg setText:[NSString stringWithFormat:@"%@:", REQUEST_DETAILS_STRING]];
            }
            
            [reasonLabelOrg setHidden:NO];
            [reasonMoreInfoViewOrg setHidden:NO];
            
            //Commenting deprecated method and replacing with sizeWithAttributes:
            //CGSize size = [reqObj.reason sizeWithFont:reasonTextLabelOrg.font];
            CGSize size = [reqObj.reason sizeWithAttributes:@{NSFontAttributeName:reasonTextLabelOrg.font}];
            
            if(size.width > reasonTextLabelOrg.frame.size.width)
            {
                [reasonMoreInfoViewOrg setHidden:NO];
                [reasonTextLabelOrg setHidden:YES];
            }
            else
            {
                [reasonMoreInfoViewOrg setHidden:YES];
                [reasonLabelOrg setHidden:NO];
                [reasonTextLabelOrg setHidden:NO];
                reasonTextLabelOrg.text=[NSString stringWithFormat:@"%@",reqObj.reason];
            }
        }
        else
        {
            [reasonLabelOrg setHidden:YES];
            [reasonMoreInfoViewOrg setHidden:YES];
        }
        
        //--- load the remove address view if remove address enabled
        if(shouldLoadRemoveAddress)
        {
            [detailView setHidden:TRUE];
            [detailViewOrg setHidden:TRUE];
            [removeAddressDetailView setHidden:FALSE];
            [removeAddressScrollView setHidden:FALSE];
            // set hidden false for the remove address view
        }
        else
        {
            [detailViewOrg setHidden:FALSE];
            [detailView setHidden:TRUE];
            [removeAddressDetailView setHidden:TRUE];
            [removeAddressScrollView setHidden:TRUE];
            //set hidden true for the remove address view
        }
        
        [addressTableOrg reloadData];
        [requestStatusTableOrg reloadData];
    }
    if(removeAddressApproveBtn.enabled == NO)
        isApproverTerritory = NO;
    else
        isApproverTerritory = YES;
    
//For HO user hide all buttons
    if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
        [withdrawRequestBtnOrg setEnabled:NO];
        [withdrawRequestBtn setEnabled:NO];
        [removeAddressWithdrawRequestBtn setEnabled:NO];
        [removeAddressWithdrawRequestBtn2 setEnabled:NO];

    }
    [removeAddressApproveBtn setHidden:YES];
    [removeAddressRejectBtn setHidden:YES];
    [removeAddressAlignApproveBtn setHidden:YES];

    //NSLog(@"%d:%d:%d",isApproverTerritory,(int)([removedAddressArray count]==1),(int)([alignedAddressArray count]==0));
}

-(void)refreshSearchParametersView:(NSMutableDictionary *)searchParametersDict
{
    //Update UI with search parameters received from search form
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])  //Individual
    {
        if(searchParametersDict)
        {
            [indvSearchParameters setDictionary:searchParametersDict];
        }
    }
    else    //Organization
    {
        if(searchParametersDict)
        {
            [orgSearchParameters setDictionary:searchParametersDict];
        }
    }
    
    [searchParameterTable reloadData];
}

-(void)updateServerResponseLabelWithText:(NSString*)responseMsgOrNil forIdentifier:(NSString*)identifier successOrFailure:(BOOL)success
{
    [serverResponseLabel setText:responseMsgOrNil];
    
    if(success)
    {
        [serverResponseLabel setTextColor:THEME_COLOR];
    }
    else
    {
        [serverResponseLabel setTextColor:[UIColor redColor]];
    }
    //Added ho user error message for ho user only
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
        if (responseMsgOrNil.length>0) {
            responseMsgOrNil = [NSString stringWithFormat:@"%@\n%@",[defaults objectForKey:REQUEST_MESSAGE_KEY],responseMsgOrNil];
            
        }
        else
            responseMsgOrNil = [NSString stringWithFormat:@"%@",[defaults objectForKey:REQUEST_MESSAGE_KEY]];
        serverResponseLabel.text = responseMsgOrNil;
        [serverResponseLabel setTextColor:[UIColor redColor]];
    }

    if(responseMsgOrNil && responseMsgOrNil.length)
    {
        //Adjust details view frame
        if(shouldLoadRemoveAddress)
        {
            //Old Code
            //            CGRect detailsViewFrame = removeAddressDetailView.frame;
            //            detailsViewFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            //            removeAddressDetailView.frame = detailsViewFrame;
            //New code
            CGRect scrollViewFrame = removeAddressScrollView.frame;
            scrollViewFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            removeAddressScrollView.frame = scrollViewFrame;
            
            CGRect detailsViewOrgFrame = detailViewOrg.frame;
            detailsViewOrgFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailViewOrg.frame = detailsViewOrgFrame;
        }
        else
        {
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailView.frame = detailsViewFrame;
            
            CGRect detailsViewOrgFrame = detailViewOrg.frame;
            detailsViewOrgFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailViewOrg.frame = detailsViewOrgFrame;
        }
    }
    else
    {
        //Adjust details view frame
        if(shouldLoadRemoveAddress)
        {
            //Old code
            //            CGRect detailsViewFrame = removeAddressDetailView.frame;
            //            detailsViewFrame.origin.y = 10;
            //            removeAddressDetailView.frame = detailsViewFrame;
            //New code
            CGRect scrollViewFrame = removeAddressScrollView.frame;
            scrollViewFrame.origin.y = 10;
            removeAddressScrollView.frame = scrollViewFrame;
            
            CGRect detailsViewOrgFrame = detailViewOrg.frame;
            detailsViewOrgFrame.origin.y = 10;
            detailViewOrg.frame = detailsViewOrgFrame;
        }
        else
        {
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = 10;
            detailView.frame = detailsViewFrame;
            
            CGRect detailsViewOrgFrame = detailViewOrg.frame;
            detailsViewOrgFrame.origin.y = 10;
            detailViewOrg.frame = detailsViewOrgFrame;
        }
    }
}

-(void)selectFirstItemFromList
{
    BOOL isDataAvailable = FALSE;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRequest])
    {
        if(indvRequestsData.count>0)
        {
            isDataAvailable = TRUE;
            if(shouldLoadRemoveAddress)
            {
                //---[removeAddressWithdrawRequestBtn setEnabled:TRUE];
                //---[removeAddressApproveBtn setEnabled:TRUE];
                //---[removeAddressRejectBtn setEnabled:TRUE];
            }
            else
            {
                //[withdrawRequestBtn setEnabled:TRUE];
            }
        }
    }
    else
    {
        if(orgRequestsData.count>0)
        {
            isDataAvailable = TRUE;
        }
    }
    
    if(isDataAvailable)
    {
        //Select Default First Row
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [requestListTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self refreshRequestDetailsOfIndex:indexPath.row];
    }
    else
    {
        //[self getDataFromServer];
        if(shouldLoadRemoveAddress)
        {
            //---removeAddressWithdrawRequestBtn.enabled=FALSE;
            
            selectedRequestListIndex=-1;
            [addressTableRemoveAddress reloadData];
            [requestStatusTableRemoveAddress reloadData];
            [otherAlignedAdressTableView reloadData];
            
            if([requestStatusTableRemoveAddress numberOfRowsInSection:0]>1)
            {
               
                requestStatusTableRemoveAddress.scrollEnabled = YES;
            }
            else{
                requestStatusTableRemoveAddress.scrollEnabled = YES;
            }
        }
        else
        {
            self.withdrawRequestBtn.enabled=FALSE;
            self.withdrawRequestBtnOrg.enabled=FALSE;
            selectedRequestListIndex=-1;
            [addressTable reloadData];
            [addressTableOrg reloadData];
            [requestStatusTable reloadData];
            [requestStatusTableOrg reloadData];
            
            if([requestStatusTableRemoveAddress numberOfRowsInSection:0]>1)
            {                requestStatusTableRemoveAddress.scrollEnabled = YES;
            }
            else{
                requestStatusTableRemoveAddress.scrollEnabled = YES;
            }
        }
    }
}

-(void)presentMoreInfoForTicketIdPopoverFromRect:(CGRect)presentFromRect inView:(UIView*)presentInView withMoreInfo:(NSString*)moreInfoString
{
    TicketIdContentViewController *infoViewController=[[TicketIdContentViewController alloc]initWithNibName:@"TicketIdContentViewController" bundle:nil info:moreInfoString];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(225, 65);
    infoPopOver.backgroundColor = [UIColor blackColor];
    [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(void)presentMoreInfoPopoverFromRect:(CGRect)presentFromRect inView:(UIView*)presentInView withMoreInfo:(NSString*)moreInfoString
{
    ErrroPopOverContentViewController *infoViewController=[[ErrroPopOverContentViewController alloc]initWithNibName:@"ErrroPopOverContentViewController" bundle:nil info:moreInfoString];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(400, 200);
    infoPopOver.backgroundColor = [UIColor blackColor];
    
    if(CGRectIsNull(presentFromRect))   //Present UIpopover at center of View
    {
        presentFromRect  = CGRectMake(presentInView.center.x, presentInView.center.y, 1, 1);
        [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:0 animated:YES];
    }
    else    //Present UIpopover anchored to rect
    {
        [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(void)removeCustomModalViewController
{
    CGRect viewFrame = customModalViewController.view.frame;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [customModalViewController.view setFrame:CGRectMake(viewFrame.origin.x, viewFrame.origin.y + CGRectGetHeight(viewFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame))];
                     }
                     completion:^(BOOL finished){
                         [customModalViewController.view removeFromSuperview];
                         [customModalViewController removeFromParentViewController];
                     }];
}

-(void)clearSearchData
{
    //Individual
    nameText.text = @"";
    primarySpecialtyText.text = @"";
    secondarySpecialtyText.text = @"";
    BPIDText.text = @"";
    NPIText.text = @"";
    
    removeAddressnameText.text = @"";
    removeAddressPrimarySpecialtyText.text = @"";
    removeAddresssecondarySpecialtyText.text = @"";
    reomveAddressBPIDText.text = @"";
    removeAddressNPIText.text = @"";
    
    removeAddressRequestorText.text = @"";
    removeAddressReqDateText.text = @"";
    removeAddressReqTerText.text = @"";
    removeAddressRemReasonText.text = @"";
    requestStatusText.text = @"";
    
    CustTypeText.text = @"";
    professionalText.text = @"";
    ticketNOLbl.text = @"";
    
    removeAddressCustTypeText.text = @"";
    removeAddressProfessionalText.text = @"";
    removeAddressTicketNOLbl.text = @"";
    
    //Org
    organizationTypeText.text = @"";
    orgNameText.text = @"";
    orgBPIDText.text = @"";
    orgValidationStatusText.text = @"";
    subClassificationText.text = @"";
    ticketNOLblOrg.text = @"";
    
    //Clear saved successful URL
    latestSuccessfulIndvSearchUrl = @"";
    latestSuccessfulOrgSearchUrl = @"";
    latestConnectionIdentifier = @"";
    
    [indvRequestsData removeAllObjects];
    [indvSearchParameters removeAllObjects];
    [orgRequestsData removeAllObjects];
    [orgSearchParameters removeAllObjects];
    
    [searchParameterTable reloadData];
    [requestListTable reloadData];
    
    [addressTable reloadData];
    [requestStatusTable reloadData];
    [addressTableOrg reloadData];
    [requestStatusTableOrg reloadData];
    [addressTableRemoveAddress reloadData];
    [requestStatusTableRemoveAddress reloadData];
    [otherAlignedAdressTableView reloadData];
}
#pragma mark -

@end
