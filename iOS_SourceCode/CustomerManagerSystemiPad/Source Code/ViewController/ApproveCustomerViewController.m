//
//  ApproveCustomerViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 08/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "ApproveCustomerViewController.h"
#import "CreateAffiliationSearchViewController.h"
#import "Themes.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "AddressObject.h"
#import "CustomerObject.h"
#import "MapFullScreenViewController.h"
#import "OrganizationObject.h"
#import "DummyData.h"
#import "DataManager.h"
#import "ModalDataLoader.h"
#import "CustomModalViewBO.h"
#import "Utilities.h"
#import "Constants.h"
#import "ApproveAddressDetailCell.h"
#import "JSONDataFlowManager.h"
#import "LOVData.h"
#import "ApproveInfoCell.h"
#import "PopOverContentViewController.h"
#import "ErrroPopOverContentViewController.h"


@interface ApproveCustomerViewController ()
{
    CustomModalViewController *customModalViewController;
    int selectedAddressIndex;
    
    BOOL isTargetForApproval;
    BOOL isTargetForRejection;
    BOOL isTargetForWithdrawal;
    BOOL breStatusFlag;
    BOOL isConnectionInProgress;
    
    NSString *targetProcess;
    NSString *connectionUrl;
    NSString *latestConnectionIdentifier;
    
    BOOL loadMoreRecordsFlag;
    UIButton *btn;
    NSMutableArray *responseArrayforDuplicateAddress;
    NSMutableArray *completeDuplicateAddressArray;
    
    NSMutableArray *responseArray;
    BOOL isSearchAffiliatedScreen;
    NSString *masterIDForCheck;
}

@property(nonatomic,retain) CreateAffiliationSearchViewController *affiliationSearchViewController;
@property(nonatomic,retain) NSArray* custData;
@property(nonatomic,retain) NSMutableDictionary* searchParameters;
@property(nonatomic,assign) IBOutlet UIView * leftView;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) IBOutlet UILabel *serverResponseLabel;
@property(nonatomic,assign) BOOL loadAllRecordsFlag;
@property(nonatomic,assign) IBOutlet UITableView * searchParameterTable;
@property(nonatomic,assign) IBOutlet UILabel * nameLabel;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UITableView * customerListTable;
@property(nonatomic,retain) UIPopoverController*  infoPopOver;
@property(nonatomic,assign) IBOutlet UIButton * infoBtn ;
@property(nonatomic,assign) IBOutlet UITableView * custDetailAddressTable;
@property(nonatomic,retain) NSMutableArray * selectedCustDetailAddress;
@property(nonatomic,retain) NSMutableArray * custDetailAddress;
@property(nonatomic,assign) IBOutlet UIView * detailView;
@property(assign)NSInteger selectedIndexCustData;
@property(nonatomic,assign) IBOutlet UIView * detailViewOrg;
@property(nonatomic,retain)  UIPopoverController * listPopOverController;
@property(nonatomic,assign) IBOutlet UILabel * nameText;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * professionalText;
@property(nonatomic,retain) UILabel * eligibilityText;
@property(nonatomic,assign) IBOutlet UILabel * BPIDText;
@property(nonatomic,assign) IBOutlet UILabel * NPIText;
@property(nonatomic,assign) IBOutlet UILabel *nameLabelOrg;
@property(nonatomic,assign) IBOutlet UILabel * CustTypeText;
@property(nonatomic,assign) IBOutlet UILabel * CustTypeLabel;
@property(nonatomic,assign) IBOutlet UISegmentedControl * indvidualOrganisationSegmentControl;
@property(nonatomic,retain) NSMutableArray * individualsData;
@property(nonatomic,retain) NSMutableDictionary *  indvSearchParameters;
@property(nonatomic,retain) UIButton * changeTerritoryBtn;
@property(nonatomic,retain) NSString *latestSuccessfulIndvSearchUrl;
@property(nonatomic,assign)IBOutlet UILabel * professionalLabel;
@property(nonatomic,assign) IBOutlet UILabel * BPIDLabel;
@property(nonatomic,assign) IBOutlet UILabel * NPILabel;
@property(nonatomic,assign) IBOutlet UIButton *resetButton;
@property(nonatomic,assign) IBOutlet UIButton *searchButton;
@property(nonatomic,assign) IBOutlet UIButton *withdrawButton;
@property(nonatomic,retain) MLPModalViewController *mlpModalviewController;
@property (nonatomic,retain) NSMutableDictionary *sections;
@property (nonatomic,retain) NSMutableDictionary *customers;
@property(assign) NSInteger selectedIndexCustAddress;

-(IBAction)clickSearch:(id)sender;
-(IBAction)clickResetButton:(id)sender;
-(IBAction)valueChangedSegmentControl:(UISegmentedControl *)segment;
-(IBAction)clickInfo:(id)sender;
-(void)clickLogOut;
-(void)refreshCustomerDetailOfIndex:(NSInteger)index;
-(void)changeTargetAddressStatus:(id)sender;
-(IBAction)clickWithdrawRequest:(id)sender;
-(void)clickMap:(id)sender;
// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView;

@end

@implementation ApproveCustomerViewController
@synthesize affiliationSearchViewController,searchParameters,custData,leftView,scrollView,serverResponseLabel,individualsData,indvSearchParameters,searchParameterTable,customerListTable,infoPopOver,infoBtn,custDetailAddressTable,selectedCustDetailAddress,custDetailAddress,selectedIndexCustData,nameText,NPIText,primarySpecialtyText,secondarySpecialtyText,professionalText,BPIDText,CustTypeText,eligibilityText,detailViewOrg,indvidualOrganisationSegmentControl,detailView,changeTerritoryBtn,listPopOverController,CustTypeLabel, latestSuccessfulIndvSearchUrl,nameLabel,primarySpecialtyLabel,secondarySpecialtyLabel,professionalLabel,BPIDLabel,NPILabel,nameLabelOrg,mlpModalviewController,sections,customers,selectedIndexCustAddress,withdrawButton,loadAllRecordsFlag;

#pragma mark - Initialization: View Life Cycle

-(void)getDuplicateAddressRemovalReasonWithString:(NSString *)removalReasonString
{}

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
    
    loadMoreRecordsFlag = NO;
    loadAllRecordsFlag = NO;
    [self setTargetFlags:NO];

    selectedCustDetailAddress = [[NSMutableArray alloc] init];
    custDetailAddress = [[NSMutableArray alloc] init];
    customers = [[NSMutableDictionary alloc] init];
    
    [self setCustomFontToUIComponent];
    [self setBorderAndBackground];
    
    //[[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:YES];
    [[DataManager sharedObject] setIsDefaultRequestForReviews:YES];
    isConnectionInProgress = FALSE;
    latestConnectionIdentifier = @"";
    completeDuplicateAddressArray = [[NSMutableArray alloc] init];
    masterIDForCheck = [[NSString alloc] init];
}

