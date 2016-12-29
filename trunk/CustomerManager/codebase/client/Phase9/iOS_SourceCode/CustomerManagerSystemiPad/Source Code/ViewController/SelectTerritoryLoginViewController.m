//
//  SelectTerritoryLoginViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "SelectTerritoryLoginViewController.h"
#import "Themes.h"
#import "LoginViewController.h"
#import "ApproveCustomerViewController.h"
#import "AddCustomerViewController.h"
#import "RemoveCustomerViewController.h"
#import "RequestsViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "CDFFlagModalTableViewCell.h"
#import "Utilities.h"
#import "TabBarViewController.h"

@interface SelectTerritoryLoginViewController ()

@property(nonatomic,retain) UIButton * selectTerritoryBtn;
@property(nonatomic,retain) IBOutlet UINavigationBar *topBar;
@property(nonatomic,retain) UITableView * territoryList;
@property(nonatomic,retain) NSMutableArray* territoryListData;
@property(nonatomic,retain) UINavigationController* nav1;
@property(nonatomic,retain) UINavigationController* nav2;
@property(nonatomic,retain) UINavigationController* nav3;
@property(nonatomic,retain) UINavigationController* nav4;
@property(nonatomic,retain) UITabBarItem *targetTab;
@property (nonatomic,assign)bool showHideTargetBool;
@property (nonatomic,retain) NSUserDefaults *hoUserDefault;
@property(nonatomic,retain) UIPopoverPresentationController * listPopOverController;
@property(nonatomic,retain) UILabel * territoryBULabel;
@property(nonatomic,retain) UITextField * territoryBUTextField;
@property(nonatomic,retain) UILabel * territoryTeamLabel;
@property(nonatomic,retain) UITextField * territoryTeamTextField;
@property(nonatomic,retain) UILabel * territoryTerrLabel;
@property(nonatomic,retain) UITextField * territoryTerrTextField;
@property (nonatomic, retain) NSString *selectedBuIndexValue;
@property (nonatomic, retain) NSString *selectedTeamIndexValue;



-(void)clickLogOut;
-(void)clickSelectTerritoryBtn;
@end

@implementation SelectTerritoryLoginViewController
@synthesize territoryList,territoryListData,nav1,nav2,nav3,nav4,targetTab,hoUserDefault,listPopOverController,territoryBULabel,territoryBUTextField,territoryTeamLabel,territoryTeamTextField,territoryTerrLabel,territoryTerrTextField;

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
    
    //Populate Territory data of req User
    hoUserDefault = [NSUserDefaults standardUserDefaults];
    if (![[hoUserDefault objectForKey:HO_USER]isEqualToString:@"Y"])
        [self populateReqUserData];
    
    [Themes setBackgroundTheme1:self.view];
    self.topBar.tintColor=THEME_COLOR;
    self.topBar.topItem.titleView=[Themes setNavigationBarNormal:LOGIN_SCREEN_TITLE_STRING ofViewController:@"SelectTerritoryLogin"];
	[self.topBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024"] forBarMetrics:UIBarMetricsDefault];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.topBar.frame.size.height-1,self.topBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.topBar addSubview:navBorder];
    //Add Touch Up event to Log out button
    for(UIButton* btn in self.topBar.topItem.titleView.subviews)
    {
        //Log out btn Tag is 1
        if(btn.tag==1)
        {
            [btn addTarget:self action:@selector(clickLogOut) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [self loadUIViewForTerriotaryList];
    
    //Refresh Top Bar UserName
    [Themes refreshTerritory:self.topBar.topItem.titleView.subviews ];

    
//ZS Associate On Tab Bar
//ZS Associate On Tab Bar
    
//    //Added for new requirement to change zs logo and title
    UILabel *tabBarLogoTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+833, 700, 206, 48)];
    [tabBarLogoTitle setFont:[UIFont fontWithName:@"Ariel" size:12.0]];
    [tabBarLogoTitle setTextColor:[UIColor whiteColor]];
    [tabBarLogoTitle setText:@"Powered by"];
    [self.view addSubview:tabBarLogoTitle];
    
    UIView* tabBarLogo=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+860,700, 206, 48)];
    [tabBarLogo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_ZS"]]];
    [self.view addSubview:tabBarLogo];
    
    //BMS Logo On Tab Bar
    UIImageView* tabBarBMSLogo=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+20,702, 266, 44)];
    [tabBarBMSLogo setImage:[UIImage imageNamed:@"logo_BMS"]];
    [self.view addSubview:tabBarBMSLogo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSelectButton:) name:@"enableSelectButtonNotification" object:nil];

 }

