//
//  AdvancedSearchViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 10/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "AdvancedSearchViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "Themes.h"
#import "DummyData.h"
#import "AddCustomerSearchDetailsViewController.h"
#import "DataManager.h"
#import "DatabaseManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "ModalDataLoader.h"
#import "CustomModalViewBO.h"
#import "JSONDataFlowManager.h"
#import "LOVData.h"

#define kOFFSET_FOR_KEYBOARD 260.0
@interface AdvancedSearchViewController ()
{
    UITextField *activeTextField;
}
@property(nonatomic,assign) IBOutlet UIView * mainView;
@property(nonatomic,assign) IBOutlet UISegmentedControl* indvidualOrganisationSegmentControl;
@property(nonatomic,retain) UIPopoverPresentationController * listPopOverController;
@property(nonatomic,retain) UIButton *changeTerritoryBtn;
@property(nonatomic,assign) IBOutlet UIButton *searchButton;
@property(nonatomic,assign) IBOutlet UILabel *errorMessageLabel;

-(void)clickLogOut;
-(IBAction)valueChangedSegmentControl:(id)sender;
// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView;

@end

@implementation AdvancedSearchViewController

@synthesize listPopOverController;
@synthesize changeTerritoryBtn, searchButton;
@synthesize indvidualOrganisationSegmentControl;
@synthesize customTableViewController;
@synthesize tableContainerView;
@synthesize searchParameters;
@synthesize errorMessageLabel;

#pragma mark - Initialization: View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.searchParameters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView=[Themes setNavigationBarNormal:ADVANCE_SEARCH_TITLE_STRING ofViewController:@"AdvancedSearch"];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar. frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.navigationController.navigationBar addSubview:navBorder];
    
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
    }
    
    indvidualOrganisationSegmentControl.frame= CGRectMake(20, 20, 250, 35);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
    
    //Set Values From Home pgae
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"selectedsearchtype"] isEqualToString:INDIVIDUALS_KEY])
    {
        [indvidualOrganisationSegmentControl setSelectedSegmentIndex:0];
        [self valueChangedSegmentControl:nil];
    }
    else
    {
        [indvidualOrganisationSegmentControl setSelectedSegmentIndex:1];
        [self valueChangedSegmentControl:nil];
    }
}

