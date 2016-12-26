//
//  LoginViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "LoginViewController.h"
#import "Themes.h"
#import "SelectTerritoryLoginViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "MapFullScreenViewController.h"
#import "DatabaseManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "AddCustomerViewController.h"
#import "RemoveCustomerViewController.h"
#import "RequestsViewController.h"
#import "ApproveCustomerViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
{
    UINavigationController* nav1;
    UINavigationController* nav2;
    UINavigationController* nav3;
    UINavigationController* nav4;
    
    CGRect originalLoginViewFrame;
    
    UIWebView *loginWebView;
    BOOL isCertificateError;
    NSMutableData *dataConn;
}
@property(nonatomic,retain) IBOutlet UINavigationBar *topBar;
@property(nonatomic,retain) IBOutlet UIButton * loginBtn;
@property(nonatomic,assign) IBOutlet UIView * loginCredentialView;
@property(nonatomic,assign) IBOutlet UITextField* passwordText;
@property(nonatomic,assign) IBOutlet UITextField* userNameText;
@property(nonatomic,assign) IBOutlet UILabel * loginCredentialLbl;
@property(nonatomic,assign) IBOutlet UIView * userNameView;
@property (nonatomic,assign) IBOutlet UILabel* userNameLbl;
@property (nonatomic,assign) IBOutlet UIView * passwordView;
@property (nonatomic,assign) IBOutlet UILabel* passwordLbl;

-(IBAction)clickLoginBtn:(id)sender;

@end

@implementation LoginViewController
@synthesize loginCredentialView,passwordText,userNameText,loginCredentialLbl,userNameView,userNameLbl,passwordView,passwordLbl;

