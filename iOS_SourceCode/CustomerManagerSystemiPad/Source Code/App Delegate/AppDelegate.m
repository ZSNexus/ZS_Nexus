//
//  AppDelegate.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DatabaseManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "JSONDataFlowManager.h"
#import "DataManager.h"
#import "SelectTerritoryLoginViewController.h"

//TODO: Uncomment when API_KEY for business license is received from ZS Team
//#ifdef PRODUCTION_BUILD
//#import <GoogleMapsM4B/GoogleMaps.h>
//#else
#import <GoogleMaps/GoogleMaps.h>
//#endif

@interface AppDelegate()
{
    UIPopoverController *listPopOverController;
    UIBackgroundTaskIdentifier backgroundTaskIdentifier;
}

@end

@implementation AppDelegate
@synthesize nvc;

#pragma mark - Application Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HO_USER];//remove ho user defaults if any
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_BU_INDEX];//remove retained values for BU
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TEAM_INDEX];//remove retained values for Team
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TERR_INDEX];//remove retained values for Terriotary
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_TERRITTORY_NAME];//remove default selected Terriotary name
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REQUEST_MESSAGE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REMOVE_MESSAGE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCH_MESSAGE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TARGET_MESSAGE_KEY];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    nvc=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    [nvc setNavigationBarHidden:YES];
    [self setNvc:self.nvc];
    self.window.rootViewController = self.nvc;
    [self.window makeKeyAndVisible];
    
//TODO: Uncomment when API_KEY for business license is received from ZS Team
//#ifdef PRODUCTION_BUILD
//    [GMSServices provideAPIKey:GOOGLE_MAPS_BUSINESS_USAGE_API_KEY];
//#else
    [GMSServices provideAPIKey:GOOGLE_MAPS_FREE_USAGE_API_KEY]; //key received on Wednesday, August 21, 2013
//#endif
    
    //Set title attributes to bar button items in order to avoid text truncation
    UIFont *font = [UIFont fontWithName:@"Roboto-Medium" size:12.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:font,UITextAttributeFont, nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributeDict forState:UIControlStateNormal];
    
//    // selected text : blue
//    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} forState:UIControlStateNormal];
//    
//    // selected text : white
//    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
//    
//    // disabled text : blue
//    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blueColor] } forState:UIControlStateNormal];
//    
//    // color tint segmented control ---> black
//    [[UISegmentedControl appearance] setTintColor:[UIColor greenColor]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL returnValue = NO;
    NSString *urlString = [url absoluteString];
    if([urlString hasPrefix:@"nexus://"]){
        DebugLog(@"Open URL called to lauch app: %@", url);
        returnValue = YES;
    }
    return returnValue;
}
#pragma mark -

