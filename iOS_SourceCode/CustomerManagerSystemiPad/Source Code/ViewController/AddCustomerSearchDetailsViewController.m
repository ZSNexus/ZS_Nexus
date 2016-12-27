//
//  AddCustomerSearchDetailsViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 12/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "AddCustomerSearchDetailsViewController.h"
#import "Themes.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "AddressObject.h"
#import "CustomerObject.h"
#import "MapFullScreenViewController.h"
#import "OrganizationObject.h"
#import "Constants.h"
#import "CustomModalViewController.h"
#import "CustomModalViewBO.h"
#import "DataManager.h"
#import "ModalDataLoader.h"
#import "Utilities.h"
#import "CustomerAddressDetailCell.h"
#import "JSONDataFlowManager.h"
#import "LOVData.h"
#import "CustomerInfoCell.h"
#import "PopOverContentViewController.h"
#import "ErrroPopOverContentViewController.h"
#import "CreateAffiliationSearchViewController.h"

@interface AddCustomerSearchDetailsViewController ()
{
    BOOL isConnectionInProgress;
    NSMutableArray *responseArray;
    NSString *latestConnectionIdentifier;
    BOOL isSearchAffiliatedScreen;
    NSString *masterIDForCheck;
}

@property(nonatomic,retain) CustomModalViewController *customModalViewController;
@property(nonatomic,retain) CreateAffiliationSearchViewController *affiliationSearchViewController;
@property(nonatomic,retain) MLPModalViewController *mlpModalviewController;
@property(nonatomic,assign) IBOutlet UINavigationBar *topBar;
@property(nonatomic,assign) IBOutlet UIView *leftView;
@property(nonatomic,assign) IBOutlet UIButton * refineSearchBtn;
@property(nonatomic,assign) IBOutlet UITableView * searchParameterTable;
@property(nonatomic,assign) IBOutlet UITableView * customerListTable;
@property(nonatomic,assign) IBOutlet UILabel *serverResponseLabel;
@property(nonatomic,retain) UIPopoverController*  infoPopOver;
@property(nonatomic,assign) IBOutlet UIButton * infoBtn ;
@property(nonatomic,retain) UIButton *changeTerritoryBtn;
@property(nonatomic,retain) UIButton *addNewCustomerBtn;
@property(nonatomic,assign) IBOutlet UITableView * custDetailAddressTable;
@property(nonatomic,assign) IBOutlet UILabel *custAddressNotAvailable;
@property(nonatomic,retain) NSMutableArray * selectedCustDetailAddress;
@property(assign) NSInteger selectedIndexCustData;
@property(assign) NSInteger selectedIndexCustAddress;
@property(nonatomic,retain) UIPopoverController * listPopOverController;
@property(nonatomic,assign) IBOutlet UILabel * nameText;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyText;
@property(nonatomic,assign) IBOutlet UILabel * professionalText;
@property(nonatomic,assign) IBOutlet UILabel * BPIDText;
@property(nonatomic,assign) IBOutlet UILabel * NPIText;
@property(nonatomic,retain) IBOutlet UILabel * CustTypeText;
@property(nonatomic,retain) IBOutlet UILabel * CustTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel * subClassificationText;
@property(nonatomic,assign) IBOutlet UILabel * orgValidationStatusText;
@property(nonatomic,assign) IBOutlet UILabel * orgBPIDText;
@property(nonatomic,assign) IBOutlet UILabel * organizationTypeText;
@property(nonatomic,assign) IBOutlet UILabel * orgNameText;
@property(nonatomic,assign) IBOutlet UIButton * addAddressBtn;
@property(nonatomic,retain) UIButton * addTerritoryBtn;
@property(nonatomic,assign) IBOutlet UIView *detailView;
@property(nonatomic,assign) IBOutlet UILabel * nameLabel;
@property(nonatomic,assign) IBOutlet UILabel * primarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * secondarySpecialtyLabel;
@property(nonatomic,assign) IBOutlet UILabel * professionalLabel;
@property(nonatomic,assign) IBOutlet UILabel * BPIDLabel;
@property(nonatomic,assign) IBOutlet UILabel * NPILabel;
@property(nonatomic,assign) IBOutlet UILabel * organizationTypeLabel;
@property(nonatomic,assign) IBOutlet UILabel * subClassificationLabel;
@property(nonatomic,assign) IBOutlet  UILabel * orgValidationStatusLabel;

-(void)clickLogOut;
-(void)refreshCustomerDetailOfIndex:(NSInteger)index;
-(void)clickAddTerritory:(id)sender;
-(void)clickMap:(id)sender;
-(IBAction)clickRefineSearch:(id)sender;
-(IBAction)clickInfo:(id)sender;
-(IBAction)clickAddAdress:(id)sender;

// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView;

@end

@implementation AddCustomerSearchDetailsViewController
@synthesize topBar,leftView,refineSearchBtn,custData,searchParameters,searchParameterTable,customerListTable,serverResponseLabel,infoPopOver,infoBtn,custDetailAddressTable,selectedCustDetailAddress,selectedIndexCustData,nameText,NPIText,primarySpecialtyText,secondarySpecialtyText,professionalText,BPIDText,CustTypeText,organizationTypeText,subClassificationText,orgValidationStatusText,orgBPIDText,orgNameText,addAddressBtn,addTerritoryBtn,changeTerritoryBtn,listPopOverController,addNewCustomerBtn,selectedIndexCustAddress,customModalViewController,CustTypeLabel,detailView,custAddressNotAvailable,nameLabel,primarySpecialtyLabel,secondarySpecialtyLabel,professionalLabel,BPIDLabel,NPILabel,organizationTypeLabel,subClassificationLabel,orgValidationStatusLabel,mlpModalviewController,affiliationSearchViewController;

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
    
    isConnectionInProgress = FALSE;
    
    [self setNavigationBarThemeAndColor];
    [self setBorderAndBackground];
    
    selectedCustDetailAddress=[[NSMutableArray alloc]init];
    
    if([[searchParameters objectForKey:@"SearchType"] isEqualToString:INDIVIDUALS_KEY])
    {
        [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];
        
        //Add Primary Specialty
        [primarySpecialtyLabel setHidden:NO];
        [organizationTypeLabel setHidden:YES];
        
        //Add Secondary Specialty
        [secondarySpecialtyLabel setHidden:NO];
        [subClassificationLabel setHidden:YES];
        
        //Add Professional Designation
        [professionalLabel setHidden:NO];
        [orgValidationStatusLabel setHidden:YES];
        [NPILabel setHidden:NO];
        
        //Add Add an Address addAddressBtn Button
        addAddressBtn.frame= CGRectMake(550,119,114,31);
    }
    else if([[searchParameters objectForKey:@"SearchType"] isEqualToString:ORGANIZATIONS_KEY])
    {
        [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:NO];
        
        //Add Organization Type
        [primarySpecialtyLabel setHidden:YES];
        [organizationTypeLabel setHidden:NO];
        //Add Sub Classification
        [secondarySpecialtyLabel setHidden:YES];
        [subClassificationLabel setHidden:NO];
        
        //Add Organization Validatiobn Status
        [professionalLabel setHidden:YES];
        [orgValidationStatusLabel setHidden:NO];
        
        [NPILabel setHidden:YES];
        //Add Add an Address addAddressBtn Button
        addAddressBtn.frame= CGRectMake(560,124,114,31);
    }
    
    [self setCustomFontToUIComponent];
    [self showCustmerAddressNotAvilableLabel];
    
    //Select Default First Row
    if([custData count]>0)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [customerListTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:customerListTable didSelectRowAtIndexPath:indexPath];
    }
    
    selectedIndexCustAddress=-1;
    [searchParameterTable reloadData];
    latestConnectionIdentifier = @"";
    masterIDForCheck = [[NSString alloc] init];
}

-(void)setBorderAndBackground
{
    leftView.layer.borderWidth=1.0f;
    leftView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    customerListTable.layer.borderWidth=1.0f;
    customerListTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    detailView.layer.borderWidth=1.0f;
    detailView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right.png"]]];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:custDetailAddressTable.frame];
    [imgView setImage:[UIImage imageNamed:@"detail_add.png"]];
    [custDetailAddressTable setBackgroundView:imgView];
    
    custDetailAddressTable.layer.borderWidth=1.0f;
    custDetailAddressTable.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
}