#pragma mark - Initialization
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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HO_USER];//remove ho user defaults if any
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_BU_INDEX];//remove retained values for BU
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TEAM_INDEX];//remove retained values for Team
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TERR_INDEX];//remove retained values for Terriotary
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TERRITTORY_NAME];//remove default selected Terriotary name
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TEAM_NAME];//remove default selected team name
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TargetFlag"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REQUEST_MESSAGE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REMOVE_MESSAGE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCH_MESSAGE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TARGET_MESSAGE_KEY];
    

    
    //Clear User Object Roles if already present
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"LoggedInUser"];
    
    //Set Top Bar Theme
    self.topBar.tintColor=THEME_COLOR;
    self.topBar.topItem.titleView=[Themes setNavigationBarNormal:LOGIN_SCREEN_TITLE_STRING ofViewController:@"Login"];
    [self.topBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024.png"] forBarMetrics:UIBarMetricsDefault];
    self.topBar.frame = CGRectMake(0, 20, 1024, 44);
    
    [Themes setBackgroundTheme1:self.view];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.topBar.frame.size.height-1,self.topBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.topBar addSubview:navBorder];
    
    [loginCredentialLbl setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    userNameView.layer.cornerRadius=10.0f;
    userNameView.layer.borderWidth=1.0f;
    userNameView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [userNameLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    userNameText.tag=2;
    [userNameText setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    passwordView.layer.cornerRadius=10.0f;
    passwordView.layer.borderWidth=1.0f;
    passwordView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    [passwordText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordText setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    passwordText.tag=1;
    [passwordLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    
    //Save original login view frame
    //Use this to reset login credentials view when virtual kaypad is dismissed
    originalLoginViewFrame = self.loginCredentialView.frame;
    
    if(isSSOEnabled)
    {
        //SSO By Pass
        [loginCredentialView setHidden:YES];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if(![self loadZipLovDatabase])
    {
        if(iSLiveApp)
        {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate updateZipLovDatabase];
        }
    }
    
    if(iSLiveApp && isSSOEnabled)
    {
        //Load SSO view
        [self loadSSO];
    }
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

-(BOOL)loadZipLovDatabase
{
    BOOL isDatabaseCopied = FALSE;
    
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    //Copy State Database from Resources to Application Support directory
    if(![[defaults objectForKey:@"Launch"] isEqualToString:@"Second"]) //First Launch
    {
        //Add spinner
        [self startSpinnerWithMessage:UPDATING_DATABASE_STRING];
        
        DebugLog(@"LoginViewController: First launch App");
        if([Utilities copyDatabaseFromResources])
        {
            isDatabaseCopied = TRUE;
            [defaults setObject:@"Second" forKey:@"Launch"];
        }
        else
        {
            isDatabaseCopied = FALSE;
        }
        
        //Remove spinner
        [self dismissSpinner];
    }
    else //Second launch
    {
        DebugLog(@"LoginViewController: Second launch App");
        
        isDatabaseCopied = TRUE;
    }
    
    return isDatabaseCopied;
}

-(void)loadSSO
{
    SSOViewController * ssoView=[[SSOViewController alloc]initWithNibName:@"SSOViewController" bundle:nil withParameters:nil];
    ssoView.delegate=self;
    [self addChildViewController:ssoView];
    [self.view addSubview:ssoView.view];
}
#pragma mark -

#pragma mark SSO Delegate
-(void)ssoLoginisSucessFul:(BOOL)isSucessfull withCallbackParameters:(NSDictionary *)calbackParams
{
    if(isSucessfull)
    {
        [self startSpinnerWithMessage:PLEASE_WAIT_FETCHING_USER_ROLES_STRING];
        
        //Get USer Roles
        if(iSLiveApp)
        {
            NSString * url=[NSString stringWithFormat:@"%@opentoken=%@",GET_USER_ROLES,[calbackParams objectForKey:@"SSOToken"]];
            ConnectionClass * connection= [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"GetUserRoles" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    }
}
#pragma mark -

#pragma mark UI Actions
-(IBAction)clickLoginBtn:(id)sender
{
    //first of all trim aal of the speces from user name and password
    userNameText.text = [userNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    passwordText.text = [passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userNameText.text =@"abc";
    passwordText.text =@"123";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ((userNameText.text== nil || userNameText.text.length<=0) && (passwordText.text==nil || passwordText.text.length<=0))
    {
        [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:ERROR_PROVIDE_VALID_USERNAME_AND_PASSWORD withDelegate:self];
        userNameText.text=@"";
        passwordText.text=@"";
    }
    else if (userNameText.text== nil || userNameText.text.length<=0)
    {
        [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:ERROR_PROVIDE_VALID_USERNAME_AND_PASSWORD withDelegate:self];
        userNameText.text=@"";
    }
    else if(passwordText.text==nil || passwordText.text.length<=0)
    {
        [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:ERROR_PROVIDE_VALID_USERNAME_AND_PASSWORD withDelegate:self];
        passwordText.text=@"";
    }
    else
    {
        [self startSpinnerWithMessage:PLEASE_WAIT_FETCHING_USER_ROLES_STRING];
        [self.userNameText resignFirstResponder];
        [self.passwordText resignFirstResponder];
        
        if(iSLiveApp)
        {
            NSString * url=[NSString stringWithFormat:@"%@username=%@",GET_USER_ROLES,userNameText.text];
            
            ConnectionClass * connection= [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"GetUserRoles" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        else //Static Mode
        {
            [defaults setObject:@"Y" forKey:@"isHoUser"];//adding flag for HO user

            //static data for req user
            NSMutableDictionary * loggedInUser=[[NSMutableDictionary alloc]init];
            [loggedInUser setObject:userNameText.text forKey:@"FullName"];
            [loggedInUser setObject:userNameText.text forKey:@"LoginName"];
            [loggedInUser setObject:@"NexusServerToken" forKey:@"NexusServerToken"];
            [loggedInUser setObject:@"1" forKey:@"PersonalId"];
            NSMutableDictionary * territoriesAndRolesDict=[[NSMutableDictionary alloc]init];
            NSDictionary * terrRoleObj1=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"1",@"Admin",@"Territory1", nil] forKeys:[NSArray arrayWithObjects:@"RoleId",@"RoleName",@"TerritoryName", nil]];
            NSDictionary * terrRoleObj2=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"2",@"Rep",@"Territory2", nil] forKeys:[NSArray arrayWithObjects:@"RoleId",@"RoleName",@"TerritoryName", nil]];
            [territoriesAndRolesDict setObject:terrRoleObj1 forKey:@"1"];
            [territoriesAndRolesDict setObject:terrRoleObj2 forKey:@"2"];
            [loggedInUser setObject:territoriesAndRolesDict forKey:@"TerritoriesAndRoles"];
            [defaults setObject:loggedInUser forKey:@"LoggedInUser"];
            
            
            //static data for HO user
            
            NSMutableArray *buArray = [[NSMutableArray alloc]init];
            NSMutableDictionary *teamDict = [[NSMutableDictionary alloc]init];
            NSMutableArray *teamArray = [[NSMutableArray alloc]init];
            NSDictionary *terr1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"territoryId",@"my terr1",@"territoryName", nil];
            NSDictionary *terr2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"territoryId",@"my terr2",@"territoryName", nil];
            //creating array of dict of territory
            [teamArray addObject:terr1];
            [teamArray addObject:terr2];
            [teamDict setObject:teamArray forKey:@"terr"];// created first aar of dict of team 1
            //adding other info for team
            [teamDict setObject:@"111" forKey:@"teamCode"];
            [teamDict setObject:@"my team 1" forKey:@"teamCodeName"];
            
            NSMutableDictionary *teamDict2 = [[NSMutableDictionary alloc]init];
            [teamDict2 setObject:teamArray forKey:@"terr"];// created first aar of dict of team 1
            //adding other info for team
            [teamDict2 setObject:@"teamCode1" forKey:@"teamCode"];
            [teamDict2 setObject:@"teamCodeName" forKey:@"teamCodeName"];
            
            [buArray addObject:teamDict2];
            NSMutableDictionary *buDict = [[NSMutableDictionary alloc]init];
            [buDict setObject:@"bu1" forKey:@"businessUnitId"];
            [buDict setObject:@"my bu name" forKey:@"businessUnitName"];
            [buDict setObject:buArray forKey:@"team"];
            
            [defaults setObject:buDict forKey:@"hoUserData"];
//            if (buDict) {
//                [[DatabaseManager sharedSingleton] createNewHOUserDataWith:buDict];
//                [[DatabaseManager sharedSingleton] swapOldDbWithNewDb];
//            }
            
            [self dismissSpinner];
            SelectTerritoryLoginViewController * selectTerritoryLoginViewController=[[SelectTerritoryLoginViewController alloc]initWithNibName:@"SelectTerritoryLoginViewController" bundle:nil];
            [self addChildViewController:selectTerritoryLoginViewController];
            [self.view addSubview:selectTerritoryLoginViewController.view];
        }
    }
}
#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    if([identifier isEqualToString:@"GetUserRoles"])
    {
        @try {
            
            NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if(jsonDataObject!=nil)
            {
                DebugLog(@"Login Class | Response - %@ | Identifier - %@",jsonDataObject ,identifier);
                if ([jsonDataObject objectForKey:@"ho_user"]) {

                    [Utilities parseJsonLoginUserDetails:jsonDataObject];
                    
                    NSUserDefaults *hoUserDefault = [NSUserDefaults standardUserDefaults];
                    [hoUserDefault setObject:@"Y" forKey:HO_USER];

                    SelectTerritoryLoginViewController * selectTerritoryLoginViewController=[[SelectTerritoryLoginViewController alloc]initWithNibName:@"SelectTerritoryLoginViewController" bundle:nil];
                    [self addChildViewController:selectTerritoryLoginViewController];
                    [self.view addSubview:selectTerritoryLoginViewController.view];
                }
                else if([Utilities parseJsonLoginUserDetails:jsonDataObject])
                {
                    [self dismissSpinner];
                    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
                    if([[defaults objectForKey:@"NoOfRoles"] isEqualToString:@"1"]) // Only 1 role and territory
                    {
                        //Push Tab Bar controller with Add Customer Screen
                        AddCustomerViewController *viewController1 = [[AddCustomerViewController alloc] initWithNibName:@"AddCustomerViewController" bundle:nil];
                        nav1=[[UINavigationController alloc]initWithRootViewController:viewController1];
                        
                        RemoveCustomerViewController *viewController2 =[[RemoveCustomerViewController alloc]initWithNibName:@"RemoveCustomerViewController" bundle:nil];
                        nav2=[[UINavigationController alloc]initWithRootViewController:viewController2];
                        
                        RequestsViewController *viewController3 =[[RequestsViewController alloc]initWithNibName:@"RequestsViewController" bundle:nil];
                        nav3=[[UINavigationController alloc]initWithRootViewController:viewController3];
                        
                        ApproveCustomerViewController *viewController4;
                        UITabBarController* tabBarController = [[UITabBarController alloc] init];
                        
                        /*
                        viewController4 =[[ApproveCustomerViewController alloc]initWithNibName:@"ApproveCustomerViewController" bundle:nil];
                        nav4=[[UINavigationController alloc]initWithRootViewController:viewController4];
                        tabBarController.viewControllers = [NSArray
                                                            arrayWithObjects:nav1,nav2,nav3,nav4, nil];
                         */
                        
                        if([[defaults objectForKey:@"TargetFlag"] isEqualToString:@"Y"]){
                            viewController4 =[[ApproveCustomerViewController alloc]initWithNibName:@"ApproveCustomerViewController" bundle:nil];
                            nav4=[[UINavigationController alloc]initWithRootViewController:viewController4];
                            tabBarController.viewControllers = [NSArray
                                                                arrayWithObjects:nav1,nav2,nav3,nav4, nil];
                        }
                        else{
                            tabBarController.viewControllers = [NSArray
                                                                arrayWithObjects:nav1,nav2,nav3, nil];
                        }
                        
                        tabBarController.delegate=self;
                        [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_bar.png"] ];
                        //SetTab Bar  Images
                        UITabBar *tabBar = tabBarController.tabBar;
                        UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
                        UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
                        UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
                        
                        
                        [item0 setImage:[UIImage imageNamed:@"addcust_selected.png"]];
                        [item0 setTitle:SEARCH_CUSTOMERS_TAB_NAME_STRING];
                        [item1 setImage:[UIImage imageNamed:@"removecust_selected.png"]];
                        [item1 setTitle:REMOVE_CUSTOMER_TAB_TITLE_STRING];
                        [item2 setImage:[UIImage imageNamed:@"requests_selected.png"]];
                        [item2 setTitle:REQUESTS_TAB_TITLE_STRING];
                        UITabBarItem *item3;
                        
                        /*
                        item3 = [tabBar.items objectAtIndex:3];
                        [item3 setImage:[UIImage imageNamed:@"approve_selected.png"]];
                        [item3 setTitle:APPROVE_CUSTOMER_TAB_BOTTOM_STRING];
                        */
                        
                        
                        if([[defaults objectForKey:@"TargetFlag"] isEqualToString:@"Y"]){
                            item3 = [tabBar.items objectAtIndex:3];
                            [item3 setImage:[UIImage imageNamed:@"approve_selected.png"]];
                            [item3 setTitle:APPROVE_CUSTOMER_TAB_BOTTOM_STRING];
                        }
                        
                        //BMS Logo On Tab Bar
                        UIImageView* tabBarBMSLogo=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+20,722, 266, 44)];
                        [tabBarBMSLogo setImage:[UIImage imageNamed:@"logo_BMS.png"]];
                        [tabBarController.view addSubview:tabBarBMSLogo];
                        
                        UINavigationController *nvc=[[UINavigationController alloc] initWithRootViewController:tabBarController];
                        [nvc setNavigationBarHidden:YES];
                        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                        [appDelegate.nvc removeFromParentViewController];
                        [appDelegate setNvc:nvc];
                        appDelegate.window.rootViewController=nvc;
                    }
                    else // For more than 1 role and territory
                    {
                        SelectTerritoryLoginViewController * selectTerritoryLoginViewController=[[SelectTerritoryLoginViewController alloc]initWithNibName:@"SelectTerritoryLoginViewController" bundle:nil];
                        [self addChildViewController:selectTerritoryLoginViewController];
                        [self.view addSubview:selectTerritoryLoginViewController.view];
                    }
                }
                else
                {
                    if(isSSOEnabled)
                    {
                        //SSO By pass
                        [self loadSSO];
                    }
                    [self.userNameText setText:@""];
                    [self.passwordText setText:@""];
                    [self dismissSpinner];
                    [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:[NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]] withDelegate:self];
                }
            }
            else
            {
                if(isSSOEnabled)
                {
                    //SSO By pass
                    [self loadSSO];
                }
                [self.userNameText setText:@""];
                [self.passwordText setText:@""];
                [self dismissSpinner];
                [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:ERROR_USER_CAN_NOT_BE_VERIFIED_CONTACT_HELP_DESK withDelegate:self];
                
                NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                ErrorLog(@"Login Class | Error - %@ | Identifier - %@",myString ,identifier);
            }
        }
        @catch (NSException *exception) {
            ErrorLog(@"Error Login - %@",exception);
            
            if(isSSOEnabled)
            {
                //SSO By pass
                [self loadSSO];
            }
            
            [self.userNameText setText:@""];
            [self.passwordText setText:@""];
            [self dismissSpinner];
            [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:ERROR_USER_CAN_NOT_BE_VERIFIED_CONTACT_HELP_DESK withDelegate:self];
        }
    }
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    [self dismissSpinner];
    
    if([identifier isEqualToString:@"GetUserRoles"])
    {
        ErrorLog(@"Login Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
        
        //Load SSO login page
        if(isSSOEnabled)
        {
            //SSO By pass
            [self loadSSO];
        }
        
        [self.userNameText setText:@""];
        [self.passwordText setText:@""];
        [Utilities displayErrorAlertWithTitle:LOGIN_STRING andErrorMessage:error withDelegate:self];
    }
}
#pragma mark -

#pragma mark Text Field Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.userNameText])
    {
        [textField setReturnKeyType:UIReturnKeyDefault];
    }
    else if ([textField isEqual:self.passwordText])
    {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [self clickLoginBtn:nil];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
#pragma mark -

#pragma mark Keyboard Notifications
-(void)keyboardWillShow
{
    if(!isSSOEnabled)
        [self.loginCredentialView setFrame:CGRectMake(self.loginCredentialView.frame.origin.x, self.loginCredentialView.frame.origin.y-100, self.loginCredentialView.frame.size.width, self.loginCredentialView.frame.size.height)] ;
}

-(void)keyboardWillHide
{
    if(!isSSOEnabled)
        [self.loginCredentialView setFrame:originalLoginViewFrame];
}
#pragma mark -

#pragma mark View Handlers
//TODO: Use addSpinnerOnView from Utilities
-(void)startSpinnerWithMessage:(NSString*)msg
{
    UIView* spinnerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [spinnerView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    spinnerView.tag=100;
    UIActivityIndicatorView* spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinnerView addSubview:spinner];
    spinner.center=spinnerView.center;
    [self.view addSubview:spinnerView];
    //Add Message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:17.0]];
    [messageLabel setText:msg];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [spinnerView addSubview:messageLabel];
    [messageLabel setCenter:CGPointMake(spinnerView.center.x, spinnerView.center.y+150)];
    
    [spinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=TRUE;
}

-(void)dismissSpinner
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=FALSE;
    
    //Remove Spinner
    for(UIView * view in self.view.subviews)
    {
        if(view.tag==100)
        {
            [view removeFromSuperview];
            break;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *touchedView = [touch view];
    if(![touchedView isKindOfClass:[UITextField class]])
    {
        [self.userNameText resignFirstResponder];
        [self.passwordText resignFirstResponder];
    }
}
#pragma mark -

@end
