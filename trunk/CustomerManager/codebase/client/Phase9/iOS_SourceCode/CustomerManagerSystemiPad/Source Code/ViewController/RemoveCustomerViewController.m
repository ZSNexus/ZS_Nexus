//
//  RemoveCustomerViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 08/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "RemoveCustomerViewController.h"
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
#import "CustomerAddressDetailCell.h"
#import "JSONDataFlowManager.h"
#import "LOVData.h"
#import "CustomerInfoCell.h"
#import "PopOverContentViewController.h"

@interface RemoveCustomerViewController ()
{
    CustomModalViewController *customModalViewController;
    int selectedAddressIndex;
    
    
    BOOL isConnectionInProgress;
    NSString *connectionUrl;
    NSString *latestConnectionIdentifier;
    
    BOOL removeAddressButtonClicked;
    UIButton *btn;
    CGRect frameInWindow;
    NSMutableArray *responseArrayforDuplicateAddress;
    NSMutableArray *completeDuplicateAddressArray;
    BOOL isSingleAddress;
    
}
@property(nonatomic,assign) IBOutlet UIView * leftView;
@property(nonatomic,assign) IBOutlet UILabel *serverResponseLabel;
@property(nonatomic,assign) IBOutlet UITableView * searchParameterTable;
@property(nonatomic,assign) IBOutlet UILabel * nameLabel;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UITableView * customerListTable;
@property(nonatomic,retain) UITableView * reasonForRemovalTableView;
@property(nonatomic,retain) UITableView * reasonForCustomerAddressRemovalTable;
@property(nonatomic,retain) UIPopoverPresentationController*  infoPopOver;
@property(nonatomic,assign) IBOutlet UIButton * infoBtn ;
@property(nonatomic,assign) IBOutlet UITableView * custDetailAddressTable;
@property(nonatomic,assign) IBOutlet UITableView * custDetailAddressTableOrg;
@property(nonatomic,retain) NSMutableArray * selectedCustDetailAddress;
@property(nonatomic,retain) NSMutableArray * selectedOrgDetailAddress;
@property(nonatomic,retain) NSArray * bpaIdArray;
@property(nonatomic,retain) NSArray * reasonForCustomerRemovalArray;
@property(nonatomic,retain) NSArray * reasonForCustomerAddressRemovalArray;
@property(nonatomic,assign) IBOutlet UIView * detailView;
@property(assign)NSInteger selectedIndexCustData;
@property(nonatomic,assign) IBOutlet UIView * detailViewOrg;
@property(nonatomic,retain)  UIPopoverPresentationController * listPopOverController;
@property(nonatomic,assign) IBOutlet UILabel * nameText;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * professionalText;
@property(nonatomic,retain) UILabel * eligibilityText;
@property(nonatomic,assign) IBOutlet UILabel * BPIDText;
@property(nonatomic,assign) IBOutlet UILabel * NPIText;
@property(nonatomic,assign) IBOutlet UILabel *nameLabelOrg;
@property(nonatomic,assign) IBOutlet UILabel *organizationTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel *subClassificationLabel;
@property(nonatomic,assign) IBOutlet UILabel *orgValidationStatusLabel;
@property(nonatomic,assign) IBOutlet UILabel * BPIDLabelOrg;
@property(nonatomic,assign) IBOutlet UILabel * CustTypeText;
@property(nonatomic,assign) IBOutlet UILabel * CustTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel * subClassificationText;
@property(nonatomic,assign) IBOutlet UILabel * orgValidationStatusText;
@property(nonatomic,assign) IBOutlet UILabel * orgBPIDText;
@property(nonatomic,assign) IBOutlet UILabel * organizationTypeText;
@property(nonatomic,assign) IBOutlet UILabel * orgNameText;
@property(nonatomic,assign) IBOutlet UIButton * submitForRemovalButton;
@property(nonatomic,assign) IBOutlet UISegmentedControl * indvidualOrganisationSegmentControl;
@property(nonatomic,retain) NSMutableArray * individualsData;
@property(nonatomic,retain) NSMutableArray * organizationsData;
@property(nonatomic,retain) NSMutableDictionary *  indvSearchParameters;
@property(nonatomic,retain) NSMutableDictionary *  orgSearchParameters;
@property(nonatomic,retain) UIButton * changeTerritoryBtn;
@property(nonatomic,retain) NSString *selectedReasonForRemoval;
@property(nonatomic,retain) UIButton* removeBtn;
@property(nonatomic,retain) NSString *latestSuccessfulIndvSearchUrl;
@property(nonatomic,retain) NSString *latestSuccessfulOrgSearchUrl;
@property(nonatomic,assign)IBOutlet UILabel * professionalLabel;
@property(nonatomic,assign) IBOutlet UILabel * BPIDLabel;
@property(nonatomic,assign) IBOutlet UILabel * NPILabel;
@property(nonatomic,assign) IBOutlet UIButton *resetButton;
@property(nonatomic,retain) MLPAddressViewController *mlpModalviewController;
@property(nonatomic,retain) NSString *additionalAddressesForRemoval;


-(IBAction)clickRefineSearch:(id)sender;
-(IBAction)clickResetButton:(id)sender;
-(IBAction)valueChangedSegmentControl:(UISegmentedControl *)segment;
-(IBAction)clickInfo:(id)sender;
-(void)clickLogOut;
-(void)refreshCustomerDetailOfIndex:(NSInteger)index;
-(IBAction)clickSubmitForRemoval:(id)sender;
-(void)clickRemoveAddress:(id)sender;
-(void)clickMap:(id)sender;
//-(IBAction)clickInfoCustomerRemoval:(NSString*)senderata;
// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView;
@end