-(void)setBorderAndBackground
{
    leftView.layer.borderWidth=1.0f;
    leftView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [leftView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    customerListTable.layer.borderWidth=1.0f;
    customerListTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [infoBtn setHidden:YES];
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
    detailView.layer.borderWidth=1.0f;
    detailView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right.png"]]];
    [[DataManager sharedObject] setIsIndividualSegmentSelectedForRemoveCustomer:YES];
    detailViewOrg.layer.borderWidth=1.0f;
    detailViewOrg.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [custDetailAddressTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
    custDetailAddressTable.layer.borderWidth=1.0f;
    custDetailAddressTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
}

// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate displayHOUserHomePage];
}

-(void)setNavigationBarThemeAndColor
{
    //Set Navigation Bar Themes
    self.navigationController.navigationBar.tintColor=THEME_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[Themes setNavigationBarNormal:APPROVE_CUSTOMER_TAB_TITLE_STRING ofViewController:@"RemoveCustomer"];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar. frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.navigationController.navigationBar addSubview:navBorder];
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //Add Touch Up event to Log out button
    for(UIButton* btn1 in self.navigationItem.titleView.subviews)
    {
        //Log out btn Tag is 1
        if(btn1.tag==1)
        {
            [btn1 addTarget:self action:@selector(clickLogOut) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(btn1.tag==3)
        {
            //Change Territory Btn
            [btn1 setHidden:NO];
            [btn1 addTarget:self action:@selector(clickChangeTerritory) forControlEvents:UIControlEventTouchUpInside];
            changeTerritoryBtn=btn1;
        }
        //Go to BU, Team and Terriotary selection page
        else if (btn1.tag==1101)
        {
            [btn1 addTarget:self action:@selector(loadBuTeamTerrSelectionView) forControlEvents:UIControlEventTouchUpInside];
//            changeTerritoryBtn=btn1;
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
    [CustTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [CustTypeText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [nameLabelOrg setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [serverResponseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Clear server response label
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
    
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

    [self clearSearchData];
    
    //Refresh Territory field on navigation bar
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //If modal view is present then remove it
    if(customModalViewController && [self.view.subviews containsObject:customModalViewController.view])
    {
        [self removeCustomModalViewController];
    }
    
    //Check for latest successful URL
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        if(self.latestSuccessfulIndvSearchUrl.length == 0)
        {
            [[DataManager sharedObject] setIsDefaultRequestForReviews:TRUE];
        }
    }
    
    //Request last search result
    if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForReviews])
    {
        [self refreshPreviousSearchResult];
    }
    
    //Default call should be after "Request last search result"
    if([[DataManager sharedObject] isDefaultRequestForReviews] && !isConnectionInProgress)
    {
        [self valueChangedSegmentControl:indvidualOrganisationSegmentControl];
    }
    self.indvidualOrganisationSegmentControl.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;//Fixed onTrack 510
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [indvSearchParameters setObject:@"" forKey:@"targetType"];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskLandscape);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

#pragma mark UI Action
-(IBAction)clickInfo:(id)senderata
{
    NSInteger recordCount = 0, remainingRecordsCount = 0;
    NSString *infoTitle,*messageText;
    PopOverContentViewController *infoViewController;
    CGRect infoPopOverModified = CGRectMake(infoBtn.frame.origin.x, infoBtn.frame.origin.y, infoBtn.frame.size.width, infoBtn.frame.size.height);

    //info button is shown only if 100 search results are received
    if(individualsData.count < 100)
    {
        recordCount = [individualsData count];
        messageText = nil;
    }
    else if (individualsData.count == 100)
    {
        messageText = [NSString stringWithFormat:SEARCH_MESSAGE_STRING];
        recordCount = ONE_HUNDRED_RECORDS;
    }
    else
    {
        remainingRecordsCount = individualsData.count - ONE_HUNDRED_RECORDS;
        
        if(individualsData.count == 101)
        {
            recordCount = [self.customerListTable numberOfRowsInSection:0]-1;
            messageText = [NSString stringWithFormat:LOAD_ONE_TARGET];
        }
        else if(individualsData.count > 100 && loadMoreRecordsFlag)
        {
            recordCount = [self.customerListTable numberOfRowsInSection:0]-1;
            messageText = [NSString stringWithFormat:LOAD_XXX_TARGETS,(int)remainingRecordsCount];
        }
        else if(individualsData.count > 100 && loadAllRecordsFlag)
        {
            recordCount = [self.customerListTable numberOfRowsInSection:0];
            messageText = [NSString stringWithFormat:SEARCH_MESSAGE_STRING];
        }
    }
    infoTitle = [NSString stringWithFormat:TOP_XXX_RESULTS_STRING,(int)recordCount];
    
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverContentViewController" bundle:nil infoText:infoTitle andMessageText:messageText];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(200, 130);
    infoPopOver.backgroundColor = [UIColor blackColor];
    [infoPopOver presentPopoverFromRect:infoPopOverModified inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}



-(void)showMoreAddressInfo:(id)sender
{
    UIButton *infoButton = (UIButton*) sender;
    
    UIView *parentCell = [sender superview];
    
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    
    while (![parentView isKindOfClass:[UITableView class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    
    UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    
    AddressObject *addressObj = [selectedCustDetailAddress objectAtIndex:indexPath.row];
    if(addressObj)
    {
        NSArray *alignMsgArray = [addressObj.errorlLabel componentsSeparatedByString:@"||"];
        NSString *moreInfo=nil;
        if (alignMsgArray.count==1) {
            moreInfo=[alignMsgArray objectAtIndex:0];
            moreInfo=[moreInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
        }
        else
        {
            if (alignMsgArray.count>0)
            {
                moreInfo=[alignMsgArray objectAtIndex:1];
                moreInfo=[moreInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
            }
        }
        
        CGRect buttonFrameToTable = [infoButton convertRect:infoButton.bounds toView:self.view];
        [self presentMoreInfoPopoverFromRect:buttonFrameToTable inView:self.view withMoreInfo:moreInfo];
    }
}

-(void)presentMoreInfoPopoverFromRect:(CGRect)presentFromRect inView:(UIView*)presentInView withMoreInfo:(NSString*)moreInfoString
{
    ErrroPopOverContentViewController *infoViewController=[[ErrroPopOverContentViewController alloc]initWithNibName:@"ErrroPopOverContentViewController" bundle:nil info:moreInfoString];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(400, 200);
    
    if(CGRectIsNull(presentFromRect))   //Present UIpopover at center of View
    {
        presentFromRect  = CGRectMake(presentInView.center.x, presentInView.center.y, 1, 1);
        [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:0 animated:YES];
    }
    else    //Present UIpopover anchored to rect
    {
        if((CGRectGetMinY(presentFromRect)+ infoPopOver.popoverContentSize.height - CGRectGetMinY(custDetailAddressTable.frame)) > custDetailAddressTable.frame.size.height)
        {
            [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
        else
        {
            [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

//resets all used targets flag
-(void) setTargetFlags:(BOOL)flag{
    isTargetForRejection = flag;
    isTargetForApproval = flag;
    isTargetForWithdrawal = flag;
}

//removes BRT initials from responce code
-(NSString*) getBRTStringByRemoving:(NSString*)childString fromString:(NSString*)parentString{
    
    NSString *result;
    if(parentString && childString)
    {
        NSRange range = [parentString rangeOfString:childString];
        if(!(range.location == NSNotFound))
        {
            result = [parentString stringByReplacingCharactersInRange:range withString:@""];
        }
        else
            return NULL;
        
        return result;
    }
    else
        return NULL;
}

//Method is invoked when map icon is clicked on targets tab
-(void)clickMap:(id)sender
{
    UITapGestureRecognizer *v = (UITapGestureRecognizer *) sender;
    UITableViewCell *cell = (UITableViewCell*) [[v.view superview]superview];
    NSIndexPath *indexPath;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        indexPath = [custDetailAddressTable indexPathForCell:cell];
    }
    
    int row = (int)indexPath.row;
    
    AddressObject* addObj=nil;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        addObj = [selectedCustDetailAddress objectAtIndex:row];
    }

    MapFullScreenViewController* map=[[MapFullScreenViewController alloc]initWithNibName:@"MapFullScreenViewController" bundle:nil];
    
    NSMutableArray *addressTitleArray = [[NSMutableArray alloc] init];
    NSMutableArray *addressSnippetArray = [[NSMutableArray alloc] init];
    
    if(addObj.addressLineOne!=nil && addObj.addressLineOne.length)
    {
        [addressTitleArray addObject:addObj.addressLineOne];
    }
    
    if(addObj.addressLineTwo!=nil && addObj.addressLineTwo.length)
    {
        [addressTitleArray addObject:addObj.addressLineTwo];
    }
    
    if(addObj.city!=nil && addObj.city.length)
    {
        if(addressTitleArray.count!=0)
        {
            [addressSnippetArray addObject:addObj.city];
        }
        else
        {
            [addressTitleArray addObject:addObj.city];
        }
    }
    if(addObj.state!=nil && addObj.state.length)
    {
        if(addressTitleArray.count!=0)
        {
            [addressSnippetArray addObject:addObj.state];
        }
        else
        {
            [addressTitleArray addObject:addObj.state];
        }
    }
    
    NSMutableArray *addressArray = [NSMutableArray arrayWithObjects:[addressTitleArray componentsJoinedByString:@", "], [addressSnippetArray componentsJoinedByString:@", "], nil];
    [map setTitle:[addressTitleArray componentsJoinedByString:@", "] withSnippet:[addressSnippetArray componentsJoinedByString:@", "] ofAddress:[addressArray componentsJoinedByString:@", "]];
    [self.navigationController pushViewController:map animated:YES];
}

//Method is called when "Search" button is clicked from Review tab.
-(IBAction)clickSearch:(id)sender
{
    //Clear server response label
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    
    customModalViewController = [[CustomModalViewController alloc] initWithNibName:@"CustomModalViewController" bundle:nil];
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    
    //Set Delegate
    customModalViewController.customTableViewController.customerDataDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO ;
    
    NSString *targetStr = @"Individual Type";
    [searchParameters setObject:targetStr forKey:@"targetType"];
    
    //modified indvSearchParameters to searchParameters
    customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualTargetSearchWithParametrs:self.searchParameters];
    customModalViewController.customTableViewController.callBackIdentifier = @"RefineSearchForRemoveCustomerOfTypeIndividual";
    
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    customModalViewController.customTableViewController.tableView.layer.cornerRadius=10.0f;
    customModalViewController.customTableViewController.tableView.layer.borderWidth=0.0f;
    customModalViewController.customTableViewController.tableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    //Set title
    [customModalViewController.titleLabel setText:APPROVE_TAB_REFINE_SEARCH_TITLE_STRING];
    
    //Add target to cancel button
    [customModalViewController.cancelButton addTarget:self action:@selector(removeCustomModalViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
    
    //Animate view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, customModalViewController.view.frame.origin.y-offset-64, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height+60);
    [UIView commitAnimations];
}

//Method is called when "Reset" button is clicked from Review tab.
-(IBAction)clickResetButton:(id)sender
{
    [self getDataFromServer];
}

//Method is called when "Withdraw" button is clicked from Review tab.
-(IBAction)clickWithdrawRequest:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CANCEL_ACTIONS_STRING
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Confirm"
                                          otherButtonTitles:@"Cancel",nil];
    [alert show];
}

//Method is called when "Approve"/"Reject"/"Withdraw" button is clicked from Review tab.
-(void)changeTargetAddressStatus:(id)sender
{
    UIButton *button = (UIButton*) sender;
    [self setTargetFlags:NO];
    
    button = (UIButton*) sender;
    //Disabled Approve/Reject/Withdraw buttons for HO User.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
        button.enabled = NO;
    }
    if(button.tag == APPROVE_ADDRESS){
        targetProcess = APPROVAL_STRING;
        isTargetForApproval = YES;
    }
    else if(button.tag == REJECT_ADDRESS){
        targetProcess = REJECTION_STRING;
        isTargetForRejection = YES;
    }
    else if(button.tag == WITHDRAW_TARGET){
        targetProcess = WITHDRAWAL_STRING;
        isTargetForWithdrawal = YES;
    }
    
    if(isTargetForApproval || isTargetForRejection)
    {
        UIView *parentCell = [sender superview];
        while (![parentCell isKindOfClass:[UITableViewCell class]]) {
            parentCell = parentCell.superview;
        }
        
        UIView *parentView = parentCell.superview;
        while (![parentView isKindOfClass:[UITableView class]]) {
            parentView = parentView.superview;
        }
        
        UITableView *tableView = (UITableView *)parentView;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
        
        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
        
        UITableViewCell *cell = (UITableViewCell*) [[button superview]superview];
        UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
        errorLabel.text=@"";
        int row = (int)indexPath.row;
        
        selectedIndexCustAddress=row;
    }
    else if (isTargetForWithdrawal){
        selectedIndexCustAddress=0;
    }
    
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
    [self approveOrRejectOrWithdrawCall];
}

//Method calls WebService API
-(void)approveOrRejectOrWithdrawCall
{
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:@"POST" forKey:@"request_type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * postBody=nil;

    CustomerObject * custObj =[individualsData objectAtIndex:selectedIndexCustData];
    AddressObject * addObj=[custObj.custAddress objectAtIndex:selectedIndexCustAddress];
    
    postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"bpTypeCd\":\"INDV\",\"bpClasfnCd\":\"%@\",\"bpaId\": \"%@\",\"bpId\": \"%@\",\"territoryId\": \"%@\",\"status\": \"%@\",\"targetId\": \"%@\"}",
              [[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],
              custObj.custType,addObj.BPA_ID,custObj.custBPID,
              [defaults objectForKey:@"SelectedTerritoryId"],
              targetProcess,addObj.targetId];

//        hardcoded for check
//        postBody=[NSString stringWithFormat:@"{\"personnelId\": \"11111111\",\"bpTypeCd\":\"INDV\",\"bpClasfnCd\":\"Prescriber\",\"bpaId\": \"39012829\",\"bpId\": \"13629336\",\"territoryId\": \"157819\",\"status\": \"A\",\"targetId\": \"131728\"}"];

    [parameters setObject:postBody forKey:@"post_body"];

    //changeTargetStatus Protocol
    ConnectionClass * connection= [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:[CHANGE_TARGET_STATUS_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:CHANGE_TARGET_STATUS_URL andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
     {
         //CallBack block
         if(!error)
         {
             [self receiveDataFromServer:data ofCallIdentifier:identifier];
         }
         else
         {
             [self failWithError:error ofCallIdentifier:identifier];
         }
     }];
    
    //Set connection in progress flag
    isConnectionInProgress = TRUE;
}

//Method shows status message in popover
-(void) showApprovedStatusMessage:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    NSInteger row = button.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self refreshCustomerDetailOfIndex:indexPath.row];
    [self.customerListTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //Get cell frame rect for popover
    ApproveInfoCell *cell = (ApproveInfoCell*)[self.customerListTable cellForRowAtIndexPath:indexPath];
    CGRect rect = CGRectMake(cell.bounds.origin.x+33.0, cell.bounds.origin.y-cell.bounds.size.height/2.0-16, 258.0, 114.0);
    
    PopOverContentViewController *infoViewController;
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverApproveViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", APPROVE_STATUS_MSG_STRING]];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(258, 145);
    infoPopOver.backgroundColor = [UIColor blackColor];
    [infoPopOver presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(IBAction)valueChangedSegmentControl:(UISegmentedControl *)segment
{
    if(segment==indvidualOrganisationSegmentControl)
    {
        //Clear server response label
        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
        
        [[DataManager sharedObject] setIsIndividualSegmentSelectedForRemoveCustomer:(indvidualOrganisationSegmentControl.selectedSegmentIndex==0 ? YES : NO)];
        
        [searchParameterTable reloadData];
        [customerListTable reloadData];
        
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])   //Individual
        {
            [detailView setHidden:NO];
            [detailViewOrg setHidden:YES];
            //Enable or Disable Reset button
            [self.resetButton setEnabled:(self.latestSuccessfulIndvSearchUrl.length ? YES : NO)];
            
            if([[DataManager sharedObject] isDefaultRequestForReviews] || !indvSearchParameters || indvSearchParameters.count==0)
            {
                if(indvSearchParameters==nil)
                    indvSearchParameters = [[NSMutableDictionary alloc] init];
                
                [self getDataFromServer];
            }
            else
            {
                //Request last search result
                if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForReviews])
                {
                    [self refreshPreviousSearchResult];
                }
            }
        }
    }
}

//Method is called when changeTerritory button is pressed.
-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];
    listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
    listViewController.delegate=self;
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor blackColor];
    listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    [listPopOverController presentPopoverFromRect:CGRectMake(changeTerritoryBtn.frame.origin.x+5+14
                                                             , changeTerritoryBtn.frame.origin.y-50, changeTerritoryBtn.frame.size.width, changeTerritoryBtn.frame.size.height)
                                           inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
}

//Log out
-(void)clickLogOut
{
 	AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	[appDelegate Logout];
}
#pragma mark -

#pragma mark View Data Handlers
-(void)saveLatestSearchUrl:(NSString*)searchUrl
{
    self.latestSuccessfulIndvSearchUrl = searchUrl;
}

-(void)getDataFromServer
{
    isConnectionInProgress=TRUE;
    [[DataManager sharedObject] setIsDefaultRequestForReviews:TRUE];;
    
    //Add spineer
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    //No default search parameters
    [self refreshSearchParametersView:nil];
    
    if(iSLiveApp)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableString *searchAlignmentsUrl= nil;
        NSString *connectionIdentifier = nil;
        
//        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
//        {
        //Test URl : http://ps8411:8083/nexus-ws/CMService/requests/searchIndividualInAlignments?personnel_id=1&terr_id=1
        
        //Form URl
        searchAlignmentsUrl = [[NSMutableString alloc] initWithString:GET_TARGETS];
        
        //Set connection identifier
        connectionIdentifier = @"SearchIndividualInAlignments";
        
        //Set 'quickSearchType' which is used while parsing response
        [userDefaults setObject:INDV_REMOVE_SEARCH forKey:@"quickSearchType"];
//        }
        
        [searchAlignmentsUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [searchAlignmentsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];

        //NSLog(@"RELOAD URL:%@",searchAlignmentsUrl);
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[searchAlignmentsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        connectionUrl = @"";
        latestConnectionIdentifier = connectionIdentifier;
    }
    else
    {
        individualsData=[DummyData searchCustomerWithType:INDIVIDUALS_KEY];
        
        [customerListTable reloadData];
        
        //Remove Spinner and reset connectionInProgress flag
        isConnectionInProgress=FALSE;
        [Utilities removeSpinnerFromView:self.view];
        
        [self selectFirstItemFromList];
    }
}

//Method clears previously set values
-(void)refreshPreviousSearchResult
{
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        if(self.latestSuccessfulIndvSearchUrl.length)
        {
            //Set connectionInProgress flag
            isConnectionInProgress = TRUE;
            
            //Add spinner
            [Utilities addSpinnerOnView:self.view withMessage:nil];
            ConnectionClass *connection = [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[self.latestSuccessfulIndvSearchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchIndividualInAlignments" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
            latestConnectionIdentifier = @"SearchIndividualInAlignments";
        }
        else    //This should never get executed, added just for failsafe
        {
            [self getDataFromServer];
        }
    }
}

//Method to sort list of customer names
-(void)setCustomerSectionList
{
    NSString * firstName,*c;
    BOOL found;
    [customers removeAllObjects];
    
    // Loop through the States and create keys
    for ( int i = 0 ; i < individualsData.count ; i++ )
    {
        CustomerObject *cust = [individualsData objectAtIndex:i];
        firstName = cust.custFirstName;
        c = [firstName substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.customers allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.customers setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.customers objectForKey:c])
            [[self.customers objectForKey:c] addObject:firstName];
    }
}

//Method call MLP flow process
-(void)showMLPPage
{
//    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];

    [self updateServerResponseLabelWithText:nil forIdentifier:nil successOrFailure:YES];
    
    if(mlpModalviewController)
    {
        mlpModalviewController = nil;
    }
    
    mlpModalviewController = [[MLPModalViewController alloc] initWithNibName:@"MLPModalViewController" bundle:nil];
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + mlpModalviewController.view.frame.size.height;
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    
    CustomerObject *custObj = [individualsData objectAtIndex:selectedIndexCustData];
    if(custObj.custPrimarySpecialtyCode)
        mlpModalviewController.primarySpeAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custPrimarySpecialtyCode];
        
    if(custObj.custSecondarySpecialtyCode)
        mlpModalviewController.secSpeAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custSecondarySpecialtyCode];
        
    mlpModalviewController.masterIDLabel.text = [NSString stringWithFormat:@"Master ID #:"];
    if(custObj.custBPID)
        mlpModalviewController.masterIDAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custBPID];
    if(custObj.custNPI)
        mlpModalviewController.NPIAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custNPI];
    if(custObj.custFirstName || custObj.custLastName)
        mlpModalviewController.nameAnsLabel.text = [NSString stringWithFormat:@"%@ %@",custObj.custFirstName,custObj.custLastName];
    
    //Set data
    mlpModalviewController.customTableViewController.customerDataDelegate = self;
    mlpModalviewController.customTableViewController.isIndividual = [[DataManager sharedObject]
                                                                     isIndividualSegmentSelectedForAddCustomer];
    mlpModalviewController.customTableViewController.dataArray = [[NSArray alloc] init];
    mlpModalviewController.customTableViewController.dataArray = responseArray;
    mlpModalviewController.customTableViewController.popUpScreenTitle = MLP_SCREEN;
    mlpModalviewController.cdfProtocolDataDelegate = self;
    mlpModalviewController.mlpSearchPDelegate = self;
    
    [mlpModalviewController.cancelButton setBackgroundImage:nil forState:UIControlStateNormal];
    [mlpModalviewController.cancelButton setBackgroundImage:[UIImage imageNamed:@"button_searchagain.png"] forState:UIControlStateNormal];
    [mlpModalviewController.searchButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
    [mlpModalviewController.cancelButton setTitle: @"" forState: UIControlStateNormal];
    [mlpModalviewController.searchButton setTitle: @"" forState: UIControlStateNormal];
    
    [mlpModalviewController.titleLabel setText:@"Select Affiliated MD"];
    
    [self addChildViewController:mlpModalviewController];
    [self.view addSubview:mlpModalviewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, mlpModalviewController.view.frame.origin.y-offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)dismissSearchPage
{
    [mlpModalviewController.view removeFromSuperview];
    [affiliationSearchViewController.view removeFromSuperview];
}

-(void)setUpCDFFLagScreenwithName:(NSString *)name primarySpeciality:(NSString *)primarySpe secondarySpeciality:(NSString *)secondarySpe masterID:(NSString *)bpaId andNPI:(NSString *)npiValue
{
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.mlpModalviewController.view withMessage:nil];
    
    //Form URL
    NSMutableString *cdfFlagDetailsUrl = [[NSMutableString alloc] initWithString:SHOW_CDF_FLAG_URL];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *connectionIdentifier = nil;
    [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
    [cdfFlagDetailsUrl appendFormat:@"&bp_id=%@", bpaId];
    [cdfFlagDetailsUrl appendFormat:@"&childBp_id=%@", mlpModalviewController.masterIDAnsLabel.text];
    [cdfFlagDetailsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
    connectionIdentifier = @"CDFFlagIdentfier";
    
    //form connection
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"GET" forKey:@"request_type"];
    
    //showCDFForMLP Protocol
    ConnectionClass *connection = [ConnectionClass sharedSingleton];
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

//Method to save current screen names.
-(void)getCurrentScreenName:(BOOL)isSearchAffiliationPage withMasterId:(NSString *)masterId
{
    isSearchAffiliatedScreen = isSearchAffiliationPage;
    masterIDForCheck = masterId;
}

//Method to affiliate MLP to MD
-(void)affiliateMLPRequestWithString:(NSString *)masterID
{
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.mlpModalviewController.cdfFlagModalviewController.view withMessage:nil];
 
    //Form URL
    NSMutableString *cdfFlagDetailsUrl = [[NSMutableString alloc] initWithString:AFFILIATE_MLP_URL];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *connectionIdentifier = nil;

    CustomerObject * custObj=[individualsData objectAtIndex:selectedIndexCustData];
    AddressObject * addObj=[custObj.custAddress objectAtIndex:selectedIndexCustAddress];
    [cdfFlagDetailsUrl appendFormat:@"personnel_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
    [cdfFlagDetailsUrl appendFormat:@"&bp_id=%@", masterID];
    
    //Adding targetId field in CDFFlagUrl
    [cdfFlagDetailsUrl appendFormat:@"&targetId=%@", addObj.targetId];
    [cdfFlagDetailsUrl appendFormat:@"&childbp_id=%@", custObj.custBPID];
    [cdfFlagDetailsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
    [cdfFlagDetailsUrl appendFormat:@"&childbpa_id=%@", addObj.BPA_ID];
    [cdfFlagDetailsUrl appendFormat:@"&bpClassFnCd=%@", custObj.custType];
    connectionIdentifier = @"AffiliateMLP";
    
    
    //form connection
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"GET" forKey:@"request_type"];

    //AffiliateMLP Protocol
    ConnectionClass *connection = [ConnectionClass sharedSingleton];
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


#pragma mark -

#pragma mark Connection Data Handlers
//Method to receive responce from web server
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
   
    //Parse Data for search response
    if ([identifier rangeOfString:@"AffiliateMLP"].location != NSNotFound)
    {
        NSError *e = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        if([[responseDictionary allKeys] containsObject:@"status"])
        {
            //NSString *responseValue = [[NSString alloc] init];
            NSString *responseValue = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"status"]];
            if([responseValue isEqualToString:@"Success"])
            {
                [mlpModalviewController.cdfFlagModalviewController.view removeFromSuperview];
                [mlpModalviewController.view removeFromSuperview];
                [affiliationSearchViewController.view removeFromSuperview];
                identifier = CHANGE_TARGET_STATUS_URL;
                [Utilities removeSpinnerFromView:self.mlpModalviewController.cdfFlagModalviewController.view];
                
            }
            else
            {
                [mlpModalviewController.cdfFlagModalviewController displayErrorMessage:[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"reasonCode"]]];
                [Utilities removeSpinnerFromView:self.mlpModalviewController.cdfFlagModalviewController.view];
                return;
            }
        }
        else
        {
            [mlpModalviewController.cdfFlagModalviewController.view removeFromSuperview];
            [mlpModalviewController.view removeFromSuperview];
            [affiliationSearchViewController.view removeFromSuperview];
            identifier = CHANGE_TARGET_STATUS_URL;
            [Utilities removeSpinnerFromView:self.mlpModalviewController.cdfFlagModalviewController.view];
        }
    }
    
    isConnectionInProgress = FALSE;
    [Utilities removeSpinnerFromView:self.view];
    
    if([identifier isEqualToString:CHANGE_TARGET_STATUS_URL])
    {
        NSString* myString;
        NSInteger selectedRecord = selectedIndexCustData;
        NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        DebugLog(@"[ApproveCustomerViewController : receiveDataFromServer : JSON received : \n%@ \nIdentifier: %@",jsonDataObject ,identifier);
        
        NSMutableArray *bpaIdModified = [[NSMutableArray alloc] init];
        //Check approve & reject enability conditions - CR
        if([[jsonDataObject allKeys] containsObject:@"payLoad"])
        {
            NSArray *bpaIdArray;
            //  changes:  = [[NSArray alloc] init];
            bpaIdArray = [[jsonDataObject objectForKey:@"payLoad"] componentsSeparatedByString:@","];
            
            for (NSInteger i = 0 ; i < bpaIdArray.count; i ++) {
                NSString *string;
                //Changes:  = [[NSString alloc] init];
                
                string = [[bpaIdArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                if([string containsString:@"["]){
                    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@""];
                }
                if([string containsString:@"]"]){
                    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@""];
                }
                
                [bpaIdModified addObject:string];
            }
        }
        
        if(jsonDataObject==nil)
        {
            //Error Align Teritory
            NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
            UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
            UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
            errorLabel.textColor = [UIColor redColor];
            errorLabel.text=[NSString stringWithFormat:ERROR_ADD_TO_TERRITORY_FAILED];
            AddressObject *addObj= [selectedCustDetailAddress objectAtIndex:index.row];
            addObj.errorlLabel=errorLabel.text;
            [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
        }
        else //there is some JSON received, parse it and use it
        {
            NSString *string;
            breStatusFlag = NO;
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if(!([dataString rangeOfString:@"[BRE]"].location == NSNotFound)){
                breStatusFlag = YES;
                string = [NSString stringWithFormat:@"%@",[self getBRTStringByRemoving:@"[BRE]" fromString:[jsonDataObject objectForKey:@"reasonCode"]]];
            }
            
            if ([dataString rangeOfString:@"requireSearch"].location == NSNotFound)
            {
                if([Utilities parseJsonAndCheckStatus:jsonDataObject]) //Success
                {
                    if(isTargetForApproval || isTargetForRejection)
                    {
                        //Align Territory Sucess
                        NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
                        UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
                        UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
                        errorLabel.textColor = THEME_COLOR;

                        if(breStatusFlag)
                            errorLabel.text = [NSString stringWithFormat:@"%@",string];
                        else
                            errorLabel.text = [NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]];
                        
                        //Modify customber object to remove NotApproved Status
                        CustomerObject *custObj = [individualsData objectAtIndex:selectedRecord];
                        
                        //Modify address list to disable approve button
                        AddressObject *addObj= [selectedCustDetailAddress objectAtIndex:index.row];
                        addObj.errorlLabel=errorLabel.text;
                        addObj.isAddedToTerritory = @"Yes";
                        if(isTargetForApproval)
                            addObj.addressApprovalFlag = A_STRING;
                        if(isTargetForRejection)
                            addObj.addressApprovalFlag = R_STRING;
                        
                        [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
                        
                        AddressObject *addObj2;
                        NSInteger approvedAddrCount = 0;
                        for (int i = 0 ; i < selectedCustDetailAddress.count ; i ++ ){
                            addObj2 = [selectedCustDetailAddress objectAtIndex:i];
                            if([addObj2.addressApprovalFlag isEqualToString:A_STRING]||[addObj2.addressApprovalFlag isEqualToString:R_STRING])
                                approvedAddrCount ++;
                        }
                        //NSLog(@"%d,%d",(int)approvedAddrCount,(int)selectedCustDetailAddress.count);
                        if(approvedAddrCount == selectedCustDetailAddress.count)
                            [custObj setApprovalFlag:nil];
                        else
                            [custObj setApprovalFlag:@"N"];

                        //Modifying data in individuals' array to buffer "approvalFlag"
                        if(selectedRecord < individualsData.count)
                            [individualsData setObject:custObj atIndexedSubscript:selectedRecord];
                        [custDetailAddressTable reloadData];
                        [customerListTable reloadData];

                        [self.customerListTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRecord inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        [self refreshCustomerDetailOfIndex:selectedRecord];
                    }
                    //Withdraw Status Code : "Success"
                    else if (isTargetForWithdrawal)
                    {
                        [self.withdrawButton setEnabled:NO];
                        [self updateServerResponseLabelWithText:[jsonDataObject objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:YES];
                        [self.customerListTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRecord inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

                        //NSInteger selectedIndex = selectedRecord;
                        CustomerObject *custObj = [individualsData objectAtIndex:selectedRecord];
                        custDetailAddress = custObj.custAddress;
                        for (int i = 0 ; i < custDetailAddress.count ; i ++ ){
                            AddressObject *addObj = [custDetailAddress objectAtIndex:i];
                            for (int j = 0 ; j < bpaIdModified.count ; j ++ ){
                                NSString * s1 = [NSString stringWithFormat:@"%@",[bpaIdModified objectAtIndex:j]];
                                NSString *s2 = [NSString stringWithFormat:@"%@",addObj.BPA_ID];
                                if([s1 isEqualToString:s2]){
                                    custObj.approvalFlag = @"N";
                                    addObj.addressApprovalFlag = nil;
                                    addObj.errorlLabel = nil;
                                }
                            }
                        }
                        [individualsData setObject:custObj atIndexedSubscript:selectedRecord];
                        [self.customerListTable reloadData];
                        [self.customerListTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRecord inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        [self refreshCustomerDetailOfIndex:selectedRecord];
                    }
                }
                else //Failure
                {
                    if(![[jsonDataObject objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        if(isTargetForApproval || isTargetForRejection)
                        {
                            //Error Align Teritory
                            NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
                            UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
                            UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
                            errorLabel.textColor = [UIColor redColor];
                            if(breStatusFlag)
                                errorLabel.text = [NSString stringWithFormat:@"%@",string];
                            else
                                errorLabel.text = [NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]];
                            
                            //Modify customber object to remove NotApproved Status
                            CustomerObject *custObj = [individualsData objectAtIndex:selectedRecord];
                            
                            //Modify address object and retain error label for time being
                            AddressObject *addObj= [selectedCustDetailAddress objectAtIndex:index.row];
                            addObj.errorlLabel = errorLabel.text;
                            addObj.isAddedToTerritory = @"No";
                            if(breStatusFlag)
                            {
                                if(isTargetForApproval)
                                    addObj.addressApprovalFlag = A_STRING;
                                if(isTargetForRejection)
                                    addObj.addressApprovalFlag = R_STRING;
                            }
                            [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
                            
                            AddressObject *addObj2;
                            NSInteger approvedAddrCount = 0;
                            for (int i = 0 ; i < selectedCustDetailAddress.count ; i ++ ){
                                addObj2 = [selectedCustDetailAddress objectAtIndex:i];
                                if([addObj2.addressApprovalFlag isEqualToString:A_STRING]||[addObj2.addressApprovalFlag isEqualToString:R_STRING])
                                    approvedAddrCount ++;
                            }
                            //NSLog(@"AprvdAddCount:%d,AllCount:%d",(int)approvedAddrCount,(int)selectedCustDetailAddress.count);
                            if(approvedAddrCount == selectedCustDetailAddress.count)
                                [custObj setApprovalFlag:nil];
                            else
                                [custObj setApprovalFlag:@"N"];
                            
                            [individualsData setObject:custObj atIndexedSubscript:selectedRecord];
                            [customerListTable reloadData];
                            [custDetailAddressTable reloadData];
                            
                            [self.customerListTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRecord inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                            [self refreshCustomerDetailOfIndex:selectedRecord];
                        }
                        else if(isTargetForWithdrawal)
                        {
                            //Withdraw status code : "Failure"
                            [self updateServerResponseLabelWithText:[jsonDataObject objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:NO];
                        
                            [self.customerListTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRecord inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                            [self refreshCustomerDetailOfIndex:selectedRecord];
                        }
                    }
                }
            }
            //response string contains "requireSearch : true" flag
            else
            {
                NSError *e = nil;
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                //responseArray = [[NSMutableArray alloc] init];
                
                if (!jsonArray) {
                    NSLog(@"Error parsing JSON: %@", e);
                }
                else
                {
                    //MLP(Mid Level Practitioner) Flow - affiliate to MD
                    [self showAffiliationScreen];
                }
            }
        }
    }
    else if([identifier isEqualToString:@"RefineSearchForIndividual"])
    {
        NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(jsonDataArrayOfObjects == nil)
        {
            [customModalViewController displayErrorMessage:ERROR_NO_RESULTS_FOUND_TRY_AGAIN];
        }
        else
        {
            NSArray * custDataServer=[Utilities parseJsonSearchIndividual:jsonDataArrayOfObjects];
            if(custDataServer!=nil && [custDataServer count]>0)
            {
                custData= custDataServer;
                if(custData!=nil && [custData count]>0)
                {
                    [customerListTable reloadData];
                    //Select Default First Row
                    if([custData count]>0)
                    {
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                        [customerListTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                        [self tableView:customerListTable didSelectRowAtIndexPath:indexPath];
                    }
                    
                    //On success
                    //Refresh search parameters view
                    [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
                    [self removeCustomModalViewController];
                }
            }
            else
            {
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    
                    if(isSearchAffiliatedScreen == YES )
                    {
                        [affiliationSearchViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]]];
                    }
                    //Error Refine Search
                    [customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]]];
                }
            }
        }
    }
    else if([identifier isEqualToString:@"SearchIndividualInAlignments"]  || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
    {
        //Hide Remove Button Defautlt..When we get data from server and count >0 then we will unhide it
        NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        DebugLog(@"Remove Customer Class | Recieve Data - %@ | Identifier - %@",jsonDataArrayOfObjects ,identifier);
        if(jsonDataArrayOfObjects != nil)
        {
            if([identifier isEqualToString:@"SearchIndividualInAlignments"] || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
            {
                BOOL isValidDataReceived = FALSE;
                NSMutableArray * serverData=[[Utilities parseJsonSearchIndividual:jsonDataArrayOfObjects] mutableCopy];
                if([serverData count]>0)
                {
                    individualsData = serverData;
                    isValidDataReceived = [individualsData count]>0;
                }
                
                [customerListTable reloadData];
                [searchParameterTable reloadData];
                [custDetailAddressTable reloadData];
                
                if(isValidDataReceived)
                {
                    //First save latest successful search URL
                    [self saveLatestSearchUrl:connectionUrl];
                    
                    //Enable or Disable Reset button
                    [self.resetButton setEnabled:(self.latestSuccessfulIndvSearchUrl.length ? YES : NO)];
                    
                    [self selectFirstItemFromList];
                    
                    //On success, clear response label
                    [self updateServerResponseLabelWithText:@"" forIdentifier:identifier successOrFailure:TRUE];
                    
                    if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])   //Remove custom modal view
                    {
                        //On success
                        //Refresh search parameters view
                        [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
                        
                        //Remove modal view with animation
                        [self removeCustomModalViewController];
                    }
                    else if([identifier isEqualToString:@"SearchIndividualInAlignments"])
                    {
                        //Clear out c parameters view for default search
                        if(self.latestSuccessfulIndvSearchUrl.length == 0)
                        {
                            //Refresh search parameters view
                            [indvSearchParameters removeAllObjects];
                            [searchParameterTable reloadData];
                        }
                    }
                }
                else //Display error label
                {
                    if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        if([identifier isEqualToString:@"SearchIndividualInAlignments"])
                        {
                            [self updateServerResponseLabelWithText:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:FALSE];
                        }
                        else if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
                        {
                            [self displayErrorMessage:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]];
                        }
                    }
                }
            }
        }
        else
        {
            //Handle error response
            if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
            {
                //Display error on modal view
                [self displayErrorMessage:ERROR_NO_RESULTS_FOUND_TRY_AGAIN];
            }
            else
            {
                //Update server response label
                [self updateServerResponseLabelWithText:ERROR_NO_RESULTS_FOUND_TRY_AGAIN forIdentifier:identifier successOrFailure:FALSE];
            }
            
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ErrorLog(@"Remove Customer Class | Connection Data - %@ | Identifier - %@",myString ,identifier);
        }
    }
    else if([identifier isEqualToString:@"SearchPageForAffiliation"])
    {
        NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //[self showMLPPage];
        if(jsonDataArrayOfObjects == nil)
        {
            [customModalViewController displayErrorMessage:ERROR_NO_RESULTS_FOUND_TRY_AGAIN];
        }
        else
        {
            NSArray * custDataServer=[Utilities parseJsonSearchIndividual:jsonDataArrayOfObjects];
            if(custDataServer!=nil && [custDataServer count]>0)
            {
                NSError *e = nil;
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                responseArray = [[NSMutableArray alloc] init];
                
                if (!jsonArray) {
                    NSLog(@"Error parsing JSON: %@", e);
                }
                else
                {
                    for(NSDictionary *item in jsonArray) {
                        NSDictionary *mlpItem = item;
                        [responseArray addObject:mlpItem];
                        //NSLog(@"Item: %@", item);
                    }
                    [self showMLPPage];
                }
            }
            else
            {
                NSError *e = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                if([responseDictionary objectForKey:@"status"])
                {
                    if(affiliationSearchViewController.customTableViewController.isCreateAffiliationSearchPage == YES || [affiliationSearchViewController.customTableViewController.currentScreen isEqualToString:@"Align To Territory"])
                    {
                        [affiliationSearchViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"reasonCode"]]];
                    }
                }
            }
        }
    }
    else if([identifier isEqualToString:@"CDFFlagIdentfier"])
    {
        [Utilities removeSpinnerFromView:mlpModalviewController.view];
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        mlpModalviewController.responseArrayForCDF = [[NSMutableArray alloc] init];
        NSMutableArray *responseArr = [[NSMutableArray alloc] init];
        if (!jsonArray) {
            [mlpModalviewController displayErrorMessage:ERROR_ADD_ADDRESS_FAILED];
        }
        else
        {
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([dataString rangeOfString:@"status"].location == NSNotFound)
            {
                for(NSDictionary *item in jsonArray) {
                    NSDictionary *mlpItem = item;
                    [responseArr addObject:mlpItem];
                }
                
                NSDictionary *mlpStatus = [responseArr objectAtIndex:0];
                
                if ([[mlpStatus allKeys] containsObject:@"allFlagD"])
                {
                    mlpModalviewController.isAllFlagD = YES;
                    mlpModalviewController.allFlagsDMessage = [NSString stringWithFormat:@"%@",[mlpStatus objectForKey:@"allFlagD"]];
                    [responseArr removeObjectAtIndex:0];
                }
                else
                {
                    mlpModalviewController.isAllFlagD = NO;
                }
                
                
                mlpModalviewController.cdfFlagModalviewController.mlpAffiliateProtocolDataDelegate = (id)self;
                [mlpModalviewController showCDFFLagScreenWithArray:responseArr];
            }
            else
            {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                if([[responseDictionary allKeys] containsObject:@"status"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"reasonCode"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
                
            }
        }
        
        
        
    }
    
    //Remove Spinner and reset connectionInProgress flag
    isConnectionInProgress=FALSE;
    [Utilities removeSpinnerFromView:self.view];
}

//Method is routine call when response fails
-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    ErrorLog(@"Remove Customer Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    //Handle error response
    if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
    {
        //Display error on modal view
        [self displayErrorMessage:error];
    }
    else
    {
        //Update server response label
        [self updateServerResponseLabelWithText:error forIdentifier:identifier successOrFailure:FALSE];
    }
    
    //Remove Spinner and reset connectionInProgress flag
    isConnectionInProgress=FALSE;
    [Utilities removeSpinnerFromView:self.view];
}
#pragma mark -

#pragma mark Customer Data Delegate
//Method is called when
-(void)processCustomerData:(NSArray *)data forIdentifier:(NSString*)identifier;
{
    //Set connectionInProgress flag
    isConnectionInProgress=TRUE;
    
    //Add spinner on view
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
    {
        if(iSLiveApp)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableString *searchAlignmentsUrl= nil;
            NSString *connectionIdentifier = nil;
            
            //Set connection identifier
            connectionIdentifier = @"RefineSearchForRemoveCustomerOfTypeIndividual";
            
            //Individual customer data
            CustomerObject *customerDataObject = (CustomerObject*)[data objectAtIndex:0];
            
            //Form URl
            searchAlignmentsUrl = [[NSMutableString alloc] initWithString:GET_TARGETS];
            
            if(customerDataObject.custFirstName !=nil && customerDataObject.custFirstName.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"fname=%@&",customerDataObject.custFirstName];
            }
            if(customerDataObject.custMiddleName !=nil && customerDataObject.custMiddleName.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"mname=%@&",customerDataObject.custMiddleName];
            }
            if(customerDataObject.custLastName !=nil && customerDataObject.custLastName.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"lname=%@&",customerDataObject.custLastName];
            }
            
            if(customerDataObject.custBPID !=nil && customerDataObject.custBPID.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"bp_id=%@&",customerDataObject.custBPID];
            }
            if(customerDataObject.custNPI !=nil && customerDataObject.custNPI.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"npi=%@&",customerDataObject.custNPI];
            }
            
            AddressObject *customerAddress = [customerDataObject.custAddress objectAtIndex:0];
            if(customerAddress.state !=nil && customerAddress.state.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"state=%@&",customerAddress.state];
            }
            if(customerAddress.city !=nil && customerAddress.city.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"city=%@&",customerAddress.city];
            }
            if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"zip=%@&",customerAddress.zip];
            }
            
            if(customerDataObject.custPrimarySpecialty !=nil && customerDataObject.custPrimarySpecialty.length!=0)
            {
                
                NSArray *priSpecArray = [customerDataObject.custPrimarySpecialty componentsSeparatedByString:@"-"];
                [searchAlignmentsUrl appendFormat:@"primary_spec=%@&",[[priSpecArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            
            if(customerDataObject.custProfessionalDesignation !=nil && customerDataObject.custProfessionalDesignation.length!=0 && [[[JSONDataFlowManager sharedInstance]profDesignKeyValue] allKeysForObject:customerDataObject.custProfessionalDesignation].count)
            {
                [searchAlignmentsUrl appendFormat:@"prof_desg=%@&",[[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] allKeysForObject:customerDataObject.custProfessionalDesignation] objectAtIndex:0]];
            }
            if(customerDataObject.custType !=nil && customerDataObject.custType.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"individual_type=%@&", customerDataObject.custType];
            }
            if(customerAddress.addr_usage_type != nil && customerAddress.addr_usage_type.length!=0)
            {
                [searchAlignmentsUrl appendFormat:@"addr_usage_type=%@&", customerAddress.addr_usage_type];
            }
            
            [searchAlignmentsUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [searchAlignmentsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
            
            [searchAlignmentsUrl appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
            
            ConnectionClass * connection= [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[searchAlignmentsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
            connectionUrl = searchAlignmentsUrl;
            latestConnectionIdentifier = connectionIdentifier;
        }
        else
        {
            individualsData=[DummyData searchCustomerWithType:INDIVIDUALS_KEY];
            //Refresh search parameters view
            [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
            [customerListTable reloadData];
            
            //Remove Spinner and reset connectionInProgress flag
            isConnectionInProgress=FALSE;
            [Utilities removeSpinnerFromView:self.view];
            
            [self selectFirstItemFromList];
        }
    }
    else if([identifier isEqualToString:@"RefineSearchForIndividual"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:INDV_ADVANCED_SEARCH forKey:@"quickSearchType"];
        NSMutableDictionary *searchParametersDict = [[NSMutableDictionary alloc] init];
        
        CustomerObject * customerDataObject=[data objectAtIndex:0];
        NSMutableString * url=[[NSMutableString alloc]init];

        if(isSearchAffiliatedScreen == YES)
        {
            [url appendFormat:@"%@",SEARCH_BP_URL];
        }
        else
        {
            [url appendFormat:@"%@",SEARCH_INDIVIDUAL_URL];
        }
        if(isSearchAffiliatedScreen == NO)
        {
            if(customerDataObject.custFirstName !=nil && customerDataObject.custFirstName.length!=0)
            {
                if(isSearchAffiliatedScreen == YES)
                {
                    [url appendFormat:@"first_Name=%@&",customerDataObject.custFirstName];
                }
                else
                {
                    [url appendFormat:@"fname=%@&",customerDataObject.custFirstName];
                }
            }
            if(customerDataObject.custMiddleName !=nil && customerDataObject.custMiddleName.length!=0)
            {
                [url appendFormat:@"mname=%@&",customerDataObject.custMiddleName];
            }
            if(customerDataObject.custLastName !=nil && customerDataObject.custLastName.length!=0)
            {
                if(isSearchAffiliatedScreen == YES)
                {
                    [url appendFormat:@"last_Name=%@&",customerDataObject.custLastName];
                }
                else
                {
                    [url appendFormat:@"lname=%@&",customerDataObject.custLastName];
                }
            }
            
            if(customerDataObject.custBPID !=nil && customerDataObject.custBPID.length!=0)
            {
                [url appendFormat:@"bp_id=%@&",customerDataObject.custBPID];
            }
            if(customerDataObject.custNPI !=nil && customerDataObject.custNPI.length!=0)
            {
                if(isSearchAffiliatedScreen == YES)
                {
                    [url appendFormat:@"npi_id=%@&",customerDataObject.custNPI];
                }
                else
                {
                    [url appendFormat:@"npi=%@&",customerDataObject.custNPI];
                }
            }
            
            AddressObject *customerAddress = [customerDataObject.custAddress objectAtIndex:0];
            if(isSearchAffiliatedScreen == YES)
            {
                if(![affiliationSearchViewController.customTableViewController.stateSelected isEqualToString:@"none"] && ![affiliationSearchViewController.customTableViewController.stateSelected isEqualToString:@""])
                {
                    [url appendFormat:@"state_cd=%@&",affiliationSearchViewController.customTableViewController.stateSelected];
                    [searchParametersDict setObject:affiliationSearchViewController.customTableViewController.stateSelected forKey:STATE_KEY];
                }
            }
            else
            {
                if(customerAddress.state !=nil && customerAddress.state.length!=0)
                {
                    [url appendFormat:@"state=%@&",customerAddress.state];
                    [searchParametersDict setObject:customerAddress.state forKey:STATE_KEY];
                }
            }
            if(customerAddress.city !=nil && customerAddress.city.length!=0)
            {
                [url appendFormat:@"city=%@&",customerAddress.city];
                [searchParametersDict setObject:customerAddress.city forKey:CITY_KEY];
            }
            if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
            {
                [url appendFormat:@"zip=%@&",customerAddress.zip];
                [searchParametersDict setObject:customerAddress.zip forKey:ZIP_KEY];
            }
            if(customerAddress.addr_usage_type != nil && customerAddress.addr_usage_type.length!=0)
            {
                [url appendFormat:@"addr_usage_type=%@&", customerAddress.addr_usage_type];
                [searchParametersDict setObject:customerAddress.addr_usage_type forKey:ADDRESS_USAGE_KEY];
            }
            if(customerDataObject.custPrimarySpecialty !=nil && customerDataObject.custPrimarySpecialty.length!=0)
            {
                /*
                 if ([[JSONDataFlowManager sharedInstance]selectedSpecialityIndex]) {
                 LOVData *data=[[[JSONDataFlowManager sharedInstance] specilalityArray] objectAtIndex:([[JSONDataFlowManager sharedInstance]selectedSpecialityIndex]-1)];
                 [url appendFormat:@"primary_spec=%@&",data.code];
                 
                 }*/
                
                NSArray *priSpecArray = [customerDataObject.custPrimarySpecialty componentsSeparatedByString:@"-"];
                [url appendFormat:@"primary_spec=%@&",[[priSpecArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            
            if(customerDataObject.custProfessionalDesignation !=nil && customerDataObject.custProfessionalDesignation.length!=0 && [[[JSONDataFlowManager sharedInstance]profDesignKeyValue] allKeysForObject:customerDataObject.custProfessionalDesignation].count)
            {
                [url appendFormat:@"prof_desg=%@&",[[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] allKeysForObject:customerDataObject.custProfessionalDesignation] objectAtIndex:0]];
            }
            if(customerDataObject.custType !=nil && customerDataObject.custType.length!=0)
            {
                [url appendFormat:@"individual_type=%@&",customerDataObject.custType];
            }
            
            if(isSearchAffiliatedScreen == NO)
            {
                [   url appendFormat:@"search_type=adv"];
            }
            
            if(isSearchAffiliatedScreen == NO)
            {
                [url appendFormat:@"&personnel_id=%@", [[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            }
            else
            {
                [url appendFormat:@"personnel_Id=%@", [[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            }
            if(isSearchAffiliatedScreen == NO)
            {
                [   url appendFormat:@"&team_id=%@",[defaults objectForKey:@"SelectedTeamId"]];
            }
        }
        NSString *identifier;// = [[NSString alloc] init];
        if(isSearchAffiliatedScreen == YES)
        {
            identifier = @"SearchPageForAffiliation";
        }
        else
        {
            identifier = @"RefineSearchForIndividual";
        }

        if(isSearchAffiliatedScreen == YES)
        {
            if((customerDataObject.custBPID !=nil && customerDataObject.custBPID.length!=0 && (![customerDataObject.custBPID isEqualToString:masterIDForCheck])) || (customerDataObject.custNPI !=nil && customerDataObject.custNPI.length!=0))
            {
                if(customerDataObject.custBPID !=nil && customerDataObject.custBPID.length!=0)
                {
                    //bpid value exists
                    [url appendFormat:@"bp_id=%@&",customerDataObject.custBPID];
                }
                else
                {
                    //npiexists
                    [url appendFormat:@"npi_id=%@&",customerDataObject.custNPI];
                }
            }
            else
            {
                if((customerDataObject.custFirstName !=nil && customerDataObject.custFirstName.length!=0) && (customerDataObject.custLastName !=nil && customerDataObject.custLastName.length!=0) && (![affiliationSearchViewController.customTableViewController.stateSelected isEqualToString:@"none"] && ![affiliationSearchViewController.customTableViewController.stateSelected isEqualToString:@""]))
                {
                    [url appendFormat:@"first_Name=%@&",customerDataObject.custFirstName];
                    [url appendFormat:@"last_Name=%@&",customerDataObject.custLastName];
                    
                    [url appendFormat:@"state_cd=%@&",affiliationSearchViewController.customTableViewController.stateSelected];
                    [searchParametersDict setObject:affiliationSearchViewController.customTableViewController.stateSelected forKey:STATE_KEY];
                }
                else
                {
                    [affiliationSearchViewController displayErrorMessage:@"Enter all the fields in Name section or enter any one ID"];
                    return;
                }
            }
            [url appendFormat:@"personnel_Id=%@", [[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [url appendFormat:@"&terr_id=%@", [defaults objectForKey:@"SelectedTerritoryId"]];
        }
        
        //searchBP/searchIndividual Protocol
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:identifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        
        [defaults setObject:searchParametersDict forKey:@"searchParamState"];
        [defaults synchronize];
        
    }
}

//Method to refresh info parameters of selected record
-(void)refreshSearchParametersView:(NSMutableDictionary *)searchParametersDict
{
    //Update UI with search parameters received from search form
    if([self.searchParameters isEqualToDictionary:searchParametersDict])
        return;
    
    [searchParameters removeAllObjects];
    searchParameters = [[NSMutableDictionary alloc] init];
    
    if(searchParametersDict){
        [searchParameters setDictionary:searchParametersDict];
        [searchParameters setObject:INDIVIDUALS_STRING forKey:@"SearchType"];
    }
    [searchParameterTable reloadData];
}

//Method to screen first call of MLP flow.
-(void)showAffiliationScreen
{
    [self updateServerResponseLabelWithText:@"" forIdentifier:@"identifier" successOrFailure:YES];
    
    if(affiliationSearchViewController)
    {
        affiliationSearchViewController = nil;
    }
    
    affiliationSearchViewController = [[CreateAffiliationSearchViewController alloc] initWithNibName:@"CreateAffiliationSearchViewController" bundle:nil];
    
    //Set frame for animation
    //TODO:optimize CGRectMake below
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + affiliationSearchViewController.view.frame.size.height;
    affiliationSearchViewController.view.frame=CGRectMake(affiliationSearchViewController.view.frame.origin.x, offset, affiliationSearchViewController.view.frame.size.width, affiliationSearchViewController.view.frame.size.height);
    
    //Set data
    affiliationSearchViewController.customTableViewController.customerDataDelegate = self;
    affiliationSearchViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO;
    
        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualAffiliationSearch:searchParameters];
        affiliationSearchViewController.customTableViewController.callBackIdentifier = @"RefineSearchForIndividual";
    
    [affiliationSearchViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [affiliationSearchViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [affiliationSearchViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    affiliationSearchViewController.customTableViewController.currentScreen = [[NSString alloc] init];
    affiliationSearchViewController.customTableViewController.currentScreen = @"Align To Territory";
    
    CustomerObject *custObj = [individualsData objectAtIndex:selectedIndexCustData];
    [affiliationSearchViewController.titleLabel setText:SEARCH_TAB_CREATE_AFFILIATION_STRING];
    if(custObj.custPrimarySpecialtyCode)
        affiliationSearchViewController.primarySpeAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custPrimarySpecialtyCode];
    if(custObj.custSecondarySpecialtyCode)
        affiliationSearchViewController.secSpeAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custSecondarySpecialtyCode];
    if(custObj.custBPID)
        affiliationSearchViewController.masterIDAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custBPID];;
    if(custObj.custNPI)
        affiliationSearchViewController.NPIAnsLabel.text = [NSString stringWithFormat:@"%@",custObj.custNPI];
    if(custObj.custFirstName || custObj.custLastName){
        [affiliationSearchViewController.nameAnsLabel setText:[NSString stringWithFormat:@"%@ %@",custObj.custFirstName,custObj.custLastName]];
    }

    [self addChildViewController:affiliationSearchViewController];
    [self.view addSubview:affiliationSearchViewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    affiliationSearchViewController.view.frame=CGRectMake(affiliationSearchViewController.view.frame.origin.x, affiliationSearchViewController.view.frame.origin.y-offset, affiliationSearchViewController.view.frame.size.width, affiliationSearchViewController.view.frame.size.height);
    [UIView commitAnimations];
}


-(void)showSearchError
{
    [affiliationSearchViewController displayErrorMessage:@"Enter all the fields in Name section or enter any one ID"];
}

-(void)displayErrorMessage:(NSString *)errorMsg
{
    [customModalViewController displayErrorMessage:errorMsg];
}

#pragma mark -

#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==customerListTable)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == customerListTable)
    {
        return [[self.customers allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==searchParameterTable)
    {
        return [[searchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] count];
    }
    else if(tableView==customerListTable)
    {
        NSInteger dataCount = 0;
        dataCount = individualsData.count;
        if(dataCount>0)
        {
            selectedIndexCustData = 0;

            if(dataCount <= ONE_HUNDRED_RECORDS){
                [infoBtn setHidden:YES];
                return (dataCount);
            }
            else if(dataCount > ONE_HUNDRED_RECORDS){
                [infoBtn setHidden:NO];
                loadMoreRecordsFlag = YES;
                if(loadAllRecordsFlag == YES)
                {
                    if(dataCount <= TWO_HUNDRED_RECORDS){
                        [infoBtn setHidden:NO];
                        loadMoreRecordsFlag = NO;
                        return (dataCount);
                    }
                    else
                        return TWO_HUNDRED_RECORDS;
                }
                return (ONE_HUNDRED_RECORDS + 1);
            }
        }
        else
        {
            loadMoreRecordsFlag = NO;
            loadAllRecordsFlag = NO;
            [infoBtn setHidden:YES];
            [self refreshCustomerDetailOfIndex:-1];
            return 0;
        }
    }
    else if(tableView==custDetailAddressTable)
    {
        return [selectedCustDetailAddress count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==searchParameterTable)
    {
        static NSString *simpleTableIdentifier = @"ParametersInd";

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
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [cellTemp.textLabel setTextColor:THEME_COLOR];
        
        //Modified searchParameters - stores search values/parameters entered for searching
        NSString *rowName = [[self.searchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] objectAtIndex:indexPath.row];
        [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [self.searchParameters objectForKey:rowName]]];
        
        return cellTemp;
    }
    else  if(tableView==customerListTable)
    {
        static NSString *CellIdentifier = @"customerList";
        int remainingTargets = (int)individualsData.count - ONE_HUNDRED_RECORDS;
        
        //To show "Load next XX records..." label in last cell
        if( indexPath.row == ONE_HUNDRED_RECORDS && loadMoreRecordsFlag == YES )
        {
            ApproveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ApproveInfoCell" owner:self options:nil] objectAtIndex:0];
            }
            [cell.nameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
            [cell.specialtyAndTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.nameLabel setText:[NSString stringWithFormat:@"Load next %3d targets for review",remainingTargets]];
            
            cell.nameLabel.textAlignment = NSTextAlignmentLeft;
            [cell.specialtyAndTypeLabel setText:@""];
            
            UIView *bgColorNormalView = [[UIView alloc] init];
            //Change background of View Fill Gradient
            CAGradientLayer *gradient1 = [CAGradientLayer layer];
            gradient1.frame = cell.bounds;
            gradient1.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0] CGColor], nil];
            [bgColorNormalView.layer insertSublayer:gradient1 atIndex:0];
            [cell setBackgroundView:bgColorNormalView];
            
            //Set Selection Color
            UIView *bgColorView = [[UIView alloc] init];
            //Change background of View Fill Gradient
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = cell.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:253.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:201.0/255.0 green:235.0/255.0 blue:252.0/255.0 alpha:1.0] CGColor], nil];
            [bgColorView.layer insertSublayer:gradient atIndex:0];
            [cell setSelectedBackgroundView:bgColorView];
            
            return cell;
        }
        
        //To show all cells on the CustomerListTable
        ApproveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ApproveInfoCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell.nameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
        [cell.specialtyAndTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        
        
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        CustomerObject* custObj=[individualsData objectAtIndex:indexPath.row ];

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
        
        NSMutableString * specialtyCustTypeLabel=[[NSMutableString alloc]init];
        if(custObj.custPrimarySpecialty!=nil)
        {
            [specialtyCustTypeLabel appendString:[NSString stringWithFormat:@"%@",custObj.custPrimarySpecialty]];
        }
        
        NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
        {
            if(custObj.custPrimarySpecialty!=nil && custObj.custType!=nil)
            {
                [specialtyCustTypeLabel appendFormat:@", "];
            }
            if(custObj.custType!=nil)
            {
                [specialtyCustTypeLabel appendFormat:@"%@",custObj.custType];
            }
        }
        cell.specialtyAndTypeLabel.text=specialtyCustTypeLabel;
        
        //NSLog(@"F:%@",custObj.approvalFlag);
        if ((custObj.approvalFlag != nil) && custObj.approvalFlag.length && [custObj.approvalFlag isEqualToString:@"N"])
        {
            [cell.notApprovedStatus setHidden:NO];
            [cell.notApprovedStatus setTag:indexPath.row];
            [cell.notApprovedStatus addTarget:self action:@selector(showApprovedStatusMessage:) forControlEvents:UIControlEventTouchUpInside];
            
            //"Status:Pending" if atleast one address is not approved.
            [cell.specialtyAndTypeLabel setText:STATUS_PENDING];
        }
        else{
            //"Status:Completed" if all addresses are approved.
            [cell.specialtyAndTypeLabel setText:STATUS_COMPLETED];
            [cell.notApprovedStatus setHidden:YES];
        }

        cell.nameLabel.text=[nameArray componentsJoinedByString:@" "];
        
        //Set Normal Color
        UIView *bgColorNormalView = [[UIView alloc] init];
        
        //Change background of View Fill Gradient
        CAGradientLayer *gradient1 = [CAGradientLayer layer];
        gradient1.frame = cell.bounds;
        gradient1.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0] CGColor], nil];
        [bgColorNormalView.layer insertSublayer:gradient1 atIndex:0];
        [cell setBackgroundView:bgColorNormalView];
        
        //Set Selection Color
        UIView *bgColorView = [[UIView alloc] init];
        
        //Change background of View Fill Gradient
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:253.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:201.0/255.0 green:235.0/255.0 blue:252.0/255.0 alpha:1.0] CGColor], nil];
        [bgColorView.layer insertSublayer:gradient atIndex:0];
        [cell setSelectedBackgroundView:bgColorView];
        
        return cell;
    }
    else if(tableView==custDetailAddressTable)
    {
        static NSString *CellIdentifier = @"IndvAddressSelected";
        
        //Cell displays address details & google map link
        ApproveAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ApproveAddressDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [cell.imageType setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"map_thumb.png"]]];
        
        //Add Google Map Touch Event
        UITapGestureRecognizer* tapGestMap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMap:)];
        [tapGestMap setNumberOfTapsRequired:1];
        [cell.imageType addGestureRecognizer:tapGestMap];
        
        [cell.add1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [cell.add2 setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [cell.add2 setTextColor:[UIColor grayColor]];
        [cell.add3 setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
        [cell.add3 setTextColor:[UIColor grayColor]];
        
        //Add To territoryButton
        [cell.approveTargetBtn setImage:[UIImage imageNamed:@"button_approve.png"] forState:UIControlStateNormal];
        [cell.approveTargetBtn addTarget:self action:@selector(changeTargetAddressStatus:) forControlEvents:UIControlEventTouchUpInside];
        [cell.approveTargetBtn setTag:APPROVE_ADDRESS];
        
        //Add Reject target button
        [cell.rejectTargetBtn setHidden:NO];
        [cell.rejectTargetBtn setImage:[UIImage imageNamed:@"button_reject.png"] forState:UIControlStateNormal];
        [cell.rejectTargetBtn addTarget:self action:@selector(changeTargetAddressStatus:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rejectTargetBtn setTag:REJECT_ADDRESS];
        
        //error Label
        [cell.responseLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [cell.responseLabel setTextColor:[UIColor redColor]];
        [cell.responseLabel setText:@""];
        [cell.responseLabel setNumberOfLines:0];
        [cell.responseLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        //More info view
        [cell.successLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [cell.successLabel setTextColor:THEME_COLOR];
        [cell.successLabel setText:@""];
        
        [cell.failureLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [cell.failureLabel setTextColor:[UIColor redColor]];
        [cell.failureLabel setText:@""];
        
        [cell.moreInfoLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [cell.moreInfoLabel setTextColor:[UIColor grayColor]];
        [cell.moreInfoButton addTarget:self action:@selector(showMoreAddressInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        AddressObject* addObj=nil;
        if(selectedCustDetailAddress.count>indexPath.row)
            addObj = [selectedCustDetailAddress objectAtIndex:indexPath.row ];
        
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        
        if(addObj.addressLineOne!=nil)
            [arr addObject:addObj.addressLineOne];
        if(addObj.addressLineTwo!=nil)
            [arr addObject:addObj.addressLineTwo];
        
        CGSize size = [[arr componentsJoinedByString:@", "] sizeWithAttributes:@{NSFontAttributeName:cell.add1.font}];
        
        if (size.width > cell.add1.bounds.size.width) {
            [cell.add1 setNumberOfLines:2];
            [cell.add1 setFrame:CGRectMake(140, 20, 400, 40)];
            [cell.add2 setFrame:CGRectMake(140, 60, 400, 25)];
            [cell.add3 setFrame:CGRectMake(140, 85, 400, 25)];
            [cell.responseLabel setFrame:CGRectMake(140, 110, 524, 40)];
            [cell.moreInfoView setFrame:CGRectMake(140, 110, 524, 58)];
        }
        else
        {
            [cell.add1 setNumberOfLines:1];
            [cell.add1 setFrame:CGRectMake(140, 20, 400, 25)];
            [cell.add2 setFrame:CGRectMake(140, 45, 400, 25)];
            [cell.add3 setFrame:CGRectMake(140, 70, 400, 25)];
            [cell.responseLabel setFrame:CGRectMake(140, 105, 524, 40)];
            [cell.moreInfoView setFrame:CGRectMake(140, 105, 524, 58)];
        }
        cell.add1.text=[arr componentsJoinedByString:@" "];
        [arr removeAllObjects];
        
        if(addObj.city!=nil)
        {
            [arr addObject:[NSString stringWithFormat:@"%@,", addObj.city ]];
        }
        if(addObj.state!=nil)
        {
            [arr addObject:addObj.state];
        }
        if(addObj.zip!=nil)
        {
            [arr addObject:addObj.zip];
        }
        cell.add2.text=[arr componentsJoinedByString:@" "];
        
        if(addObj.addr_usage_type!=nil)
        {
            [cell.add3 setText:[NSString stringWithFormat:@"%@: %@", ADDRESS_TYPE_STRING, addObj.addr_usage_type]];
        }
        if(addObj.errorlLabel!=nil && ![addObj.errorlLabel isEqualToString:@""])
        {
            cell.responseLabel.text=addObj.errorlLabel;
        }
        else
        {
            cell.responseLabel.text=@"";
        }

        if([addObj.addressApprovalFlag isEqualToString:A_STRING] || [addObj.addressApprovalFlag isEqualToString:R_STRING])
        {
            cell.approveTargetBtn.enabled = NO;
            cell.rejectTargetBtn.enabled = NO;
        }
        else
        {
            cell.approveTargetBtn.enabled = YES;
            cell.rejectTargetBtn.enabled = YES;
        }
        cell.approveTargetBtn.hidden=NO;
        
        //Disable Approve and Reject buttons for HO User
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
            cell.approveTargetBtn.enabled = NO;
            cell.rejectTargetBtn.enabled = NO;
        }
        
        if(addObj.errorlLabel!=nil && ![addObj.errorlLabel isEqualToString:@""])
        {
            NSString *str=[NSString stringWithFormat:@"%@",addObj.errorlLabel];
            str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
            str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
            cell.responseLabel.text=str;
            
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:addObj.errorlLabel
                                                                                 attributes:@{NSFontAttributeName:cell.responseLabel.font}];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGRectGetWidth(cell.responseLabel.frame), CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGSize errorLabelSize = rect.size;
            
            if(!([addObj.errorlLabel rangeOfString:@"||"].location==NSNotFound) || [addObj.addressApprovalFlag isEqualToString:R_STRING])
            {
                if(errorLabelSize.height > CGRectGetHeight(cell.responseLabel.frame) || [addObj.addressApprovalFlag isEqualToString:R_STRING])
                {
                    [cell.moreInfoView setHidden:NO];
                    [cell.responseLabel setHidden:YES];
                    
                    //changing color to theme color
                    [cell.successLabel setTextColor:THEME_COLOR];
                    [cell.successLabel bringSubviewToFront:cell.successLabel];
                    NSString *str=[NSString stringWithFormat:@"%@",addObj.errorlLabel];
                    str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                    str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                    [cell.successLabel setText:str];
                    
                    //NSLog(@"success:%@",str);
                    CGRect frame=cell.additionalDetailsView.frame;
                    frame.origin.y=cell.failureLabel.frame.origin.y;
                    [cell.additionalDetailsView setFrame:frame];
                }
                else
                {
                    [cell.moreInfoView setHidden:YES];
                    [cell.responseLabel setHidden:NO];
                }
            }
            else
            {
                [cell.moreInfoView setHidden:NO];
                [cell.responseLabel setHidden:YES];
                
                //Change color of 'i' button as per the status of alignment
                if([addObj.addressApprovalFlag isEqualToString:A_STRING])
                    [cell.moreInfoButton setImage:[UIImage imageNamed:@"info_blue_btn.png"] forState:UIControlStateNormal];
                else
                    [cell.moreInfoButton setImage:[UIImage imageNamed:@"btn_info.png"] forState:UIControlStateNormal];
                
                NSArray *alignMsgArray = [addObj.errorlLabel componentsSeparatedByString:@"||"];
                
                if (alignMsgArray.count==1) {
                    if([addObj.addressApprovalFlag isEqualToString:A_STRING])
                    {
                        [cell.successLabel setTextColor:THEME_COLOR];
                        NSString *str=[NSString stringWithFormat:@"%@",[alignMsgArray objectAtIndex:0]];
                        str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                        str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                        [cell.successLabel setText:str];
                        
                        CGRect frame=cell.additionalDetailsView.frame;
                        frame.origin.y=cell.failureLabel.frame.origin.y;
                        [cell.additionalDetailsView setFrame:frame];
                    }
                    else
                    {
                        [cell.successLabel setTextColor:[UIColor redColor]];
                        NSString *str=[NSString stringWithFormat:@"%@",[alignMsgArray objectAtIndex:0]];
                        str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                        str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                        
                        [cell.successLabel setText:str];
                        
                        CGRect frame=cell.additionalDetailsView.frame;
                        frame.origin.y=cell.failureLabel.frame.origin.y;
                        [cell.additionalDetailsView setFrame:frame];
                    }
                }
                else
                {
                    if([addObj.addressApprovalFlag isEqualToString:A_STRING])
                    {
                        NSString *str=[[alignMsgArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                        NSArray *subArray=[str componentsSeparatedByString:@"$$"];
                        NSString *sucessStr=nil;
                        NSString *failureStr=nil;
                        
                        sucessStr=[subArray objectAtIndex:0];
                        
                        if(subArray.count>1)
                            failureStr=[subArray objectAtIndex:1];
                        
                        if (subArray.count==2 && sucessStr.length && failureStr.length ) {
                            
                            [cell.successLabel setTextColor:THEME_COLOR];
                            [cell.successLabel setText:[subArray objectAtIndex:0]];
                            
                            [cell.failureLabel setTextColor:[UIColor redColor]];
                            [cell.failureLabel setText:[subArray objectAtIndex:1]];
                        }
                        else if (subArray.count==2 && !sucessStr.length && failureStr.length )
                        {
                            [cell.successLabel setTextColor:[UIColor redColor]];
                            [cell.successLabel setText:[subArray objectAtIndex:1]];
                            
                            CGRect frame=cell.additionalDetailsView.frame;
                            frame.origin.y=cell.failureLabel.frame.origin.y;
                            [cell.additionalDetailsView setFrame:frame];
                        }
                        else if ((subArray.count==2 && sucessStr.length && !failureStr.length) || (subArray.count==1 && sucessStr.length))
                        {
                            [cell.successLabel setTextColor:THEME_COLOR];
                            [cell.successLabel setText:[subArray objectAtIndex:0]];
                            
                            CGRect frame=cell.additionalDetailsView.frame;
                            frame.origin.y=cell.failureLabel.frame.origin.y;
                            [cell.additionalDetailsView setFrame:frame];
                        }
                    }
                    else
                    {
                        [cell.successLabel setTextColor:[UIColor redColor]];
                        NSString *str=[[alignMsgArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                        
                        NSArray *subArray=[str componentsSeparatedByString:@"$$"];
                        NSString *failureStr;
                        if (subArray.count>1)
                            failureStr=[subArray objectAtIndex:1];
                        else
                            failureStr=[subArray objectAtIndex:0];
                        
                        if (failureStr.length)
                            [cell.successLabel setText:failureStr];
                        
                        CGRect frame=cell.additionalDetailsView.frame;
                        frame.origin.y=cell.failureLabel.frame.origin.y;
                        [cell.additionalDetailsView setFrame:frame];
                    }
                }
            }
        }
        else
            cell.responseLabel.text=@"";
        
        //reset all target flags
        [self setTargetFlags:NO];
        breStatusFlag = NO;
        
        //Set Normal Color Color
        UIView *bgColorNormalView = [[UIView alloc] init];
        [bgColorNormalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
        [cell setBackgroundView:bgColorNormalView];
        
        return cell;
    }
    return nil;
}
#pragma mark -

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==customerListTable)
    {
        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
        if(indexPath.row == 100 && [self.customerListTable numberOfRowsInSection:0] == 101){
            loadAllRecordsFlag = YES;
        }
        [self refreshCustomerDetailOfIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchParameterTable)
    {
        return 19.0;
    }
    else if(tableView==custDetailAddressTable)
    {
        return 165.0;
    }
    else
    {
        return 44.0;
    }
}
#pragma mark -

#pragma mark Popover Controller Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [changeTerritoryBtn setSelected:NO];
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
#pragma mark -

#pragma mark View Handlers

//Method to refresh parameters of selected records
-(void)refreshCustomerDetailOfIndex:(NSInteger)index
{
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
//    serverResponseLabel.text=@"";//On selection change error message was not getting updated
    
    //Clear previous labels
    nameText.text = @"";
    primarySpecialtyText.text = @"";
    secondarySpecialtyText.text = @"";
    BPIDText.text = @"";
    NPIText.text = @"";
    
    CustTypeText.text = @"";
    professionalText.text = @"";
    
    //Hide Individual Type label as login rules are aplicable for it
    CustTypeText.hidden=TRUE;
    CustTypeLabel.hidden=TRUE;

    //Return if index is out of bounds
    if(index<0)
    {
        return;
    }
    if(index == ONE_HUNDRED_RECORDS && loadAllRecordsFlag && loadMoreRecordsFlag){
        [self.customerListTable reloadData];
        [self.customerListTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    //code for individual segment
    NSMutableDictionary *cmehDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *nonCmehDict = [[NSMutableDictionary alloc]init];
    CustomerObject* selectedCustObject = nil;
    if([individualsData count]>0)
    {
        selectedCustObject=[individualsData objectAtIndex:index];
    }
    
    //Hide Cust Type When User is no Sales
    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
    {
        CustTypeText.hidden=FALSE;
        CustTypeLabel.hidden=FALSE;
    }
    else
    {
        CustTypeText.hidden=TRUE;
        CustTypeLabel.hidden=TRUE;
    }

    //Set Customer Details
    selectedIndexCustData=index;
    
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

    //Name
    if([nameArray count])
    {
        nameText.text=[nameArray componentsJoinedByString:@" "];
    }
    else
    {
        nameText.text = nil;
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
    
    if([primarySpeciltyArray count]){
        if([primarySpeciltyArray count] > 1){
            if([[primarySpeciltyArray objectAtIndex:0] isEqualToString:NOT_AVAILABLE] &&
               [[primarySpeciltyArray objectAtIndex:1] isEqualToString:NOT_AVAILABLE])
            {
                [cmehDict setObject:NOT_AVAILABLE forKey:@"Primary Specialty"];
            }
            else
                [cmehDict setObject:[primarySpeciltyArray componentsJoinedByString:@" - "] forKey:@"Primary Specialty"];
        }
        else{
            [cmehDict setObject:[primarySpeciltyArray componentsJoinedByString:@" - "] forKey:@"Primary Specialty"];
        }
    }
    else
    {
        primarySpecialtyText.text = nil;
        [cmehDict setObject:@"" forKey:@"Primary Specialty"];
    }

    primarySpecialtyText.text = [primarySpeciltyArray componentsJoinedByString:@" - "];

    NSMutableArray *secondarySpeciltyArray = [[NSMutableArray alloc] init];
    if(selectedCustObject.custSecondarySpecialtyCode!=nil && [[selectedCustObject.custSecondarySpecialtyCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
    {
        [secondarySpeciltyArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custSecondarySpecialtyCode]];
    }
    
    if(selectedCustObject.custSecondarySpecialty!=nil && [[selectedCustObject.custSecondarySpecialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
    {
        [secondarySpeciltyArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custSecondarySpecialty]];
    }
    
    if([secondarySpeciltyArray count]){
        if([secondarySpeciltyArray count] > 1){
            if([[secondarySpeciltyArray objectAtIndex:0] isEqualToString:NOT_AVAILABLE] &&
               [[secondarySpeciltyArray objectAtIndex:1] isEqualToString:NOT_AVAILABLE])
            {
                [cmehDict setObject:NOT_AVAILABLE forKey:@"Secondary Specialty"];
            }
            else
                [cmehDict setObject:[secondarySpeciltyArray componentsJoinedByString:@" - "] forKey:@"Secondary Specialty"];
        }
        else{
            [cmehDict setObject:[secondarySpeciltyArray componentsJoinedByString:@" - "] forKey:@"Secondary Specialty"];
        }
    }
    else
    {
        secondarySpecialtyText.text = nil;
        [cmehDict setObject:@"" forKey:@"Secondary Specialty"];
    }
    
    //[cmehDict setObject:[secondarySpeciltyArray componentsJoinedByString:@" - "] forKey:@"Secondary Specialty"];

    
    //NPI
    if(selectedCustObject.custNPI!=nil)
    {
        NPIText.text=[NSString stringWithFormat:@"%@",selectedCustObject.custNPI ];
        [cmehDict setObject:[NSString stringWithFormat:@"%@",selectedCustObject.custNPI ] forKey:@"NPI #"];

    }
    else
    {
        NPIText.text = nil;
        [cmehDict setObject:@"" forKey:@"NPI #"];
    }
    
    //Customer Type
    if(selectedCustObject.custType!=nil)
    {
        CustTypeText.text = selectedCustObject.custType;
    }
    else
    {
        CustTypeText.text = nil;
    }
    
    //BPID
    if(selectedCustObject.custBPID!=nil)
    {
        BPIDText.text=[NSString stringWithFormat:@"%@",selectedCustObject.custBPID];
        [cmehDict setObject:[NSString stringWithFormat:@"%@",selectedCustObject.custBPID] forKey:@"Master ID #"];
    }
    else
    {
        BPIDText.text = nil;
        [cmehDict setObject:@"" forKey:@"Master ID #"];
    }

    //Professional Designation
    NSMutableArray *profDesgnArray = [[NSMutableArray alloc] init];
    if(selectedCustObject.custProfessionalDesignation!=nil && [[selectedCustObject.custProfessionalDesignation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
    {
        [profDesgnArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custProfessionalDesignation]];
    }
    
    if(selectedCustObject.custProfessionalDesignationName!=nil && [[selectedCustObject.custProfessionalDesignationName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
    {
        [profDesgnArray addObject:[NSString stringWithFormat:@"%@", selectedCustObject.custProfessionalDesignationName]];
    }

    //To show Prof Desng code & name combined
    if([profDesgnArray count]){
        if([profDesgnArray count] > 1){
            if([[profDesgnArray objectAtIndex:0] isEqualToString:NOT_AVAILABLE] &&
               [[profDesgnArray objectAtIndex:1] isEqualToString:NOT_AVAILABLE])
            {
                [cmehDict setObject:NOT_AVAILABLE forKey:@"Professional Designation"];
            }
            else
                [cmehDict setObject:[NSString stringWithFormat:@"%@", selectedCustObject.custProfessionalDesignationName] forKey:@"Professional Designation"];
        }
        else{
            //Only name
            [cmehDict setObject:[NSString stringWithFormat:@"%@", selectedCustObject.custProfessionalDesignationName] forKey:@"Professional Designation"];
            
            //Name & code combined.
            //[cmehDict setObject:[profDesgnArray componentsJoinedByString:@" - "] forKey:@"Professional Designation"];
        }
    }
    else
    {
        professionalText.text = nil;
        [cmehDict setObject:@"" forKey:@"Professional Designation"];
    }
    
    [selectedCustDetailAddress removeAllObjects];
    
    
    BOOL withdrawFlag = NO;
    for(AddressObject* add in selectedCustObject.custAddress)
    {
        [selectedCustDetailAddress addObject:add];
        if([add.addressApprovalFlag isEqualToString:@"A"] || [add.addressApprovalFlag isEqualToString:@"R"])
            withdrawFlag = YES;
        //add withdraw show hide here
        //NSLog(@"Flag:%@",add.addressApprovalFlag);
    }
    if(withdrawFlag){
        withdrawFlag = NO;
        //Disable Withdraw buttons for HO User
        if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
           withdrawButton.enabled = NO;
        }
        else
           withdrawButton.enabled = YES;
 
    }
    else
        withdrawButton.enabled = NO;
    
    if([selectedCustDetailAddress count]==0)
    {
        [custDetailAddressTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    else
    {
        [custDetailAddressTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    
    [custDetailAddressTable reloadData];
    
    // create non cmeh distionary
    if(selectedCustObject.custAttr1!=nil)
    {
        NSArray *keyValueArray = [selectedCustObject.custAttr1 componentsSeparatedByString:@":"];
        [nonCmehDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
    }
    if(selectedCustObject.custAttr2!=nil)
    {
        NSArray *keyValueArray = [selectedCustObject.custAttr2 componentsSeparatedByString:@":"];
        [nonCmehDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
    }

    if(selectedCustObject.custAttr3!=nil)
    {
        NSArray *keyValueArray = [selectedCustObject.custAttr3 componentsSeparatedByString:@":"];
        [nonCmehDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
    }

    if(selectedCustObject.custAttr4!=nil)
    {
        NSArray *keyValueArray = [selectedCustObject.custAttr4 componentsSeparatedByString:@":"];
        [nonCmehDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
    }

    if(selectedCustObject.custAttr5!=nil)
    {
        NSArray *keyValueArray = [selectedCustObject.custAttr5 componentsSeparatedByString:@":"];
        [nonCmehDict setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
    }
    [scrollView removeFromSuperview];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40,684,130)];
    [scrollView flashScrollIndicators];
    
    [self createLabelsForCMEHAttributes:cmehDict];
    [self createLabelsForNonCMEHAttributes:nonCmehDict];
    [self.detailView addSubview:scrollView];
}

-(void)createLabelsForNonCMEHAttributes:(NSMutableDictionary*)keyValDict
{
    float keyLabelx = 10;
    float keyLabely = scrollView.frame.size.height - 22;
    float keyLabelWidth = 162;
    float keyLabelHeight = 16;
    
    float valueLabelx = 182;
    float valueLabely = scrollView.frame.size.height - 22;
    float valueLabelWidth = 272;
    float valueLabelHeight = 16;
    
    float rightKeyLabelx = 441;
    float rightKeyLabely = scrollView.frame.size.height - 22;
    float rightKeyLabelWidth = 77;
    float rightKeyLabelHeight = 16;
    
    float rightValueLabelx = 528;
    float rightValueLabely = scrollView.frame.size.height - 22;
    float rightValueLabelWidth = 153;
    float rightValueLabelHeight = 16;
    
    NSArray *allKeysArray = [keyValDict allKeys];
    NSArray *allValuesArray = [keyValDict allValues];
    
    NSMutableArray *keysArray = [[NSMutableArray alloc]initWithArray:allKeysArray];
    NSMutableArray *valuesArray = [[NSMutableArray alloc]initWithArray:allValuesArray];
    
    // create labels for cmeh attributes (left side)
    [self createKeyValueLabels:keyValDict
                      keyArray:keysArray
               xpositionForKey:keyLabelx
               yPositionForKey:keyLabely
                         width:keyLabelWidth
                        height:keyLabelHeight
                    valueArray:valuesArray
             xpositionForValue:valueLabelx
             yPositionForValue:valueLabely
                         width:valueLabelWidth
                        height:valueLabelHeight
                     strtLimit:0
                   incrementBy:2];
    
    // create labels for cmeh attributes (right side)
    [self createKeyValueLabels:keyValDict
                      keyArray:keysArray
               xpositionForKey:rightKeyLabelx
               yPositionForKey:rightKeyLabely
                         width:rightKeyLabelWidth
                        height:rightKeyLabelHeight
                    valueArray:valuesArray
             xpositionForValue:rightValueLabelx
             yPositionForValue:rightValueLabely
                         width:rightValueLabelWidth
                        height:rightValueLabelHeight
                     strtLimit:1
                   incrementBy:2];

    
}

-(void)createLabelsForCMEHAttributes:(NSMutableDictionary*)keyValDict
{
    float keyLabelx = 10;
    float keyLabely = 10;
    float keyLabelWidth = 162;
    float keyLabelHeight = 16;
    
    float valueLabelx = 182;
    float valueLabely = 10;
    float valueLabelWidth = 272;
    float valueLabelHeight = 16;
    
    float rightKeyLabelx = 441;
    float rightKeyLabely = 10;
    float rightKeyLabelWidth = 77;
    float rightKeyLabelHeight = 16;
    
    float rightValueLabelx = 528;
    float rightValueLabely = 10;
    float rightValueLabelWidth = 153;
    float rightValueLabelHeight = 16;
    
    NSArray *allKeysArray = [keyValDict allKeys];
    NSArray *allValuesArray = [keyValDict allValues];

    NSMutableArray *keysArray = [[NSMutableArray alloc]initWithArray:allKeysArray];
    NSMutableArray *valuesArray = [[NSMutableArray alloc]initWithArray:allValuesArray];

    //Arrange Primary Spec id at first position
    if ([keysArray containsObject:@"Primary Specialty"]) {
        NSString *key1 = @"Primary Specialty";
        NSInteger anIndex1 = [keysArray indexOfObject:key1];
        [keysArray exchangeObjectAtIndex:anIndex1 withObjectAtIndex:0];
        [valuesArray exchangeObjectAtIndex:anIndex1 withObjectAtIndex:0];
    }

    //Arrange master id at second position
    if ([keysArray containsObject:@"Master ID #"]) {
        NSString *key2 = @"Master ID #";
        NSInteger anIndex2 = [keysArray indexOfObject:key2];
        [keysArray exchangeObjectAtIndex:anIndex2 withObjectAtIndex:1];
        [valuesArray exchangeObjectAtIndex:anIndex2 withObjectAtIndex:1];

    }
    
    //Arrange Primary Spec id at first position
    if ([keysArray containsObject:@"Secondary Specialty"]) {
        NSString *key3 = @"Secondary Specialty";
        NSInteger anIndex3 = [keysArray indexOfObject:key3];
        [keysArray exchangeObjectAtIndex:anIndex3 withObjectAtIndex:2];
        [valuesArray exchangeObjectAtIndex:anIndex3 withObjectAtIndex:2];
    }
    
    //Arrange NPI at fourth position
    if ([keysArray containsObject:@"NPI #"]) {
        NSString *key5 = @"NPI #";
        NSInteger anIndex5 = [keysArray indexOfObject:key5];
        [keysArray exchangeObjectAtIndex:anIndex5 withObjectAtIndex:3];
        [valuesArray exchangeObjectAtIndex:anIndex5 withObjectAtIndex:3];
    }
    
    //Arrange Professional Designation at fifth position

    if ([keysArray containsObject:@"Professional Designation"]) {
        NSString *key5 = @"Professional Designation";
        NSInteger anIndex5 = [keysArray indexOfObject:key5];
        [keysArray exchangeObjectAtIndex:anIndex5 withObjectAtIndex:4];
        [valuesArray exchangeObjectAtIndex:anIndex5 withObjectAtIndex:4];
    }

    // create labels for cmeh attributes (left side)
    [self createKeyValueLabels:keyValDict keyArray:keysArray xpositionForKey:keyLabelx yPositionForKey:keyLabely width:keyLabelWidth height:keyLabelHeight valueArray:valuesArray xpositionForValue:valueLabelx yPositionForValue:valueLabely width:valueLabelWidth height:valueLabelHeight strtLimit:0 incrementBy:2];

    // create labels for cmeh attributes (right side)
    [self createKeyValueLabels:keyValDict keyArray:keysArray xpositionForKey:rightKeyLabelx yPositionForKey:rightKeyLabely width:rightKeyLabelWidth height:rightKeyLabelHeight valueArray:valuesArray xpositionForValue:rightValueLabelx yPositionForValue:rightValueLabely width:rightValueLabelWidth height:rightValueLabelHeight strtLimit:1 incrementBy:2];
    
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.contentSize = CGSizeMake(684, scrollView.frame.size.height+30);
}

-(void)createKeyValueLabels:(NSMutableDictionary*)keyValDict keyArray:(NSMutableArray*)keysArray xpositionForKey:(float)keyLabelx yPositionForKey:(float)keyLabely width:(float)keyLabelWidth height:(float)keyLabelHeight valueArray:(NSMutableArray*)valuesArray xpositionForValue:(float)valueLabelx yPositionForValue:(float)valueLabely width:(float)valueLabelWidth height:(float)valueLabelHeight strtLimit:(int)startIndex incrementBy:(int)increment
{
    
    int scrollViewHeight;
    
    for (; startIndex<[keyValDict count]; ) {
        //Added labels for left keys
        UILabel *customLabelForLeftKey = [[UILabel alloc]initWithFrame:CGRectMake(keyLabelx, keyLabely, keyLabelWidth, keyLabelHeight)];
        [customLabelForLeftKey setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [customLabelForLeftKey setTextColor:[UIColor grayColor]];
        customLabelForLeftKey.text = [keysArray objectAtIndex:startIndex];
        customLabelForLeftKey.numberOfLines = 0;
        [customLabelForLeftKey sizeToFit];
        [scrollView addSubview:customLabelForLeftKey];
        keyLabely = keyLabely+customLabelForLeftKey.frame.size.height+16;// 16 is used to make the space between upper and lower labels
        
        // add left colon seperator
        
        UILabel *customLabelForSeperator = [[UILabel alloc]initWithFrame:CGRectMake(valueLabelx-8, valueLabely+2, 5,10)];
        [customLabelForSeperator setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [customLabelForSeperator setTextColor:[UIColor grayColor]];
        customLabelForSeperator.text = @":";
        customLabelForSeperator.numberOfLines = 0;
        [scrollView addSubview:customLabelForSeperator];
        
        //Added labels for left values
        UILabel *customLabelForLeftValue = [[UILabel alloc]initWithFrame:CGRectMake(valueLabelx, valueLabely, valueLabelWidth-20, valueLabelHeight)];
        [customLabelForLeftValue setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        [customLabelForLeftValue setTextColor:[UIColor grayColor]];
        
        //Truncate space
        customLabelForLeftValue.text = [[NSString stringWithFormat:@"%@",[valuesArray objectAtIndex:startIndex]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        customLabelForLeftValue.numberOfLines = 0;
        [customLabelForLeftValue sizeToFit];
        [scrollView addSubview:customLabelForLeftValue];
        
        valueLabely = valueLabely+customLabelForLeftValue.frame.size.height+16;

        if (keyLabely>valueLabely) {
            valueLabely = keyLabely;
        }
        else
            keyLabely = valueLabely;
        
        scrollViewHeight = keyLabely;
        
        //Right labels allignment
        
        //Added labels for right keys
        
        startIndex = startIndex+increment;
        if (startIndex >=[keyValDict count]) {
            break;
        }
        float height = scrollView.frame.size.height;
        scrollView.contentSize = CGSizeMake(684, height/2.0 + scrollViewHeight + 30);
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

-(void)updateServerResponseLabelWithText:(NSString*)responseMsgOrNil forIdentifier:(NSString*)identifier successOrFailure:(BOOL)success
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"] || [identifier isEqualToString:@"RemoveOrganizationAddress"] ||
       [identifier isEqualToString:CLEAR_CELL_ERROR_LABEL])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
        UITableViewCell *cell ;
        if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"])
        {
            cell = [custDetailAddressTable cellForRowAtIndexPath:indexPath];
        }
        
        UILabel *responseLabel = (UILabel*)[cell viewWithTag:ERROR_LABEL_TAG];
        
        //Set text
        [responseLabel setText:responseMsgOrNil];
        
        NSIndexPath* index=[NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
        
        //Retain Error Or Success in Address Table
        AddressObject* addObj=nil;
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
        {
            addObj = [selectedCustDetailAddress objectAtIndex:index.row];
        }
        
        addObj.errorlLabel=responseLabel.text;
        //Set color
        if(success)
        {
            [responseLabel setTextColor:THEME_COLOR];
            addObj.isAddedToTerritory=@"Yes";
            addObj.addressApprovalFlag = A_STRING;
        }
        else
        {
            [responseLabel setTextColor:[UIColor redColor]];
        }
        
        if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"])
        {
            [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
            [custDetailAddressTable reloadData];
        }
    }
    else if ([identifier isEqualToString:@"RemoveIndividualCustomer"] || [identifier isEqualToString:@"RemoveOrganization"] || [identifier isEqualToString:@"SearchIndividualInAlignments"] ||
             [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"] ||
             [identifier isEqualToString:CLEAR_VIEW_ERROR_LABEL])
    {
        [serverResponseLabel setText:responseMsgOrNil];
        
        //Set color
        if(success)
        {
            [serverResponseLabel setTextColor:THEME_COLOR];
            [scrollView setHidden:NO];
            [nameLabel setHidden:NO];
            [_searchButton setEnabled:YES];
        }
        else
        {
            [serverResponseLabel setTextColor:[UIColor redColor]];
            // clear the non cmeh data
            [scrollView setHidden:YES];
            [nameLabel setHidden:YES];
            [_searchButton setEnabled:NO];
            [withdrawButton setEnabled:NO];
        }
        //Added error message for HO user also
        if ([[defaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
            if (responseMsgOrNil.length>0) {
                responseMsgOrNil = [NSString stringWithFormat:@"%@\n%@",[defaults objectForKey:TARGET_MESSAGE_KEY],responseMsgOrNil];
            }
            else
                responseMsgOrNil = [NSString stringWithFormat:@"%@",[defaults objectForKey:TARGET_MESSAGE_KEY]];
            serverResponseLabel.text = responseMsgOrNil;
            [serverResponseLabel setTextColor:[UIColor redColor]];
        }
        
        if(responseMsgOrNil && responseMsgOrNil.length)
        {
            //Adjust details view frame
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailView.frame = detailsViewFrame;
        }
        else
        {
            //Adjust details view frame
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = 10;
            detailView.frame = detailsViewFrame;
        }
    }
    else if ([identifier isEqualToString:CHANGE_TARGET_STATUS_URL])
    {
        //[serverResponseLabel setText:[NSString stringWithFormat:@"%@",responseMsgOrNil]];
        dispatch_async(dispatch_get_main_queue(), ^{
        [serverResponseLabel setText:[NSString stringWithFormat:@"%@",responseMsgOrNil]];
        [serverResponseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
        [serverResponseLabel setHidden:NO];
        });
        
        //Set color
        if(success)
            [serverResponseLabel setTextColor:THEME_COLOR];
        else
            [serverResponseLabel setTextColor:[UIColor redColor]];
        
        if ([[defaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
            if (responseMsgOrNil.length>0) {
                responseMsgOrNil = [NSString stringWithFormat:@"%@\n%@",[defaults objectForKey:TARGET_MESSAGE_KEY],responseMsgOrNil];
            }
            else
                responseMsgOrNil = [NSString stringWithFormat:@"%@",[defaults objectForKey:TARGET_MESSAGE_KEY]];
            serverResponseLabel.text = responseMsgOrNil;
            [serverResponseLabel setTextColor:[UIColor redColor]];
        }

        if(responseMsgOrNil && responseMsgOrNil.length)
        {
            //Adjust details view frame
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailView.frame = detailsViewFrame;
        }
        else
        {
            //Adjust details view frame
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = 10;
            detailView.frame = detailsViewFrame;
        }
    }
}

//Method to select first item in Customer List Table.
-(void)selectFirstItemFromList
{
    @try {
        //Select Default First Row
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [customerListTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:customerListTable didSelectRowAtIndexPath:indexPath];
    }
    @catch (NSException *exception) {
        ErrorLog(@"Remove Customer | selectFirstItemFromList | %@",exception.description);
        
        //In case of exception handle it with default search request
        [self getDataFromServer];
    }
}

//Method to clear data from Review Table.
-(void)clearSearchData
{
    //Individual
    nameText.text = @"";
    primarySpecialtyText.text = @"";
    secondarySpecialtyText.text = @"";
    BPIDText.text = @"";
    NPIText.text = @"";
    CustTypeText.text = @"";
    professionalText.text = @"";
    
    //Clear saved successful URL
    latestSuccessfulIndvSearchUrl = @"";
    latestConnectionIdentifier = @"";
    
    [individualsData removeAllObjects];
    [indvSearchParameters removeAllObjects];
    [selectedCustDetailAddress removeAllObjects];
    
    [searchParameterTable reloadData];
    [customerListTable reloadData];
    [custDetailAddressTable reloadData];
}
#pragma mark -

#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && [alertView.title isEqualToString:CANCEL_ACTIONS_STRING])
    {
        [self setTargetFlags:NO];
        targetProcess = WITHDRAWAL_STRING;
        isTargetForWithdrawal = YES;
        selectedIndexCustAddress=0;
        
        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
        [self approveOrRejectOrWithdrawCall];
    }
//    if(buttonIndex==0 && [alertView.message isEqualToString:REMOVE_CUSTOMER_ADDRESS_ALERT_MSG]) // Yes
//    {
//        [self clickRemoveCustomerAddress];
//        
//    }
//    else if(buttonIndex==1 && [alertView.message isEqualToString:REMOVE_CUSTOMER_ADDRESS_ALERT_MSG]) // Yes
//    {
//        NSLog(@"Implement reject functionality");
//        [alertView dismissWithClickedButtonIndex:1 animated:YES];
//        //implement the backend call for reject similar to the top code for withdraw
//    }
}


@end