#pragma mark Common to All
-(void)Logout
{
    /*Add UIAlertController
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:LOGOUT_STRING message:ARE_YOU_SURE_YOU_WANT_TO_LOGOUT_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:YES_STRING,NO_STRING, nil];
    [alt show];
    */
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:LOGOUT_STRING  message:ARE_YOU_SURE_YOU_WANT_TO_LOGOUT_STRING  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:YES_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self userSessionExpireAction];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NO_STRING style:UIAlertActionStyleDefault handler:nil]];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)resetAppForTerritoryChange
{
    [ConnectionClass cancelNSUrlConnectionForIdentifier:nil];
    
    //Default request for Remove and Request tab
    [[DataManager sharedObject] setIsDefaultRequestForRemoveCustomer:TRUE];
    [[DataManager sharedObject] setIsDefaultRequestForRequests:TRUE];
    
    UITabBarController *tabBarController = [self.nvc.viewControllers objectAtIndex:0];
    [tabBarController setSelectedViewController:[[tabBarController viewControllers] objectAtIndex:0]];
    
    //Enable target tab if flag is yes
    NSArray *itemsArray = [[tabBarController tabBar]items];
    UITabBarItem *tabItem;
    
    //Uncomment this to enable Hide & Show functionality on Review(Target) Tab.
    /*
    tabItem = [itemsArray objectAtIndex:3];
    [tabItem setEnabled:YES];
    [tabItem setImage:[UIImage imageNamed:@"approve_selected.png"]];
    [tabItem setTitle:APPROVE_CUSTOMER_TAB_BOTTOM_STRING];*/
    
    //Comment this to disable Hide & Show functionality on Review(Target) Tab.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[[tabBarController tabBar]items] count]>3) {//checking for Approve tab
        if([[defaults objectForKey:@"TargetFlag"] isEqualToString:@"Y"]){
            tabItem = [itemsArray objectAtIndex:3];
            [tabItem setEnabled:YES];
            [tabItem setImage:[UIImage imageNamed:@"approve_selected.png"]];
            [tabItem setTitle:APPROVE_CUSTOMER_TAB_BOTTOM_STRING];
        }
        else{
            tabItem = [itemsArray objectAtIndex:3];
            [tabItem setEnabled:NO];
            [tabItem setImage:[UIImage imageNamed:@""]];
            [tabItem setTitle:@""];
        }
    }

    //till here.
    
    for (UINavigationController *navigationController in [tabBarController viewControllers]) {
        [navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark -

#pragma mark ZIP LOV Update
-(BOOL)isZipDatabaseUpdateRequired
{
    //update on first installation and on first working day of the month
    
    //Date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //User defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Get reference calender
    NSCalendar *gregorianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //Get Last DB Update Date and its components
    NSString *lastDBUpdateDateString = [defaults objectForKey:@"lastDBUpdateDate"];
    NSDate *lastDbUpdateDate = nil;
    NSDateComponents *lastDbUpdateDateComponents = nil;
    if(lastDBUpdateDateString.length)
    {
        lastDbUpdateDate = [dateFormatter dateFromString:lastDBUpdateDateString];
        lastDbUpdateDateComponents = [gregorianCalender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:lastDbUpdateDate];
    }
    
    //Get Next DB Update Date and its components
    NSString *nextDBUpdateDateString = [defaults objectForKey:@"nextDBUpdateDate"];
    NSDate *nextDbUpdateDate = nil;
    if(nextDBUpdateDateString)
    {
        nextDbUpdateDate = [dateFormatter dateFromString:nextDBUpdateDateString];
    }
    
    //Get Current Date and its components
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentDateComponents = [gregorianCalender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
    
    //Check for fresh installation
    if(lastDBUpdateDateString == nil || nextDBUpdateDateString == nil)
    {
        return YES;
    }
    
    //Check that whether last update was done before current month
    BOOL wasLastUpdatedInPrevMonth = TRUE;
    if(lastDbUpdateDateComponents.year < currentDateComponents.year)
    {
        wasLastUpdatedInPrevMonth = TRUE;
    }
    else
    {
        if(lastDbUpdateDateComponents.month < currentDateComponents.month)
        {
            wasLastUpdatedInPrevMonth = TRUE;
        }
        else
        {
            wasLastUpdatedInPrevMonth = FALSE;
        }
    }
    
    //Compare Current Date and Last Updated Date with Next Update Date to decide whether update is required or not
    if(([currentDate compare:nextDbUpdateDate]==NSOrderedDescending || [currentDate compare:nextDbUpdateDate]==NSOrderedSame))
    {
        if(wasLastUpdatedInPrevMonth || ([lastDbUpdateDate compare:nextDbUpdateDate]==NSOrderedAscending))
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)updateZipLovDatabase
{
    //Check that whether zip database update is required or not
    if(![self isZipDatabaseUpdateRequired])
    {
        return;
    }
    
    //Begin Background task
    backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
        backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DebugLog(@"AppDelegate | updateZipLovDatabase: Updating ZIP LOV database");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableString *getStatesUrl= [[NSMutableString alloc] init];
        [getStatesUrl appendFormat:@"%@", GET_STATES];
        [getStatesUrl appendFormat:@"firstInstallation=%@",(([defaults objectForKey:@"lastDBUpdateDate"] && [defaults objectForKey:@"nextDBUpdateDate"]) ? @"no" : @"yes")];
        
        ConnectionClass *connection = [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[getStatesUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"GetStatesWebService" andConnectionCallback:^(NSMutableData *receivedData, NSString *identifier, NSString *error)
         {
             if(!error)
             {
                 [self receiveDataFromServer:receivedData ofCallIdentifier:identifier];
             }
             else
             {
                 [self failWithError:error ofCallIdentifier:identifier];
             }
             
             [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
             backgroundTaskIdentifier = UIBackgroundTaskInvalid;
         }];
    });
}
#pragma mark -

/*Add UIAlertController
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0 && ([alertView.title isEqualToString:LOGOUT_STRING] || [alertView.title isEqualToString:SESSION_EXPIRED]))
    {
        [[JSONDataFlowManager sharedInstance]setSelectedTerritoryName:@""];
        
        //cancel all active connections
        [ConnectionClass cancelNSUrlConnectionForIdentifier:nil];
        
        if(iSLiveApp)
        {
            //Logout URL
            ConnectionClass *connection = [ConnectionClass sharedSingleton];
            [connection fetchDataFromUrl:[LOGOUT_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"Logout" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        
        //No need to check for the response in case of Logout, it should always succeed
        [self.nvc removeFromParentViewController];
        self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        nvc=[[UINavigationController alloc]initWithRootViewController:self.viewController];
        [nvc setNavigationBarHidden:YES];
        [self setNvc:self.nvc];
        self.window.rootViewController = self.nvc;
    }
}*/

-(void)userSessionExpireAction
{
    [[JSONDataFlowManager sharedInstance]setSelectedTerritoryName:@""];
    
    //cancel all active connections
    [ConnectionClass cancelNSUrlConnectionForIdentifier:nil];
    
    if(iSLiveApp)
    {
        //Logout URL
        ConnectionClass *connection = [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[LOGOUT_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"Logout" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    
    //No need to check for the response in case of Logout, it should always succeed
    [self.nvc removeFromParentViewController];
    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    nvc=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    [nvc setNavigationBarHidden:YES];
    [self setNvc:self.nvc];
    self.window.rootViewController = self.nvc;
}

//on click Home button load BU, Team and terriotary selection page
-(void)displayHOUserHomePage
{
    [self.nvc removeFromParentViewController];
    self.terriotaryViewController = [[SelectTerritoryLoginViewController alloc] initWithNibName:@"SelectTerritoryLoginViewController" bundle:nil];
    nvc=[[UINavigationController alloc]initWithRootViewController:self.terriotaryViewController];
    [nvc setNavigationBarHidden:YES];
    [self setNvc:self.nvc];
    self.window.rootViewController = self.nvc;
}

#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString *)identifier
{    
    //No need to check for the response in case of Logout, it should always succeed
    if([identifier isEqualToString:LOGOUT_STRING])
    {
        DebugLog(@"AppDelegate | Recieve Data - %@ | Identifier - %@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] ,identifier);
    }
    else if ([identifier isEqualToString:@"GetStatesWebService"])
    {
        //Handled on secondary thread hence do not perform any UI related operations in this block
        NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if(jsonDataObject!=nil)
        {
            NSDictionary *zipLovData = [Utilities parseJsonGetState:jsonDataObject];
            
            if(zipLovData)
            {
                if([[DatabaseManager sharedSingleton] createNewZipDatabaseWithData:zipLovData])
                {
                    DebugLog(@"AppDelegate | receiveDataFromServer: Created new ZIP LOV database");
                    
                    //Swap old database with new database
                    [[DatabaseManager sharedSingleton] swapOldDbWithNewDb];
                }
                else
                {
                    ErrorLog(@"AppDelegate | receiveDataFromServer: Error while creating new ZIP LOV database");
                }
            }
            else if ([jsonDataObject objectForKey:@"nextUpdateDate"])
            {
                [defaults setObject:[jsonDataObject objectForKey:@"nextUpdateDate"] forKey:@"nextDBUpdateDate"];
                DebugLog(@"AppDelegate | receiveDataFromServer: Next ZIP Upate Date is %@", [jsonDataObject objectForKey:@"nextUpdateDate"]);
            }
            else
            {
                if([jsonDataObject objectForKey:@"reasonCode"])
                {
                    ErrorLog(@"AppDelegate | receiveDataFromServer: Error - %@", [jsonDataObject objectForKey:@"reasonCode"]);
                }
                else
                {
                    ErrorLog(@"AppDelegate | receiveDataFromServer: Error - ZIP LOV database update failed");
                }
            }
        }
        else
        {
            ErrorLog(@"AppDelegate | receiveDataFromServer: Error - ZIP LOV database update failed");
        }
    }
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString *)identifier
{
    ErrorLog(@"AppDelegate | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    if([identifier isEqualToString:@"GetStatesWebService"])
    {
        //Handled on secondary thread hence do not perform any UI related operations in this block        
        ErrorLog(@"AppDelegate | receiveDataFromServer: Error - %@ | %@", error, identifier);
    }
}
#pragma mark -

#pragma mark View Handlers
-(void)startSpinnerWithMessage:(NSString *)msgString
{
    UIView* spinnerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.nvc.view.frame.size.height,self.nvc.view.frame.size.width)];
    [spinnerView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    spinnerView.tag=100;
    UIActivityIndicatorView* spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinnerView addSubview:spinner];
    spinner.center=spinnerView.center;
    [self.nvc.view addSubview:spinnerView];
    //Add Message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:17.0]];
    [messageLabel setText:msgString];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [spinnerView addSubview:messageLabel];
    [messageLabel setCenter:CGPointMake(spinnerView.center.x, spinnerView.center.y+50)];
    
    [spinner startAnimating];
    [self.nvc.view bringSubviewToFront:spinnerView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=TRUE;
}

-(void)dismissSpinner
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=FALSE;
    
    //Remove Spinner
    for(UIView * view in self.nvc.view.subviews)
    {
        if(view.tag==100)
        {
            [view removeFromSuperview];
            break;
        }
    }
}
#pragma mark -


-(NSString*)getUserDefaultsForKey:(NSString*)key
{
    NSString *defaultValue = nil;
    
    //Read from 'User Defaults'
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults == nil)
        return nil;
    
    defaultValue = [userDefaults objectForKey:key];
    if(defaultValue)
        return defaultValue;
    
    //Get default value from 'Settings Bundle' is not found in 'User defaults'
    NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(settingsBundlePath == nil)
        return nil;
    
    NSString *filePath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    for (NSDictionary *setting in preferencesArray) {
        
        NSString *keyString = [setting objectForKey:@"Key"];
        if([keyString isEqualToString:key])
        {
            defaultValue = [setting objectForKey:@"DefaultValue"];
            if(defaultValue)
            {
                [userDefaults setObject:defaultValue forKey:key];
            }
        }
        //Store value to 'User defaults'
    }
    
    return defaultValue;
}

@end