@implementation RemoveCustomerViewController
@synthesize leftView,serverResponseLabel,individualsData,organizationsData,indvSearchParameters,orgSearchParameters,searchParameterTable,customerListTable,infoPopOver,infoBtn,custDetailAddressTable,selectedCustDetailAddress,selectedOrgDetailAddress,selectedIndexCustData,nameText,NPIText,primarySpecialtyText,secondarySpecialtyText,professionalText,BPIDText,CustTypeText,eligibilityText,organizationTypeText,subClassificationText,orgValidationStatusText,orgBPIDText,orgNameText,submitForRemovalButton,detailViewOrg,indvidualOrganisationSegmentControl,detailView,reasonForRemovalTableView,reasonForCustomerAddressRemovalTable,selectedReasonForRemoval,changeTerritoryBtn,listPopOverController,custDetailAddressTableOrg,reasonForCustomerRemovalArray, reasonForCustomerAddressRemovalArray,CustTypeLabel,removeBtn, latestSuccessfulIndvSearchUrl, latestSuccessfulOrgSearchUrl,nameLabel,primarySpecialtyLabel,secondarySpecialtyLabel,professionalLabel,BPIDLabel,NPILabel,nameLabelOrg,organizationTypeLabel,subClassificationLabel,orgValidationStatusLabel,BPIDLabelOrg,mlpModalviewController,bpaIdArray;

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
    
    selectedCustDetailAddress = [[NSMutableArray alloc] init];
    selectedOrgDetailAddress = [[NSMutableArray alloc] init];
    
    [self setCustomFontToUIComponent];
    [self setBorderAndBackground];
    
    reasonForCustomerRemovalArray=[[JSONDataFlowManager sharedInstance]reasonForCustomerRemovalArray];
    reasonForCustomerAddressRemovalArray = [[JSONDataFlowManager sharedInstance] reasonForCustomerAddressRemovalArray];
    [[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:TRUE];
    isConnectionInProgress = FALSE;
    latestConnectionIdentifier = @"";
    removeAddressButtonClicked = FALSE;
    completeDuplicateAddressArray = [[NSMutableArray alloc] init];
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
                                    [UIFont systemFontOfSize:13], NSFontAttributeName,
                                    [UIColor colorWithRed:15.0/255.0 green:68.0/255.0 blue:146.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                    nil];
        [indvidualOrganisationSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [indvidualOrganisationSegmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
        
//        indvidualOrganisationSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
        indvidualOrganisationSegmentControl.tintColor = [UIColor colorWithRed:6.0 / 255.0 green:86.0 / 255.0 blue:161.0 / 255.0 alpha:1.0];
    }
    indvidualOrganisationSegmentControl.frame= CGRectMake(10, 10, 280, 35);
    detailView.layer.borderWidth=1.0f;
    detailView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right"]]];
    [[DataManager sharedObject] setIsIndividualSegmentSelectedForRemoveCustomer:YES];
    detailViewOrg.layer.borderWidth=1.0f;
    detailViewOrg.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [custDetailAddressTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
    custDetailAddressTable.layer.borderWidth=1.0f;
    custDetailAddressTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [custDetailAddressTableOrg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
    custDetailAddressTableOrg.layer.borderWidth=1.0f;
    custDetailAddressTableOrg.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
}

-(void)setNavigationBarThemeAndColor
{
    //Set Navigation Bar Themes
    self.navigationController.navigationBar.tintColor=THEME_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[Themes setNavigationBarNormal:REMOVE_CUSTOMER_TAB_TITLE_STRING ofViewController:@"RemoveCustomer"];
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
    [orgNameText setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [organizationTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [organizationTypeText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [subClassificationLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [subClassificationText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgValidationStatusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgValidationStatusText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [BPIDLabelOrg setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgBPIDText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
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
    
    if([[DataManager sharedObject] isDefaultRequestForRemoveCustomer])
    {
        //Clear previous data
        [self clearSearchData];
    }
    
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
            [[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:TRUE];
        }
    }
    else
    {
        if(self.latestSuccessfulOrgSearchUrl.length == 0)
        {
            [[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:TRUE];
        }
    }
    
    //Request last search result
    if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForRemoveCustomer])
    {
        [self refreshPreviousSearchResult];
    }
    
    //Default call should be after "Request last search result"
    if([[DataManager sharedObject] isDefaultRequestForRemoveCustomer] && !isConnectionInProgress)
    {
        [self valueChangedSegmentControl:indvidualOrganisationSegmentControl];
    }
    
    self.indvidualOrganisationSegmentControl.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;//Fixed onTrack 510

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

#pragma mark UI Actions
-(IBAction)clickInfo:(id)senderata
{
    PopOverContentViewController *infoViewController;
     infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverContentViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", TOP_50_RESULTS_STRING]];
    CGRect infoPopOverModified = CGRectMake(infoBtn.frame.origin.x, infoBtn.frame.origin.y, infoBtn.frame.size.width, infoBtn.frame.size.height);
    infoViewController.modalPresentationStyle=UIModalPresentationPopover;
   
    //INFO button is shown only if 50 search results are received
    // Get the popover presentation controller and configure it.
    infoPopOver  = [infoViewController popoverPresentationController];
    infoViewController.popoverPresentationController.sourceRect = infoPopOverModified;
    infoViewController.popoverPresentationController.sourceView = self.view;
    infoViewController.preferredContentSize= CGSizeMake(200, 130);
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor blackColor];
    listPopOverController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    
    [self presentViewController:infoViewController animated: YES completion: nil];
   
}

-(void)clickMap:(id)sender
{
    UITapGestureRecognizer *v = (UITapGestureRecognizer *) sender;
    UITableViewCell *cell = (UITableViewCell*) [[v.view superview]superview];
    NSIndexPath *indexPath;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        indexPath = [custDetailAddressTable indexPathForCell:cell];
    }
    else
    {
        indexPath = [custDetailAddressTableOrg indexPathForCell:cell];
    }
    
    int row = (int)indexPath.row;
    
    AddressObject* addObj=nil;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        addObj = [selectedCustDetailAddress objectAtIndex:row];
    }
    else
    {
        addObj = [selectedOrgDetailAddress objectAtIndex:row];
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TabBarView" bundle:nil];
    MapFullScreenViewController *map = [sb instantiateViewControllerWithIdentifier:@"MapFullScreenViewController"];
//    vc.modalTransitionStyle = uimodaltr;
  
    
//    MapFullScreenViewController* map=[[MapFullScreenViewController alloc]initWithNibName:@"MapFullScreenViewController" bundle:nil];
    
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

-(IBAction)clickRefineSearch:(id)sender
{
//  Clear server response label
//    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TabBarView" bundle:nil];
    customModalViewController = [sb instantiateViewControllerWithIdentifier:@"CustomModalViewController"];
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    
    //Set Delegate
    customModalViewController.customTableViewController.customerDataOfCustomTableViewDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO ;
    
    if ([DataManager sharedObject].isIndividualSegmentSelectedForRemoveCustomer)
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualRemoveSearchWithParametrs:indvSearchParameters];
        customModalViewController.customTableViewController.callBackIdentifier = @"RefineSearchForRemoveCustomerOfTypeIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:orgSearchParameters];
        customModalViewController.customTableViewController.callBackIdentifier = @"RefineSearchForRemoveCustomerOfTypeOrganization";
    }
    
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    customModalViewController.customTableViewController.tableView.layer.cornerRadius=10.0f;
    customModalViewController.customTableViewController.tableView.layer.borderWidth=0.0f;
    customModalViewController.customTableViewController.tableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    //Set title
    [customModalViewController.titleLabel setText:REMOVE_TAB_REFINE_SEARCH_TITLE_STRING];
    
    //Add target to cancel button
    [customModalViewController.cancelButton addTarget:self action:@selector(removeCustomModalViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
    
    //Animate view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, customModalViewController.view.frame.origin.y-offset-64, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)clickResetButton:(id)sender
{
    [self getDataFromServer];
}

//Method gets called when "Remove Address" button is clicked 
-(void)clickRemoveAddress:(id)sender
{
    
    //select index of selected address
    
    UIButton *button = (UIButton*)sender;
    UIView *parentCell = [button superview];
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    
    while (![parentView isKindOfClass:[UITableView class]]) {
        parentView = parentView.superview;
    }
    
    //UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath;// = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        indexPath = [custDetailAddressTable indexPathForCell:(UITableViewCell *)parentCell];
    }
    else
    {
        indexPath = [custDetailAddressTableOrg indexPathForCell:(UITableViewCell *)parentCell];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    int row = (int)indexPath.row;
    
    //Set selected address index
    selectedAddressIndex = row;
    
    //Clear server response label
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
    removeAddressButtonClicked = TRUE;
    btn = (UIButton*) sender;
    frameInWindow = [btn.superview convertRect:btn.frame toView:self.view];
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        //Need more than 1 addresses in the territory to be shown in duplicate address screen.
        int addressCount = 0;
        CustomerObject *customerObj = (CustomerObject*)[individualsData objectAtIndex:selectedIndexCustData];
        for (int i = 0; i<customerObj.pendingCustBpaIds.count; i++) {
            if([[customerObj.pendingCustBpaIds objectAtIndex:i] integerValue]==0)
                addressCount ++;
        }
        if(addressCount > 1)
        {
            selectedReasonForRemoval = [NSString stringWithFormat:@"Duplicate Address"];
            [self showDuplicateAddressScreen];
        }
        else
        {
            
            //Need to ask for reason
            selectedReasonForRemoval = [NSString stringWithFormat:@"Moved out of territory"];
            /*Add UIAlertController
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"Address Removal" message:ADDRESS_REMOVAL_MESSAGE delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil];
            [alView show];*/
            //[self clickRemoveCustomerAddress];
            UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:ADDRESS_REMOVAL_STRING  message:ADDRESS_REMOVAL_MESSAGE  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:OK_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                isSingleAddress= YES;
                [self clickRemoveCustomerAddress];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:CANCEL_STRING style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else    //Do not display popup of reasons for removal for organizations.
    {
        [self clickRemoveCustomer];
    }
    
}

- (void)showDuplicateAddressScreen
{
    //Implement duplicate Address Screen here
    //[self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    if(mlpModalviewController)
    {
        mlpModalviewController = nil;
    }
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TabBarView" bundle:nil];
    mlpModalviewController = [sb instantiateViewControllerWithIdentifier:@"MLPAddressViewController"];
    self.mlpModalviewController.duplicateAddressDataDelegate = self;
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + mlpModalviewController.view.frame.size.height;
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    
    mlpModalviewController.nameAnsLabel.text = nameText.text;
    mlpModalviewController.secSpeLabel.hidden = YES;
    mlpModalviewController.secSpeAnsLabel.hidden= YES;
    mlpModalviewController.NPILabel.hidden = NO;
    mlpModalviewController.NPIAnsLabel.hidden = NO;
    mlpModalviewController.primarySpeAnsLabel.hidden = YES;
    mlpModalviewController.primarySpeLabel.hidden = YES;
    mlpModalviewController.addressLabel.hidden = NO;
    
    [responseArrayforDuplicateAddress removeAllObjects];
    responseArrayforDuplicateAddress = nil;
    responseArrayforDuplicateAddress = [[NSMutableArray alloc] init];
    
    NSString *str1,*str2;
    AddressObject * selectedItem;
    if(selectedAddressIndex < selectedCustDetailAddress.count)
        selectedItem = (AddressObject*)[selectedCustDetailAddress objectAtIndex:selectedAddressIndex];
    for(int addressCount=0; addressCount < selectedCustDetailAddress.count; addressCount++)
    {
        AddressObject *addressObject = [selectedCustDetailAddress objectAtIndex:addressCount];
        str1 = [NSString stringWithFormat:@"%@",addressObject.BPA_ID];
        str2 = [NSString stringWithFormat:@"%@",selectedItem.BPA_ID];
        if([str1 isEqualToString:str2])
        {
            mlpModalviewController.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@ %@",selectedItem.addressLineOne,selectedItem.city,selectedItem.state,selectedItem.zip];
            mlpModalviewController.masterIDAnsLabel.text = [NSString stringWithFormat:@"%@",selectedItem.BPA_ID];
            mlpModalviewController.NPILabel.text = [NSString stringWithFormat:@"Address Type:"];
            mlpModalviewController.NPIAnsLabel.text = [NSString stringWithFormat:@"%@",selectedItem.addr_usage_type];
        }
        else
        {
            CustomerObject *customerObj = (CustomerObject*)[individualsData objectAtIndex:selectedIndexCustData];
            if([[customerObj.pendingCustBpaIds objectAtIndex:addressCount] integerValue] == 0)
            {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
                NSString * bpaIdString =  [NSString stringWithFormat:@"%@",addressObject.BPA_ID];
                [item setObject:bpaIdString forKey:@"bpaId"];
                NSString *addressType = [NSString stringWithFormat:@"%@",addressObject.addr_usage_type];
                [item setObject:addressType forKey:@"addrUsageType"];
                NSString * addressString = [NSString stringWithFormat:@"%@ %@, %@ %@", addressObject.addressLineOne, addressObject.city, addressObject.state, addressObject.zip];
                [item setObject:addressString forKey:@"address"];
                [responseArrayforDuplicateAddress addObject:item];
            }
        }
    }
    
    
    //remove spinner view
    [Utilities removeSpinnerFromView:self.view];
    
    //Set data
    mlpModalviewController.customTableViewController.customerDataOfMLPModalViewDelegate = self;
    mlpModalviewController.customTableViewController.isIndividual = [[DataManager sharedObject]isIndividualSegmentSelectedForAddCustomer];
    mlpModalviewController.customTableViewController.dataArray = [[NSArray alloc] init];
    mlpModalviewController.customTableViewController.popUpScreenTitle = DUPLICATE_ADDRESS_SCREEN;
    mlpModalviewController.customTableViewController.dataArray = responseArrayforDuplicateAddress;
    
    [mlpModalviewController.titleLabel setText:DUPLICATE_ADDRESSES_REMOVAL_SCREEN];
    
    [self addChildViewController:mlpModalviewController];
    [self.view addSubview:mlpModalviewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, mlpModalviewController.view.frame.origin.y-offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) getDuplicateAddressRemovalReasonWithString:(NSString *)removalReasonString andAddressArrays:(NSArray*)bpaArray
{
    if (self.additionalAddressesForRemoval) {
        self.additionalAddressesForRemoval= nil;
    }
    self.additionalAddressesForRemoval = removalReasonString;
    NSString *reasonString = [NSString stringWithFormat:@"%@",MOVED_OUT_OF_TERRITORY_STRING];
    selectedReasonForRemoval = [NSString stringWithFormat:@"%@",reasonString];
    bpaIdArray = [[NSArray alloc] initWithArray:bpaArray];
    
    //remove mlpModalViewController.m once response received - in receivedata.... method
    [mlpModalviewController.view removeFromSuperview];
    [self clickRemoveCustomerAddress];
}

-(void) getDuplicateAddressRemovalReasonWithString:(NSString *)removalReasonString
{
    //NSLog(@"Impment function for done on duplicate poup closed. call delete request");
    //NSString *reasonString = [NSString stringWithFormat:@"%@%@",MOVED_OUT_OF_TERRITORY_STRING,removalReasonString];
    if (self.additionalAddressesForRemoval) {
        self.additionalAddressesForRemoval= nil;
    }
    self.additionalAddressesForRemoval = removalReasonString;
    NSString *reasonString = [NSString stringWithFormat:@"%@",MOVED_OUT_OF_TERRITORY_STRING];
    selectedReasonForRemoval = [NSString stringWithFormat:@"%@",reasonString];//[NSString stringWithFormat:<#(NSString *), ...#>]
    
    //remove mlpModalViewController.m once response received - in receivedata.... method
    [mlpModalviewController.view removeFromSuperview];
    [self clickRemoveCustomerAddress];
}


- (void)clickRemoveCustomerAddress
{
    if (!isSingleAddress)
    {
      [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    //NSLog(@"row#: %d, reason:%@",(int)selectedAddressIndex,selectedReasonForRemoval);
    
    //if([selectedReasonForRemoval isEqualToString:@"Duplicate Address"])
    //{
    
    //Call showDuplicateAddressScreen method
    [completeDuplicateAddressArray removeAllObjects];
    [responseArrayforDuplicateAddress removeAllObjects];
    completeDuplicateAddressArray = nil;
    responseArrayforDuplicateAddress = nil;
    responseArrayforDuplicateAddress = [[NSMutableArray alloc] init];//reset on receiveddata method
    completeDuplicateAddressArray = [[NSMutableArray alloc] init];
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        //Set connectionInProgress flag
        isConnectionInProgress = TRUE;
        
        //Add spinner
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        
        //Form URL
        NSMutableString *removeAddressUrl = [[NSMutableString alloc] initWithString:REMOVE_ADDRESS_URL];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *connectionIdentifier = nil;
        
        if(selectedIndexCustData < individualsData.count && selectedAddressIndex < selectedCustDetailAddress.count){
            ////////////// Changes
            CustomerObject *customerObj;
            //= [[CustomerObject alloc] init];
            customerObj = (CustomerObject*)[individualsData objectAtIndex:selectedIndexCustData];
            AddressObject *addressObj;
            //=[[AddressObject alloc]init];
            
            //////////////
            addressObj = (AddressObject*)[selectedCustDetailAddress objectAtIndex:selectedAddressIndex];
            NSMutableString *bpa_id = [NSMutableString stringWithString:@""];
            
            if (isSingleAddress) {
                isSingleAddress=NO;
                self.additionalAddressesForRemoval= nil;
                [bpa_id appendFormat:@"%@", addressObj.BPA_ID];
                
                
            }
            else
            {
                if( self.additionalAddressesForRemoval )    {
                    [bpa_id appendFormat:@"%@%@", addressObj.BPA_ID, self.additionalAddressesForRemoval];
                }
                else    {
                    [bpa_id appendFormat:@"%@", addressObj.BPA_ID];
                }
            }
            [removeAddressUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [removeAddressUrl appendFormat:@"&bp_id=%@", customerObj.custBPID];
            [removeAddressUrl appendFormat:@"&bpa_id=%@", bpa_id];
            [removeAddressUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
            [removeAddressUrl appendFormat:@"&removal_cd=%@", MOOT_STRING];
            [removeAddressUrl appendFormat:@"&removal_desc=%@",selectedReasonForRemoval];
            [removeAddressUrl appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
            connectionIdentifier = @"RemoveIndividualCustomerAddress";
            
            //NSLog(@"%@",removeAddressUrl);
            
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:@"DELETE" forKey:@"request_type"];
            
            //Remove Address Protocol: removeAddress
            ConnectionClass *connection = [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[removeAddressUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        latestConnectionIdentifier = connectionIdentifier;
    }
}

-(IBAction)valueChangedSegmentControl:(UISegmentedControl *)segment
{
    //Reset selectedReasonForRemoval as it has different values for indv and org
    selectedReasonForRemoval = @"";
    
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
            if(!removeAddressButtonClicked)
            {
                reasonForCustomerRemovalArray = [[JSONDataFlowManager sharedInstance]reasonForCustomerRemovalArray];
            }
            else
            {
                
                reasonForCustomerAddressRemovalArray = [[JSONDataFlowManager sharedInstance] reasonForCustomerAddressRemovalArray];
            }
            
            //Enable or Disable Reset button
            [self.resetButton setEnabled:(self.latestSuccessfulIndvSearchUrl.length ? YES : NO)];
            
            if([[DataManager sharedObject] isDefaultRequestForRemoveCustomer] || !indvSearchParameters || indvSearchParameters.count==0)
            {
                if(indvSearchParameters==nil)
                    indvSearchParameters = [[NSMutableDictionary alloc] init];
                
                [self getDataFromServer];
            }
            else
            {
                //Request last search result
                if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForRemoveCustomer])
                {
                    [self refreshPreviousSearchResult];
                }
            }
        }
        else    //Organization
        {
            [detailView setHidden:YES];
            [detailViewOrg setHidden:NO];
            if(!removeAddressButtonClicked)
            {
                reasonForCustomerRemovalArray = [[JSONDataFlowManager sharedInstance]reasonForOrgRemovalArray];
            }
            else
            {
                reasonForCustomerAddressRemovalArray = [[JSONDataFlowManager sharedInstance] reasonForCustomerAddressRemovalArray];
            }
            
            //Enable or Disable Reset button
            [self.resetButton setEnabled:(self.latestSuccessfulOrgSearchUrl.length ? YES : NO)];
            
            if([[DataManager sharedObject] isDefaultRequestForRemoveCustomer] || !orgSearchParameters || orgSearchParameters.count==0)
            {
                if(orgSearchParameters == nil)
                    orgSearchParameters = [[NSMutableDictionary alloc] init];
                
                [self getDataFromServer];
            }
            else
            {
                //Request last search result
                if(!isConnectionInProgress && ![[DataManager sharedObject] isDefaultRequestForRemoveCustomer])
                {
                    [self refreshPreviousSearchResult];
                }
            }
        }
    }
}

-(IBAction)clickSubmitForRemoval:(id)sender
{
    removeAddressButtonClicked = FALSE;
    UIButton *button = sender;
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        [self presentReasonCodesPopoverFromRect:button.frame inView:self.view withNote:nil];
    }
    else    //Do not display popup of reasons for removal for organizations.
    {
        /*Add UIAlertController
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"Organisation Removal" message:ORGANISATION_REMOVAL_STRING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:CANCEL_STRING, nil];
        [alertView show];*/
        //Call to remove organisation after popup
        //[self clickRemoveCustomer];
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Organisation Removal"  message:ORGANISATION_REMOVAL_STRING  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:OK_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self clickRemoveCustomer];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:CANCEL_STRING style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//To remove customer with reason "Deceased" / "Retired" as customer removal reason
-(void)removeCustomerRequest
{
    //Clear server response label
    if(!removeAddressButtonClicked)
    {
        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
        
      [self dismissViewControllerAnimated:YES completion:nil];
        //[self showDuplicateAddressScreen];
        
        //Set connectionInProgress flag
        isConnectionInProgress = TRUE;
        
        //Add spinner
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        
        //Form URL
        NSMutableString *removeCustomerUrl = [[NSMutableString alloc] initWithString:REMOVE_CUSTOMER_URL];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *connectionIdentifier = nil;
        
        //Add required parameters to URL
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])   //Individuals
        {
            CustomerObject *selectedCustomerData = [individualsData objectAtIndex:selectedIndexCustData];
            
            [removeCustomerUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [removeCustomerUrl appendFormat:@"&bp_id=%@", selectedCustomerData.custBPID];
            [removeCustomerUrl appendFormat:@"&reason_code=%@",[selectedReasonForRemoval substringToIndex:1]];
            [removeCustomerUrl appendFormat:@"&reason_desc=%@",selectedReasonForRemoval];
            [removeCustomerUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
            [removeCustomerUrl appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
            connectionIdentifier = @"RemoveIndividualCustomer";
        }
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:@"DELETE" forKey:@"request_type"];
        
        //NSLog(@"link:%@",removeCustomerUrl);
        //Protocol: removeCustomer
        ConnectionClass *connection = [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[removeCustomerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
}

//To customer removal workflow
-(void)clickRemoveCustomer
{
    //Code for "Deceased" & "Retired" as customer removal reason
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer] &&
       ([selectedReasonForRemoval isEqualToString:@"Deceased"] ||
        [selectedReasonForRemoval isEqualToString:@"Retired"]))
    {
        /*Add UIAlertController
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"Customer Removal" message:REMOVE_CUSTOMER_ALERT_MSG delegate:self cancelButtonTitle:@"OK" otherButtonTitles:CANCEL_STRING, nil];
        [alertView show];*/
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Customer Removal"  message:REMOVE_CUSTOMER_ALERT_MSG  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:OK_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self removeCustomerRequest];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:CANCEL_STRING style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController.visibleViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    //Code for "Recommeded for Removal" as customer removal reason
    if(!removeAddressButtonClicked)
    {
        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //Set connectionInProgress flag
        isConnectionInProgress = TRUE;
        
        //Add spinner
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        
        //Form URL
        NSMutableString *removeCustomerUrl = [[NSMutableString alloc] initWithString:REMOVE_CUSTOMER_URL];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString	 *connectionIdentifier = nil;
        
        //Add required parameters to URL
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])   //Individuals
        {
            CustomerObject *selectedCustomerData = [individualsData objectAtIndex:selectedIndexCustData];
            
            [removeCustomerUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [removeCustomerUrl appendFormat:@"&bp_id=%@", selectedCustomerData.custBPID];
            [removeCustomerUrl appendFormat:@"&reason_code=%@", @"RR"];
            // Changes based on Recommended
            [removeCustomerUrl appendFormat:@"&reason_desc=%@", @"Recommended for removal"];
            [removeCustomerUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
            [removeCustomerUrl appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
            
            connectionIdentifier = @"RemoveIndividualCustomer";
            
        }
        else{   //Organizations
            
            OrganizationObject *selectedOrgData = [organizationsData objectAtIndex:selectedIndexCustData];
            
            [removeCustomerUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [removeCustomerUrl appendFormat:@"&bp_id=%@", selectedOrgData.orgBPID];
            
            //For organizations pass empty string as reason for removal because this is mandatory parameter at server side
             [removeCustomerUrl appendFormat:@"&reason_desc=%@", @"Recommended for removal"];
            [removeCustomerUrl appendFormat:@"&reason_code=%@", @" "];
            //[removeCustomerUrl appendFormat:@"&reason_code=%@", @"RR"];
            //[removeCustomerUrl appendFormat:@"&reason_desc=%@", @"Recommended for Removal"];
            [removeCustomerUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
            
            connectionIdentifier =@"RemoveOrganization";
        }
        
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:@"DELETE" forKey:@"request_type"];
        
        ConnectionClass *connection = [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[removeCustomerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:connectionIdentifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
}

-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];

    // Present the view controller using the popover style.
    listViewController.modalPresentationStyle = UIModalPresentationPopover;
    
     listViewController.delegate=self;

    // Get the popover presentation controller and configure it.
    listPopOverController  = [listViewController popoverPresentationController];
    CGRect presentFromRect = [self.navigationItem.titleView convertRect:changeTerritoryBtn.frame toView:self.view];
    presentFromRect.origin.y -=5;
    listViewController.popoverPresentationController.sourceRect = presentFromRect;
    listViewController.popoverPresentationController.sourceView = self.view;
    listViewController.preferredContentSize= CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
//    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor whiteColor];
    listPopOverController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    [self presentViewController:listViewController animated: YES completion: nil];
    //CGRectMake(changeTerritoryBtn.frame.origin.x+19 , changeTerritoryBtn.frame.origin.y-50, listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    //changeTerritoryBtn.frame.size.height
    //changeTerritoryBtn.frame.origin.y-50
    //changeTerritoryBtn.frame.origin.x+19
    
}

-(void)clickCancelRemoval
{
   [self dismissViewControllerAnimated:YES completion:nil];
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
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
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
    isConnectionInProgress=TRUE;
    [[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:FALSE];;
    
    //Add spineer
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    //No default search parameters
    [self refreshSearchParametersView:nil];
    
    if(iSLiveApp)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableString *searchAlignmentsUrl= nil;
        NSString *connectionIdentifier = nil;
        
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            //Test URl : http://ps8411:8083/nexus-ws/CMService/requests/searchIndividualInAlignments?personnel_id=1&terr_id=1
            
            //Form URl
            searchAlignmentsUrl = [[NSMutableString alloc] initWithString:SEARCH_INDIVIDUAL_ALIGNMENTS_URL];
            
            //Set connection identifier
            connectionIdentifier = @"SearchIndividualInAlignments";
            
            //Set 'quickSearchType' which is used while parsing response
            [userDefaults setObject:INDV_REMOVE_SEARCH forKey:@"quickSearchType"];
        }
        else
        {
            //Form URl
            searchAlignmentsUrl = [[NSMutableString alloc] initWithString:SEARCH_ORGANIZATION_ALIGNMENTS_URL];
            
            //Set connection identifier
            connectionIdentifier = @"SearchOrganizationInAlignments";
            
            //Set 'quickSearchType' which is used while parsing response
            [userDefaults setObject:ORG_REMOVE_SEARCH forKey:@"quickSearchType"];
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
        connectionUrl = @"";
        latestConnectionIdentifier = connectionIdentifier;
    }
    else
    {
        
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            individualsData=[DummyData searchCustomerWithType:INDIVIDUALS_KEY];
        }
        else
        {
            organizationsData=[DummyData searchCustomerWithType:ORGANIZATIONS_KEY];
        }
        
        [customerListTable reloadData];
        
        //Remove Spinner and reset connectionInProgress flag
        isConnectionInProgress=FALSE;
        [Utilities removeSpinnerFromView:self.view];
        
        [self selectFirstItemFromList];
    }
}

-(void)refreshPreviousSearchResult
{
    //Conection dentifier should alway be that of default search
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
        if(self.latestSuccessfulIndvSearchUrl.length)
        {
            //Set 'quickSearchType' which is used while parsing response
            [userDefaults setObject:INDV_REMOVE_SEARCH forKey:@"quickSearchType"];
            
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
    else
    {
        if(self.latestSuccessfulOrgSearchUrl.length)
        {
            //Set 'quickSearchType' which is used while parsing response
            [userDefaults setObject:ORG_REMOVE_SEARCH forKey:@"quickSearchType"];
            
            //Set connectionInProgress flag
            isConnectionInProgress = TRUE;
            
            //Add spinner
            [Utilities addSpinnerOnView:self.view withMessage:nil];
            
            ConnectionClass *connection = [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[self.latestSuccessfulOrgSearchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchOrganizationInAlignments" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
            latestConnectionIdentifier = @"SearchOrganizationInAlignments";
        }
        else    //This should never get executed, added just for failsafe
        {
            [self getDataFromServer];
        }
    }
}

#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    

    //Parse Data for search response
    if([identifier isEqualToString:@"SearchOrganizationInAlignments"] || [identifier isEqualToString:@"SearchIndividualInAlignments"]  || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"]  || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"]  )
    {
        //Hide Remove Button Defautlt..When we get data from server and count >0 then we will unhide it
        removeBtn.enabled=FALSE;
        NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        DebugLog(@"Remove Customer Class | Recieve Data - %@ | Identifier - %@",jsonDataArrayOfObjects ,identifier);
        if(jsonDataArrayOfObjects!=nil)
        {
            if([identifier isEqualToString:@"SearchOrganizationInAlignments"] || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"])
            {
                BOOL isValidDataReceived = FALSE;
                NSMutableArray * serverData=[[Utilities parseJsonSearchOrganization:jsonDataArrayOfObjects] mutableCopy];
                if([serverData count]>0)
                {
                    organizationsData=serverData;
                    isValidDataReceived = [organizationsData count]>0;
                }
                
                [customerListTable reloadData];
                [searchParameterTable reloadData];
                [custDetailAddressTableOrg reloadData];
                
                if(isValidDataReceived)
                {
                    //First save latest successful search URL
                    [self saveLatestSearchUrl:connectionUrl];
                    
                    //Enable or Disable Reset button
                    [self.resetButton setEnabled:(self.latestSuccessfulOrgSearchUrl.length ? YES : NO)];
                    
                    [self selectFirstItemFromList];
                    removeBtn.enabled=TRUE;
                    
                    //On success, clear response label
                    [self updateServerResponseLabelWithText:@"" forIdentifier:identifier successOrFailure:TRUE];
                    
                    if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"])   //Remove custom modal view
                    {
                        //On success
                        //Refresh search parameters view
                        [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
                        
                        //Remove modal view with animation
                        [self removeCustomModalViewController];
                    }
                    else if([identifier isEqualToString:@"SearchOrganizationInAlignments"])
                    {
                        //Clear out search parameters view for default search
                        if(self.latestSuccessfulOrgSearchUrl.length == 0)
                        {
                            //Refresh search parameters view
                            [orgSearchParameters removeAllObjects];
                            [searchParameterTable reloadData];
                        }
                    }
                }
                else//Display error label
                {
                    if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        //Handle error response
                        if([identifier isEqualToString:@"SearchOrganizationInAlignments"])
                        {
                           /////// ******************
                            [self updateServerResponseLabelWithText:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:FALSE];
                            
                            
                        }
                        else if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"])
                        {
                            [self displayErrorMessage:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]];
                        }
                    }
                }
                NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
                NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
                NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
                if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_ORG_KEY]||[[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"])
                {
                    [submitForRemovalButton setEnabled:NO];
                }

            }
            else  if([identifier isEqualToString:@"SearchIndividualInAlignments"] || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
            {
                BOOL isValidDataReceived = FALSE;
                NSMutableArray * serverData=[[Utilities parseJsonSearchIndividual:jsonDataArrayOfObjects] mutableCopy];
                if([serverData count]>0)
                {
                    individualsData=serverData;
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
                    removeBtn.enabled=TRUE;
                    
                    //On success, clear response label
                    
                    if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
                    {
                        CustomerObject *custObj=[individualsData objectAtIndex:selectedIndexCustData] ;
                        if (custObj.isPendingText) {
                            [custObj setCustomerRemovalStatusMessage:nil];
                            [individualsData setObject:custObj atIndexedSubscript:selectedIndexCustData];
                            [self updateServerResponseLabelWithText:custObj.isPendingText forIdentifier:identifier successOrFailure:FALSE];
                            
                        }
                        else {
                            
                            [self updateServerResponseLabelWithText:@"" forIdentifier:identifier successOrFailure:TRUE];
                            
                        }
                        
                    }
                    else
                    {
                        
                        OrganizationObject *orgObj = [organizationsData objectAtIndex:selectedIndexCustData];
                        if ( orgObj.organisationRemovalStatusMessage)
                        {
                            [self updateServerResponseLabelWithText:orgObj.organisationRemovalStatusMessage forIdentifier:@"RemoveOrganization" successOrFailure:YES];
                        }
                        else
                        {
                            [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
                            
                        }
                        
                    }
                   
                    
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
                NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
                NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
                NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
                if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_INDV_KEY]||[[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"])
                {
                    [submitForRemovalButton setEnabled:NO];
                }

            }
        }
        else
        {
            //Handle error response
            if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"] ||
               [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
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
    
    //Parse data for remove response
    else if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"] || [identifier isEqualToString:@"RemoveOrganizationAddress"] || [identifier isEqualToString:@"RemoveIndividualCustomer"] || [identifier isEqualToString:@"RemoveOrganization"])
    {
        NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        DebugLog(@"Remove Customer Class | Recieve Data - %@ | Identifier - %@",jsonDictionary ,identifier);
        
        if(jsonDictionary!=nil)
        {
            //Remove customer address functioanlity is currently not added in app.
            if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"] || [identifier isEqualToString:@"RemoveOrganizationAddress"])
            {
                if([Utilities parseJsonAndCheckStatus:jsonDictionary])  //Success
                {
                    //Update server response label
                    [self updateServerResponseLabelWithText:[jsonDictionary objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:TRUE];
                }
                else    //Failure
                {
                    if(![[jsonDictionary objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        //Update server response label
                        [self updateServerResponseLabelWithText:[jsonDictionary objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:FALSE];
                    }
                }
            }
            
            if([identifier isEqualToString:@"RemoveIndividualCustomer"] || [identifier isEqualToString:@"RemoveOrganization"])
            {
                if([Utilities parseJsonAndCheckStatus:jsonDictionary])  //Success
                {
                    
                    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
                    {
                        CustomerObject *custObj = [individualsData objectAtIndex:selectedIndexCustData];
                        [custObj setCustomerRemovalStatusMessage:[jsonDictionary objectForKey:@"reasonCode"]];
                        custObj.isRequestedForRemoval = YES;
                        custObj.pendingCustRemovalReq = 1;
                        //Disable here
                        //                        [individualsData setObject:custObj atIndexedSubscript:selectedIndexCustData];
                        if (custObj.pendingCustRemovalReq==0) {
                            [submitForRemovalButton setEnabled:YES];
                        } else {
                            [submitForRemovalButton setEnabled:NO];
                            
                            if (custObj.isPendingText.length>0) {
                                [custObj setCustomerRemovalStatusMessage:nil];
                                
                                NSString *custRemoveCustomerStatus=custObj.isPendingText;
                                [self updateServerResponseLabelWithText:custRemoveCustomerStatus forIdentifier:identifier successOrFailure:FALSE];
                            }
                            [individualsData setObject:custObj atIndexedSubscript:selectedIndexCustData];
                            
                        }
                        [self updateServerResponseLabelWithText:[jsonDictionary objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:TRUE];
                       
                        [custDetailAddressTable reloadData];
                        
                        //Update server response label
                      
                        
                    }
                    else
                    {
                        OrganizationObject *orgObj = [organizationsData objectAtIndex:selectedIndexCustData];
                        orgObj.isRequestedForRemoval = YES;
                         [orgObj setOrganisationRemovalStatusMessage:[jsonDictionary objectForKey:@"reasonCode"]];
                        [organizationsData setObject:orgObj atIndexedSubscript:selectedIndexCustData];
                        [submitForRemovalButton setEnabled:NO];
                        //commented
                        /*if (orgObj.isRequestedForRemoval==0) {
                            [submitForRemovalButton setEnabled:YES];
                        } else {
                            [submitForRemovalButton setEnabled:NO];
                        }*/
//                        [custDetailAddressTableOrg reloadData];
                        [self updateServerResponseLabelWithText:[jsonDictionary objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:TRUE];
                        
                    }
                    
                    //Disable removal button
                    
                   
                }
                else    //Failure
                {
                    //Enable removal button
                    [submitForRemovalButton setEnabled:YES];
                    
                    if(![[jsonDictionary objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        //Update server response label
                        [self updateServerResponseLabelWithText:[jsonDictionary objectForKey:@"reasonCode"] forIdentifier:identifier successOrFailure:FALSE];
                    }
                }
            }
        }
        else
        {
            //Update server response label
            if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"] || [identifier isEqualToString:@"RemoveOrganizationAddress"])
                [self updateServerResponseLabelWithText:ERROR_NO_RESULTS_FOUND_TRY_AGAIN forIdentifier:identifier successOrFailure:FALSE];
            
            else
                [self updateServerResponseLabelWithText:ERROR_REMOVE_CUSTOMER_FAILED forIdentifier:identifier successOrFailure:FALSE];
            
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ErrorLog(@"Remove Customer Class | Connection Data - %@ | Identifier - %@",myString ,identifier);
        }
    }
    else if([identifier isEqualToString:@"ShowDuplicateAddressIndividualCustomerAddress"] || [identifier isEqualToString:@"ShowDuplicateAddressOrganizationAddress"])
    {
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        //completeDuplicateAddressArray = [[NSMutableArray alloc] init];
        
        if (!jsonArray) {
            [self updateServerResponseLabelWithText:ERROR_NO_RESULTS_FOUND_TRY_AGAIN forIdentifier:identifier successOrFailure:FALSE];
        }
        else
        {
            if(jsonArray.count == 0)
            {
                /*Add UIAlertController
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No records found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];*/
                [Utilities removeSpinnerFromView:self.view];
                UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Error"  message:@"No records found"  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:OK_STRING style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            //Multiple addresses received
            for(NSDictionary *item in jsonArray) {
                NSMutableDictionary *addressItem = [[NSMutableDictionary alloc] init];
                NSString * bpaIdString =  [NSString stringWithFormat:@"%@",[item objectForKey:@"bpaId"]];
                [addressItem setObject:bpaIdString forKey:@"bpaId"];
                
                NSString *addressType = [item objectForKey:@"addrUsageType"];
                
                [addressItem setObject:addressType forKey:@"addrUsageType"];
                
                NSString *city = [item objectForKey:@"city"];
                NSString *state = [item objectForKey:@"state"];
                NSString *zip = [item objectForKey:@"zip"];
                NSString *addressLine1 = [item objectForKey:@"addrLine1"];
                
                NSString * addressString = [NSString stringWithFormat:@" %@ %@, %@ %@", addressLine1 ,city, state, zip];
                [addressItem setObject:addressString forKey:@"address"];
                [completeDuplicateAddressArray addObject:addressItem];
            }
            //Show screen with received addresses.
            //[self showDuplicateAddressScreen];
        }
        
        
    }
    
    //Remove Spinner and reset connectionInProgress flag
    isConnectionInProgress=FALSE;
    [Utilities removeSpinnerFromView:self.view];
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    ErrorLog(@"Remove Customer Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    //Handle error response
    if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"] ||
       [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"])
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
-(void)processCustomerData:(NSArray *)data forIdentifier:(NSString*)identifier
{
    //Set connectionInProgress flag
    isConnectionInProgress=TRUE;
    
    //Add spinner on view
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    if([identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"] || [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"])
    {
        if(iSLiveApp)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableString *searchAlignmentsUrl= nil;
            NSString *connectionIdentifier = nil;
            
            if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0) //For individual
            {
                //Set connection identifier
                connectionIdentifier = @"RefineSearchForRemoveCustomerOfTypeIndividual";
                
                //Set 'quickSearchType' which is used while parsing response
                [userDefaults setObject:INDV_REMOVE_SEARCH forKey:@"quickSearchType"];
                
                //Individual customer data
                CustomerObject *customerDataObject = (CustomerObject*)[data objectAtIndex:0];
                
                //Form URl
                searchAlignmentsUrl = [[NSMutableString alloc] initWithString:SEARCH_INDIVIDUAL_ALIGNMENTS_URL];
                
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
                    /*
                     if ([[JSONDataFlowManager sharedInstance]selectedSpecialityIndex]) {
                     LOVData *data=[[[JSONDataFlowManager sharedInstance] specilalityArray] objectAtIndex:([[JSONDataFlowManager sharedInstance]selectedSpecialityIndex]-1)];
                     
                     [searchAlignmentsUrl appendFormat:@"primary_spec=%@&",data.code];
                     
                     }*/
                    
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
            }
            else    //For organization
            {
                //Test URL: http://ps8411:8082/nexus-ws/CMService/requests/searchOrganizationInAlignments?personnel_id=1&terr_id=1
                
                //Set connection identifier
                connectionIdentifier = @"RefineSearchForRemoveCustomerOfTypeOrganization";
                
                //Set 'quickSearchType' which is used while parsing response
                [userDefaults setObject:ORG_REMOVE_SEARCH forKey:@"quickSearchType"];
                
                //Organization customer data
                OrganizationObject *orgObj = (OrganizationObject*)[data objectAtIndex:0];
                
                //Form URl
                searchAlignmentsUrl = [[NSMutableString alloc] initWithString:SEARCH_ORGANIZATION_ALIGNMENTS_URL];
                
                if(orgObj.orgName !=nil && orgObj.orgName.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"org_name=%@&",orgObj.orgName];
                }
                
                if(orgObj.orgType !=nil && orgObj.orgType.length!=0 && [[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:orgObj.orgType].count)
                {
                    [searchAlignmentsUrl appendFormat:@"org_type=%@&",[[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:orgObj.orgType] objectAtIndex:0]];
                }
                
                if(orgObj.orgBPID !=nil && orgObj.orgBPID.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"bp_id=%@&",orgObj.orgBPID];
                }
                
                AddressObject *customerAddress = [orgObj.orgAddress objectAtIndex:0];
                if(customerAddress.street !=nil && customerAddress.street.length!=0)
                {
                    //Street is used as Address line 1 at server side
                    [searchAlignmentsUrl appendFormat:@"street=%@&",customerAddress.street];
                }
                if(customerAddress.building !=nil && customerAddress.building.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"building=%@&",customerAddress.building];
                }
                if(customerAddress.suite !=nil && customerAddress.suite.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"suite=%@&",customerAddress.suite];
                }
                if(customerAddress.state !=nil && customerAddress.state.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"state=%@&",customerAddress.state];
                }
                if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"zip=%@&",customerAddress.zip];
                }
                if(customerAddress.city !=nil && customerAddress.city.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"city=%@&",customerAddress.city];
                }
                if(customerAddress.addr_usage_type != nil && customerAddress.addr_usage_type.length!=0)
                {
                    [searchAlignmentsUrl appendFormat:@"addr_usage_type=%@&", customerAddress.addr_usage_type];
                }
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
            if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
            {
                individualsData=[DummyData searchCustomerWithType:INDIVIDUALS_KEY];
                //Refresh search parameters view
                [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
            }
            else
            {
                organizationsData=[DummyData searchCustomerWithType:ORGANIZATIONS_KEY];
                //Refresh search parameters view
                [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
            }
            
            [customerListTable reloadData];
            
            //Remove Spinner and reset connectionInProgress flag
            isConnectionInProgress=FALSE;
            [Utilities removeSpinnerFromView:self.view];
            
            [self selectFirstItemFromList];
        }
    }
}

-(void)displayErrorMessage:(NSString *)errorMsg
{
    [customModalViewController displayErrorMessage:errorMsg];
}

- (NSArray *) getReasonsForCustRemoval  {
    
    NSArray *arrReasonForCustRemoval = reasonForCustomerRemovalArray;
    CustomerObject* selectedCustObject = nil;
    if( [individualsData count] > selectedIndexCustData )
    {
        selectedCustObject = [individualsData objectAtIndex:selectedIndexCustData];
        if ( ![selectedCustObject.custType isEqualToString:@"Prescriber"] ) {
            arrReasonForCustRemoval = @[ reasonForCustomerRemovalArray[2] ];
        }
    }
    return arrReasonForCustRemoval;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==searchParameterTable)
    {
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
        {
            return [[indvSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] count];
        }
        else
        {
            return [[orgSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] count];
        }
    }
    else if(tableView==customerListTable)
    {
        NSInteger dataCount = 0;
        
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            dataCount = individualsData.count;
        }
        else
        {
            dataCount = organizationsData.count;
        }
        
        //Show info button and enable 'Submit for removal' button only if data received
        if(dataCount>0)
        {
            //Show info button only if data received is for more than 25
            if(dataCount>=MAX_SEARCH_RESULT_COUNT)
            {
                [infoBtn setHidden:NO];
            }
            else
            {
                [infoBtn setHidden:YES];
            }
        }
        else
        {
            [infoBtn setHidden:YES];
            [submitForRemovalButton setEnabled:NO];
            
            //Clear previous customer details
            [self refreshCustomerDetailOfIndex:-1];
        }
        
        return dataCount;
    }
    else if(tableView==custDetailAddressTable)
    {
        return [selectedCustDetailAddress count];
    }
    else if (tableView==custDetailAddressTableOrg)
    {
        return [selectedOrgDetailAddress count];
    }
    else if(tableView==reasonForRemovalTableView)
    {
        if(!removeAddressButtonClicked)
        {
            return [[self getReasonsForCustRemoval] count];
        }
        else
        {
            return [reasonForCustomerAddressRemovalArray count];
        }
    }
    else if (tableView==reasonForCustomerAddressRemovalTable)
    {
        return [reasonForCustomerAddressRemovalArray count];
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
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [cellTemp.textLabel setTextColor:THEME_COLOR];
        
        if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
        {
            NSString *rowName = [[self.indvSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] objectAtIndex:indexPath.row];
            [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [self.indvSearchParameters objectForKey:rowName]]];
        }
        else
        {
            NSString *rowName = [[self.orgSearchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] objectAtIndex:indexPath.row];
            [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [self.orgSearchParameters objectForKey:rowName]]];
        }
        return cellTemp;
    }
    else  if(tableView==customerListTable)
    {
        static NSString *CellIdentifier = @"customerList";
        
        CustomerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerInfoCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell.nameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
        [cell.specialtyAndTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        
        
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
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
            if(custObj.custSuffix!=nil && custObj.custSuffix.length)
            {
                [nameArray addObject:custObj.custSuffix];
            }
            cell.nameLabel.text=[nameArray componentsJoinedByString:@" "];
            
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
            
        }
        else
        {
            OrganizationObject* orgObj=[organizationsData objectAtIndex:indexPath.row ];
            if(orgObj.orgName!=nil)
            {
                [cell.nameLabel setText:[NSString stringWithFormat:@"%@",orgObj.orgName]];
            }
            if(orgObj.orgType!=nil)
            {
                [cell.specialtyAndTypeLabel setText:[NSString stringWithFormat:@"%@",[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] objectForKey:orgObj.orgType]]];
            }
        }
        
        //Set Normal Color Color
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
        
        CustomerAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerAddressDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [cell.imageType setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"map_thumb"]]];
        
        
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
        [cell.addTerritoryBtn setImage:[UIImage imageNamed:@"btn_removeAddress"] forState:UIControlStateNormal];
        [cell.addTerritoryBtn addTarget:self action:@selector(clickRemoveAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        //error Label
        [cell.responseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
//        [cell.responseLabel setTextColor:[UIColor redColor]];
        [cell.responseLabel setText:@""];
        [cell.responseLabel setNumberOfLines:3];
        
        
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        AddressObject* addObj=nil;
        if(selectedCustDetailAddress.count>indexPath.row)
            addObj = [selectedCustDetailAddress objectAtIndex:indexPath.row ];
        
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        
        if(addObj.addressLineOne!=nil)
        {
            [arr addObject:addObj.addressLineOne];
        }
        if(addObj.addressLineTwo!=nil)
        {
            [arr addObject:addObj.addressLineTwo];
        }
        //Commenting deprecated method sizeWithFont:
        //CGSize size = [[arr componentsJoinedByString:@", "] sizeWithFont:cell.add1.font];
        
        //Adding new method for deprecated method here
        CGSize size = [[arr componentsJoinedByString:@", "] sizeWithAttributes:@{NSFontAttributeName:cell.add1.font}];
        if (size.width > cell.add1.bounds.size.width) {
            [cell.add1 setNumberOfLines:2];
            [cell.add1 setFrame:CGRectMake(140, 20, 400, 40)];
            [cell.add2 setFrame:CGRectMake(140, 60, 400, 25)];
            [cell.add3 setFrame:CGRectMake(140, 85, 400, 25)];
        }
        else
        {
            [cell.add1 setNumberOfLines:1];
            [cell.add1 setFrame:CGRectMake(140, 20, 400, 25)];
            [cell.add2 setFrame:CGRectMake(140, 45, 400, 25)];
            [cell.add3 setFrame:CGRectMake(140, 70, 400, 25)];
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
            [cell.responseLabel setTextColor:THEME_COLOR];
            cell.responseLabel.text=addObj.errorlLabel;
        }

        CustomerObject *selectedCustObject;
        NSString *customerAddressRemovalStatus;
        BOOL isCustRequestedForRemoval = NO;
        if( [individualsData count] > 0 ) {
            selectedCustObject = [individualsData objectAtIndex:selectedIndexCustData];
            isCustRequestedForRemoval = selectedCustObject.isRequestedForRemoval;
            
        }
        
        if (selectedCustObject.isPendingText || selectedCustObject.customerRemovalStatusMessage)
        {
            cell.addTerritoryBtn.enabled = FALSE;
            cell.responseLabel.text=@"";

        }
        else
        {
            
            if(isCustRequestedForRemoval || [addObj.isAddedToTerritory isEqualToString:@"Yes"] || [[selectedCustObject.pendingCustBpaIds objectAtIndex:indexPath.row] integerValue]==1)
            {
                
                cell.addTerritoryBtn.enabled=FALSE;
                
                if (selectedCustObject.pendingBpaTexts.count) {
                    
                    for (int i=0; i<selectedCustObject.pendingBpaTexts.count; i++) {
                        
                        if ([selectedCustObject.pendingBpaTexts objectAtIndex:i]) {
                            
                            customerAddressRemovalStatus= [selectedCustObject.pendingBpaTexts objectAtIndex:i];
                            cell.responseLabel.text=customerAddressRemovalStatus;
                            
                            [cell.responseLabel setTextColor:[UIColor redColor]];
                            break;
                        }
                        
//                        break;
                        
                    }
                   
                }
            }
            else
            {
                cell.addTerritoryBtn.enabled=TRUE;
                cell.responseLabel.text=@"";
            }
    
        }
        
        NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
        NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
        
        if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_INDV_KEY]||[[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"])
        {
            cell.addTerritoryBtn.enabled = NO;
        }


        //TODO: To be enabled  in Phase 2  as suggested by ZS 11 Sep 13
        cell.addTerritoryBtn.hidden=FALSE;

        //Set Normal Color Color
        UIView *bgColorNormalView = [[UIView alloc] init];
        [bgColorNormalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
        
        [cell setBackgroundView:bgColorNormalView];
        
        return cell;
    }
    else if(tableView==custDetailAddressTableOrg)
    {
        static NSString *CellIdentifier = @"OrgAddressSelected";
        
        CustomerAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerAddressDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        
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
        [cell.addTerritoryBtn setImage:[UIImage imageNamed:@"btn_removeAddress"] forState:UIControlStateNormal];
        
        [cell.addTerritoryBtn addTarget:self action:@selector(clickRemoveAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        //error Label
        [cell.responseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
        [cell.responseLabel setTextColor:[UIColor redColor]];
        [cell.responseLabel setText:@""];
        
        
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        AddressObject* addObj=nil;
        if(selectedOrgDetailAddress.count>indexPath.row)
            addObj = [selectedOrgDetailAddress objectAtIndex:indexPath.row ];
        
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        
        if(addObj.addressLineOne!=nil)
        {
            [arr addObject:addObj.addressLineOne];
        }
        if(addObj.addressLineTwo!=nil)
        {
            [arr addObject:addObj.addressLineTwo];
        }
        
        //Commenting deprecated method sizeWithFont: and replacing with sizeWithAttributes:
        //CGSize size = [[arr componentsJoinedByString:@", "] sizeWithFont:cell.add1.font];
        CGSize size = [[arr componentsJoinedByString:@", "] sizeWithAttributes:@{NSFontAttributeName:cell.add1.font}];
        if (size.width > cell.add1.bounds.size.width) {
            [cell.add1 setNumberOfLines:2];
            [cell.add1 setFrame:CGRectMake(140, 20, 400, 40)];
            [cell.add2 setFrame:CGRectMake(140, 60, 400, 25)];
            [cell.add3 setFrame:CGRectMake(140, 85, 400, 25)];
        }
        else
        {
            [cell.add1 setNumberOfLines:1];
            [cell.add1 setFrame:CGRectMake(140, 20, 400, 25)];
            [cell.add2 setFrame:CGRectMake(140, 45, 400, 25)];
            [cell.add3 setFrame:CGRectMake(140, 70, 400, 25)];
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
            [cell.add3 setText:[NSString stringWithFormat:@"%@: %@",ADDRESS_TYPE_STRING, addObj.addr_usage_type]];
        }
        if(addObj.errorlLabel!=nil && ![addObj.errorlLabel isEqualToString:@""])
        {
            cell.responseLabel.text=addObj.errorlLabel;
        }
        else
        {
            cell.responseLabel.text=@"";
        }
        if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
        {
            cell.addTerritoryBtn.enabled=FALSE;
        }
        else
        {
            cell.addTerritoryBtn.enabled=TRUE;
        }
        //TODO: To be enabled  in Phase 2  as suggested by ZS 11 Sep 13
        cell.addTerritoryBtn.hidden=TRUE;
        
        //Set Normal Color Color
        UIView *bgColorNormalView = [[UIView alloc] init];
        [bgColorNormalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
        
        [cell setBackgroundView:bgColorNormalView];
        cell.add1.tag = 100 + indexPath.row;
        
        return cell;
    }
    else if(tableView==reasonForRemovalTableView)
    {
        static NSString *simpleTableIdentifier = @"reasonForRemovalTableView";
        UITableViewCell *cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cellTemp == nil) {
            cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cellTemp.tag=indexPath.row;
        cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
        if(!removeAddressButtonClicked)
        {
            //
            NSArray *arrReasonForCustRemoval = [self getReasonsForCustRemoval];
            cellTemp.textLabel.text=[arrReasonForCustRemoval objectAtIndex:indexPath.row];
        }
        else
        {
            cellTemp.textLabel.text=[reasonForCustomerAddressRemovalArray objectAtIndex:indexPath.row];
        }
        if(selectedReasonForRemoval.length==0 && indexPath.row==0)
        {
            [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
            selectedReasonForRemoval = cellTemp.textLabel.text;
        }
        else if([cellTemp.textLabel.text isEqualToString:selectedReasonForRemoval])
        {
            [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        return cellTemp;
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
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
        {
            CustomerObject *custObj=[individualsData objectAtIndex:indexPath.row] ;
            if (custObj.isPendingText) {
                [custObj setCustomerRemovalStatusMessage:nil];
                [individualsData setObject:custObj atIndexedSubscript:indexPath.row];
                [self updateServerResponseLabelWithText:custObj.isPendingText forIdentifier:@"RemoveIndividualCustomer" successOrFailure:FALSE];
                
            }
            else {
                
                if ( custObj.customerRemovalStatusMessage)
                {
                    [self updateServerResponseLabelWithText:custObj.customerRemovalStatusMessage forIdentifier:@"RemoveIndividualCustomer" successOrFailure:YES];
                }
                else
                {
                    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
                    
                }
            }
            
            
            //        }
            
            //        [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
           
        }
        else    ///for Organisation
        {
            
            OrganizationObject *orgObj = [organizationsData objectAtIndex:indexPath.row];
            if ( orgObj.organisationRemovalStatusMessage)
            {
                [self updateServerResponseLabelWithText:orgObj.organisationRemovalStatusMessage forIdentifier:@"RemoveOrganization" successOrFailure:YES];
            }
            else
            {
                [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:YES];
                
            }            
        }
         [self refreshCustomerDetailOfIndex:indexPath.row];
       
    }
    else if(tableView==reasonForRemovalTableView)
    {
        
        UITableViewCell * cell=[reasonForRemovalTableView cellForRowAtIndexPath:indexPath];
        selectedReasonForRemoval=cell.textLabel.text;
        [reasonForRemovalTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchParameterTable)
    {
        return 19.0;
    }
    else if(tableView==custDetailAddressTable || tableView==custDetailAddressTableOrg)
    {
        return 165.0;
    }
    else
    {
        return 44.0;
    }
}


#pragma mark -

#pragma mark Popover Presentation Controller Delegate

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    [changeTerritoryBtn setSelected:NO];
    return YES;
}

// Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    
}

#pragma mark -

#pragma mark List View Custom Delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
//    [listPopOverController dismissPopoverAnimated:NO];
//    [listPopOverController dismissPopoverAnimated:NO];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
-(void)refreshCustomerDetailOfIndex:(NSInteger)index
{
//    serverResponseLabel.text=@"";
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    
    //Clear previous details
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])
    {
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
    }
    else
    {
        organizationTypeText.text = @"";
        orgNameText.text = @"";
        orgBPIDText.text = @"";
        orgValidationStatusText.text = @"";
        subClassificationText.text = @"";
    }
    
    //Return if index is out of bounds
    if(index<0)
    {
        return;
    }
    
    if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
    {
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
        if(selectedCustObject.custSuffix!=nil && selectedCustObject.custSuffix.length)
        {
            [nameArray addObject:selectedCustObject.custSuffix];
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
        secondarySpecialtyText.text = [secondarySpeciltyArray componentsJoinedByString:@" - "];
        
        //BPID
        if(selectedCustObject.custBPID!=nil)
        {
            BPIDText.text=[NSString stringWithFormat:@"%@",selectedCustObject.custBPID];
        }
        else
        {
            BPIDText.text = nil;
        }
        
        //NPI
        if(selectedCustObject.custNPI!=nil)
        {
            NPIText.text=[NSString stringWithFormat:@"%@",selectedCustObject.custNPI ];
        }
        else
        {
            NPIText.text = nil;
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
        
        //Professional Designation
        if(selectedCustObject.custProfessionalDesignation!=nil)
        {
            professionalText.text=[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] objectForKey:selectedCustObject.custProfessionalDesignation];
        }
        else
        {
            professionalText.text = nil;
        }
        
        //Addresses
        [selectedCustDetailAddress removeAllObjects];
        for(AddressObject* add in selectedCustObject.custAddress)
        {
            [selectedCustDetailAddress addObject:add];
        }
        if([selectedCustDetailAddress count]==0)
        {
            [custDetailAddressTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }
        else
        {
            [custDetailAddressTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
        
      
        //Enable or diable removal button
        NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
        NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
        
        if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_INDV_KEY] || [[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"])
        {
            [submitForRemovalButton setEnabled:NO];
        }
        else
        {
            if(selectedCustObject.isRequestedForRemoval || (selectedCustObject.pendingCustRemovalReq == 1))
            {
                [submitForRemovalButton setEnabled:NO];
                if (selectedCustObject.isPendingText.length>0) {
                    NSString *custRemoveCustomerStatus=selectedCustObject.isPendingText;
                    [self updateServerResponseLabelWithText:custRemoveCustomerStatus forIdentifier:@"RemoveIndividualCustomer" successOrFailure:FALSE];
                }
            }
            else
            {
                [submitForRemovalButton setEnabled:YES];
                [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
            }
        }
        [self.submitForRemovalButton setHidden:NO];
        [custDetailAddressTable reloadData];
//                if()
//                {
//        
//                    [self.submitForRemovalButton setEnabled:NO];
//                }
//                else
//                {
//                    [self.submitForRemovalButton setEnabled:YES];
//                }
        
    }
    else
    {
        OrganizationObject  * selectedOrgObject = nil;
        
        if([organizationsData count]>0)
        {
            selectedOrgObject=[organizationsData objectAtIndex:index];
        }
        
        //Set Organisation Details
        selectedIndexCustData=index;
        
        //Org Type
        if(selectedOrgObject.orgType!=nil)
        {
            organizationTypeText.text=[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] objectForKey:selectedOrgObject.orgType];
        }
        else
        {
            organizationTypeText.text = nil;
        }
        
        //Org name
        if(selectedOrgObject.orgName!=nil)
        {
            orgNameText.text=selectedOrgObject.orgName;
        }
        else
        {
            orgNameText.text = nil;
        }
        
        //Org BPID
        if(selectedOrgObject.orgBPID!=nil)
        {
            orgBPIDText.text=[NSString stringWithFormat:@"%@",selectedOrgObject.orgBPID];
        }
        else
        {
            orgBPIDText.text = nil;
        }
        
        //Org validation
        if(selectedOrgObject.orgValidationStatus!=nil)
        {
            orgValidationStatusText.text=selectedOrgObject.orgValidationStatus;
        }
        else
        {
            orgValidationStatusText.text = nil;
        }
        
        //Org BPClassification
        if(selectedOrgObject.orgBPClassification!=nil)
        {
            subClassificationText.text=selectedOrgObject.orgBPClassification;
        }
        else
        {
            subClassificationText.text = nil;
        }
        
        //Addresses
        [selectedOrgDetailAddress removeAllObjects];
        for(AddressObject* add in selectedOrgObject.orgAddress)
        {
            [selectedOrgDetailAddress addObject:add];
        }
        if([selectedOrgDetailAddress count]==0)
        {
            [custDetailAddressTableOrg setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }
        else
        {
            [custDetailAddressTableOrg setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
        
        [custDetailAddressTableOrg reloadData];
        
        //Enable or diable removal button
        NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
        NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
        if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_ORG_KEY]||[[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"])
        {
            [submitForRemovalButton setEnabled:NO];
        }
        else
        {
            if(selectedOrgObject.isRequestedForRemoval)
            {
                [submitForRemovalButton  setEnabled:NO];
            }
            else
            {
                [submitForRemovalButton setEnabled:YES];
            }
        }
    }
}

-(void)refreshSearchParametersView:(NSMutableDictionary *)searchParametersDict
{
    //Update UI with search parameters received from search form
    if([[DataManager sharedObject] isIndividualSegmentSelectedForRemoveCustomer])  //Individual
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

//Pass Null rect to present UIpopover at center of View
-(void)presentReasonCodesPopoverFromRect:(CGRect)presentFromRect inView:(UIView*)presentInView withNote:(NSString*)noteStringOrNil
{
    CGFloat tableOffset = 0.0;
    UILabel* noteLabel = nil;
    
    //Reset previously selected reason for removal
    selectedReasonForRemoval = @"";
    
    if(noteStringOrNil)
    {
        noteLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 30)];
        [noteLabel setText:noteStringOrNil];
        [noteLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [noteLabel setTextAlignment:NSTextAlignmentCenter];
        [noteLabel setTextColor:[UIColor blackColor]];
        [noteLabel setNumberOfLines:2];
        [noteLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [noteLabel setBackgroundColor:[UIColor clearColor]];
        
        tableOffset = CGRectGetHeight(noteLabel.frame);
    }
    
    UIViewController*infoViewController=[[UIViewController alloc]init];
    UIView * infoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 225+tableOffset)];
    [infoView setBackgroundColor:[UIColor clearColor]];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    if(!removeAddressButtonClicked)
    {
        [titleLabel setText:REASON_FOR_REMOVAL_POPOVER_TITLE_STRING];
    }
    else
    {
        [titleLabel setText:REASON_FOR_ADDRESS_REMOVAL_POPOVER_TITLE_STRING];
    }
    [titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [infoView addSubview:titleLabel];
    
    UIView * listView=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 300, 191+tableOffset)];
    [listView setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1.0]];
    listView.layer.cornerRadius=10.0f;
    listView.layer.borderWidth=1.0f;
    [infoView addSubview:listView];
    
    //Add note label to list view if applicable
    if(noteLabel)
    {
        [listView addSubview:noteLabel];
    }
    
    //Add topBarView  Table
    if(!removeAddressButtonClicked)
    {
        reasonForRemovalTableView=[[UITableView alloc]initWithFrame:CGRectMake(10,45+tableOffset,infoView.frame.size.width-20,[self getReasonsForCustRemoval].count*44)];
    }
    else
    {
        reasonForRemovalTableView=[[UITableView alloc]initWithFrame:CGRectMake(10,45+tableOffset,infoView.frame.size.width-20,reasonForCustomerAddressRemovalArray.count*44)];
    }
    [reasonForRemovalTableView setBackgroundColor:[UIColor whiteColor]];
    reasonForRemovalTableView.layer.cornerRadius=10.0f;
    reasonForRemovalTableView.layer.borderWidth=1.0f;
    reasonForRemovalTableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [reasonForRemovalTableView setBounces:NO];
    [reasonForRemovalTableView setDelegate:self];
    [reasonForRemovalTableView setDataSource:self];
    [infoView addSubview:reasonForRemovalTableView];
    
    //Cancel and Remove Btn
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame= CGRectMake(reasonForRemovalTableView.frame.origin.x+20,reasonForRemovalTableView.frame.origin.y+reasonForRemovalTableView.frame.size.height+10,114,31);
    [cancelBtn setImage:[UIImage imageNamed:@"btn_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelRemoval) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:cancelBtn];
    
    //Cancel and Remove Btn
    removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame= CGRectMake(reasonForRemovalTableView.frame.origin.x+150,reasonForRemovalTableView.frame.origin.y+reasonForRemovalTableView.frame.size.height+10,114,31);
    [removeBtn setImage:[UIImage imageNamed:@"btn_remove"] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(clickRemoveCustomer) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:removeBtn];
    
    [infoViewController.view addSubview:infoView];
    infoViewController.modalPresentationStyle=UIModalPresentationPopover;
    infoPopOver  = [infoViewController popoverPresentationController];
   
    infoViewController.preferredContentSize= CGSizeMake(300, CGRectGetHeight(reasonForRemovalTableView.frame) + 94 + tableOffset);

    [infoPopOver setBackgroundColor:[UIColor blackColor]];
    
    if(CGRectIsNull(presentFromRect))   //Present UIpopover at center of View
    {
        presentFromRect  = CGRectMake(presentInView.center.x, presentInView.center.y-64, 1, 1);
        infoViewController.popoverPresentationController.sourceRect = presentFromRect;
        infoViewController.popoverPresentationController.sourceView = presentInView;
         infoPopOver.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
        [self presentViewController:infoViewController animated: YES completion: nil];
    }
    else    //Present UIpopover anchored to rect
    {
        infoViewController.popoverPresentationController.sourceRect = presentFromRect;
        infoViewController.popoverPresentationController.sourceView = presentInView;
        infoPopOver.permittedArrowDirections = UIPopoverArrowDirectionAny;
        [self presentViewController:infoViewController animated: YES completion: nil];
    }
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
        else
        {
            cell = [custDetailAddressTableOrg cellForRowAtIndexPath:indexPath];
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
        else
        {
            addObj = [selectedOrgDetailAddress objectAtIndex:index.row];
        }
        
        CustomerObject *custObj;
        if(selectedIndexCustData<individualsData.count)
            custObj = [individualsData objectAtIndex:selectedIndexCustData];
        
        addObj.errorlLabel=responseLabel.text;
        //Set color
        if(success)
        {
            [responseLabel setTextColor:THEME_COLOR];
            addObj.isAddedToTerritory=@"Yes";
            [custObj.pendingCustBpaIds setObject:[NSNumber numberWithInt:1] atIndexedSubscript:indexPath.row] ;
            ////////////////////////////////**********
        }
        else
        {
            [responseLabel setTextColor:[UIColor redColor]];
        }
        
        if([identifier isEqualToString:@"RemoveIndividualCustomerAddress"])
        {
            [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
            for(int i = 0; i < selectedCustDetailAddress.count ; i++)
            {
                for(int j = 0; j < bpaIdArray.count ; j++){
                    AddressObject *addressObj = [selectedCustDetailAddress objectAtIndex:i];
                    NSString *addStr = [NSString stringWithFormat:@"%@",addressObj.BPA_ID];
                    NSString *addStrObj = [bpaIdArray objectAtIndex:j];
                    if([addStr isEqualToString:addStrObj])
                    {
                        addressObj.errorlLabel=responseLabel.text;
                        if(success)
                        {
                            [responseLabel setTextColor:THEME_COLOR];
                            addressObj.isAddedToTerritory=@"Yes";
                            [custObj.pendingCustBpaIds setObject:[NSNumber numberWithInt:1] atIndexedSubscript:indexPath.row] ;
                        }
                        else
                        {
                            [responseLabel setTextColor:[UIColor redColor]];
                        }
                        [selectedCustDetailAddress setObject:addressObj atIndexedSubscript:i];
                        break;
                    }
                }
            }
            [custDetailAddressTable reloadData];
        }
        else
        {
            [selectedOrgDetailAddress setObject:addObj atIndexedSubscript:index.row];
            [custDetailAddressTableOrg reloadData];
        }
        
    }
    else if ([identifier isEqualToString:@"RemoveIndividualCustomer"] || [identifier isEqualToString:@"RemoveOrganization"] ||
             [identifier isEqualToString:@"SearchOrganizationInAlignments"] || [identifier isEqualToString:@"SearchIndividualInAlignments"] ||
             [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeIndividual"]  ||
             [identifier isEqualToString:@"RefineSearchForRemoveCustomerOfTypeOrganization"] ||
             [identifier isEqualToString:CLEAR_VIEW_ERROR_LABEL])
    {
//        if (!responseMsgOrNil.length >0)
        if (responseMsgOrNil == nil && responseMsgOrNil.length == 0)
        {
            serverResponseLabel.text = @"";//Added to fix On Track 516
            NSDictionary *onOffDictionary = [defaults objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
            NSDictionary *terriotaryId = [onOffDictionary objectForKey:[defaults objectForKey:@"SelectedTerritoryId"]];
            if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_INDV_KEY] && (indvidualOrganisationSegmentControl.selectedSegmentIndex ==0))
            {
                [serverResponseLabel setText:[terriotaryId objectForKey:REMOVE_ONOFF_ERROR_KEY]];
                [serverResponseLabel setTextColor:[UIColor redColor]];
                responseMsgOrNil = [terriotaryId objectForKey:REMOVE_ONOFF_ERROR_KEY];
                [serverResponseLabel setTextColor:[UIColor redColor]];
            }
            if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:REMOVE_ORG_KEY] && (indvidualOrganisationSegmentControl.selectedSegmentIndex ==1))
            {
                [serverResponseLabel setText:[terriotaryId objectForKey:REMOVE_ONOFF_ERROR_KEY]];
                [serverResponseLabel setTextColor:[UIColor redColor]];
                responseMsgOrNil = [terriotaryId objectForKey:REMOVE_ONOFF_ERROR_KEY];
                [serverResponseLabel setTextColor:[UIColor redColor]];
            }

        }
        else
        {
            [serverResponseLabel setText:responseMsgOrNil];
            //Set color
            if(success)
            {
                [serverResponseLabel setTextColor:THEME_COLOR];
            }
            else
            {
                [serverResponseLabel setTextColor:[UIColor redColor]];
            }
        }
        
        if ([[defaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
            if (responseMsgOrNil.length>0) {
                responseMsgOrNil = [NSString stringWithFormat:@"%@\n%@",[defaults objectForKey:REMOVE_MESSAGE_KEY],responseMsgOrNil];
                
            }
            else
                responseMsgOrNil = [NSString stringWithFormat:@"%@",[defaults objectForKey:REMOVE_MESSAGE_KEY]];
            serverResponseLabel.text = responseMsgOrNil;
            [serverResponseLabel setTextColor:[UIColor redColor]];
        }
        
        if(responseMsgOrNil && responseMsgOrNil.length)
        {
            //Adjust details view frame
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailView.frame = detailsViewFrame;
            
            CGRect detailsViewOrgFrame = detailViewOrg.frame;
            detailsViewOrgFrame.origin.y = CGRectGetMaxY(serverResponseLabel.frame);
            detailViewOrg.frame = detailsViewOrgFrame;
        }
        else
        {
            //Adjust details view frame
            CGRect detailsViewFrame = detailView.frame;
            detailsViewFrame.origin.y = 70;
            detailView.frame = detailsViewFrame;
            
            CGRect detailsViewOrgFrame = detailViewOrg.frame;
            detailsViewOrgFrame.origin.y = 70;
            detailViewOrg.frame = detailsViewOrgFrame;
        }
        
        CGRect submitForRemovalButtonFrame = submitForRemovalButton.frame;
        submitForRemovalButtonFrame.origin.y = (detailView.hidden ? CGRectGetMinY(detailViewOrg.frame) : CGRectGetMinY(detailView.frame))+10;
        [submitForRemovalButton setFrame:submitForRemovalButtonFrame];
        if(indvidualOrganisationSegmentControl.selectedSegmentIndex==0)
            [custDetailAddressTable reloadData];
        else
            [custDetailAddressTableOrg reloadData];
    }
}

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
    
    //Org
    organizationTypeText.text = @"";
    orgNameText.text = @"";
    orgBPIDText.text = @"";
    orgValidationStatusText.text = @"";
    subClassificationText.text = @"";
    
    //Clear saved successful URL
    latestSuccessfulIndvSearchUrl = @"";
    latestSuccessfulOrgSearchUrl = @"";
    latestConnectionIdentifier = @"";
    
    [individualsData removeAllObjects];
    [indvSearchParameters removeAllObjects];
    [selectedCustDetailAddress removeAllObjects];
    
    [organizationsData removeAllObjects];
    [orgSearchParameters removeAllObjects];
    [selectedOrgDetailAddress removeAllObjects];
    
    [searchParameterTable reloadData];
    [customerListTable reloadData];
    [custDetailAddressTable reloadData];
    [custDetailAddressTableOrg reloadData];
}

#pragma mark -
/*Add UIAlertController
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0 && [alertView.message isEqualToString:REMOVE_CUSTOMER_ADDRESS_ALERT_MSG]) // Yes
    {
        [self clickRemoveCustomerAddress];
    }
    else if(buttonIndex==1 && [alertView.message isEqualToString:REMOVE_CUSTOMER_ADDRESS_ALERT_MSG]) // Yes
    {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
    else if(buttonIndex == 0 && [alertView.message isEqualToString:REMOVE_CUSTOMER_ALERT_MSG]){
        [self removeCustomerRequest];
    }
    else if (buttonIndex == 0 && [alertView.message isEqualToString:ADDRESS_REMOVAL_MESSAGE]){
        isSingleAddress= YES;
        [self clickRemoveCustomerAddress];
    }
    else if(buttonIndex == 0 && [alertView.message isEqualToString:ORGANISATION_REMOVAL_STRING]){
        [self clickRemoveCustomer];
    }
}*/

@end
