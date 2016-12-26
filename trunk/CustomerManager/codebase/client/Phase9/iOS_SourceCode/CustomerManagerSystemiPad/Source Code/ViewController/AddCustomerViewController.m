//
//  AddCustomerViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 08/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "AddCustomerViewController.h"
#import "Themes.h"
#import "QuartzCore/QuartzCore.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AddCustomerCustomCellSearchTwo.h"
#import "AdvancedSearchViewController.h"
#import "AddCustomerSearchDetailsViewController.h"
#import "CustomerObject.h"
#import "AddressObject.h"
#import "DummyData.h"
#import "ListViewController.h"
#import "DataManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "JSONDataFlowManager.h"
#import "ModalDataLoader.h"
#import "CustomModalViewBO.h"
#import "DatabaseManager.h"
#define CELL_PADDING 20

@interface AddCustomerViewController ()
{
    BOOL isConnectionInProgress;
    NSString *latestConnectionIdentifier;
}
@property(nonatomic,assign) IBOutlet UIView * mainView;
@property(nonatomic,assign) IBOutlet UILabel * welcomeUserText;
@property(nonatomic,assign) IBOutlet UITableView *searchType;
@property(nonatomic,assign) IBOutlet UILabel *idQuickSearchErrorLabel;
@property(nonatomic,assign) IBOutlet UITableView *recentChangesList;
@property(nonatomic,assign) IBOutlet UILabel *nameQuickSearchErrorLabel;
@property(nonatomic,retain) NSMutableArray *searchTypeData;
@property(nonatomic,retain) NSMutableArray *recentChangesData;
@property(nonatomic,retain) UIButton * changeTerritoryBtn;
@property(nonatomic,assign) IBOutlet UIView *BPIDView;
@property(nonatomic,assign) IBOutlet UIView *NPIView;
@property(nonatomic,assign) IBOutlet UITextField * BPIDText;
@property(nonatomic,assign) IBOutlet UITextField * NPIText;
@property(nonatomic,retain) UIView* tabBarLogo;
@property(nonatomic,retain) UITextField * lastNameText;
@property(nonatomic,retain) UITextField * firstNameText;
@property(nonatomic,retain) UITextField * stateText;
@property(nonatomic,assign) IBOutlet UITableView *searchTwoTableView;
@property(nonatomic,assign) IBOutlet UILabel* NPILbl;
@property(nonatomic,assign) IBOutlet UILabel * searchCriteriaTwoLbl;
@property(nonatomic,assign) IBOutlet UILabel * searchCriteriaOneLbl;
@property(nonatomic,assign) IBOutlet UILabel *OrLbl;
@property(nonatomic,assign) IBOutlet UIView * seperatorLine;
@property(nonatomic,retain) UIPopoverController * listPopOverController;

@property(nonatomic,assign) IBOutlet UIView *searchOnIdView;
@property(nonatomic,assign) IBOutlet UIView *searchOnNameView;
@property(nonatomic,assign) IBOutlet UIButton *searchOnIdBtn;
@property(nonatomic,assign) IBOutlet UIButton *searchOnNameBtn;
@property(nonatomic,assign) IBOutlet UILabel *serverResponseCommonlabel;
@property(nonatomic,retain) CustomModalViewController *customModalViewController;
@property(nonatomic,retain) UIButton *addNewCustomerButton;

-(IBAction)clickSearchCriteriaOneBtn:(id)sender;
-(IBAction)clickSearchCriteriaTwoBtn:(id)sender;
-(IBAction)clickAdvancedSearch:(id)sender;
-(void)clickState;
-(void)clickLogOut;
-(void)resignActiveTextFields;
-(void)clearAllTextFields;
// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView;
@end

@implementation AddCustomerViewController
@synthesize mainView,welcomeUserText,searchType,idQuickSearchErrorLabel,searchTypeData,NPIText,BPIDText,lastNameText,firstNameText,stateText,recentChangesList,recentChangesData,tabBarLogo,searchTwoTableView,NPILbl,searchCriteriaOneLbl,searchCriteriaTwoLbl,listPopOverController,changeTerritoryBtn,BPIDView,NPIView,OrLbl,nameQuickSearchErrorLabel,seperatorLine,searchOnIdBtn,searchOnNameBtn,searchOnIdView,searchOnNameView,serverResponseCommonlabel,customModalViewController,addNewCustomerButton;

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
    
    isConnectionInProgress = FALSE;
    latestConnectionIdentifier = @"";
    
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self setNavigationBarThemeAndColor];
    [self setBorderAndColor];
    
    [self.serverResponseCommonlabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
    
    //Init Array
    searchTypeData=[[NSMutableArray alloc]init];
    [searchTypeData addObject:INDIVIDUALS_STRING];
    [searchTypeData addObject:ORGANIZATIONS_STRING];
    [defaults setObject:[self.searchTypeData objectAtIndex:0] forKey:@"selectedsearchtype"];
    
    recentChangesData=[[NSMutableArray alloc]init];
    [recentChangesList setBackgroundView:nil];
    [recentChangesList setClipsToBounds:YES];
    [recentChangesList setRowHeight:60.0];
    
    [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];

    //Checking if target tab is enabled/Disabled at the time of Apperaing
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate resetAppForTerritoryChange];
}

-(void)setBorderAndColor
{
    mainView.layer.borderWidth=1.0f;
    mainView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [Themes setBackgroundTheme1:mainView];
    NSMutableString * fullName=[[NSMutableString alloc]init];
    [fullName appendFormat:WELCOME_STRING];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
    if([loggedInUser objectForKey:@"FullName"]!=nil)
    {
        [fullName appendString:[loggedInUser objectForKey:@"FullName"]];
    }
    [fullName appendString:@"!"];
    
    welcomeUserText.text=fullName;
    //searchType.layer.cornerRadius=10.0f;
    searchType.layer.borderWidth=1.0f;
    searchType.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    //BPIDView.layer.cornerRadius=10.0f;
    BPIDView.layer.borderWidth=1.0f;
    BPIDView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [BPIDText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    BPIDText.tag=2;
    //NPIView.layer.cornerRadius=10.0f;
    NPIView.layer.borderWidth=1.0f;
    NPIView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [NPIText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    NPIText.tag=1;
    //searchTwoTableView.layer.cornerRadius=10.0f;
    searchTwoTableView.layer.borderWidth=1.0f;
    searchTwoTableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = seperatorLine.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor], nil];
    [seperatorLine.layer insertSublayer:gradient atIndex:0];
}