-(void)initCustomTableViewWithObject:(CustomModalViewBO*)modalObject forIdentifier:(NSString*)callbackIdentifier
{
    self.customTableViewController = [[CustomTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.customTableViewController.tableView setFrame:CGRectMake(45, 0, CGRectGetWidth(self.tableContainerView.frame)-90, CGRectGetHeight(self.tableContainerView.frame))];
    self.customTableViewController.tableView.layer.borderColor = [UIColor clearColor].CGColor;
    self.customTableViewController.tableView.layer.borderWidth = 4.0;
    [self.customTableViewController.tableView setBackgroundView:nil];
    [self.customTableViewController.tableView setBackgroundColor:[UIColor clearColor]];
    self.customTableViewController.tableView.contentInset = UIEdgeInsetsZero;
    self.customTableViewController.tableView.contentOffset = CGPointZero;
    
    //make tableviewcells rounded rect
//    self.customTableViewController.tableView.layer.cornerRadius=10.0f;
//    self.customTableViewController.tableView.layer.borderWidth=1.0f;
//    self.customTableViewController.tableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;

    [self.customTableViewController setInputTableDataDict:modalObject.customModalInputDict];
    [self.customTableViewController setSectionArray:modalObject.customModalSectionArray];
    [self.customTableViewController setRowArray:modalObject.customModalRowArray];
    
    [self.customTableViewController.tableView reloadData];
    
    self.customTableViewController.isIndividual = [[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer];
    
    //Set data delegate for table
    self.customTableViewController.customerDataOfCustomTableViewDelegate = self;
    
    //Add target to search button
    [searchButton addTarget:self.customTableViewController action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Refresh navigation bar
    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //Forced to call viewWillAppear as it was not getting called first time view is loaded
    //TODO: Investigate the issue
    [self.customTableViewController viewWillAppear:animated];
    self.indvidualOrganisationSegmentControl.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;//Fixed onTrack 510
    CGRect mainViewFrame = self.mainView.frame;
    mainViewFrame.origin.y = 65;
    self.mainView.frame = mainViewFrame;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //TODO: When Back button of advanced search is click then we have to cancel the web service call in case if fired
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [ConnectionClass cancelNSUrlConnectionForIdentifier:@"SearchIndividualWebServiceAdvanced"];
        [Utilities removeSpinnerFromView:self.view];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark UI Actions
-(IBAction)valueChangedSegmentControl:(id)sender
{
    //Bug Before Changing Custom Table View Dismiss the Keyboard-  Fixed crash issue
    if(self.customTableViewController)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.customTableViewController name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self.customTableViewController name:UIKeyboardWillHideNotification object:nil];
        [self.customTableViewController.view endEditing:YES];
        
        //Remove search button target
        [searchButton removeTarget:self.customTableViewController action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //Add table to container view
    if([self.tableContainerView.subviews containsObject:self.customTableViewController.tableView])
    {
        [self.customTableViewController.tableView removeFromSuperview];
        self.customTableViewController = nil;
    }
    
    switch (self.indvidualOrganisationSegmentControl.selectedSegmentIndex) {
        case 0:
        {
            [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:YES];
            
            CustomModalViewBO *individualCustomBO = [ModalDataLoader getModalCustomInputDictionaryForIndividualAdvanceSearchWithParameters:self.searchParameters];
            
            [self initCustomTableViewWithObject:individualCustomBO forIdentifier:@"AdvanceSearchForIndividuals"];
            
        }break;
            
        case 1:
        {
            [[DataManager sharedObject] setIsIndividualSegmentSelectedForAddCustomer:NO];
            
            //Load table for individual advance search
            CustomModalViewBO *organizationCustomBO = [ModalDataLoader getModalCustomInputDictionaryForOrganizationAdvanceSearchWithParameters:self.searchParameters];
            
            //Init CustomTableView
            [self initCustomTableViewWithObject:organizationCustomBO forIdentifier:@"AdvanceSearchForOrganizations"];
            
        }break;
            
        default:
            break;
    }
    
    [self.tableContainerView addSubview:self.customTableViewController.tableView];
    
    //Clear error label
    [self displayErrorMessage:nil];
}

-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];
    
    [changeTerritoryBtn setSelected:YES];
    
    
    // Present the view controller using the popover style.
    listViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    listViewController.delegate=self;
    
    // Get the popover presentation controller and configure it.
    listPopOverController  = [listViewController popoverPresentationController];
    
    listViewController.popoverPresentationController.sourceRect = CGRectMake(changeTerritoryBtn.frame.origin.x+60+5
                                                                             , changeTerritoryBtn.frame.origin.y+13, changeTerritoryBtn.frame.size.width, changeTerritoryBtn.frame.size.height);
    listViewController.popoverPresentationController.sourceView = self.view;
    listViewController.preferredContentSize= CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor whiteColor];
    listPopOverController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    [self presentViewController:listViewController animated: YES completion: nil];

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

#pragma mark Advance Search
-(void)searchIndividualForData:(CustomerObject*)customerDataObject
{
    //Update search parameters
    self.searchParameters = self.customTableViewController.searchParameters;
    [self.searchParameters setObject:INDIVIDUALS_STRING forKey:@"SearchType"];
    
    //Form search URL using customer object
    if(iSLiveApp)
    {
        //Add spineer
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:INDV_ADVANCED_SEARCH forKey:@"quickSearchType"];
        [defaults setObject:searchParameters forKey:@"searchParamState"];
        [defaults synchronize];
        
        NSMutableString * url=[[NSMutableString alloc]init];
        [url appendFormat:@"%@",SEARCH_INDIVIDUAL_URL];
        if(customerDataObject.custFirstName !=nil && customerDataObject.custFirstName.length!=0)
        {
            [url appendFormat:@"fname=%@&",customerDataObject.custFirstName];
        }
        if(customerDataObject.custMiddleName !=nil && customerDataObject.custMiddleName.length!=0)
        {
            [url appendFormat:@"mname=%@&",customerDataObject.custMiddleName];
        }
        if(customerDataObject.custLastName !=nil && customerDataObject.custLastName.length!=0)
        {
            [url appendFormat:@"lname=%@&",customerDataObject.custLastName];
        }
        
        if(customerDataObject.custBPID !=nil && customerDataObject.custBPID.length!=0)
        {
            [url appendFormat:@"bp_id=%@&",customerDataObject.custBPID];
        }
        if(customerDataObject.custNPI !=nil && customerDataObject.custNPI.length!=0)
        {
            [url appendFormat:@"npi=%@&",customerDataObject.custNPI];
        }
        
        AddressObject *customerAddress = [customerDataObject.custAddress objectAtIndex:0];
        if(customerAddress.state !=nil && customerAddress.state.length!=0)
        {
            [url appendFormat:@"state=%@&",customerAddress.state];
        }
        if(customerAddress.city !=nil && customerAddress.city.length!=0)
        {
            [url appendFormat:@"city=%@&",customerAddress.city];
        }
        if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
        {
            [url appendFormat:@"zip=%@&",customerAddress.zip];
        }
        
        if(customerAddress.addr_usage_type != nil && customerAddress.addr_usage_type.length!=0)
        {
            [url appendFormat:@"addr_usage_type=%@&", customerAddress.addr_usage_type];
        }
        
        if(customerDataObject.custPrimarySpecialty !=nil && customerDataObject.custPrimarySpecialty.length!=0)
        {
            /*
            NSMutableArray *array=[[JSONDataFlowManager sharedInstance]specilalityArray];
            if ([[JSONDataFlowManager sharedInstance]selectedSpecialityIndex]) {
                LOVData *data=[array objectAtIndex:([[JSONDataFlowManager sharedInstance]selectedSpecialityIndex]-1)];
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
        [url appendFormat:@"search_type=adv"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchIndividualWebServiceAdvanced" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else
    {
        //Searchtype is already so > 1
        if([self.searchParameters count]>1)
        {
//            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            AddCustomerSearchDetailsViewController* addCustomerSearchDetailsViewController = (AddCustomerSearchDetailsViewController*)[Utilities getViewController:@"AddCustomerSearchDetailsViewController" fromStoryboardWithId:@"TabBarView"];
            
            NSMutableArray *searchedCustDataFromServer;
            searchedCustDataFromServer=[DummyData searchCustomerWithType:INDIVIDUALS_KEY];
            
            addCustomerSearchDetailsViewController.self.searchParameters=self.searchParameters;
            addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
            [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
        }
    }
}

-(void)searchOrganizationForData:(OrganizationObject *)orgObj
{
    //Update search parameters
    self.searchParameters = self.customTableViewController.searchParameters;
    [self.searchParameters setObject:ORGANIZATIONS_STRING forKey:@"SearchType"];
    
    //Form search URL using customer object
    if(iSLiveApp)
    {
        //Add spineer
        [Utilities addSpinnerOnView:self.view withMessage:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ORG_ADVANCED_SEARCH forKey:@"quickSearchType"];
        [defaults setObject:searchParameters forKey:@"searchParamState"];
        [defaults synchronize];
        
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
        }
        if(customerAddress.building !=nil && customerAddress.building.length!=0)
        {
            [url appendFormat:@"building=%@&",customerAddress.building];
        }
        if(customerAddress.suite !=nil && customerAddress.suite.length!=0)
        {
            [url appendFormat:@"suite=%@&",customerAddress.suite];
        }
        if(customerAddress.state !=nil && customerAddress.state.length!=0)
        {
            [url appendFormat:@"state=%@&",customerAddress.state];
        }
        if(customerAddress.zip !=nil && customerAddress.zip.length!=0)
        {
            [url appendFormat:@"zip=%@&",customerAddress.zip];
        }
        if(customerAddress.city !=nil && customerAddress.city.length!=0)
        {
            [url appendFormat:@"city=%@&",customerAddress.city];
        }
        if(customerAddress.addr_usage_type != nil && customerAddress.addr_usage_type.length!=0)
        {
            [url appendFormat:@"addr_usage_type=%@", customerAddress.addr_usage_type];
        }
        
        [url appendFormat:@"search_type=adv"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [url appendFormat:@"&personnel_id=%@", [[userDefaults objectForKey:@"LoggedInUser"] objectForKey:@"PersonalId"]];
        [url appendFormat:@"&team_id=%@",[userDefaults objectForKey:@"SelectedTeamId"]];
        
        ConnectionClass * connection= [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SearchOrganizationWebServiceAdvanced" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    else
    {
        if([self.searchParameters count]>1)
        {
//            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            AddCustomerSearchDetailsViewController* addCustomerSearchDetailsViewController = (AddCustomerSearchDetailsViewController*)[Utilities getViewController:@"AddCustomerSearchDetailsViewController" fromStoryboardWithId:@"TabBarView"];
            
            NSMutableArray *searchedCustDataFromServer;
            searchedCustDataFromServer=[DummyData searchCustomerWithType:ORGANIZATIONS_KEY];
            
            addCustomerSearchDetailsViewController.self.searchParameters=self.searchParameters;
            addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
            [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
        }
    }
}
#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    NSArray *jsonDataArrayOfObjects=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    DebugLog(@"[AdvancedSearchViewController : recieveDataFromServer] LOG3: JSON received: \n%@ \nIdentifier: %@",jsonDataArrayOfObjects ,identifier);
    
    if(jsonDataArrayOfObjects!=nil)
    {
        if([identifier isEqualToString:@"SearchOrganizationWebServiceAdvanced"])
        {
//            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            AddCustomerSearchDetailsViewController* addCustomerSearchDetailsViewController = (AddCustomerSearchDetailsViewController*)[Utilities getViewController:@"AddCustomerSearchDetailsViewController" fromStoryboardWithId:@"TabBarView"];
            
            NSArray *searchedCustDataFromServer;
            searchedCustDataFromServer= [Utilities parseJsonSearchOrganization:jsonDataArrayOfObjects];
            if(searchedCustDataFromServer!=nil && [searchedCustDataFromServer count]>0)
            {
                addCustomerSearchDetailsViewController.self.searchParameters=self.searchParameters;
                addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
                
                //Remove Spinner
                [Utilities removeSpinnerFromView:self.view];
                
                [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
            }
            else
            {
                NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                ErrorLog(@"Add Customer Class | Error - %@ | Identifier - %@",myString ,identifier);
                
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    //Display error message
                    [self displayErrorMessage:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]];
                }
                
                //Remove Spinner
                [Utilities removeSpinnerFromView:self.view];
            }
        }
        else if([identifier isEqualToString:@"SearchIndividualWebServiceAdvanced"])
        {
//            AddCustomerSearchDetailsViewController * addCustomerSearchDetailsViewController=[[AddCustomerSearchDetailsViewController alloc]initWithNibName:@"AddCustomerSearchDetailsViewController" bundle:nil];
            AddCustomerSearchDetailsViewController* addCustomerSearchDetailsViewController = (AddCustomerSearchDetailsViewController*)[Utilities getViewController:@"AddCustomerSearchDetailsViewController" fromStoryboardWithId:@"TabBarView"];
            NSArray *searchedCustDataFromServer;
            searchedCustDataFromServer= [Utilities parseJsonSearchIndividual:jsonDataArrayOfObjects];
            if(searchedCustDataFromServer!=nil && [searchedCustDataFromServer count]>0)
            {
                addCustomerSearchDetailsViewController.self.searchParameters=self.searchParameters;
                addCustomerSearchDetailsViewController.custData=searchedCustDataFromServer;
                
                //Remove Spinner
                [Utilities removeSpinnerFromView:self.view];
                
                [self.navigationController pushViewController:addCustomerSearchDetailsViewController animated:YES];
            }
            else
            {
                NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                ErrorLog(@"Add Customer Class | Error - %@ | Identifier - %@",myString ,identifier);
                
                if(![[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"status"] isEqualToString:LOGOUT_KEY])
                {
                    //Display error message
                    [self displayErrorMessage:[[jsonDataArrayOfObjects objectAtIndex:0] objectForKey:@"reasonCode"]];
                }
                //Remove Spinner
                [Utilities removeSpinnerFromView:self.view];
            }
        }
    }
    else
    {
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ErrorLog(@"Advanced Search Class | Data Recieved Null. Json Parsing Error - %@ | Identifier - %@",myString ,identifier);
        
        //Display error message
        [self displayErrorMessage:ERROR_NO_RESULTS_FOUND_TRY_AGAIN];
        
        //Remove Spinner
        [Utilities removeSpinnerFromView:self.view];
    }
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    ErrorLog(@"Advanced Search Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    //Display error message
    [self displayErrorMessage:error];
    
    //Remove Spinner
    [Utilities removeSpinnerFromView:self.view];
}
#pragma mark -

#pragma mark Customer Data Delegate
-(void)processCustomerData:(NSArray *)data forIdentifier:(NSString *)identifier
{
    if([[DataManager sharedObject] isIndividualSegmentSelectedForAddCustomer])
    {
        [self searchIndividualForData:[data objectAtIndex:0]];
    }
    else
    {
        [self searchOrganizationForData:[data objectAtIndex:0]];
    }
}

-(void)displayErrorMessage:(NSString *)errorMsg
{
    if(![errorMsg length])
    {
        [errorMessageLabel setText:nil];
        [errorMessageLabel setHidden:YES];
    }
    else
    {
        [errorMessageLabel setText:errorMsg];
        [errorMessageLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
        
        [errorMessageLabel setHidden:NO];
        [self.view bringSubviewToFront:errorMessageLabel];
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
    [changeTerritoryBtn setSelected:NO];
}




#pragma mark -

#pragma mark List View Custom Delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    if([listType isEqualToString:CHANGE_TERRITORY])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        listPopOverController = nil;
        //Reset state of change territory button
        [changeTerritoryBtn setSelected:NO];
        
        BOOL isTerritoryChanged = [Utilities changeSelectedTerritoryTo:value];
        if(isTerritoryChanged)
        {
            //Close all connections
            [Utilities removeSpinnerFromView:self.view];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate resetAppForTerritoryChange];
        }
    }
    else //if([listType isEqualToString:STATE_KEY])
    {
            [self dismissViewControllerAnimated:YES completion:nil];;
            listPopOverController = nil;
    
        }
}

#pragma mark -

@end