-(void)setNavigationBarThemeAndColor
{
    //Set Navigation Bar Themes
    //self.navigationController.navigationBar.tintColor=THEME_COLOR;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[Themes setNavigationBarNormal:SEARCH_CUSTOMERS_TAB_TITLE_STRING ofViewController:@"AddCustomerDetails"];
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar. frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //Add Touch Up event to Log out button
    for(UIButton* btn in self.navigationItem.titleView.subviews)
    {
        //Log out btn Tag is 1
        if(btn.tag==1)
            [btn addTarget:self action:@selector(clickLogOut) forControlEvents:UIControlEventTouchUpInside];
        else if(btn.tag==3)
        {
            //Change Territory Btn
            [btn addTarget:self action:@selector(clickChangeTerritory) forControlEvents:UIControlEventTouchUpInside];
            changeTerritoryBtn=btn;
        }
        else if(btn.tag==4)
        {
            //Change Territory Btn
            [btn addTarget:self action:@selector(clickAddCustomer) forControlEvents:UIControlEventTouchUpInside];
            addNewCustomerBtn=btn;
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
    //Set custom font to all Lables
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
    [orgNameText setFont:[UIFont fontWithName:@"Roboto-Medium" size:22.0]];
    [organizationTypeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [organizationTypeText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [subClassificationLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgValidationStatusLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [subClassificationText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgValidationStatusText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [BPIDLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [orgBPIDText setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [custAddressNotAvailable setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    //Global error Label, on top
    [serverResponseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Clear global error label
//    NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
//    NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
//    NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
//    if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_INDV_KEY] || [[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_ORG_KEY])
//    {
//        [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
//    }
    
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
        addAddressBtn.enabled=TRUE;
    else
    {
        //TODO: Need to discuss with ZS - We are Hiding Add Address for organization as not in scope.
        addAddressBtn.enabled=FALSE;
        addAddressBtn.hidden = TRUE;
    }
    
    if([custData count]>0)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [customerListTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:customerListTable didSelectRowAtIndexPath:indexPath];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //TODO: When Back button of advanced search is click then we have to cancel the web service call in case if fired
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [ConnectionClass cancelNSUrlConnectionForIdentifier:@"AlignTerritory"];
        [ConnectionClass cancelNSUrlConnectionForIdentifier:@"AddAddress"];
        isConnectionInProgress = FALSE;
        [Utilities removeSpinnerFromView:self.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark UI Actions
-(IBAction)clickInfo:(id)sender{
    
    PopOverContentViewController *infoViewController;
    
    //INFO button is shown only if 25 search results are received
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverContentViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", TOP_50_RESULTS_STRING]];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(200, 130);
	[infoPopOver setBackgroundColor:[UIColor blackColor]];
    [infoPopOver presentPopoverFromRect:infoBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(void)clickAlertInfoAction:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = [sender convertRect:button.bounds toView:self.view];
    
    PopOverContentViewController *infoViewController;
    
    //INFO button is shown only if 50 search results are received
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverContentViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", TOP_50_RESULTS_STRING]];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(200, 130);
    [infoPopOver setBackgroundColor:[UIColor blackColor]];
    [infoPopOver presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(void)showMoreAddressInfo:(id)sender
{
    UIButton *btn = (UIButton*) sender;

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

    //Commenting code for table hierarchy for ios 6 due to change in ios7
    /*
    UIButton *btn = (UIButton*) sender;
    
    UITableViewCell *cell = (UITableViewCell*) [[[[btn superview] superview] superview]superview];
    NSIndexPath *indexPath = [custDetailAddressTable indexPathForCell:cell];
    */
    
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
        
        CGRect buttonFrameToTable = [btn convertRect:btn.bounds toView:self.view];
        [self presentMoreInfoPopoverFromRect:buttonFrameToTable inView:self.view withMoreInfo:moreInfo];
    }
}

-(void)clickMap:(id)sender
{
    //Clear global error label
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    UITapGestureRecognizer *v = (UITapGestureRecognizer *) sender;
    UITableViewCell *cell = (UITableViewCell*) [[v.view superview]superview];
    NSIndexPath *indexPath = [custDetailAddressTable indexPathForCell:cell];
    int row = (int)indexPath.row;
    AddressObject* addObj=[selectedCustDetailAddress objectAtIndex:row];
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

-(IBAction)clickRefineSearch:(id)sender{
    //Clear global error label
//    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    
    customModalViewController = [[CustomModalViewController alloc] initWithNibName:@"CustomModalViewController" bundle:nil];
    
    //Set frame for animation
    //TODO:optimize CGRectMake below
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    
    //Set data
    customModalViewController.customTableViewController.customerDataOfCustomTableViewDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO;
    
    if ([DataManager sharedObject].isIndividualSegmentSelectedForAddCustomer)
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualRefineSearchWithParametrs:searchParameters];
        customModalViewController.customTableViewController.callBackIdentifier = @"RefineSearchForIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:searchParameters];
        customModalViewController.customTableViewController.callBackIdentifier = @"RefineSearchForOrganization";
    }
    
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    customModalViewController.customTableViewController.currentScreen = @"Add Refine Search";
    
    [customModalViewController.titleLabel setText:SEARCH_TAB_REFINE_SEARCH_TITLE_STRING];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
	[self.view bringSubviewToFront:customModalViewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, customModalViewController.view.frame.origin.y-offset-64, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height+60);
    [UIView commitAnimations];
    
}

-(void)showMLPPage
{
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    if(mlpModalviewController)
    {
        mlpModalviewController = nil;
    }
    
   
    
    mlpModalviewController = [[MLPModalViewController alloc] initWithNibName:@"MLPModalViewController" bundle:nil];
    
    //Set frame for animation
    //TODO:optimize CGRectMake below
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + mlpModalviewController.view.frame.size.height;
    mlpModalviewController.view.frame=CGRectMake(mlpModalviewController.view.frame.origin.x, offset, mlpModalviewController.view.frame.size.width, mlpModalviewController.view.frame.size.height);
    mlpModalviewController.primarySpeAnsLabel.text = primarySpecialtyText.text;
    mlpModalviewController.secSpeAnsLabel.text = secondarySpecialtyText.text;
    mlpModalviewController.masterIDLabel.text = @"Master ID:";
    mlpModalviewController.masterIDAnsLabel.text = BPIDText.text;
    mlpModalviewController.NPIAnsLabel.text = NPIText.text;
    mlpModalviewController.nameAnsLabel.text = nameText.text;
    
    //Set data
    mlpModalviewController.customTableViewController.customerDataOfMLPModalViewDelegate = self;
    mlpModalviewController.customTableViewController.isIndividual = [[DataManager sharedObject]
                                                                     isIndividualSegmentSelectedForAddCustomer];
    mlpModalviewController.customTableViewController.dataArray = [[NSArray alloc] init];
    mlpModalviewController.customTableViewController.dataArray = responseArray;
    mlpModalviewController.customTableViewController.popUpScreenTitle = MLP_SCREEN;
    mlpModalviewController.cdfProtocolDataOfMLPModalViewDelegate = self;
    mlpModalviewController.mlpSearchPOfMLPModalViewDelegate = self;
    
    [mlpModalviewController.cancelButton setBackgroundImage:nil forState:UIControlStateNormal];
    [mlpModalviewController.cancelButton setBackgroundImage:[UIImage imageNamed:@"button_searchagain.png"] forState:UIControlStateNormal];
    [mlpModalviewController.searchButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
    [mlpModalviewController.cancelButton setTitle: @"" forState: UIControlStateNormal];
    [mlpModalviewController.searchButton setTitle: @"" forState: UIControlStateNormal];
    
    
    //Do any required UI changes after frame set
//    CustomModalViewBO *customBO;
//    
//    if ([DataManager sharedObject].isIndividualSegmentSelectedForAddCustomer)
//    {
//        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualRefineSearchWithParametrs:searchParameters];
//        mlpModalviewController.customTableViewController.callBackIdentifier = @"RefineSearchForIndividual";
//    }
//    else
//    {
//        customBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:searchParameters];
//        mlpModalviewController.customTableViewController.callBackIdentifier = @"RefineSearchForOrganization";
//    }
    
    
    //set data
    //MLPModalViewController.primarySpecialtyLabel.text = @"Primary Speciality";
//    mlpModalviewController.primarySpeLabel.text = @"Primary Speciality";
//    mlpModalviewController.primarySpeAnsLabel.text = @"NRP";
//    mlpModalviewController.secSpeLabel.text = @"Secondary Speciality";
//    mlpModalviewController.secSpeAnsLabel.text = @"RN";
//    mlpModalviewController.masterIDLabel.text = @"Master ID #";
//    mlpModalviewController.masterIDAnsLabel.text = @"329488";
//    mlpModalviewController.NPILabel.text = @"NPI #";
//    mlpModalviewController.NPIAnsLabel.text = @"7258";
    
    
    
   // [mlpModalviewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    //[mlpModalviewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    //[mlpModalviewController.customTableViewController setRowArray:customBO.customModalRowArray];
    
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
    /*---
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:@"GET" forKey:@"request_type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * postBody=nil;
    if([[searchParameters objectForKey:@"SearchType"] isEqualToString:INDIVIDUALS_KEY])
    {
        CustomerObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        AddressObject * addObj=[custObj.custAddress objectAtIndex:selectedIndexCustAddress];
        postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"bp_Id\": \"%@\",\"childBp_id\": \"%@\",\"territoryId\": \"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],mlpModalviewController.masterIDAnsLabel.text,bpaId,[defaults objectForKey:@"SelectedTerritoryId"]];
    }
    else
    {
        OrganizationObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        AddressObject * addObj=[custObj.orgAddress objectAtIndex:selectedIndexCustAddress];
        postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"bp_Id\": \"%@\",\"childBp_id\": \"%@\",\"territoryId\": \"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],mlpModalviewController.masterIDAnsLabel.text,bpaId,[defaults objectForKey:@"SelectedTerritoryId"]];
    }
    [parameters setObject:postBody forKey:@"post_body"];
    
    ConnectionClass * connection= [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:[ALIGN_TO_TERRITORY_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AlignTerritory" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    isConnectionInProgress = TRUE;---*/
    
    
    
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.mlpModalviewController.view withMessage:nil];
    
    
    
    //Form URL
    NSMutableString *cdfFlagDetailsUrl = [[NSMutableString alloc] initWithString:SHOW_CDF_FLAG_URL];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *connectionIdentifier = nil;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])   //Individuals
    {
        
        [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [cdfFlagDetailsUrl appendFormat:@"&bp_id=%@", bpaId];
        [cdfFlagDetailsUrl appendFormat:@"&childBp_id=%@", mlpModalviewController.masterIDAnsLabel.text];
        [cdfFlagDetailsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
//        
//        [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
//        [cdfFlagDetailsUrl appendFormat:@"&bp_id=576694"];
//        [cdfFlagDetailsUrl appendFormat:@"&childBp_id=288"];
//        [cdfFlagDetailsUrl appendFormat:@"&terr_id=162444"];
        
        connectionIdentifier = @"CDFFlagIdentfier";
    }
    else    //Organizations
    {
        [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [cdfFlagDetailsUrl appendFormat:@"&bp_id=%@", bpaId];
        [cdfFlagDetailsUrl appendFormat:@"&childBp_id=%@", mlpModalviewController.masterIDAnsLabel.text];
        [cdfFlagDetailsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
        //            [removeAddressUrl appendFormat:@"&removal_reason=%@", selectedReasonForRemoval];
        
        connectionIdentifier = @"CDFFlagIdentfier";
    }
    
    //form connection
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"GET" forKey:@"request_type"];
    
    
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

    
    //[Utilities removeSpinnerFromView:self.mlpModalviewController.view];
    //[mlpModalviewController showCDFFLagScreen];
}

-(void)getCurrentScreenName:(BOOL)isSearchAffiliationPage withMasterId:(NSString *)masterId
{
    isSearchAffiliatedScreen = isSearchAffiliationPage;
    masterIDForCheck = masterId;
}

-(void)showSearchPrescriberScreen
{/*
    
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
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
    
    if ([DataManager sharedObject].isIndividualSegmentSelectedForAddCustomer)
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualAffiliationSearch:searchParameters];
        affiliationSearchViewController.customTableViewController.callBackIdentifier = @"RefineSearchForIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:searchParameters];
        affiliationSearchViewController.customTableViewController.callBackIdentifier = @"RefineSearchForOrganization";
    }
    
    [affiliationSearchViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [affiliationSearchViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [affiliationSearchViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    
    [affiliationSearchViewController.titleLabel setText:SEARCH_TAB_CREATE_AFFILIATION_STRING];
    
    affiliationSearchViewController.primarySpeAnsLabel.text = primarySpecialtyText.text;
    affiliationSearchViewController.secSpeAnsLabel.text = secondarySpecialtyText.text;
    affiliationSearchViewController.masterIDAnsLabel.text = BPIDText.text;
    affiliationSearchViewController.NPIAnsLabel.text = NPIText.text;
    affiliationSearchViewController.nameAnsLabel.text = nameText.text;

    
    [self addChildViewController:affiliationSearchViewController];
    [self.view addSubview:affiliationSearchViewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    affiliationSearchViewController.view.frame=CGRectMake(affiliationSearchViewController.view.frame.origin.x, affiliationSearchViewController.view.frame.origin.y-offset, affiliationSearchViewController.view.frame.size.width, affiliationSearchViewController.view.frame.size.height);
    [UIView commitAnimations];*/
     
    
    
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
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
    affiliationSearchViewController.customTableViewController.customerDataOfCustomTableViewDelegate = self;
    affiliationSearchViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO;
    
    if ([DataManager sharedObject].isIndividualSegmentSelectedForAddCustomer)
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualAffiliationSearch:searchParameters];
        affiliationSearchViewController.customTableViewController.callBackIdentifier = @"RefineSearchForIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:searchParameters];
        affiliationSearchViewController.customTableViewController.callBackIdentifier = @"RefineSearchForOrganization";
    }
    
    [affiliationSearchViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [affiliationSearchViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [affiliationSearchViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    affiliationSearchViewController.customTableViewController.currentScreen = [[NSString alloc] init];
    affiliationSearchViewController.customTableViewController.currentScreen = @"Align To Territory";
    
    [affiliationSearchViewController.titleLabel setText:SEARCH_TAB_CREATE_AFFILIATION_STRING];
    affiliationSearchViewController.primarySpeAnsLabel.text = primarySpecialtyText.text;
    affiliationSearchViewController.secSpeAnsLabel.text = secondarySpecialtyText.text;
    affiliationSearchViewController.masterIDAnsLabel.text = BPIDText.text;
    affiliationSearchViewController.NPIAnsLabel.text = NPIText.text;
    affiliationSearchViewController.nameAnsLabel.text = nameText.text;
    
    [self addChildViewController:affiliationSearchViewController];
    [self.view addSubview:affiliationSearchViewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    affiliationSearchViewController.view.frame=CGRectMake(affiliationSearchViewController.view.frame.origin.x, affiliationSearchViewController.view.frame.origin.y-offset, affiliationSearchViewController.view.frame.size.width, affiliationSearchViewController.view.frame.size.height);
    [UIView commitAnimations];
    
}


-(void)clickAddTerritory:(id)sender
{
    //If connection is already in progress then return
    //[self showMLPPage];//--- remove later
    
    if(isConnectionInProgress)
    {
        return;
    }
	
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
    
    
    //Clear global error label
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    UIButton *btn = (UIButton*) sender;
    UITableViewCell *cell = (UITableViewCell*) [[btn superview]superview];
    //    //Clearing error message on click
    UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
    errorLabel.text=@"";
    //NSIndexPath *indexPath = [custDetailAddressTable indexPathForCell:cell];
    int row = (int)indexPath.row;
    selectedIndexCustAddress=row;
    [self addToTerritoryWebserviceCall];
    
}

-(void)addToTerritoryWebserviceCall
{
    //Web Service Call for Align
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    
    NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:@"POST" forKey:@"request_type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * postBody=nil;
    if([[searchParameters objectForKey:@"SearchType"] isEqualToString:INDIVIDUALS_KEY])
    {
        CustomerObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        AddressObject * addObj=[custObj.custAddress objectAtIndex:selectedIndexCustAddress];
        //In postBody added a new parameter for HO User as per HO user requirement
        postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"bpTypeCd\":\"INDV\",\"bpClasfnCd\":\"%@\",\"bpaId\": \"%@\",\"bpId\": \"%@\",\"territoryId\": \"%@\",\"isHOUser\": \"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],custObj.custType,addObj.BPA_ID,custObj.custBPID,[defaults objectForKey:@"SelectedTerritoryId"],custObj.isHoUser];
    }
    else
    {
        OrganizationObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        AddressObject * addObj=[custObj.orgAddress objectAtIndex:selectedIndexCustAddress];
        //In postBody added a new parameter for HO User as per HO user requirement
        postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"bpTypeCd\":\"ORG\",\"bpClasfnCd\":\"%@\",\"bpaId\": \"%@\",\"bpId\": \"%@\",\"territoryId\": \"%@\",\"isHOUser\": \"%@\"}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],(custObj.orgType ? custObj.orgType : @""),addObj.BPA_ID,custObj.orgBPID,[defaults objectForKey:@"SelectedTerritoryId"],custObj.isHoUser];
    }
    [parameters setObject:postBody forKey:@"post_body"];
    
    ConnectionClass * connection= [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:[ALIGN_TO_TERRITORY_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AlignTerritory" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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

-(IBAction)clickAddAdress:(id)sender
{
    //Clear global error label
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    
    customModalViewController = [[CustomModalViewController alloc] initWithNibName:@"CustomModalViewController" bundle:nil];
    
    //Set SubTitle
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
    {
        customModalViewController.subTitleString = [NSString stringWithFormat:@"%@: %@", INDV_NAME_STRING, nameText.text];
    }
    else
    {
        customModalViewController.subTitleString = [NSString stringWithFormat:@"%@: %@", ORGANIZATION_NAME_STRING, orgNameText.text];
    }
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    CGRect modalViewFrame = customModalViewController.view.frame;
    modalViewFrame.origin.y = offset;
    customModalViewController.view.frame = modalViewFrame;
    
    //Set Data
    customModalViewController.customTableViewController.customerDataOfCustomTableViewDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //DO any required UI changes after frame set
    CustomModalViewBO *customBO;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForAddIndividualNewAddress];
        customModalViewController.customTableViewController.callBackIdentifier = @"AddAddressForExistingIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForAddOrganizationNewAddress];
        customModalViewController.customTableViewController.callBackIdentifier = @"AddAddressForExistingOrganization";
    }
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    
    //Title
    [customModalViewController.titleLabel setText:ADD_NEW_ADDRESS_TITLE_STRING];
    //Replace search button with submit button
    [customModalViewController.searchButton setImage:[UIImage imageNamed:@"btn_submit.png"] forState:UIControlStateNormal];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
    
    //Animate the view
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect viewFrame = customModalViewController.view.frame;
                         // viewFrame.origin.y -= offset;
						 viewFrame.origin.y -= (offset+64);
                         customModalViewController.view.frame = viewFrame;
                     }
                     completion:nil];
}

-(void)clickAddCustomer
{
    //Clear global error label
    [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    
    customModalViewController = [[CustomModalViewController alloc] initWithNibName:@"CustomModalViewController" bundle:nil];
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    
    //Set Data
    customModalViewController.customTableViewController.customerDataOfCustomTableViewDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO;
    if([DataManager sharedObject].isIndividualSegmentSelectedForAddCustomer)
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForNewIndividualCustomer];
        customModalViewController.customTableViewController.callBackIdentifier = @"AddCustomerOfTypeIndividual";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForNewOrganizationalCustomer];
        customModalViewController.customTableViewController.callBackIdentifier = @"AddCustomerOfTypeOrganization";
    }
    
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
	customModalViewController.customTableViewController.currentScreen = @"Add Refine Search";
    
    //Replace search button image with submit button
    [customModalViewController.searchButton setImage:[UIImage imageNamed:@"btn_submit.png"] forState:UIControlStateNormal];
    if([DataManager sharedObject].isIndividualSegmentSelectedForAddCustomer)
        [customModalViewController.titleLabel setText:ADD_NEW_INDV_TITLE_STRING];
    else
        [customModalViewController.titleLabel setText:ADD_NEW_ORG_TITLE_STRING];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
    
    //Animate view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, customModalViewController.view.frame.origin.y-offset-64, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];
    listViewController.delegate=self;
    listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
    listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    listPopOverController.delegate=self;
    // [listPopOverController presentPopoverFromRect:CGRectMake(changeTerritoryBtn.frame.origin.x+60
	listPopOverController.backgroundColor = [UIColor blackColor];
    [listPopOverController presentPopoverFromRect:CGRectMake(changeTerritoryBtn.frame.origin.x+60+15-27
                                                             , changeTerritoryBtn.frame.origin.y-50, changeTerritoryBtn.frame.size.width, changeTerritoryBtn.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:NO];
}

-(void)clickLogOut
{
 	AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	[appDelegate Logout];
}

// Display BU/Team/Terr selection page on Home button click
-(void)loadBuTeamTerrSelectionView
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate displayHOUserHomePage];
}

#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
   
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
                identifier = @"AlignTerritory";
                [Utilities removeSpinnerFromView:self.mlpModalviewController.cdfFlagModalviewController.view];

            }
            else
            {
                [mlpModalviewController.cdfFlagModalviewController displayErrorMessage:[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"reasonCode"]]];
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"reasonCode"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Utilities removeSpinnerFromView:self.mlpModalviewController.cdfFlagModalviewController.view];
                //[alert show];
                return;
            }
        }
        else
        {
            [mlpModalviewController.cdfFlagModalviewController.view removeFromSuperview];
            [mlpModalviewController.view removeFromSuperview];
            [affiliationSearchViewController.view removeFromSuperview];
            identifier = @"AlignTerritory";
            [Utilities removeSpinnerFromView:self.mlpModalviewController.cdfFlagModalviewController.view];
        }
    }
    
    isConnectionInProgress = FALSE;
    [Utilities removeSpinnerFromView:self.view];
    
    NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    DebugLog(@"[AddCustomerSearchDetailsViewController : receiveDataFromServer : JSON received : \n%@ \nIdentifier: %@",jsonDataObject ,identifier);
    
    if([identifier isEqualToString:@"AddAddress"])
    {
        if(jsonDataObject==nil)
        {
            //Error Add Address, this should never happen.
            [customModalViewController displayErrorMessage:ERROR_ADD_ADDRESS_FAILED];
        }
        else // JOSN has some data, parse it and use it
        {
            if([Utilities parseJsonAndCheckStatus:jsonDataObject]) //TRUE, sucess
            {
                //Add Address Sucess
                //On success
                [self removeCustomModalViewController];
                
                //Display success msg on above details view
                [self updateViewErrLabelWithText:[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]] sucessOrFail:TRUE];
            }
            else //failure
            {
                if(![[jsonDataObject objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    //Error Add Address, display on ModalView
                    [customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]]];
                }
            }
        }
    }
    else if([identifier isEqualToString:@"AlignTerritory"])
    {
        NSString* myString;
        myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
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
            //hardcode data
            
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([dataString rangeOfString:@"requireSearch"].location == NSNotFound)
            //if ([dataString rangeOfString:@"mlpOrNot"].location == NSNotFound)
            {
                
                //            if([[jsonDataObject allKeys] containsObject:@"status"])
                //            {
                
                if([Utilities parseJsonAndCheckStatus:jsonDataObject]) //Success
                {
                    
                    //Alighn Territory Sucess
                    NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
                    UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
                    UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
                    errorLabel.textColor = THEME_COLOR;
                    errorLabel.text = [NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]];
                    
                    AddressObject *addObj= [selectedCustDetailAddress objectAtIndex:index.row];
                    addObj.errorlLabel=errorLabel.text;
                    addObj.isAddedToTerritory = @"Yes";
                    [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
                    [custDetailAddressTable reloadData];
                    [self showCustmerAddressNotAvilableLabel];
                }
                else //Failure
                {
                    if(![[jsonDataObject objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                    {
                        //Error Alighn Teritory
                        NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
                        UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
                        UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
                        errorLabel.textColor = [UIColor redColor];
                        errorLabel.text=[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]];
                        
                        AddressObject *addObj= [selectedCustDetailAddress objectAtIndex:index.row];
                        addObj.errorlLabel = errorLabel.text;
                        addObj.isAddedToTerritory = @"No";
                        [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
                        [custDetailAddressTable reloadData];
                    }
                }
            }
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
//                    for(NSDictionary *item in jsonArray) {
//                        NSDictionary *mlpItem = item;
//                        //[responseArray addObject:mlpItem];
//                        NSLog(@"Item: %@", item);
//                    }
                    [self showSearchPrescriberScreen];
                    
                    
                    //NSDictionary *mlpStatus = [responseArray objectAtIndex:0];
                    
                    //if ([[jsonDataObject allKeys] containsObject:@"mlpOrNot"]) {
                    //if ([[mlpStatus allKeys] containsObject:@"requireSearch"])
                    //if ([[mlpStatus allKeys] containsObject:@"mlpOrNot"])
                    //{
                       //NSLog(@"MLP enabled");
                        //[responseArray removeObjectAtIndex:0];
                        //[self showMLPPage];
                       // [self showSearchPrescriberScreen];
                    //}
                }

                
            }
            
        }
    }
    else if([identifier isEqualToString:@"AddIndividual"])
    {
        if(jsonDataObject==nil)
        {
            //Error Add Address
            [customModalViewController displayErrorMessage:ERROR_ADD_CUSTOMER_FAILED];
        }
        else
        {
            if([Utilities parseJsonAndCheckStatus:jsonDataObject])
            {
                //Add Address Sucess
                //On success
                [self removeCustomModalViewController];
                
                //Display success msg on above details view
                [self updateViewErrLabelWithText:[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]] sucessOrFail:TRUE];
            }
            else
            {
                if(![[jsonDataObject objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    //Error Add Address
                    [customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]]];
                }
            }
        }
    }
    else if([identifier isEqualToString:@"AddOrganization"])
    {
        if(jsonDataObject==nil)
        {
            //Error Add Address
            [customModalViewController displayErrorMessage:ERROR_ADD_CUSTOMER_FAILED];
        }
        else
        {
            if([Utilities parseJsonAndCheckStatus:jsonDataObject])
            {
                //Add Address Sucess
                //On success
                [self removeCustomModalViewController];
                
                //Display success msg on above details view
                [self updateViewErrLabelWithText:[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]] sucessOrFail:TRUE];
            }
            else
            {
                if(![[jsonDataObject objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    //Error Add Address
                    [customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[jsonDataObject objectForKey:@"reasonCode"]]];
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
//                custData= custDataServer;
//                if(custData!=nil && [custData count]>0)
//                {
//                    [customerListTable reloadData];
//                    //Select Default First Row
//                    if([custData count]>0)
//                    {
//                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//                        [customerListTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
//                        [self tableView:customerListTable didSelectRowAtIndexPath:indexPath];
//                    }
//                    
//                    //On success
//                    //Refresh search parameters view
//                    [self refreshSearchParametersView:customModalViewController.customTableViewController.searchParameters];
//                    [self removeCustomModalViewController];
//                }
                
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
                    }
                    [self showMLPPage];
                }
            }
            else
            {
                NSError *e = nil;
                //NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
               // NSDictionary * item = [jsonArray objectAtIndex:0];
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                if([responseDictionary objectForKey:@"status"])
                {
                    //NSString *responseValue = [[NSString alloc] init];
                    //NSString *responseValue = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"status"]];

                    if(affiliationSearchViewController.customTableViewController.isCreateAffiliationSearchPage == YES || [affiliationSearchViewController.customTableViewController.currentScreen isEqualToString:@"Align To Territory"])
                    {
                        [affiliationSearchViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"reasonCode"]]];
                    }
                    //Error Refine Search
                    //[customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]]];
                }
            }
        }
    }

    else if([identifier isEqualToString:@"RefineSearchForOrganization"])
    {
        NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(jsonDataArrayOfObjects == nil)
        {
            [customModalViewController displayErrorMessage:ERROR_NO_RESULTS_FOUND_TRY_AGAIN];
        }
        else
        {
            NSArray * custDataServer=[Utilities parseJsonSearchOrganization:jsonDataArrayOfObjects];
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
                    //Error Refine Search
                    [customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]]];
                }
            }
        }
    }
    else if([identifier isEqualToString:@"CDFFlagIdentfier"])
    {
        [Utilities removeSpinnerFromView:mlpModalviewController.view];
        //setUpCDFFLagScreenwithName
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
            //if ([dataString rangeOfString:@"requireSearch"].location == NSNotFound)
            if ([dataString rangeOfString:@"status"].location == NSNotFound)
            {
                for(NSDictionary *item in jsonArray) {
                    NSDictionary *mlpItem = item;
                    [responseArr addObject:mlpItem];
                    //[mlpModalviewController showCDFFLagScreen];
                }
                
                NSDictionary *mlpStatus = [responseArr objectAtIndex:0];
                
                //if ([[jsonDataObject allKeys] containsObject:@"mlpOrNot"]) {
                //if ([[mlpStatus allKeys] containsObject:@"requireSearch"])
                if ([[mlpStatus allKeys] containsObject:@"allFlagD"])
                {
                    mlpModalviewController.isAllFlagD = YES;
                    mlpModalviewController.allFlagsDMessage = [NSString stringWithFormat:@"%@",[mlpStatus objectForKey:@"allFlagD"]];
                    [responseArr removeObjectAtIndex:0];
                    //mlpModalviewController.isAllFlagD = YES;
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
                    /*Add UIAlertController
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"reasonCode"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                     [alert show];*/
                    
                    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Error"  message:[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"reasonCode"]]  preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:OK_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        /*Write Ok button click code here*/
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }

            }
        }
        
        
        
    }
}