-(void)setNavigationBarThemeAndColor
{
    //Set Navigation Bar Themes
    self.navigationController.navigationBar.tintColor=THEME_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView=[Themes setNavigationBarNormal:QUICK_SEARCH_TITLE_STRING ofViewController:@"SearchCustomers"];
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
        else if (btn.tag==4)
        {
            //Add new customer button
            [btn addTarget:self action:@selector(addNewCustomerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setEnabled:NO];
            addNewCustomerButton = btn;
        }
        //Go to BU, Team and Terriotary selection page
        else if (btn.tag==1101)
        {
            [btn addTarget:self action:@selector(loadBuTeamTerrSelectionView) forControlEvents:UIControlEventTouchUpInside];
//            changeTerritoryBtn=btn;
        }

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Remove Custom view controller to Add new customer if present
    if(self.customModalViewController && [self.childViewControllers containsObject:self.customModalViewController])
    {
        [self removeCustomModalViewController];
    }
    
    //Disable Add new Customer button
    [self.addNewCustomerButton setEnabled:NO];
    
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
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([[JSONDataFlowManager sharedInstance]selectedTerritoryName]!=nil && ![[[JSONDataFlowManager sharedInstance]selectedTerritoryName]isEqualToString:@""]) {
        if (![[[JSONDataFlowManager sharedInstance]selectedTerritoryName] isEqualToString:[defaults objectForKey:SELECTED_TERRITTORY_NAME]])
        {
            [self clearAllTextFields];
            
            [[JSONDataFlowManager sharedInstance]setSelectedTerritoryName:[defaults objectForKey:SELECTED_TERRITTORY_NAME]];
            
            //Default request for Remove and Request tab
            [[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:TRUE];
            [[DataManager sharedObject] setIsDefaultRequestForRequests:TRUE];
        }
    }
    else
        [[JSONDataFlowManager sharedInstance]setSelectedTerritoryName:[defaults objectForKey:SELECTED_TERRITTORY_NAME]];
    
    [self resignActiveTextFields];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Refresh Territory field on navigation bar
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //Clear Success/Error labels
    [idQuickSearchErrorLabel setText:@""];
    [nameQuickSearchErrorLabel setText:@""];
    [self updateServerResponseLabelWithText:nil forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
    
    [self getRecents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getRecents
{
    if(iSLiveApp)
    {
        //Test URL:  http://localhost:8085/nexus-ws/CMService/requests/wooh/32a545c0-f746-4819-a03c-3dd50b5a15ab/getRecentChanges?personnel_id=1&terr_id=1
        
        isConnectionInProgress = TRUE;
        [Utilities addSpinnerOnView:recentChangesList withMessage:@""];
        
        NSMutableString *recentsUrl = [[NSString stringWithFormat:@"%@", RECENTS_URL] mutableCopy];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [recentsUrl appendFormat:@"personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [recentsUrl appendFormat:@"&terr_id=%@", [userDefaults objectForKey:@"SelectedTerritoryId"]];
        
        ConnectionClass *connection = [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[recentsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"GetRecents" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        
        latestConnectionIdentifier = @"GetRecents";
    }
}
#pragma mark -

#pragma mark UI Actions
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

-(IBAction)clickAdvancedSearch:(id)sender{
    //Resign active text field
    [self resignActiveTextFields];

    //Disable Add new Customer button
    [self.addNewCustomerButton setEnabled:NO];
    
    AdvancedSearchViewController* advancedSearchViewController=[[AdvancedSearchViewController alloc]initWithNibName:@"AdvancedSearchViewController" bundle:nil];
    NSString *callBackIdentifier = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
    {
        //Set callback identifier
        callBackIdentifier = @"AdvanceSearchForIndividuals";
        
        if([BPIDText.text length])
            [advancedSearchViewController.searchParameters setObject:BPIDText.text forKey:BPID_KEY];
        
        if([NPIText.text length])
            [advancedSearchViewController.searchParameters setObject:NPIText.text forKey:NPI_KEY];
        
        if([firstNameText.text length])
            [advancedSearchViewController.searchParameters setObject:firstNameText.text forKey:FIRST_NAME_KEY];
        
        if([lastNameText.text length])
            [advancedSearchViewController.searchParameters setObject:lastNameText.text forKey:LAST_NAME_KEY];
        
        if([stateText.text length])
            [advancedSearchViewController.searchParameters setObject:stateText.text forKey:STATE_KEY];
    }
    else
    {
        //Set callback identifier
        callBackIdentifier = @"AdvanceSearchForOrganizations";
        
        if([BPIDText.text length])
            [advancedSearchViewController.searchParameters setObject:BPIDText.text forKey:ORG_BPID_KEY];
        
        if([firstNameText.text length])
            [advancedSearchViewController.searchParameters setObject:firstNameText.text forKey:ORG_NAME_KEY];
        
        if([stateText.text length])
            [advancedSearchViewController.searchParameters setObject:stateText.text forKey:STATE_KEY];
    }
    
    [self.navigationController pushViewController:advancedSearchViewController animated:YES];
    advancedSearchViewController.customTableViewController.callBackIdentifier = callBackIdentifier;
}

-(IBAction)clickSearchCriteriaOneBtn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Clear error labels
    [idQuickSearchErrorLabel setText:@""];
    [nameQuickSearchErrorLabel setText:@""];
    
    //Disable Add new Customer button
    [self.addNewCustomerButton setEnabled:NO];
    
    //Dismiss Keyboard
    [self resignActiveTextFields];
    
    NSString* BPID = [BPIDText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* NPI = [NPIText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //check if both BPID and NPI are empty
    if ((BPID==nil || BPID.length<=0) && (NPI==nil || NPI.length<=0))
    {
        if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY]) //NPI
        {
            [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:ERROR_PROVIDE_MASTER_OR_NPI_ID withDelegate:self];
        }
        else // DDD is equal to NPI Text in Org
        {
            [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:ERROR_PROVIDE_MASTER_ID withDelegate:self];
        }
        
    }
    else //both BPID or NPI are entered
    {
        BOOL validBPID=TRUE;
        BOOL validNPIDDD=TRUE;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        if(BPID!=nil && BPID.length>0)
        {
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:BPID];
            validBPID = [alphaNums isSupersetOfSet:inStringSet];
        }
        
        if(NPI!=nil && NPI.length>0)
        {
            NSCharacterSet *inStringSet1 = [NSCharacterSet characterSetWithCharactersInString:NPI];
            validNPIDDD=[alphaNums isSupersetOfSet:inStringSet1];
        }
        
        //in case valid then proceed further
        if (validBPID && validNPIDDD)
        {
            if(iSLiveApp)
                //if(TRUE) //Demo 22 July
            {
                if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
                {
                    //Update Boolean for individual add customer
                    [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];
                    
                    NSMutableString * url=[[NSMutableString alloc]init];
                    [url appendFormat:@"%@",SEARCH_INDIVIDUAL_URL];
                    
                    NSString *msgString = @"";
                    //if BPID and NPI is entered, search will happen using only BPID
                    if(BPID!=nil && ![BPID isEqualToString:@""])
                    {
                        [url appendFormat:@"bp_id=%@&",BPID];
                        msgString = SEARCHING_FOR_MASTER_ID_STRING;
                        [defaults setObject:BP_ID_QUICK_SEARCH forKey:@"quickSearchType"];
                    }
                    //if(NPI!=nil && ![NPI isEqualToString:@""])
                    else if(NPI!=nil && ![NPI isEqualToString:@""])
                    {
                        [url appendFormat:@"npi=%@&",NPI];
                        msgString = SEARCHING_FOR_NPI_STRING;
                        [defaults setObject:NPI_QUICK_SEARCH forKey:@"quickSearchType"];
                    }
                    [url appendFormat:@"search_type=reg"];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
                    [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
                    
                    //Add spinner with message
                    [Utilities addSpinnerOnView:self.view withMessage:msgString];
                    isConnectionInProgress = TRUE;
                    
                    ConnectionClass * connection= [ConnectionClass sharedSingleton];
                    [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchIndividualWebServiceCriteriaOne" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
                    
                    latestConnectionIdentifier = @"SearchIndividualWebServiceCriteriaOne";
                }
                else // Organization search
                {
                    //Update Boolean for individual add customer
                    [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:NO];
                    
                    NSMutableString * url=[[NSMutableString alloc]init];
                    [url appendFormat:@"%@",SEARCH_ORGANIZATION_URL];
                    
                    NSString *msgString = @"";
                    //if BPID# and DDD# is entered, serach will happen using only BPID
                    if(BPID!=nil && ![BPID isEqualToString:@""])
                    {
                        [url appendFormat:@"bp_id=%@&",BPID];
                        msgString = SEARCHING_FOR_MASTER_ID_STRING;
                        [defaults setObject:BP_ID_QUICK_SEARCH forKey:@"quickSearchType"];
                    }
                    
                    [url appendFormat:@"search_type=reg"];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
                    [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
                    
                    //Add spinner with message
                    [Utilities addSpinnerOnView:self.view withMessage:msgString];
                    isConnectionInProgress = TRUE;
                    
                    ConnectionClass * connection= [ConnectionClass sharedSingleton];
                    [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchOrganizationWebServiceCriteriaOne" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
                    
                    latestConnectionIdentifier = @"SearchOrganizationWebServiceCriteriaOne";
                }
            }
            else //STATIC DUMMY DATA
            {
                NSMutableDictionary* searchParameters=[[NSMutableDictionary alloc]init];
                NSMutableArray *searchBySectionRows = [[NSMutableArray alloc] init];
                [searchParameters setObject:[defaults objectForKey:@"selectedsearchtype"] forKey:@"SearchType"];
                
                if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
                {
                    //Update Boolean for individual add customer
                    [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];
                    
                    if(BPIDText.text!=nil && ![BPIDText.text isEqualToString:@""])
                    {
                        [searchParameters setObject:BPIDText.text forKey:BPID_KEY];
                        [searchBySectionRows addObject:BPID_KEY];
                        [defaults setObject:BP_ID_QUICK_SEARCH forKey:@"quickSearchType"];
                    }
                    else if(NPIText.text!=nil && ![NPIText.text isEqualToString:@""])
                    {
                        [searchParameters setObject:NPIText.text forKey:NPI_KEY];
                        [searchBySectionRows addObject:NPI_KEY];
                        [defaults setObject:NPI_QUICK_SEARCH forKey:@"quickSearchType"];
                    }
                }
                else
                {
                    //Update Boolean for individual add customer
                    [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:NO];
                    
                    if(BPIDText.text!=nil && ![BPIDText.text isEqualToString:@""])
                    {
                        [searchParameters setObject:BPIDText.text forKey:ORG_BPID_KEY];
                        [searchBySectionRows addObject:ORG_BPID_KEY];
                        [defaults setObject:BP_ID_QUICK_SEARCH forKey:@"quickSearchType"];
                    }
                }
                
                [searchParameters setObject:searchBySectionRows forKey:SEARCH_FORM_FIELDS_SEQUENCE];
                
                AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
                
                NSArray *searchedCustDataFromServer;
                searchedCustDataFromServer= [DummyData searchCustomerWithType:[defaults objectForKey:@"selectedsearchtype"]];
                addCustomerSearchDetailsViewController.searchParameters=searchParameters;
                addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
                [Utilities removeSpinnerFromView:self.view];
                [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
            }
            
        }
        else //Validation:Not numeric and less that 2 charatcters
        {
            NSString *alertMessage = nil;
            
            if(!validBPID && !validNPIDDD)
            {
                if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY]) //BPID or NPI
                {
                    //Selected BP ID does
                    // not exist. Please select another ID
                    alertMessage = ERROR_PROVIDE_VALID_MASTER_OR_NPI_ID;
                }
                else    //BPID or DDD
                {
                    alertMessage = ERROR_PROVIDE_VALID_MASTER_ID;
                }
            }
            else if(!validBPID)
            {
                alertMessage = ERROR_PROVIDE_VALID_MASTER_ID;
                
            }
            else if(!validNPIDDD)//NPI or DDD
            {
                if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY]) //NPI
                {
                    alertMessage = ERROR_PROVIDE_VALID_NPI_ID;
                }
            }
            
            [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:alertMessage withDelegate:self];
        }
    }
}

-(IBAction)clickSearchCriteriaTwoBtn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Clear error labels
    [idQuickSearchErrorLabel setText:@""];
    [nameQuickSearchErrorLabel setText:@""];
    
    //Disable Add new Customer button
    [self.addNewCustomerButton setEnabled:NO];
    
    //Dismiss Keyboard
    [self resignActiveTextFields];
    
    NSString * fname=[firstNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * lname=[lastNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * state=[stateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isValid=TRUE;
    if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
    {
        //Check for required field validation for first name/org name and state
        if((fname==nil || fname.length<=0)  || (lname==nil || lname.length<=0) || (state==nil || state.length<=0))
        {
            [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:ERROR_PROVIDE_ALL_REQUIRED_FIELDS withDelegate:self];
            isValid=FALSE;
        }
        
        //Check for min character validation for First name , last name
        if(isValid)
        {
            if(fname.length<TEXT_INPUT_MIN_CHAR_LIMIT && lname.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:[NSString stringWithFormat:@"%@", ERROR_MINIMUM_2_CHAR_FOR_FIRST_AND_LAST_NAMES] withDelegate:self];
                isValid=FALSE;
            }
            else if(fname.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:[NSString stringWithFormat:@"%@", ERROR_MINIMUM_2_CHAR_FOR_FIRST_NAME] withDelegate:self];
                isValid=FALSE;
            }
            else if (lname.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:[NSString stringWithFormat:@"%@", ERROR_MINIMUM_2_CHAR_FOR_LAST_NAME] withDelegate:self];
                isValid=FALSE;
            }
        }
    }
    else // For required field validation on state and org name
    {
        if((fname==nil || fname.length<=0)  || (state==nil || state.length<=0))
        {
            [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:ERROR_PROVIDE_ALL_REQUIRED_FIELDS withDelegate:self];
            isValid=FALSE;
        }
        
        //Check for min character validation for Org name
        if(isValid)
        {
            if(fname.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:[NSString stringWithFormat:@"%@", ERROR_MINIMUM_2_CHAR_FOR_ORG_NAME] withDelegate:self];
                isValid=FALSE;
            }
        }
    }
    
    if(isValid==TRUE)
    {
        //Check for number and special characters
        NSCharacterSet *alphabet = [NSCharacterSet letterCharacterSet];
        NSCharacterSet *alphaNumeric = [NSCharacterSet alphanumericCharacterSet];
        
        if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
        {
            NSString *validFname = [fname stringByReplacingOccurrencesOfString:@" " withString:@""];
            validFname = [validFname stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSString *validLname = [lname stringByReplacingOccurrencesOfString:@" " withString:@""];
            validLname = [validLname stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if(![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validFname]] ||
               ![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validLname]])
            {
                [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:ERROR_ENTER_ONLY_LETTERS withDelegate:self];
                return;
            }
        }
        else
        {
            NSString *validFname = [fname stringByReplacingOccurrencesOfString:@" " withString:@""];
            validFname = [validFname stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if(![alphaNumeric isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validFname]])
            {
                [Utilities displayErrorAlertWithTitle:SEARCH_STRING andErrorMessage:[NSString stringWithFormat:@"%@ %@", ORG_NAME_KEY, ERROR_CONTAINS_ONLY_LETTERS_NUMBERS_SPACE_AND_DASH] withDelegate:self];
                return;
            }
        }
        //End of Check for number and special characters
        
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        if(iSLiveApp)
        {
            if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
            {
                [defaults setObject:INDV_NAME_QUICK_SEARCH forKey:@"quickSearchType"];
                
                NSMutableString * url=[[NSMutableString alloc]init];
                [url appendFormat:@"%@",SEARCH_INDIVIDUAL_URL];
                if(fname!=nil && ![fname isEqualToString:@""])
                {
                    [url appendFormat:@"fname=%@&",fname];
                }
                if(lname!=nil && ![lname isEqualToString:@""])
                {
                    [url appendFormat:@"lname=%@&",lname];
                }
                if(state!=nil && ![state isEqualToString:@""])
                {
                    [url appendFormat:@"state=%@&",state];
                    
                    //TODO : add it to user default
                    NSDictionary *searchParameters = [NSDictionary dictionaryWithObjectsAndKeys:state, STATE_KEY, nil];
                    [defaults setObject:searchParameters forKey:@"searchParamState"];
                    
                }
                [url appendFormat:@"search_type=reg"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
                [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
                
                ConnectionClass * connection= [ConnectionClass sharedSingleton];
                [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchIndividualWebServiceCriteriaTwo" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
                
                latestConnectionIdentifier = @"SearchIndividualWebServiceCriteriaTwo";
                
                //Set connection progress flag
                isConnectionInProgress = TRUE;
            }
            else //org
            {
                [defaults setObject:ORG_NAME_QUICK_SEARCH forKey:@"quickSearchType"];
                
                NSMutableString * url=[[NSMutableString alloc]init];
                [url appendFormat:@"%@",SEARCH_ORGANIZATION_URL];
                if(fname!=nil && ![fname isEqualToString:@""])
                {
                    [url appendFormat:@"org_name=%@&",fname];
                }
                if(state!=nil && ![state isEqualToString:@""])
                {
                    [url appendFormat:@"state=%@&",state];
                    
                    //TODO : add it to user default
                    NSDictionary *searchParameters = [NSDictionary dictionaryWithObjectsAndKeys:state, STATE_KEY, nil];
                    [defaults setObject:searchParameters forKey:@"searchParamState"];
                }
                
                [url appendFormat:@"search_type=reg"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
                [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
                
                ConnectionClass * connection= [ConnectionClass sharedSingleton];
                [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchOrganizationWebServiceCriteriaTwo" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
                
                latestConnectionIdentifier = @"SearchOrganizationWebServiceCriteriaTwo";
                
                //Set connection progress flag
                isConnectionInProgress = TRUE;
            }
        }
        else    //Static dummy data
        {
            NSMutableDictionary* searchParameters=[[NSMutableDictionary alloc]init];
            NSMutableArray *searchBySectionRows = [[NSMutableArray alloc] init];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [searchParameters setObject:[defaults objectForKey:@"selectedsearchtype"] forKey:@"SearchType"];
            
            if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
            {
                [defaults setObject:INDV_NAME_QUICK_SEARCH forKey:@"quickSearchType"];
                
                //Add Search Parameters
                if(lastNameText.text!=nil && ![lastNameText.text isEqualToString:@""])
                {
                    [searchParameters setObject:lastNameText.text forKey:LAST_NAME_KEY];
                    [searchBySectionRows addObject:LAST_NAME_KEY];
                }
                if(firstNameText.text!=nil && ![firstNameText.text isEqualToString:@""])
                {
                    [searchParameters setObject:firstNameText.text forKey:FIRST_NAME_KEY];
                    [searchBySectionRows addObject:FIRST_NAME_KEY];
                }
                if(stateText.text!=nil && ![stateText.text isEqualToString:@""])
                {
                    [searchParameters setObject:stateText.text forKey:STATE_KEY];
                    [searchBySectionRows addObject:STATE_KEY];
                }
            }
            else
            {
                [defaults setObject:ORG_NAME_QUICK_SEARCH forKey:@"quickSearchType"];
                
                if(firstNameText.text!=nil && ![firstNameText.text isEqualToString:@""])
                {
                    [searchParameters setObject:firstNameText.text forKey:ORG_NAME_KEY];
                    [searchBySectionRows addObject:ORG_NAME_KEY];
                }
                if(stateText.text!=nil && ![stateText.text isEqualToString:@""])
                {
                    [searchParameters setObject:stateText.text forKey:STATE_KEY];
                    [searchBySectionRows addObject:STATE_KEY];
                }
                
            }
            
            [searchParameters setObject:searchBySectionRows forKey:SEARCH_FORM_FIELDS_SEQUENCE];
            
            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            
            NSArray *searchedCustDataFromServer;
            searchedCustDataFromServer= [DummyData searchCustomerWithType:[defaults objectForKey:@"selectedsearchtype"]];
            addCustomerSearchDetailsViewController.searchParameters=searchParameters;
            addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
            [Utilities removeSpinnerFromView:self.view];
            [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
        }
    }
}


-(void)clickState
{
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:STATE_KEY listHeader:STATE_KEY withSelectedValue:stateText.text];
    listViewController.delegate=self;
    listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
    listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
        {
            [listPopOverController presentPopoverFromRect:CGRectMake(searchTwoTableView.frame.origin.x-50, searchTwoTableView.frame.origin.y+20, searchTwoTableView.frame.size.width, searchTwoTableView.frame.size.height) inView:searchTwoTableView permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                 animated:YES];
        }
        else
        {
            [listPopOverController presentPopoverFromRect:CGRectMake(searchTwoTableView.frame.origin.x-50, searchTwoTableView.frame.origin.y-22, searchTwoTableView.frame.size.width, searchTwoTableView.frame.size.height) inView:searchTwoTableView permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                 animated:YES];
        }
    });
}

-(void)addNewCustomerButtonClicked:(id)sender
{
    //First resign any active textField
    [self resignActiveTextFields];
    
    if(customModalViewController)
    {
        customModalViewController = nil;
    }
    
    customModalViewController = [[CustomModalViewController alloc] initWithNibName:@"CustomModalViewController" bundle:nil];
    
    //Set frame for animation
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + customModalViewController.view.frame.size.height;
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    
    //Set Data
    customModalViewController.customTableViewController.customerDataDelegate = self;
    customModalViewController.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //Do any required UI changes after frame set
    CustomModalViewBO *customBO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForNewIndividualCustomer];
        customModalViewController.customTableViewController.callBackIdentifier = @"AddCustomerOfTypeIndividualFromQuickSearch";
    }
    else
    {
        customBO = [ModalDataLoader getModalCustomInputDictionaryForNewOrganizationalCustomer];
        customModalViewController.customTableViewController.callBackIdentifier = @"AddCustomerOfTypeOrganizationFromQuickSearch";
    }
    
    [customModalViewController.customTableViewController setInputTableDataDict:customBO.customModalInputDict];
    [customModalViewController.customTableViewController setSectionArray:customBO.customModalSectionArray];
    [customModalViewController.customTableViewController setRowArray:customBO.customModalRowArray];
    
    //Replace search button image with submit button
    [customModalViewController.searchButton setImage:[UIImage imageNamed:@"btn_submit.png"] forState:UIControlStateNormal];
    if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
        [customModalViewController.titleLabel setText:ADD_NEW_INDV_TITLE_STRING];
    else
        [customModalViewController.titleLabel setText:ADD_NEW_ORG_TITLE_STRING];
    
    [self addChildViewController:customModalViewController];
    [self.view addSubview:customModalViewController.view];
    
    //Animate view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    customModalViewController.view.frame=CGRectMake(customModalViewController.view.frame.origin.x, customModalViewController.view.frame.origin.y-offset, customModalViewController.view.frame.size.width, customModalViewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    //Dismiss Keyboard
    [self resignActiveTextFields];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];
    listViewController.delegate=self;
    listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor=[UIColor blackColor];
    listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    [listPopOverController presentPopoverFromRect:CGRectMake(changeTerritoryBtn.frame.origin.x+5+14
                                                             , changeTerritoryBtn.frame.origin.y-50, changeTerritoryBtn.frame.size.width, changeTerritoryBtn.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
}
#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    DebugLog(@"AddCustomerViewController : receiveDataFromServer LOG3 : JSON received : \n%@ \nIdentifier: %@",jsonDataArrayOfObjects ,identifier);
    
    //Reset conection in progress flag
    isConnectionInProgress = FALSE;
    
    //Remove spinner
    //[Utilities removeSpinnerFromView:self.view];
    
    if(jsonDataArrayOfObjects == nil)
    {
        //remove spinner from recents table
        [Utilities removeSpinnerFromView:recentChangesList];
        
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ErrorLog(@"Add Customer Class | Data Recieved Null. Json Parsing Error - %@ | Identifier - %@",myString ,identifier);
        
        if ([identifier isEqualToString:@"GetRecents"])
        {
            [self.recentChangesData removeAllObjects];
            [self.recentChangesData addObject:[NSString stringWithFormat:@"%@", ERROR_NO_RECENT_CHANGES]];
            [recentChangesList reloadData];
        }
        else if ([identifier isEqualToString:@"AddCustomerOfTypeIndividualFromQuickSearch"] || [identifier isEqualToString:@"AddCustomerOfTypeOrganizationFromQuickSearch"])
        {
            [customModalViewController displayErrorMessage:ERROR_ADD_CUSTOMER_FAILED];
        }
        else
        {
            //Display Error
            [self displayQuickSearchError:ERROR_REQUEST_COULD_NOT_COMPLETE_TRY_AGAIN forIdentifier:identifier];
        }
    }
    else if([identifier isEqualToString:@"SearchIndividualWebServiceCriteriaOne"] || [identifier isEqualToString:@"SearchIndividualWebServiceCriteriaTwo"])
    {
        //Remove spinner
        [Utilities removeSpinnerFromView:self.view];
        
        //Check for "Data Not Found" , status - Failure //18 July 2013
        NSDictionary *statusObj=[jsonDataArrayOfObjects objectAtIndex:0];
        
        NSString *status = [[statusObj objectForKey:@"status"] lowercaseString];
        
        if([status isEqualToString:@"failure"])
        {
            ErrorLog(@"Reason : %@, Dismiss spinner and stay on same screen", [statusObj objectForKey:@"reasonCode"]);
            
            //Display Error
            [self displayQuickSearchError:[NSString stringWithFormat:@"%@", [statusObj objectForKey:@"reasonCode"]] forIdentifier:identifier];
        }
        else if ([status isEqualToString:@"none"])
        {
            NSString *reasonCode;
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            //Bug #477: Error messages changed.
            if([identifier isEqualToString:@"SearchIndividualWebServiceCriteriaOne"])
            {
                if([[defaults objectForKey:@"quickSearchType"] isEqualToString:BP_ID_QUICK_SEARCH])
                    reasonCode=ERROR_MASTER_ID_DOES_NOT_EXIST;
                else if([[defaults objectForKey:@"quickSearchType"] isEqualToString:NPI_QUICK_SEARCH])
                    reasonCode=ERROR_NPI_DOES_NOT_EXIST;
                else
                    reasonCode = ERROR_ID_DOES_NOT_EXIST;
            }
            else
            {
                reasonCode = [NSString stringWithFormat:@"%@", [statusObj objectForKey:@"reasonCode"] ];
                
                if([reasonCode isEqualToString:ERROR_NO_RESULTS_FOUND_TRY_AGAIN])
                {
                    NSDictionary *onOffDictionary = [defaults objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
                    NSDictionary *terriotaryId = [onOffDictionary objectForKey:[defaults objectForKey:@"SelectedTerritoryId"]];
                    if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_INDV_KEY])
                    {
                        reasonCode = SEARCH_ERROR_MESSAGE_KEY;
                        [self.addNewCustomerButton setEnabled:NO];
                    }
                    else if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
                    {
                        reasonCode = [defaults objectForKey:SEARCH_MESSAGE_KEY];
                        [self.addNewCustomerButton setEnabled:NO];
                    }
                    else
                    {
                        reasonCode = ERROR_NO_RESULTS_FOUND_MODIFY_SEARCH_OR_ADD_NEW_CUSTOMER;
                        [self.addNewCustomerButton setEnabled:YES];
                    }
                }
            }
            
            //Display Error
            [self displayQuickSearchError:reasonCode forIdentifier:identifier];
        }
        //"Data Not Found" Check end here.
        else
        {
            NSMutableDictionary* searchParameters=[[NSMutableDictionary alloc]init];
            NSMutableArray *searchBySectionRows = [[NSMutableArray alloc] init];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [searchParameters setObject:[defaults objectForKey:@"selectedsearchtype"] forKey:@"SearchType"];
            if([identifier isEqualToString:@"SearchIndividualWebServiceCriteriaOne"])
            {
                if(BPIDText.text!=nil && ![BPIDText.text isEqualToString:@""])
                {
                    [searchParameters setObject:BPIDText.text forKey:BPID_KEY];
                    [searchBySectionRows addObject:BPID_KEY];
                }
                else if(NPIText.text!=nil && ![NPIText.text isEqualToString:@""])
                {
                    [searchParameters setObject:NPIText.text forKey:NPI_KEY];
                    [searchBySectionRows addObject:NPI_KEY];
                }
            }
            else //SearchIndividualWebServiceCriteriaTwo
            {
                if(firstNameText.text!=nil && ![firstNameText.text isEqualToString:@""])
                {
                    [searchParameters setObject:firstNameText.text forKey:FIRST_NAME_KEY];
                    [searchBySectionRows addObject:FIRST_NAME_KEY];
                }
                if(lastNameText.text!=nil && ![lastNameText.text isEqualToString:@""])
                {
                    [searchParameters setObject:lastNameText.text forKey:LAST_NAME_KEY];
                    [searchBySectionRows addObject:LAST_NAME_KEY];
                }
                if(stateText.text!=nil && ![stateText.text isEqualToString:@""])
                {
                    [searchParameters setObject:stateText.text forKey:STATE_KEY];
                    [searchBySectionRows addObject:STATE_KEY];
                }
            }
            
            [searchParameters setObject:searchBySectionRows forKey:SEARCH_FORM_FIELDS_SEQUENCE];
            
            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            
            NSArray *searchedCustDataFromServer;
            searchedCustDataFromServer= [Utilities parseJsonSearchIndividual:jsonDataArrayOfObjects];
            
            if(searchedCustDataFromServer!=nil && searchedCustDataFromServer.count>0)
            {
                addCustomerSearchDetailsViewController.searchParameters=searchParameters;
                addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
                [Utilities removeSpinnerFromView:self.view];
                [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
            }
        }
    }
    else  if([identifier isEqualToString:@"SearchOrganizationWebServiceCriteriaOne"] || [identifier isEqualToString:@"SearchOrganizationWebServiceCriteriaTwo"])
    {
        //Remove spinner
        [Utilities removeSpinnerFromView:self.view];
        
        //Check for "Data Not Found" , status - Failure //18 July 2013
        NSDictionary *statusObj=[jsonDataArrayOfObjects objectAtIndex:0];
        
        NSString *status = [[statusObj objectForKey:@"status"] lowercaseString];
        
        if([status isEqualToString:@"failure"])
        {
            ErrorLog(@"Reason : %@, Dismiss spinner and stay on same screen", [statusObj objectForKey:@"reasonCode"]);
            
            //Display Error
            [self displayQuickSearchError:[NSString stringWithFormat:@"%@", [statusObj objectForKey:@"reasonCode"]] forIdentifier:identifier];
        }
        else if ([status isEqualToString:@"none"])
        {
            NSString *reasonCode;
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            //Bug #477: Error messages changed.
            if([identifier isEqualToString:@"SearchOrganizationWebServiceCriteriaOne"])
            {
                if([[defaults objectForKey:@"quickSearchType"] isEqualToString:BP_ID_QUICK_SEARCH])
                    reasonCode=ERROR_MASTER_ID_DOES_NOT_EXIST;
                else
                    reasonCode = ERROR_ID_DOES_NOT_EXIST;
            }
            else
            {
                reasonCode = [NSString stringWithFormat:@"%@", [statusObj objectForKey:@"reasonCode"] ];
                
                if([reasonCode isEqualToString:ERROR_NO_RESULTS_FOUND_TRY_AGAIN])
                {
                    NSDictionary *onOffDictionary = [defaults objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
                    NSDictionary *terriotaryId = [onOffDictionary objectForKey:[defaults objectForKey:@"SelectedTerritoryId"]];
                    if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_ORG_KEY])
                    {
                        reasonCode = SEARCH_ERROR_MESSAGE_KEY;
                        [self.addNewCustomerButton setEnabled:NO];
                    }
                    else if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"])
                    {
                        reasonCode = [defaults objectForKey:SEARCH_MESSAGE_KEY];
                        [self.addNewCustomerButton setEnabled:NO];
                    }
                    else
                    {
                        reasonCode = ERROR_NO_RESULTS_FOUND_MODIFY_SEARCH_OR_ADD_NEW_CUSTOMER;
                        [self.addNewCustomerButton setEnabled:YES];
                    }
                }
            }
            
            //Display Error
            [self displayQuickSearchError:reasonCode forIdentifier:identifier];
        }
        //"Data Not Found" Check end here.
        else
        {
            NSMutableDictionary* searchParameters=[[NSMutableDictionary alloc]init];
            NSMutableArray *searchBySectionRows = [[NSMutableArray alloc] init];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [searchParameters setObject:[defaults objectForKey:@"selectedsearchtype"] forKey:@"SearchType"];
            
            if([identifier isEqualToString:@"SearchOrganizationWebServiceCriteriaOne"])
            {
                if(BPIDText.text!=nil && ![BPIDText.text isEqualToString:@""])
                {
                    [searchParameters setObject:BPIDText.text forKey:ORG_BPID_KEY];
                    [searchBySectionRows addObject:ORG_BPID_KEY];
                }
            }
            else
            {
                //Add Search Parameters
                if(firstNameText.text!=nil && ![firstNameText.text isEqualToString:@""])
                {
                    [searchParameters setObject:firstNameText.text forKey:ORG_NAME_KEY];
                    [searchBySectionRows addObject:ORG_NAME_KEY];
                }
                if(stateText.text!=nil && ![stateText.text isEqualToString:@""])
                {
                    [searchParameters setObject:stateText.text forKey:STATE_KEY];
                    [searchBySectionRows addObject:STATE_KEY];
                }
                
            }
            
            [searchParameters setObject:searchBySectionRows forKey:SEARCH_FORM_FIELDS_SEQUENCE];
            
            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            
            NSArray *searchedCustDataFromServer;
            searchedCustDataFromServer= [Utilities parseJsonSearchOrganization:jsonDataArrayOfObjects];
            
            if(searchedCustDataFromServer!=nil && [searchedCustDataFromServer count]>0)
            {
                addCustomerSearchDetailsViewController.searchParameters=searchParameters;
                addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
                [Utilities removeSpinnerFromView:self.view];
                [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
            }
        }
    }
    else if ([identifier isEqualToString:@"GetRecents"])
    {
        [Utilities removeSpinnerFromView:recentChangesList];
        
        //Check for "Data Not Found" , status - Failure //18 July 2013
        NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(jsonDataObject && ![jsonDataObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *jsonResponseArray=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            jsonDataObject = [jsonResponseArray objectAtIndex:0];
        }
        
        NSString *status = [[jsonDataObject objectForKey:@"status"] lowercaseString];
        
        if([status isEqualToString:@"success"])    //Success
        {
            NSArray *serverData = [Utilities parseJsonGetRecents:jsonDataObject];
            if(serverData && serverData.count>0)
            {
                [self.recentChangesData removeAllObjects];
                [self.recentChangesData addObjectsFromArray:serverData];
                [recentChangesList reloadData];
            }
        }
        else if([status isEqualToString:@"failure"])    //Failure
        {
            [self.recentChangesData removeAllObjects];
            [self.recentChangesData addObject:[jsonDataObject objectForKey:@"reasonCode"]];
            [recentChangesList reloadData];
        }
        else if ([status isEqualToString:LOGOUT_KEY])
        {
            [Utilities displayErrorAlertWithTitle:SESSION_EXPIRED andErrorMessage:[jsonDataObject objectForKey:@"reasonCode"] withDelegate:self];
        }
    }
    else if ([identifier isEqualToString:@"AddCustomerOfTypeIndividualFromQuickSearch"] || [identifier isEqualToString:@"AddCustomerOfTypeOrganizationFromQuickSearch"])
    {
        //Remove spinner
        [Utilities removeSpinnerFromView:self.view];
        
        NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
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
                
                //Disable Add new customer button
                [self.addNewCustomerButton setEnabled:NO];
                
                //Clear all text fields and error/success labels
                [self clearAllTextFields];
                
                //Display success msg on above details view
                [self updateServerResponseLabelWithText:[NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]] forIdentifier:identifier successOrFailure:TRUE];
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
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    ErrorLog(@"Add Customer Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    if ([identifier isEqualToString:@"AddCustomerOfTypeIndividualFromQuickSearch"] || [identifier isEqualToString:@"AddCustomerOfTypeOrganizationFromQuickSearch"])
    {
        [customModalViewController displayErrorMessage:error];
    }
    else
    {
        //Display Error
        [self displayQuickSearchError:error forIdentifier:identifier];
    }
    
    [Utilities removeSpinnerFromView:self.view];
    
    //Reset conection in progress flag
    isConnectionInProgress = FALSE;
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
    
    if([identifier isEqualToString:@"AddCustomerOfTypeIndividualFromQuickSearch"])
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
        [connection fetchDataFromUrl:[ADD_INDIVIDUAL_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:identifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else if([identifier isEqualToString:@"AddCustomerOfTypeOrganizationFromQuickSearch"])
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
        [connection fetchDataFromUrl:[ADD_ORGANIZATION stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:parameters forConnectionIdentifier:identifier andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    
    //Set connection in progress flag
    isConnectionInProgress = TRUE;
    
    //Add spinner
    [Utilities addSpinnerOnView:self.view withMessage:nil];
}

-(void)displayErrorMessage:(NSString *)errorMsg
{
    [self.customModalViewController displayErrorMessage:errorMsg];
}
#pragma mark -

#pragma mark Table View Data Sources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==searchType)
    {
        return [self.searchTypeData count];
    }
    else if(tableView==recentChangesList)
    {
        tableView.clipsToBounds = YES;
        return [self.recentChangesData count];
    }
    else if(tableView==searchTwoTableView)
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
        {
            [searchTwoTableView setFrame:CGRectMake(searchTwoTableView.frame.origin.x, searchTwoTableView.frame.origin.y, searchTwoTableView.frame.size.width, 133)];
            return 3;
        }
        else
        {
            [searchTwoTableView setFrame:CGRectMake(searchTwoTableView.frame.origin.x, searchTwoTableView.frame.origin.y, searchTwoTableView.frame.size.width, 88)];
            return 2;
        }
    }
    else
    {
        return 0;
    }
}

+ (CGFloat) getTextHeight:(NSString*)str
{
    
    CGSize size = CGSizeMake(210, 190);// here is some trick.
    
//    CGSize textSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:size];
    CGRect textRect = [str boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]}
                                         context:nil];
    
    CGSize textSize = textRect.size;
    
    return textSize.height + CELL_PADDING;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return UITableViewAutomaticDimension;
    if(tableView==recentChangesList)
    {
        if(self.recentChangesData.count > 0)
        {
            NSString *string  = [recentChangesData objectAtIndex:indexPath.row];
            CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
//            CGSize expectedLabelSize = [[self.recentChangesData objectAtIndex:indexPath.row] sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            CGRect textRect = [[self.recentChangesData objectAtIndex:indexPath.row] boundingRectWithSize:maximumLabelSize
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]}
                                                context:nil];
            
            CGSize expectedLabelSize = textRect.size;

            CGFloat height = expectedLabelSize.height;
            
            //remove customer label customized height
            NSRange range1 = [[NSString stringWithFormat:@"%@",[recentChangesData objectAtIndex:indexPath.row]] rangeOfString:@"being removed from"];
            if(range1.length > 0)
                height += 15;
            
            //adjusting label height in table based on message width
            NSRange range2 = [[NSString stringWithFormat:@"%@",[recentChangesData objectAtIndex:indexPath.row]] rangeOfString:@"new addresses have been"];
            if(range2.length > 0 && string.length > 118)
                height += 15;
            
            return height + CELL_PADDING ;
        }
    }
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellTemp;
    if(tableView==searchType)
    {
        static NSString *simpleTableIdentifier = @"searchType";
        cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cellTemp == nil) {
            cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cellTemp.tag=indexPath.row;
        cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
        cellTemp.textLabel.clipsToBounds = FALSE;
        [cellTemp.textLabel setText:[self.searchTypeData objectAtIndex:indexPath.row]];
        [cellTemp.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        for (int i=0; i<[self.searchTypeData count]; i++) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([[self.searchTypeData objectAtIndex:indexPath.row] isEqualToString:[defaults objectForKey:@"selectedsearchtype"]]) {
                [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
    }
    else if(tableView==recentChangesList)
    {
        static NSString *simpleTableIdentifier = @"recentChanges";
        cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cellTemp == nil) {
            cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cellTemp.tag=indexPath.row;
        cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellTemp.textLabel setText:[self.recentChangesData objectAtIndex:indexPath.row]];
        [cellTemp.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        [cellTemp.textLabel setTextColor:THEME_COLOR];
        [cellTemp.textLabel setNumberOfLines:0];
        [cellTemp.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }
    else if(tableView==searchTwoTableView)
    {
        static NSString *simpleTableIdentifier = @"searchTwoTableView";
        AddCustomerCustomCellSearchTwo *cell = (AddCustomerCustomCellSearchTwo *)[self.searchTwoTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddCustomerCustomCellSearchTwo" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
        {
            if (indexPath.row==0) {
                cell.txtLabel.text=FIRST_NAME_KEY;
                self.firstNameText=cell.txtField;
                self.firstNameText.delegate=self;
            }
            else if (indexPath.row==1) {
                cell.txtLabel.text=LAST_NAME_KEY;
                self.lastNameText=cell.txtField;
                self.lastNameText.delegate=self;
            }
            else if (indexPath.row==2) {
                cell.txtLabel.text=STATE_KEY;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell.txtField setEnabled:FALSE];
                self.stateText=cell.txtField;
                self.stateText.delegate=self;
            }
        }
        else //For Organization
        {
            if (indexPath.row==0) {
                cell.txtLabel.text=ORG_NAME_STRING;
                self.firstNameText=cell.txtField;
                self.firstNameText.delegate=self;
            }
            else if (indexPath.row==1) {
                cell.txtLabel.text=STATE_KEY;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell.txtField setEnabled:FALSE];
                self.stateText=cell.txtField;
                self.stateText.delegate=self;
            }
        }
        return cell;
        
    }
    return cellTemp;
}
#pragma mark -

#pragma mark Table View Delegates
- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Dismiss Keyboard
    [self resignActiveTextFields];
    
    if(tableView==searchType)
    {
        //Commented for only 22 July Demo . After Demo Please uncomment below code
        ///*
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.searchTypeData objectAtIndex:indexPath.row] forKey:@"selectedsearchtype"];
        [tableView  reloadData];
        [searchTwoTableView reloadData];
        if([[self.searchTypeData objectAtIndex:indexPath.row] isEqualToString:INDIVIDUALS_KEY])
        {
            //Change frame for BPID view
            [BPIDView setFrame:CGRectMake(20, 26, 270, 44)];
            
            [searchTwoTableView setFrame:CGRectMake(20, 26, 270, 132)];
            [searchCriteriaOneLbl setText:[NSString stringWithFormat:@"%@ or %@", BPID_KEY, NPI_KEY]];
            [searchCriteriaTwoLbl setText:INDV_QUICK_SEARCH_NAME_CRITERIA_STRING];
            [NPILbl setText:[NSString stringWithFormat:@"%@", NPI_KEY]];
            
            [NPIView setHidden:NO];
            [OrLbl setHidden:NO];
            
            //Clear all fields
            [self clearAllTextFields];
            
            //Disable Add new Customer button
            [self.addNewCustomerButton setEnabled:NO];
            
            [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];
        }
        else  if([[self.searchTypeData objectAtIndex:indexPath.row] isEqualToString:ORGANIZATIONS_KEY])
        {
            //Change frame for BPID view
            [BPIDView setFrame:CGRectMake(20, 60, 270, 44)];
            
            [searchTwoTableView setFrame:CGRectMake(20, 38, 270, 88)];
            [searchCriteriaOneLbl setText:[NSString stringWithFormat:@"%@", BPID_KEY]];
            [searchCriteriaTwoLbl setText:ORG_QUICK_SEARCH_NAME_CRITERIA_STRING];
            
            //592:DDD_IMS_ID
            //Hide NPI filed which is used as DDD in case of Org
            [searchCriteriaOneLbl setText:BPID_KEY];
            [NPIView setHidden:YES];
            [OrLbl setHidden:YES];
            
            //Clear all fields
            [self clearAllTextFields];
            
            //Disable Add new Customer button
            [self.addNewCustomerButton setEnabled:NO];
            
            [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:NO];
        }
    }
    else if(tableView==searchTwoTableView)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
        {
            if (indexPath.row==2)
            {
                //Dismiss Keyboard
                [self resignActiveTextFields];
                
                [self clickState];
            }
        }
        else
        {
            if (indexPath.row==1)
            {
                //Dismiss Keyboard
                [self resignActiveTextFields];
                
                [self clickState];
            }
        }
    }
}
#pragma mark -

#pragma mark List View Custom Delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    if([listType isEqualToString:CHANGE_TERRITORY])
    {
        [listPopOverController dismissPopoverAnimated:NO];
        listPopOverController = nil;


        //Reset state of change territory button
        [changeTerritoryBtn setSelected:NO];
        
        BOOL isTerritoryChanged = [Utilities changeSelectedTerritoryTo:value];
        if(isTerritoryChanged)
        {
            //Close all connections
            isConnectionInProgress = FALSE;
            [Utilities removeSpinnerFromView:self.view];
            
            //Refresh Territory field on navigation bar
            [Themes refreshTerritory:self.navigationItem.titleView.subviews];
            
            [self clearAllTextFields];
            
            //Disable Add new Customer button
            [self.addNewCustomerButton setEnabled:NO];
            
            //Remove custom modal view if present
            if([self.childViewControllers containsObject:self.customModalViewController])
            {
                [self removeCustomModalViewController];
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [[JSONDataFlowManager sharedInstance]setSelectedTerritoryName:[defaults objectForKey:@"SelectedTerritoryName"]];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate resetAppForTerritoryChange];
            
            //Refresh recents
            [self getRecents];
        }
    }
    else if([listType isEqualToString:STATE_KEY])
    {
        stateText.text=value;
        [listPopOverController dismissPopoverAnimated:NO];
        listPopOverController = nil;
    }
}
#pragma mark -

#pragma mark Text Field Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //Set return key of type search
    [textField setReturnKeyType:UIReturnKeySearch];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //Call respective search action on search key
    if(textField.returnKeyType == UIReturnKeySearch)
    {
        if([textField isEqual:BPIDText] || [textField isEqual:NPIText])
        {
            [self clickSearchCriteriaOneBtn:nil];
        }
        else if ([textField isEqual:firstNameText] || [textField isEqual:lastNameText])
        {
            [self clickSearchCriteriaTwoBtn:nil];
        }
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==BPIDText || textField==NPIText)
    {
        //Do not allow user to enter BP ID or NPI greater than 18 digits
        if(textField.text.length >= 18 && string.length!=0)
        {
            return NO;
        }
    }
    return YES;
}
#pragma mark -

#pragma mark Keyboard Notifications
-(void)keyboardWillShow
{
    if([self.childViewControllers containsObject:customModalViewController])
    {
        return;
    }
    
    CGRect frame = self.view.frame;
    frame.origin.y = -100;
    [self.view setFrame:frame];
}
-(void)keyboardWillHide
{
    if([self.childViewControllers containsObject:customModalViewController])
    {
        return;
    }
    
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    [self.view setFrame:frame];
}
#pragma mark -

#pragma mark PopOver Controller Delgate 
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [changeTerritoryBtn setSelected:NO];
}
#pragma mark -

#pragma mark View Handlers
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *touchedView = [touch view];
    if(![touchedView isKindOfClass:[UITextField class]])
    {
        [self resignActiveTextFields];
    }
}

-(void)resignActiveTextFields
{
    [self.BPIDText resignFirstResponder];
    [self.NPIText resignFirstResponder];
    [self.firstNameText resignFirstResponder];
    [self.lastNameText resignFirstResponder];
    [self.stateText resignFirstResponder];
}

-(void)clearAllTextFields
{
    [BPIDText setText:@""];
    [NPIText setText:@""];
    [firstNameText setText:@""];
    [lastNameText setText:@""];
    [stateText setText:@""];
    
    //Clear Success/Error labels
    [idQuickSearchErrorLabel setText:@""];
    [nameQuickSearchErrorLabel setText:@""];
    [self updateServerResponseLabelWithText:@"" forIdentifier:CLEAR_VIEW_ERROR_LABEL successOrFailure:TRUE];
}

-(void)displayQuickSearchError:(NSString*)error forIdentifier:(NSString*)identifier
{
    if([identifier isEqualToString:@"SearchIndividualWebServiceCriteriaOne"] || [identifier isEqualToString:@"SearchOrganizationWebServiceCriteriaOne"])
    {
        //Commenting deprecated method and replacing sizeWithAttributes: Method
        //CGSize textSize = [error sizeWithFont:idQuickSearchErrorLabel.font];
        CGSize textSize = [error sizeWithAttributes:@{NSFontAttributeName:idQuickSearchErrorLabel.font}];
        if(textSize.width > CGRectGetWidth(idQuickSearchErrorLabel.frame))
        {
            [idQuickSearchErrorLabel setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            [idQuickSearchErrorLabel setTextAlignment:NSTextAlignmentCenter];
        }
        
        [idQuickSearchErrorLabel setText:[NSString stringWithFormat:@"%@", error]];
    }
    else if ([identifier isEqualToString:@"SearchIndividualWebServiceCriteriaTwo"] || [identifier isEqualToString:@"SearchOrganizationWebServiceCriteriaTwo"])
    {
        //Commenting deprecated method and replacing with sizeWithAttributes: Method
        //CGSize textSize = [error sizeWithFont:nameQuickSearchErrorLabel.font];
        CGSize textSize = [error sizeWithAttributes:@{NSFontAttributeName:nameQuickSearchErrorLabel.font}];
        if(textSize.width > CGRectGetWidth(nameQuickSearchErrorLabel.frame))
        {
            [nameQuickSearchErrorLabel setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            [nameQuickSearchErrorLabel setTextAlignment:NSTextAlignmentCenter];
        }
        
        [nameQuickSearchErrorLabel setText:[NSString stringWithFormat:@"%@", error]];
    }
}

-(void)updateServerResponseLabelWithText:(NSString*)responseMsgOrNil forIdentifier:(NSString*)identifier successOrFailure:(BOOL)success
{
    if ([identifier isEqualToString:@"AddCustomerOfTypeIndividualFromQuickSearch"] || [identifier isEqualToString:@"AddCustomerOfTypeOrganizationFromQuickSearch"] ||
        [identifier isEqualToString:CLEAR_VIEW_ERROR_LABEL])
    {
        [serverResponseCommonlabel setText:responseMsgOrNil];
        
        //Set color
        if(success)
        {
            [serverResponseCommonlabel setTextColor:THEME_COLOR];
        }
        else
        {
            [serverResponseCommonlabel setTextColor:[UIColor redColor]];
        }
        
        if(responseMsgOrNil && responseMsgOrNil.length)
        {
            //Adjust details view frame
            CGRect mainViewFrame = self.mainView.frame;
            mainViewFrame.origin.y = CGRectGetMaxY(serverResponseCommonlabel.frame);
            self.mainView.frame = mainViewFrame;
        }
        else
        {
            //Adjust details view frame
            CGRect mainViewFrame = self.mainView.frame;
            mainViewFrame.origin.y = 20;
            self.mainView.frame = mainViewFrame;
        }
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
                         customModalViewController = nil;
                         
                         //Disable button if error labels are nil
                         [self.addNewCustomerButton setEnabled:((idQuickSearchErrorLabel.text.length || nameQuickSearchErrorLabel.text.length) ? YES : NO)];
                     }];
}
#pragma mark -

@end