-(void)viewWillAppear:(BOOL)animated
{
    //Added to display serach in popover for BU/team and Terriotary selection
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"searchForHOUser"];

    if ([defaults objectForKey:SELECTED_TERRITTORY_NAME]) {
        [self.selectTerritoryBtn setEnabled:YES];
    }
    else
        [self.selectTerritoryBtn setEnabled:NO];

}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"searchForHOUser"];
}

-(void)enableSelectButton:(NSNotification*)notification
{
    [self.selectTerritoryBtn setEnabled:YES];
}

-(void)populateReqUserData
{
    self.territoryListData=[[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
    for(NSString * terrId in [[loggedInUser objectForKey:@"TerritoriesAndRoles"] allKeys])
    {
        //Terr Id is key
        [self.territoryListData addObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TerritoryName"]];
    }
    self.showHideTargetBool = FALSE;
    //To select first territory by default
    if([self.territoryListData objectAtIndex:0]!=nil)
    {
        for(NSString * terrId in [[loggedInUser objectForKey:@"TerritoriesAndRoles"] allKeys])
        {
            if([[self.territoryListData objectAtIndex:0] isEqualToString:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TerritoryName"]])
            {
                [defaults setObject:terrId forKey:@"SelectedTerritoryId"];
                [defaults setObject:[self.territoryListData objectAtIndex:0] forKey:@"SelectedTerritoryName"];
                //set target flag
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TargetFlag"] forKey:@"TargetFlag"];
                if (!self.showHideTargetBool && [[defaults objectForKey:@"TargetFlag"] isEqualToString:@"Y"]) {
                    self.showHideTargetBool = TRUE;
                }
                //Set Role Id for role - Can be changed in future
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"RoleId"] forKey:@"Role"];
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"teamId"] forKey:@"SelectedTeamId"];
                
                //Excluded address usage type
                if([[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"excludedAddrUsgType"])
                {
                    [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"excludedAddrUsgType"] forKey:@"SelectedRoleExcludedAddrUsgType"];
                }
                else
                {
                    [defaults removeObjectForKey:@"SelectedRoleExcludedAddrUsgType"];
                }
                
                //Inclusion bp classification
                if([[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"includedBpClassificationType"])
                {
                    [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"includedBpClassificationType"] forKey:@"SelectedRoleIncludedBpClassificationType"];
                }
                else
                {
                    [defaults removeObjectForKey:@"SelectedRoleIncludedBpClassificationType"];
                }
                
                //User roles
                if([[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MA] || [[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MSL])
                {
                    [defaults setObject:USER_ROLE_MA_MSL forKey:USER_ROLES_KEY];
                }
                else
                {
                    [defaults setObject:USER_ROLE_SALES_REP forKey:USER_ROLES_KEY];
                }
                
                break;
            }
        }
    }
    else //If there is no territory then set it to null
    {
        [defaults setObject:@"" forKey:@"SelectedTerritoryId"];
        [defaults setObject:@"" forKey:SELECTED_TERRITTORY_NAME];
        [defaults setObject:@"" forKey:@"Role"];
    }
}

-(void)populateHOUserData
{
    NSLog(@"ho user data");
}

-(void)loadUIViewForTerriotaryList
{
    //Create Territory List
    
    UIView * loginCredentialView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 244)];
    [loginCredentialView setBackgroundColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    
    UILabel * loginCredentialLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 44)];
    [loginCredentialLbl setText:SELECT_TERRITORY_STRING];
    [loginCredentialLbl setTextAlignment:NSTextAlignmentCenter];
    [loginCredentialLbl setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    [loginCredentialLbl setTextColor:THEME_COLOR];
    [loginCredentialLbl setBackgroundColor:[UIColor clearColor]];
    [loginCredentialView addSubview:loginCredentialLbl];
    
    UIView * loginView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 400, 220)];
    [loginView setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1.0]];
    [loginCredentialView addSubview:loginView];
    loginCredentialView.center=self.view.center;
    [self.view addSubview:loginCredentialView];
    
    territoryList=[[UITableView alloc]initWithFrame:CGRectMake(20, 20, 360, 132) style:UITableViewStylePlain];
    [territoryList setBackgroundColor:[UIColor whiteColor]];
    territoryList.layer.cornerRadius=10.0f;
    territoryList.layer.borderWidth=1.0f;
    territoryList.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [territoryList setBounces:YES];
    [territoryList setDelegate:self];
    [territoryList setDataSource:self];
    [loginView addSubview:territoryList];
    
    self.selectTerritoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectTerritoryBtn.frame= CGRectMake(168,170,64,31);
    [self.selectTerritoryBtn setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
    [self.selectTerritoryBtn addTarget:self action:@selector(clickSelectTerritoryBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:self.selectTerritoryBtn];
    
    
    //Add Welcome user text and Select terroitory text
    UILabel * welcomeUserText=[[UILabel alloc]initWithFrame:CGRectMake(loginCredentialView.frame.origin.x, loginCredentialView.frame.origin.y-70, 330, 30)];
    
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
    
    [welcomeUserText setTextAlignment:NSTextAlignmentLeft];
    [welcomeUserText setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    [welcomeUserText setTextColor:THEME_COLOR];
    [welcomeUserText setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:welcomeUserText];
    
    UILabel * selectTerritoryText=[[UILabel alloc]initWithFrame:CGRectMake(loginCredentialView.frame.origin.x, loginCredentialView.frame.origin.y-40, 330, 30)];
    [selectTerritoryText setText:[NSString stringWithFormat:@"%@:", PLEASE_SELECT_TERRITORY_STRING]];
    [selectTerritoryText setTextAlignment:NSTextAlignmentLeft];
    [selectTerritoryText setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    [selectTerritoryText setTextColor:THEME_COLOR];
    [selectTerritoryText setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:selectTerritoryText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark UI Actions
-(void)clickLogOut
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	[appDelegate Logout];
}

//Method to fetch User Roles after selecting BU,Team and Terriotary
-(void)clickSelectTerritoryBtn
{
    [Utilities addSpinnerOnView:self.view withMessage:@"Fetching User Roles"];
    //Push Tab Bar controller with Add Customer Screen
    
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    if ([[usrDefault objectForKey:HO_USER] isEqualToString:@"Y"]) {
        if ( [territoryTerrTextField.text length]>0) {
            NSArray *buArray = [usrDefault objectForKey:@"hoBuCodeDataArray"];
            NSDictionary *teamArrayDict = [[usrDefault objectForKey:@"buTeamDataDict"] objectForKey:[buArray objectAtIndex:[[usrDefault objectForKey:SELECTED_BU_INDEX] integerValue]]];//will return the dictionary of Team array and Team code of selected bu.
            
            NSString *selectedTeamCode = [[teamArrayDict objectForKey:@"teamId"] objectAtIndex:[[usrDefault objectForKey:SELECTED_TEAM_INDEX] integerValue]];
            [usrDefault setObject:selectedTeamCode forKey:@"selectedTeamCode"];
            [usrDefault setObject:[NSString stringWithFormat:@"%@-%@",[[teamArrayDict objectForKey:@"teamId"] objectAtIndex:[[usrDefault objectForKey:SELECTED_TEAM_INDEX] integerValue]],[[teamArrayDict objectForKey:@"teamName"] objectAtIndex:[[usrDefault objectForKey:SELECTED_TEAM_INDEX] integerValue]]] forKey:SELECTED_TEAM_NAME];
//            [usrDefault setObject:[[teamArrayDict objectForKey:@"teamName"] objectAtIndex:[[usrDefault objectForKey:SELECTED_TEAM_INDEX] integerValue]] forKey:SELECTED_TEAM_NAME];
            [usrDefault setObject:[teamArrayDict objectForKey:@"teamName"] forKey:@"selectedTeamDataArray"];

            NSDictionary *teArray = [usrDefault objectForKey:@"teamTerrDataDict"];//returns bu code array
            NSDictionary *tamArray = [teArray objectForKey:selectedTeamCode];//returns the team terriotary data dictionary
            [usrDefault setObject:[tamArray objectForKey:@"terrName"] forKey:@"selectedTerrDataArray"];

            for (int i=0;i<[[tamArray objectForKey:@"terrName"] count]; i++) {
                if ([[[tamArray objectForKey:@"terrName"] objectAtIndex:i] isEqualToString:territoryTerrTextField.text]) {
                    [usrDefault setObject:[[tamArray objectForKey:@"terrId"] objectAtIndex:i] forKey:@"SelectedTerritoryId"];
                    [usrDefault setObject:[[tamArray objectForKey:@"terrName"] objectAtIndex:i] forKey:SELECTED_TERRITTORY_NAME];

                }
            }
            
            NSString * url=[NSString stringWithFormat:@"%@/%@/%@/teamRoles?teamcode=%@",COMMON_SERVER_URL,[usrDefault objectForKey:@"LoginName"],[usrDefault valueForKey:@"hoUserToken"],[usrDefault objectForKey:@"selectedTeamCode"]];
            ConnectionClass * connection= [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"GetUserRoles" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
             {
                 //CallBack Block
                 if(!error)
                 {
                     [self receiveDataFromServer:data ofCallIdentifier:identifier];
                     
                     if ([[usrDefault objectForKey:@"TargetFlag"]isEqualToString:@"Y"])
                         self.showHideTargetBool = TRUE;
                     else
                         self.showHideTargetBool = FALSE;
                 }
                 else
                 {
                     NSLog(@"unable to fetch data from server");
                 }
             }];
        }
    }
    else
        [self searchViewDidLoad];
}

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    if([identifier isEqualToString:@"GetUserRoles"])
    {
        @try {
            
            NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if(jsonDataObject!=nil)
            {
                NSLog(@"Login Class | Response - %@ | Identifier - %@",jsonDataObject ,identifier);
                if([Utilities parseHOUserJsonLoginUserDetails:jsonDataObject])
                {
                    
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
                    NSDictionary *rolesDict = [[loggedInUser valueForKey:@"TerritoriesAndRoles"] valueForKey:[defaults objectForKey:@"SelectedTerritoryId"]];
                    [defaults setObject:[rolesDict valueForKey:@"TargetFlag"] forKey:@"TargetFlag"];
                    [self searchViewDidLoad];
                    [Utilities removeSpinnerFromView:self.view];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error Login - %@",exception);
        }
    }
}

-(void)loadSSO
{
    /*SSOViewController * ssoView=[[SSOViewController alloc]initWithNibName:@"SSOViewController" bundle:nil withParameters:nil];
    ssoView.delegate=self;
    [self addChildViewController:ssoView];
    [self.view addSubview:ssoView.view];*/
}


-(void)searchViewDidLoad
{
    TabBarViewController *tabBarViewController = (TabBarViewController*)[Utilities getViewController:@"TabBarViewController" fromStoryboardWithId:@"TabBarView"];
    [self.navigationController pushViewController:tabBarViewController animated:YES];

    /*
    AddCustomerViewController *viewController1 = [[AddCustomerViewController alloc] initWithNibName:@"AddCustomerViewController" bundle:nil];
    nav1=[[UINavigationController alloc]initWithRootViewController:viewController1];
    
    RemoveCustomerViewController *viewController2 =[[RemoveCustomerViewController alloc]initWithNibName:@"RemoveCustomerViewController" bundle:nil];
    nav2=[[UINavigationController alloc]initWithRootViewController:viewController2];
    
    RequestsViewController *viewController3 =[[RequestsViewController alloc]initWithNibName:@"RequestsViewController" bundle:nil];
    nav3=[[UINavigationController alloc]initWithRootViewController:viewController3];

    ApproveCustomerViewController *viewController4 =[[ApproveCustomerViewController alloc]initWithNibName:@"ApproveCustomerViewController" bundle:nil];
    nav4=[[UINavigationController alloc]initWithRootViewController:viewController4];

    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray
                                        arrayWithObjects:nav1,nav2,nav3,nav4, nil];
    tabBarController.delegate=self;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_bar"] ];
    //SetTab Bar  Images
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    targetTab = [tabBar.items objectAtIndex:3];
    
    [item0 setImage:[UIImage imageNamed:@"addcust_selected"]];
    [item0 setTitle:SEARCH_CUSTOMERS_TAB_NAME_STRING];
    [item1 setImage:[UIImage imageNamed:@"removecust_selected"]];
    [item1 setTitle:REMOVE_CUSTOMER_TAB_TITLE_STRING];
    [item2 setImage:[UIImage imageNamed:@"requests_selected"]];
    [item2 setTitle:REQUESTS_TAB_TITLE_STRING];
    targetTab = [tabBar.items objectAtIndex:3];
    
    [targetTab setImage:[UIImage imageNamed:@"approve_selected"]];
    [targetTab setTitle:APPROVE_CUSTOMER_TAB_BOTTOM_STRING];
    if (self.showHideTargetBool) {
        [targetTab setEnabled:YES];
        [targetTab setImage:[UIImage imageNamed:@"approve_selected"]];
        [targetTab setTitle:APPROVE_CUSTOMER_TAB_BOTTOM_STRING];
    }
    else
    {
        [targetTab setEnabled:NO];
        [targetTab setImage:[UIImage imageNamed:@""]];
        [targetTab setTitle:@""];
    }
    
    //BMS Logo On Tab Bar
    UIImageView* tabBarBMSLogo=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+20,722, 266, 44)];
    [tabBarBMSLogo setImage:[UIImage imageNamed:@"logo_BMS"]];
    [tabBarController.view addSubview:tabBarBMSLogo];
    
    UINavigationController *nvc=[[UINavigationController alloc] initWithRootViewController:tabBarController];
    [nvc setNavigationBarHidden:YES];
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate.nvc removeFromParentViewController];
    [appDelegate setNvc:nvc];
    appDelegate.window.rootViewController=nvc;*/
}
#pragma mark -

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[hoUserDefault objectForKey:HO_USER] isEqualToString:@"Y"]) {
        return 3;//For ho user only 3 rows are there (BU,Team and Terriotary)
    }
    for (int i = 0 ; i < self.territoryListData.count ; i ++) {
        for( int j = 0 ; j < self.territoryListData.count - 1 ; j++){
            if([[self.territoryListData objectAtIndex:j] length] > [[self.territoryListData objectAtIndex:j+1] length])
                [self.territoryListData exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
        }
    }
    return [self.territoryListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"territory";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UITableViewCell *cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cellTemp == nil) {
        cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cellTemp.tag=indexPath.row;
    if ([[defaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
        [cellTemp setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [tableView setScrollEnabled:NO];
        // create label and textfield for business unit
        if (indexPath.row == 0) {
            territoryBULabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 130, 30)];
            territoryBULabel.text = @"Select Business Unit";
            [territoryBULabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
            
            territoryBUTextField = [[UITextField alloc]initWithFrame:CGRectMake(165, 2, 175, 30)];
            territoryBUTextField.placeholder = @"Required";
            territoryBUTextField.userInteractionEnabled = NO;
            [territoryBUTextField setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
            territoryBUTextField.delegate = self;
            
            [cellTemp addSubview:territoryBULabel];
            [cellTemp addSubview:territoryBUTextField];
            
            //retain bu index
            if ([defaults objectForKey:SELECTED_BU_INDEX]) {
                NSArray *buNameArray = [defaults objectForKey:@"hoBuNameDataArray"];
                territoryBUTextField.text = [buNameArray objectAtIndex:[[NSString stringWithFormat:@"%@",[defaults objectForKey:SELECTED_BU_INDEX]] integerValue]];
            }

        }
        if (indexPath.row == 1) {
            territoryTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 130, 30)];
            territoryTeamLabel.text = @"Select Team";
            [territoryTeamLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
            
            territoryTeamTextField = [[UITextField alloc]initWithFrame:CGRectMake(165, 2, 175, 30)];
            territoryTeamTextField.placeholder = @"Required";
            [territoryTeamTextField setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
            territoryTeamTextField.userInteractionEnabled = NO;
            territoryTeamTextField.delegate = self;
            
            [cellTemp addSubview:territoryTeamLabel];
            [cellTemp addSubview:territoryTeamTextField];

            //retain team index
            if ([defaults objectForKey:SELECTED_TEAM_NAME]) {//tempSelectedTeamIndex
                territoryTeamTextField.text = [defaults objectForKey:SELECTED_TEAM_NAME];// teamNameArray objectAtIndex:[[NSString
            }
        }
        if (indexPath.row == 2) {
            territoryTerrLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 130, 30)];
            territoryTerrLabel.text = @"Select Territory";
            [territoryTerrLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
            
            territoryTerrTextField = [[UITextField alloc]initWithFrame:CGRectMake(165, 2, 175, 30)];
            territoryTerrTextField.placeholder = @"Required";
            [territoryTerrTextField setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
            territoryTerrTextField.userInteractionEnabled = NO;
            territoryTerrTextField.delegate = self;
            
            [cellTemp addSubview:territoryTerrLabel];
            [cellTemp addSubview:territoryTerrTextField];
            
            //retain terriotary index
            if ([defaults objectForKey:SELECTED_TERRITTORY_NAME]) {
                territoryTerrTextField.text = [defaults objectForKey:SELECTED_TERRITTORY_NAME];
            }
        }
        
        if ([[self.territoryListData objectAtIndex:indexPath.row] isEqualToString:[defaults objectForKey:SELECTED_TERRITTORY_NAME]]) {
            [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
            if ([[defaults objectForKey:@"TargetFlag"]isEqualToString:@"Y"])
                self.showHideTargetBool = TRUE;
            else
                self.showHideTargetBool = FALSE;
        }
    }
    else
    {
        cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellTemp.textLabel setText:[self.territoryListData objectAtIndex:indexPath.row]];
        [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
        [cellTemp.textLabel setNumberOfLines:0];
        [cellTemp.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
        if ([[self.territoryListData objectAtIndex:indexPath.row] isEqualToString:[defaults objectForKey:SELECTED_TERRITTORY_NAME]]) {
            [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
            if ([[defaults objectForKey:@"TargetFlag"]isEqualToString:@"Y"])
                self.showHideTargetBool = TRUE;
            else
                self.showHideTargetBool = FALSE;
        
        }
    }
    return cellTemp;
}
#pragma mark -

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
    for(NSString * terrId in [[loggedInUser objectForKey:@"TerritoriesAndRoles"] allKeys])
    {
        if([[self.territoryListData objectAtIndex:indexPath.row] isEqualToString:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TerritoryName"]])
        {
            [defaults setObject:terrId forKey:@"SelectedTerritoryId"];
            [defaults setObject:[self.territoryListData objectAtIndex:indexPath.row] forKey:SELECTED_TERRITTORY_NAME];
            // check the terriotary flag at selection
            [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TargetFlag"] forKey:@"TargetFlag"];
            if ([[defaults objectForKey:@"TargetFlag"] isEqualToString:@"Y"]) {
                self.showHideTargetBool = TRUE;
            }
            
            //Set Role Id for role - Can be changed in future
            [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"RoleId"] forKey:@"Role"];
            [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"teamId"] forKey:@"SelectedTeamId"];
            
            //Excluded address usage type
            if([[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"excludedAddrUsgType"])
            {
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"excludedAddrUsgType"] forKey:@"SelectedRoleExcludedAddrUsgType"];
            }
            else
            {
                [defaults removeObjectForKey:@"SelectedRoleExcludedAddrUsgType"];
            }
            
            //Inclusion bp classification
            if([[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"includedBpClassificationType"])
            {
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"includedBpClassificationType"] forKey:@"SelectedRoleIncludedBpClassificationType"];
            }
            else
            {
                [defaults removeObjectForKey:@"SelectedRoleIncludedBpClassificationType"];
            }
            
            //User roles
            if([[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MA] || [[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MSL])
            {
                [defaults setObject:USER_ROLE_MA_MSL forKey:USER_ROLES_KEY];
            }
            else
            {
                [defaults setObject:USER_ROLE_SALES_REP forKey:USER_ROLES_KEY];
            }
            
            break;
        }
    }
    if ([[hoUserDefault objectForKey:HO_USER]isEqualToString:@"Y"]) {
        //fetch data from database and display based on selection.
        if (indexPath.row ==0) {
            [self clickBU];
            territoryTeamTextField.text = @"";
            territoryTerrTextField.text = @"";
            [self.selectTerritoryBtn setEnabled:NO];
            
        }
        else if (indexPath.row==1)
        {
            if ([territoryBUTextField.text length]>0) {
                [self clickTeam];
                territoryTerrTextField.text = @"";
                [self.selectTerritoryBtn setEnabled:NO];
            }
        }
        else if (indexPath.row==2)
        {
            if ([territoryBUTextField.text length]>0 && [territoryTeamTextField.text length]>0) {
                [self clickTerriotary];
            }
        }
    }
    else
    {
        [tableView  reloadData];
        [Themes refreshTerritory:self.topBar.topItem.titleView.subviews];
    }
}

-(void)clickBU
{
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:BU_KEY listHeader:BU_KEY withSelectedValue:territoryBUTextField.text];
    listViewController.delegate=self;
    listViewController.modalPresentationStyle=UIModalPresentationPopover;
    listPopOverController  = [listViewController popoverPresentationController];
    listViewController.popoverPresentationController.sourceRect = CGRectMake(territoryList.frame.origin.x-165, territoryList.frame.origin.y-65, territoryList.frame.size.width, territoryList.frame.size.height);
    listViewController.popoverPresentationController.sourceView = territoryList;
    listViewController.preferredContentSize= CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor blackColor];
    listPopOverController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [self presentViewController:listViewController animated: YES completion: nil];
    });

}

-(void)clickTeam
{
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:TEAM_KEY listHeader:TEAM_KEY withSelectedValue:territoryTeamTextField.text];
    listViewController.delegate=self;
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSArray *buArray = [standardUserDefault objectForKey:@"hoBuNameDataArray"];
    if ([buArray containsObject:territoryBUTextField.text]) {
        listViewController.selectedBuIndex = [buArray indexOfObject:territoryBUTextField.text];
        
        _selectedBuIndexValue = [NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedInteger:[buArray indexOfObject:territoryBUTextField.text]]];
        [standardUserDefault setObject:_selectedBuIndexValue forKey:@"selectedBuIndex"];
    }
    listViewController.modalPresentationStyle=UIModalPresentationPopover;
    listPopOverController  = [listViewController popoverPresentationController];
    listViewController.popoverPresentationController.sourceRect = CGRectMake(territoryList.frame.origin.x-165, territoryList.frame.origin.y-22, territoryList.frame.size.width, territoryList.frame.size.height);
    listViewController.popoverPresentationController.sourceView = territoryList;
    listViewController.preferredContentSize= CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor blackColor];
    listPopOverController.permittedArrowDirections = UIPopoverArrowDirectionLeft;

    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [self presentViewController:listViewController animated: YES completion: nil];
        
    });
    
}

-(void)clickTerriotary
{
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:TERRIOTARY_KEY listHeader:TERRIOTARY_KEY withSelectedValue:territoryTerrTextField.text];
    listViewController.delegate=self;
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSArray *buNameArray = [standardUserDefault objectForKey:@"hoBuNameDataArray"];
    NSArray *buCodeArray = [standardUserDefault objectForKey:@"hoBuCodeDataArray"];

    if ([buNameArray containsObject:territoryBUTextField.text]) {
        listViewController.selectedBuIndex = [buNameArray indexOfObject:territoryBUTextField.text];
        _selectedBuIndexValue = [NSString stringWithFormat:@"%ld",(long)listViewController.selectedBuIndex];
        [standardUserDefault setObject:_selectedBuIndexValue forKey:SELECTED_BU_INDEX];

    }

    NSDictionary *teamArrayDict = [[standardUserDefault objectForKey:@"buTeamDataDict"] objectForKey:[buCodeArray objectAtIndex:listViewController.selectedBuIndex]];
    NSMutableArray *teamCodeNameArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[[teamArrayDict objectForKey:@"teamName"] count]; i++) {
        [teamCodeNameArray addObject:[NSString stringWithFormat:@"%@-%@",[[teamArrayDict objectForKey:@"teamId"] objectAtIndex:i],[[teamArrayDict objectForKey:@"teamName"] objectAtIndex:i]]];
    }

    NSArray *terrArray = [[NSArray alloc]initWithArray:teamCodeNameArray];
    if ([terrArray containsObject:territoryTeamTextField.text]) {
        for (int terrIndex=0; terrIndex<terrArray.count; terrIndex++) {
            if ([[terrArray objectAtIndex:terrIndex]isEqualToString:territoryTeamTextField.text]) {
                listViewController.selectedTeamIndex = terrIndex;
                _selectedTeamIndexValue = [NSString stringWithFormat:@"%ld",(long)listViewController.selectedTeamIndex];
                [standardUserDefault setObject:[[teamArrayDict objectForKey:@"teamId"] objectAtIndex:[_selectedTeamIndexValue integerValue]]forKey:@"SelectedTeamId"];
                [standardUserDefault setObject:_selectedTeamIndexValue forKey:SELECTED_TEAM_INDEX];
            }
        }
    }
    
    listViewController.modalPresentationStyle=UIModalPresentationPopover;
    listPopOverController  = [listViewController popoverPresentationController];
    listViewController.popoverPresentationController.sourceRect = CGRectMake(territoryList.frame.origin.x-165, territoryList.frame.origin.y+25, territoryList.frame.size.width, territoryList.frame.size.height);
    listViewController.popoverPresentationController.sourceView = territoryList;
    listViewController.preferredContentSize= CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    listPopOverController.delegate=self;
    listPopOverController.backgroundColor = [UIColor blackColor];
    listPopOverController.permittedArrowDirections = UIPopoverArrowDirectionLeft;

    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:listViewController animated: YES completion: nil];
    });
    
}