-(void)affiliateMLPRequestWithString:(NSString *)masterID
{
    
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.mlpModalviewController.cdfFlagModalviewController.view withMessage:nil];
    
    
    
    //Form URL
    NSMutableString *cdfFlagDetailsUrl = [[NSMutableString alloc] initWithString:AFFILIATE_MLP_URL];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *connectionIdentifier = nil;
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])   //Individuals
    {
        CustomerObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        AddressObject * addObj=[custObj.custAddress objectAtIndex:selectedIndexCustAddress];
        [cdfFlagDetailsUrl appendFormat:@"personnel_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [cdfFlagDetailsUrl appendFormat:@"&bp_id=%@", masterID];
        [cdfFlagDetailsUrl appendFormat:@"&childbp_id=%@", custObj.custBPID];
        [cdfFlagDetailsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
        [cdfFlagDetailsUrl appendFormat:@"&childbpa_id=%@", addObj.BPA_ID];
        [cdfFlagDetailsUrl appendFormat:@"&bpClassFnCd=%@", custObj.custType];
        //NSString * temp = [[NSString alloc] init];
        //temp = @"Prescriber";
        //[cdfFlagDetailsUrl appendFormat:@"&bpClassFnCd=%@", temp];
        //        [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        //        [cdfFlagDetailsUrl appendFormat:@"&bp_id=576694"];
        //        [cdfFlagDetailsUrl appendFormat:@"&childBp_id=288"];
        //        [cdfFlagDetailsUrl appendFormat:@"&terr_id=162444"];
        
        connectionIdentifier = @"AffiliateMLP";
        //connectionIdentifier = @"AlignTerritory";
    }
    else    //Organizations
    {
        [cdfFlagDetailsUrl appendFormat:@"personal_Id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [cdfFlagDetailsUrl appendFormat:@"&bp_id=%@", mlpModalviewController.masterIDAnsLabel.text];
        //[cdfFlagDetailsUrl appendFormat:@"&childBp_id=%@", bpaId];
        [cdfFlagDetailsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
       
        //            [removeAddressUrl appendFormat:@"&removal_reason=%@", selectedReasonForRemoval];
        
        connectionIdentifier = @"AffiliateMLP";
        //connectionIdentifier = @"AlignTerritory";
    }
    
    //form connection
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"GET" forKey:@"request_type"];
    
    
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
    
    
    
    //[mlpModalviewController showCDFFLagScreen];
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    isConnectionInProgress = FALSE;
    [Utilities removeSpinnerFromView:self.view];
    
    ErrorLog(@"Add Customer Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    if([identifier isEqualToString:@"AlignTerritory"])
    {
        NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
        UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
        UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
        errorLabel.textColor = [UIColor redColor];
        errorLabel.text=error;
        AddressObject *addObj= [selectedCustDetailAddress objectAtIndex:index.row];
        addObj.errorlLabel=errorLabel.text;
        [selectedCustDetailAddress setObject:addObj atIndexedSubscript:index.row];
    }
    else
    {
        [customModalViewController displayErrorMessage:error];
    }
}
#pragma mark -

#pragma mark Customer Data Delegate
-(void)processCustomerData:(NSArray *)data forIdentifier:(NSString *)identifier
{
    //If connection is already in progress then return
    if(isConnectionInProgress)
    {
        return;
    }
    
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    
    if([identifier isEqualToString:@"AddAddressForExistingIndividual"])
    {
        CustomerObject * customerDataObject=[data objectAtIndex:0];
        //Web Service Call for Add Address
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:@"POST" forKey:@"request_type"];
        if(customerDataObject.custAddress !=nil && [customerDataObject.custAddress count]>0)
        {
            AddressObject * addObj=[customerDataObject.custAddress objectAtIndex:0];
            if(addObj.street !=nil && addObj.street.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"street\":\"%@\"",addObj.street]];
            }
            if(addObj.building !=nil && addObj.building.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"building\":\"%@\"",addObj.building]];
            }
            if(addObj.state !=nil && addObj.state.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"state\":\"%@\"",addObj.state]];
            }
            if(addObj.zip !=nil && addObj.zip.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"zip\":\"%@\"",addObj.zip]];
            }
            if(addObj.city !=nil && addObj.city.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"city\":\"%@\"",addObj.city]];
            }
            if(addObj.addr_usage_type !=nil && addObj.addr_usage_type.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"addrUsageType\":\"%@\"",addObj.addr_usage_type]];
            }
            if(addObj.suite !=nil && addObj.suite.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"suite\":\"%@\"",addObj.suite]];
            }
        }
        CustomerObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        NSString * addBody=[arr componentsJoinedByString:@","];
        NSString * postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"territoryId\": \"%@\",\"bpId\":\"%@\",%@}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],[defaults objectForKey:@"SelectedTerritoryId"],custObj.custBPID,addBody];
        [parameters setObject:postBody forKey:@"post_body"];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[ADD_NEW_ADDRESS_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AddAddress" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else if([identifier isEqualToString:@"AddAddressForExistingOrganization"])
    {
        
        OrganizationObject * orgObject=[data objectAtIndex:0];
        //Web Service Call for Add Address
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:@"POST" forKey:@"request_type"];
        if(orgObject.orgAddress !=nil && [orgObject.orgAddress count]>0)
        {
            AddressObject * addObj=[orgObject.orgAddress objectAtIndex:0];
            if(addObj.street !=nil && addObj.street.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"street\":\"%@\"",addObj.street]];
            }
            if(addObj.building !=nil && addObj.building.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"building\":\"%@\"",addObj.building]];
            }
            if(addObj.state !=nil && addObj.state.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"state\":\"%@\"",addObj.state]];
            }
            if(addObj.zip !=nil && addObj.zip.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"zip\":\"%@\"",addObj.zip]];
            }
            if(addObj.city !=nil && addObj.city.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"city\":\"%@\"",addObj.city]];
            }
            //TO DO: Neeed to discuus Whether it is need in org or not
            if(addObj.addr_usage_type !=nil && addObj.addr_usage_type.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"addrUsageType\":\"%@\"",addObj.addr_usage_type]];
            }
            if(addObj.suite !=nil && addObj.suite.length)
            {
                [arr addObject:[NSString stringWithFormat:@"\"suite\":\"%@\"",addObj.suite]];
            }
        }
        OrganizationObject * custObj=[custData objectAtIndex:selectedIndexCustData];
        NSString * addBody=[arr componentsJoinedByString:@","];
        NSString * postBody=[NSString stringWithFormat:@"{\"personnelId\": \"%@\",\"repTargetValue\": \"%@\",\"territoryId\": \"%@\",\"bpId\":\"%@\",\"address\":{%@}}",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"],[defaults objectForKey:@"repTargetValue"],[defaults objectForKey:@"SelectedTerritoryId"],custObj.orgBPID,addBody];
        [parameters setObject:postBody forKey:@"post_body"];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[ADD_NEW_ADDRESS_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AddAddress" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else if([identifier isEqualToString:@"AddCustomerOfTypeIndividual"])
    {
        CustomerObject * customerDataObject=[data objectAtIndex:0];
        //Web Service Call for Add Individual
        NSMutableString * postBoodyStr=[[NSMutableString alloc]init];
        NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:@"POST" forKey:@"request_type"];
        if(customerDataObject.custFirstName!=nil && customerDataObject.custFirstName.length)
        {
            [postBoodyStr appendFormat:@"{\"fname\":\"%@\"",customerDataObject.custFirstName];
        }
        if(customerDataObject.custMiddleName!=nil && customerDataObject.custMiddleName.length)
        {
            [postBoodyStr appendFormat:@",\"mname\":\"%@\"",customerDataObject.custMiddleName];
        }
        
        if(customerDataObject.custLastName!=nil && customerDataObject.custLastName.length)
        {
            [postBoodyStr appendFormat:@",\"lname\":\"%@\"",customerDataObject.custLastName];
        }
        
        if(customerDataObject.custSuffix!=nil && customerDataObject.custSuffix.length)
        {
            [postBoodyStr appendFormat:@",\"custSfxTxt\":\"%@\"",customerDataObject.custSuffix];
        }
        
        if(customerDataObject.custProfessionalDesignation!=nil && [[[JSONDataFlowManager sharedInstance]profDesignKeyValue] allKeysForObject:customerDataObject.custProfessionalDesignation].count)
        {
            
            NSString *profDescCode = [[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] allKeysForObject:customerDataObject.custProfessionalDesignation] objectAtIndex:0];
            if([profDescCode isEqualToString:@"CNAP"] || [profDescCode isEqualToString:@"CNAN"])
            {
                profDescCode = @"CNA";
            }
            
            [postBoodyStr appendFormat:@",\"profDesg\":\"%@\"",profDescCode];
            
        }
        if(customerDataObject.custType!=nil && customerDataObject.custType.length)
        {
            [postBoodyStr appendFormat:@",\"bpClassification\":\"%@\"",customerDataObject.custType];
        }
        
        if([defaults objectForKey:@"SelectedTerritoryId"]!=nil)
        {
            [postBoodyStr appendFormat:@",\"territoryId\":\"%@\"",[defaults objectForKey:@"SelectedTerritoryId"]];
        }
        
        [postBoodyStr appendFormat:@",\"personnelId\":\"%@\"",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        
        if(customerDataObject.custAddress !=nil && [customerDataObject.custAddress count]>0)
        {
            AddressObject * addObj=[customerDataObject.custAddress objectAtIndex:0];
            if(addObj.street !=nil && addObj.street.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"address\":[{\"street\":\"%@\"",addObj.street]];
            }
            if(addObj.building !=nil && addObj.building.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"building\":\"%@\"",addObj.building]];
            }
            if(addObj.state !=nil && addObj.state.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"state\":\"%@\"",addObj.state]];
            }
            if(addObj.zip !=nil && addObj.zip.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"zip\":\"%@\"",addObj.zip]];
            }
            if(addObj.city !=nil && addObj.city.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"city\":\"%@\"",addObj.city]];
            }
            if(addObj.addr_usage_type !=nil && addObj.addr_usage_type.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"addrUsageType\":\"%@\"",addObj.addr_usage_type]];
            }
            if(addObj.suite !=nil && addObj.suite.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"suite\":\"%@\"",addObj.suite]];
            }
            [postBoodyStr appendString:@"}]"];
        }
        [postBoodyStr appendString:@"}"];
        [parameters setObject:postBoodyStr forKey:@"post_body"];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[ADD_INDIVIDUAL_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AddIndividual" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else if([identifier isEqualToString:@"AddCustomerOfTypeOrganization"])
    {
        OrganizationObject * orgObject=[data objectAtIndex:0];
        //Web Service Call for Add Individual
        NSMutableString * postBoodyStr=[[NSMutableString alloc]init];
        NSMutableDictionary * parameters=[[NSMutableDictionary alloc]init];
        [parameters setObject:@"POST" forKey:@"request_type"];
        if(orgObject.orgName!=nil && orgObject.orgName.length)
        {
            [postBoodyStr appendFormat:@"{\"orgName\":\"%@\"",orgObject.orgName];
        }
        
        //For add org only GRP and LLC are allowed for all users
        if(orgObject.orgType!=nil && [[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:orgObject.orgType].count)
        {
            [postBoodyStr appendFormat:@",\"bpClassification\":\"%@\"",[[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:orgObject.orgType] objectAtIndex:0]];
        }
        
        [postBoodyStr appendFormat:@",\"repTargetValue\":\"1\""];
        
        if([defaults objectForKey:@"SelectedTerritoryId"]!=nil)
        {
            [postBoodyStr appendFormat:@",\"territoryId\":\"%@\"",[defaults objectForKey:@"SelectedTerritoryId"]];
        }
        
        [postBoodyStr appendFormat:@",\"personnelId\":\"%@\"",[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        
        if(orgObject.orgAddress !=nil && [orgObject.orgAddress count]>0)
        {
            AddressObject * addObj=[orgObject.orgAddress objectAtIndex:0];
            if(addObj.street !=nil && addObj.street.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"address\":[{\"street\":\"%@\"",addObj.street]];
            }
            if(addObj.building !=nil && addObj.building.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"building\":\"%@\"",addObj.building]];
            }
            if(addObj.state !=nil && addObj.state.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"state\":\"%@\"",addObj.state]];
            }
            if(addObj.zip !=nil && addObj.zip.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"zip\":\"%@\"",addObj.zip]];
            }
            if(addObj.city !=nil && addObj.city.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"city\":\"%@\"",addObj.city]];
            }
            if(addObj.addr_usage_type !=nil && addObj.addr_usage_type.length)
            {
                //[postBoodyStr appendString:[NSString stringWithFormat:@",\"addrUsageType\":\"%@\"",addObj.addr_usage_type]];
            }
            [postBoodyStr appendString:[NSString stringWithFormat:@",\"addrUsageType\":\"OFF\""]];
            if(addObj.suite !=nil && addObj.suite.length)
            {
                [postBoodyStr appendString:[NSString stringWithFormat:@",\"suite\":\"%@\"",addObj.suite]];
            }
            [postBoodyStr appendString:@"}]"];
        }
        [postBoodyStr appendString:@"}"];
        [parameters setObject:postBoodyStr forKey:@"post_body"];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[ADD_ORGANIZATION stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:@"AddOrganization" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else if([identifier isEqualToString:@"RefineSearchForIndividual"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:INDV_ADVANCED_SEARCH forKey:@"quickSearchType"];
        NSMutableDictionary *searchParametersDict = [[NSMutableDictionary alloc] init];
        
        CustomerObject * customerDataObject=[data objectAtIndex:0];
        NSMutableString * url=[[NSMutableString alloc]init];
        //--uncomment the below if condition once the endpoint for searchalignedterritories recieved and add the new endpoint in case of the new screen
        //if(isSearchAffiliatedScreen == YES)
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
        
        //[customModalViewController displayErrorMessage:[NSString stringWithFormat:@"%@",[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]]];
        
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
                    //continue
                    //name section all fields
                    [url appendFormat:@"first_Name=%@&",customerDataObject.custFirstName];
                    [url appendFormat:@"last_Name=%@&",customerDataObject.custLastName];

                    [url appendFormat:@"state_cd=%@&",affiliationSearchViewController.customTableViewController.stateSelected];
                    [searchParametersDict setObject:affiliationSearchViewController.customTableViewController.stateSelected forKey:STATE_KEY];
                }
                else
                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Full Details" message:@"Enter all the fields in Name section or enter any one id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    
//                    [alert show];
                    [affiliationSearchViewController displayErrorMessage:@"Enter all the fields in Name section or enter any one ID"];
                    return;
                }
            }
            [url appendFormat:@"personnel_Id=%@", [[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
            [url appendFormat:@"&terr_id=%@", [defaults objectForKey:@"SelectedTerritoryId"]];
        }
        
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
    else if([identifier isEqualToString:@"RefineSearchForOrganization"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ORG_ADVANCED_SEARCH forKey:@"quickSearchType"];
        NSMutableDictionary *searchParametersDict = [[NSMutableDictionary alloc] init];
        
        OrganizationObject * orgObj=[data objectAtIndex:0];
        NSMutableString * url=[[NSMutableString alloc]init];
        [url appendFormat:@"%@",SEARCH_ORGANIZATION_URL];
        if(orgObj.orgName !=nil && orgObj.orgName.length!=0)
        {
            [url appendFormat:@"org_name=%@&",orgObj.orgName];
        }
        
        if(orgObj.orgType !=nil && orgObj.orgType.length!=0 && [[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:orgObj.orgType].count)
        {
            [url appendFormat:@"org_type=%@&",[[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] allKeysForObject:orgObj.orgType] objectAtIndex:0]];
        }
        
        if(orgObj.orgBPID !=nil && orgObj.orgBPID.length!=0)
        {
            [url appendFormat:@"bp_id=%@&",orgObj.orgBPID];
        }
        
        AddressObject *customerAddress = [orgObj.orgAddress objectAtIndex:0];
        if(customerAddress.street !=nil && customerAddress.street.length!=0)
        {
            //Street is used as Address line 1 at server side
            [url appendFormat:@"street=%@&",customerAddress.street];
            [searchParametersDict setObject:customerAddress.street forKey:STREET_KEY];
        }
        if(customerAddress.building !=nil && customerAddress.building.length!=0)
        {
            [url appendFormat:@"building=%@&",customerAddress.building];
            [searchParametersDict setObject:customerAddress.building forKey:BUILDING_KEY];
        }
        if(customerAddress.suite !=nil && customerAddress.suite.length!=0)
        {
            [url appendFormat:@"suite=%@&",customerAddress.suite];
            [searchParametersDict setObject:customerAddress.suite forKey:SUITE_KEY];
        }
        if(customerAddress.state !=nil && customerAddress.state.length!=0)
        {
            [url appendFormat:@"state=%@&",customerAddress.state];
            [searchParametersDict setObject:customerAddress.state forKey:STATE_KEY];
        }
        if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
        {
            [url appendFormat:@"zip=%@&",customerAddress.zip];
            [searchParametersDict setObject:customerAddress.zip forKey:ZIP_KEY];
        }
        if(customerAddress.city !=nil && customerAddress.city.length!=0)
        {
            [url appendFormat:@"city=%@&",customerAddress.city];
            [searchParametersDict setObject:customerAddress.city forKey:CITY_KEY];
        }
        
        [url appendFormat:@"search_type=adv"];
        
        [url appendFormat:@"&personnel_id=%@", [[defaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [url appendFormat:@"&team_id=%@",[defaults objectForKey:@"SelectedTeamId"]];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"RefineSearchForOrganization" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    
    //Set connection in progress flag
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.view withMessage:nil];
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
        return 1;
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==searchParameterTable)
    {
        NSInteger count = [[searchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] count];
        return count;
    }
    else if(tableView==customerListTable)
    {
        //how info button only if data received is for more than 25
        if(custData.count>=MAX_SEARCH_RESULT_COUNT)
            [infoBtn setHidden:NO];
        else
            [infoBtn setHidden:YES];
        
        return [custData count];
    }
    else if(tableView==custDetailAddressTable)
        return [selectedCustDetailAddress count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchParameterTable)
    {
        static NSString *simpleTableIdentifier = @"Parameters";
        UITableViewCell *cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cellTemp == nil) {
            cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        else
            cellTemp.textLabel.text = @"";
        
        cellTemp.tag=indexPath.row;
        cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [cellTemp.textLabel setTextColor:THEME_COLOR];
        
        NSString *rowName = [[self.searchParameters objectForKey:SEARCH_FORM_FIELDS_SEQUENCE] objectAtIndex:indexPath.row];
        [cellTemp.textLabel setText:[NSString stringWithFormat:@"%@ : %@", rowName, [self.searchParameters objectForKey:rowName]]];
        
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
        
        if([[searchParameters objectForKey:@"SearchType"] isEqualToString:INDIVIDUALS_KEY])
        {
            CustomerObject* custObj=[custData objectAtIndex:indexPath.row ];
            
            NSMutableArray *nameArray = [[NSMutableArray alloc] init];
            
            if(custObj.custTitle!=nil && custObj.custTitle.length)
                [nameArray addObject:[NSString stringWithFormat:@"%@.", custObj.custTitle]];
            if(custObj.custFirstName!=nil && custObj.custFirstName.length)
                [nameArray addObject:custObj.custFirstName];
            if(custObj.custMiddleName!=nil && custObj.custMiddleName.length)
                [nameArray addObject:custObj.custMiddleName];
            if(custObj.custLastName!=nil && custObj.custLastName.length)
                [nameArray addObject:custObj.custLastName];
            if(custObj.custSuffix!=nil && custObj.custSuffix.length)
                [nameArray addObject:custObj.custSuffix];
            
            cell.nameLabel.text=[nameArray componentsJoinedByString:@" "];
            
            NSMutableString * specialtyCustTypeLabel=[[NSMutableString alloc]init];
            if(custObj.custPrimarySpecialty!=nil)
                [specialtyCustTypeLabel appendString:[NSString stringWithFormat:@"%@",custObj.custPrimarySpecialty]];
            else
                [specialtyCustTypeLabel appendFormat:@"%@",custObj.custType];
            
            NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
            if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
            {
                if(custObj.custPrimarySpecialty!=nil && custObj.custType!=nil && [[custObj.custPrimarySpecialty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0 && [[custObj.custType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0)
                {
                    [specialtyCustTypeLabel appendFormat:@", "];
                }
                
                if(custObj.custType!=nil)
                {
                    if(![custObj.custType isEqualToString:specialtyCustTypeLabel])
                        [specialtyCustTypeLabel appendFormat:@"%@",custObj.custType];
                }
                
            }
            
            cell.specialtyAndTypeLabel.text=specialtyCustTypeLabel;
        }
        else
        {
            OrganizationObject* orgObj=[custData objectAtIndex:indexPath.row ];
            if(orgObj.orgName!=nil)
                [cell.nameLabel setText:[NSString stringWithFormat:@"%@",orgObj.orgName]];
            if(orgObj.orgType!=nil)
                [cell.specialtyAndTypeLabel setText:[NSString stringWithFormat:@"%@",[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] objectForKey:orgObj.orgType]]];
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
        static NSString *CellIdentifier = @"AddressSelected";
        
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
        [cell.addTerritoryBtn setImage:[UIImage imageNamed:@"btn_addTerritory.png"] forState:UIControlStateNormal];
        [cell.addTerritoryBtn addTarget:self action:@selector(clickAddTerritory:) forControlEvents:UIControlEventTouchUpInside];
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
        
        AddressObject* addObj=[selectedCustDetailAddress objectAtIndex:indexPath.row ];
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        if(addObj.addressLineOne!=nil)
            [arr addObject:addObj.addressLineOne];
        if(addObj.addressLineTwo!=nil)
            [arr addObject:addObj.addressLineTwo];
        
        // CGSize size = [[arr componentsJoinedByString:@", "] sizeWithFont:cell.add1.font];
		CGSize size = [[arr componentsJoinedByString:@", "] sizeWithAttributes:@{NSFontAttributeName: cell.add1.font}];
		
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
        cell.add1.text=[arr componentsJoinedByString:@", "];
        [arr removeAllObjects];
        
        if(addObj.city!=nil)
            [arr addObject:[NSString stringWithFormat:@"%@,", addObj.city ]];
        if(addObj.state!=nil)
            [arr addObject:addObj.state];
        if(addObj.zip!=nil)
            [arr addObject:addObj.zip];
        cell.add2.text=[arr componentsJoinedByString:@" "];
        
        if(addObj.addr_usage_type!=nil)
            [cell.add3 setText:[NSString stringWithFormat:@"%@: %@", ADDRESS_TYPE_STRING, addObj.addr_usage_type]];
        
        if([[searchParameters objectForKey:@"SearchType"] isEqualToString:INDIVIDUALS_KEY])
        {
            CustomerObject * cust=[custData objectAtIndex:selectedIndexCustData];
            if(![[cust.custValidationStatus lowercaseString] isEqualToString:@"valid"] && ![[cust.custValidationStatus lowercaseString] isEqualToString:@"hcps"])//Confirm the status from server team
            {
                //Hide Add to territory button when customer status is invalid
                cell.addTerritoryBtn.enabled=FALSE;
                cell.responseLabel.textColor=[UIColor redColor];
                cell.responseLabel.text=ERROR_PENDING_CUST_VALIDATION;//5 Sept Comment from ZS
                addObj.errorlLabel = cell.responseLabel.text;
            }
            else
            {
                if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
                {
                    cell.addTerritoryBtn.enabled=FALSE;
                    cell.responseLabel.textColor=THEME_COLOR;
                }
                else
                    cell.addTerritoryBtn.enabled=TRUE;
            }
            //For HO user, only Add to terriotary will be enables.
            NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
            NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
            if ([[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"]) {
                //if user type is HO then Align terriotary will be enable
                [self.addNewCustomerBtn setEnabled:NO];
                [addAddressBtn setEnabled:NO];
                cell.addTerritoryBtn.enabled = TRUE;
                //Added for OnTrack 536
                if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_INDV_KEY])
                {
                    [cell.addTerritoryBtn setEnabled:NO];
                    [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
                }
            }
            //For on off functionality buttons will be enabled/disabled based on the terriotary flag
            else if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_INDV_KEY])
            {
                [self.addNewCustomerBtn setEnabled:NO];
                cell.addTerritoryBtn.enabled=FALSE;
                [addAddressBtn setEnabled:NO];
                [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
            }
        }
        else//Organizaiton
        {
            OrganizationObject * org=[custData objectAtIndex:selectedIndexCustData];
            if(![[org.orgValidationStatus lowercaseString] isEqualToString:@"valid"] && ![[org.orgValidationStatus lowercaseString] isEqualToString:@"hcps"])//Confirm the status from server team
            {
                //Hide Add to territory button when customer status is invalid
                cell.addTerritoryBtn.enabled=FALSE;
                cell.responseLabel.textColor=[UIColor redColor];
                cell.responseLabel.text=ERROR_PENDING_CUST_VALIDATION;//5 Sept Comment from ZS
                addObj.errorlLabel = cell.responseLabel.text;
            }
            else
            {
                if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
                {
                    cell.addTerritoryBtn.enabled=FALSE;
                    cell.responseLabel.textColor=THEME_COLOR;
                }
                else
                {
                    cell.addTerritoryBtn.enabled=TRUE;
                }
            }
            //For HO user, only Add to terriotary will be enables.
            NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
            NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
            if ([[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"]) {
                //if user type is HO then Align terriotary will be enable
                [self.addNewCustomerBtn setEnabled:NO];
                [addAddressBtn setEnabled:NO];
                cell.addTerritoryBtn.enabled = TRUE;
                //Added for OnTrack 536
                if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_ORG_KEY])
                {
                    [cell.addTerritoryBtn setEnabled:NO];
                    [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
                }
            }
            //For on off functionality buttons will be enabled/disabled based on the terriotary flag
            else if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_ORG_KEY])
            {
                [self.addNewCustomerBtn setEnabled:NO];
                cell.addTerritoryBtn.enabled=FALSE;
                [addAddressBtn setEnabled:NO];
                [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
            }

        }
        
        if(addObj.errorlLabel!=nil && ![addObj.errorlLabel isEqualToString:@""])
        {
            NSString *str=[NSString stringWithFormat:@"%@",addObj.errorlLabel];
            str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
            str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
            cell.responseLabel.text=str;
            //Alignment message display
            //Check if alignment msg fits in resonse label
            //CGSize errorLabelSize = [addObj.errorlLabel sizeWithFont:cell.responseLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.responseLabel.frame), FLT_MAX)];
            
			//Commenting deprecated method
            //CGSize errorLabelSize = [addObj.errorlLabel sizeWithFont:cell.responseLabel.font
            //                                       constrainedToSize:CGSizeMake(CGRectGetWidth(cell.responseLabel.frame), FLT_MAX)];
            
            //New Code
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:addObj.errorlLabel
                                                                                 attributes:@{NSFontAttributeName:cell.responseLabel.font}];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGRectGetWidth(cell.responseLabel.frame), CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGSize errorLabelSize = rect.size;
			
            if([addObj.errorlLabel rangeOfString:@"||"].location==NSNotFound)
            {
                if(errorLabelSize.height > CGRectGetHeight(cell.responseLabel.frame))
                {
                    [cell.moreInfoView setHidden:NO];
                    [cell.responseLabel setHidden:YES];
                    
                    [cell.successLabel setTextColor:cell.responseLabel.textColor];
                    NSString *str=[NSString stringWithFormat:@"%@",addObj.errorlLabel];
                    str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                    str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                    [cell.successLabel setText:str];
                    
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
                if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
                    [cell.moreInfoButton setImage:[UIImage imageNamed:@"info_blue_btn.png"] forState:UIControlStateNormal];
                else
                    [cell.moreInfoButton setImage:[UIImage imageNamed:@"btn_info.png"] forState:UIControlStateNormal];
                
                NSArray *alignMsgArray = [addObj.errorlLabel componentsSeparatedByString:@"||"];
                
                if (alignMsgArray.count==1) {
                    if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
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
                    if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
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
        
        //Set Normal Color Color
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:cell.frame];
        [imgView setImage:[UIImage imageNamed:@"detail_add.png"]];
        [cell setBackgroundView:imgView];
        
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
    {   //Clear global error label
        [self updateViewErrLabelWithText:nil sucessOrFail:TRUE];
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

#pragma mark List View Custom delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    [listPopOverController dismissPopoverAnimated:YES];
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

#pragma mark PopOver Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [changeTerritoryBtn setSelected:NO];
}
#pragma mark -

#pragma mark View Handlers
-(void)refreshCustomerDetailOfIndex:(NSInteger)index
{
    [addAddressBtn setEnabled:TRUE];
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    if([[searchParameters objectForKey:@"SearchType"] isEqualToString:INDIVIDUALS_KEY])
    {
        CustomerObject* selectedCustObject=[custData objectAtIndex:index];
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
        
        //Clear All Fields
        nameText.text=@"";
        primarySpecialtyText.text=@"";
        secondarySpecialtyText.text=@"";
        professionalText.text=@"";
        CustTypeText.text=@"";
        BPIDText.text=@"";
        NPIText.text=@"";
        
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
        nameText.text=[nameArray componentsJoinedByString:@" "];
        
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
        
        if(selectedCustObject.custBPID!=nil)
        {
            BPIDText.text=[NSString stringWithFormat:@"%@",selectedCustObject.custBPID];
        }
        if(selectedCustObject.custNPI!=nil)
        {
            NPIText.text=[NSString stringWithFormat:@"%@",selectedCustObject.custNPI ];
        }
        
        if(selectedCustObject.custType!=nil)
        {
            CustTypeText.text=selectedCustObject.custType;
        }
        if(selectedCustObject.custProfessionalDesignation!=nil)
        {
            professionalText.text=[[[JSONDataFlowManager sharedInstance]profDesignKeyValue] objectForKey:selectedCustObject.custProfessionalDesignation];
        }
        
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
        //For on off functionality buttons will be enabled/disabled based on the terriotary flag
        //For HO user all buttons are disabled except Add to terriotary
        NSDictionary *onOffDictionary = [defaults objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
        NSDictionary *terriotaryId = [onOffDictionary objectForKey:[defaults objectForKey:@"SelectedTerritoryId"]];
        if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_INDV_KEY]||[[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
        {
            [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
            [self.addNewCustomerBtn setEnabled:NO];
            [addAddressBtn setEnabled:NO];
        }
        else if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
            addAddressBtn.enabled=TRUE;

        
    }
    else
    {
        OrganizationObject  * selectedOrgObject=[custData objectAtIndex:index];
        
        //Set Customer Details
        selectedIndexCustData=index;
        //Clear All Fields
        orgNameText.text=@"";
        orgBPIDText.text=@"";
        orgValidationStatusText.text=@"";
        subClassificationText.text=@"";
        
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
            orgBPIDText.text=[NSString stringWithFormat:@"%@",selectedOrgObject.orgBPID];
        }
        if(selectedOrgObject.orgValidationStatus!=nil)
        {
            orgValidationStatusText.text=selectedOrgObject.orgValidationStatus;
        }
        if(selectedOrgObject.orgBPClassification!=nil)
        {
            subClassificationText.text=selectedOrgObject.orgBPClassification;
        }
        [selectedCustDetailAddress removeAllObjects];
        for(AddressObject* add in selectedOrgObject.orgAddress)
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
        //For on off functionality buttons will be enabled/disabled based on the terriotary flag
        //For HO user all buttons are disabled except Add to terriotary
        NSDictionary *onOffDictionary = [defaults objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
        NSDictionary *terriotaryId = [onOffDictionary objectForKey:[defaults objectForKey:@"SelectedTerritoryId"]];
        if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_ORG_KEY]||[[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
        {
            [self updateViewErrLabelWithText:[terriotaryId objectForKey:ADD_ONOFF_ERROR_KEY] sucessOrFail:FALSE];
            [self.addNewCustomerBtn setEnabled:NO];
            [addAddressBtn setEnabled:NO];
        }
        else if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
                addAddressBtn.enabled=TRUE;
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:indexPath];
    
    UIButton * territoryBtn=(UIButton *)[cell viewWithTag:5];
    [territoryBtn setEnabled:YES];
    [custDetailAddressTable reloadData];
    [self showCustmerAddressNotAvilableLabel];
}

-(void)refreshSearchParametersView:(NSMutableDictionary *)searchParametersDict
{
    //Update UI with search parameters received from search form
    if([self.searchParameters isEqualToDictionary:searchParametersDict])
        return;
    
    [searchParameters removeAllObjects];
    searchParameters = [NSMutableDictionary dictionaryWithDictionary:searchParametersDict];
    
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
    {
        [searchParameters setObject:INDIVIDUALS_STRING forKey:@"SearchType"];
    }
    else
    {
        [searchParameters setObject:ORGANIZATIONS_STRING forKey:@"SearchType"];
    }
    
    [searchParameterTable reloadData];
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

//View Err Display manager
-(void)updateViewErrLabelWithText:(NSString*)msgText sucessOrFail:(BOOL)success
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(success) //blue text
    {
        serverResponseLabel.textColor = THEME_COLOR;
    }
    else // red text
    {
        serverResponseLabel.textColor = [UIColor redColor];
    }
    
    serverResponseLabel.text = msgText;
    //Adding HO user message in msgText if logedin user is HO user.
    if ([[defaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
        if (msgText.length>0) {
            msgText = [NSString stringWithFormat:@"%@\n%@",[defaults objectForKey:SEARCH_MESSAGE_KEY],msgText];
            
        }
        else
            msgText = [NSString stringWithFormat:@"%@",[defaults objectForKey:SEARCH_MESSAGE_KEY]];
        serverResponseLabel.text = msgText;
        [serverResponseLabel setTextColor:[UIColor redColor]];
    }

    if(msgText && msgText.length)
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
        // detailsViewFrame.origin.y = 10;
		detailsViewFrame.origin.y = 6;
        detailView.frame = detailsViewFrame;
    }
}

-(void)updateCellErrLabelWithText:(NSString*)msgText sucessOrFail:(BOOL)success
{
    NSIndexPath* index=[NSIndexPath indexPathForRow:selectedIndexCustAddress inSection:0];
    UITableViewCell * cell=[self.custDetailAddressTable cellForRowAtIndexPath:index];
    UILabel * errorLabel=(UILabel *)[cell viewWithTag:ERROR_LABEL_TAG];
    
    CGSize maxLabelSize = CGSizeMake(CGRectGetWidth(errorLabel.frame),CGFLOAT_MAX);
    
    // CGSize dynamicLabelSize = [msgText sizeWithFont:errorLabel.font
    //                           constrainedToSize:maxLabelSize
    //                           lineBreakMode:errorLabel.lineBreakMode];
		 
    //Adding lines to rectify sizeWithFont method
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize dynamicLabelSize = [msgText boundingRectWithSize:maxLabelSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:errorLabel.font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    //adjust the label the the new height.
    CGRect labelFrame = errorLabel.frame;
    labelFrame.size.height = dynamicLabelSize.height;
    errorLabel.frame = labelFrame;
    
    [errorLabel setText:msgText];
    
    if(success)
    {
        errorLabel.textColor = THEME_COLOR;
    }
    else
    {
        errorLabel.textColor = [UIColor redColor];
    }
}

-(void)showCustmerAddressNotAvilableLabel
{
    if ([selectedCustDetailAddress count]==0) {
        custAddressNotAvailable.hidden=NO;
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:custDetailAddressTable.frame];
        [imgView setBackgroundColor:[UIColor clearColor]];
        [custDetailAddressTable setBackgroundView:imgView];
    }
    else
    {
        custAddressNotAvailable.hidden=YES;
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:custDetailAddressTable.frame];
        [imgView setImage:[UIImage imageNamed:@"detail_add.png"]];
        [custDetailAddressTable setBackgroundView:imgView];
    }
    
}

//Modal view must be removed from parent view only
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
#pragma mark -

@end