-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    if([listType isEqualToString:CHANGE_TERRITORY])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        listPopOverController = nil;
        //Reset state of change territory button
//        [changeTerritoryBtn setSelected:NO];
        
        BOOL isTerritoryChanged = [Utilities changeSelectedTerritoryTo:value];
        if(isTerritoryChanged)
        {
            //Close all connections
            [Utilities removeSpinnerFromView:self.view];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate resetAppForTerritoryChange];
        }
    }
    else if([listType isEqualToString:BU_KEY])
    {
        territoryBUTextField.text = value;
        [self dismissViewControllerAnimated:YES completion:nil];;
        listPopOverController = nil;
        
    }
    else if([listType isEqualToString:TEAM_KEY])
    {
        territoryTeamTextField.text = value;
        [self dismissViewControllerAnimated:YES completion:nil];
//        [listPopOverController dismissPopoverAnimated:NO];
        listPopOverController = nil;
        
    }
    else if([listType isEqualToString:TERRIOTARY_KEY])
    {
        territoryTerrTextField.text = value;
        [self dismissViewControllerAnimated:YES completion:nil];
//        [listPopOverController dismissPopoverAnimated:NO];
        listPopOverController = nil;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:SELECTED_TERRITTORY_NAME];
        [defaults setObject:[defaults objectForKey:@"FullName"] forKey:@"FullName"];
        [Themes refreshTerritory:self.topBar.topItem.titleView.subviews];
    }

}

#pragma mark -

@end
