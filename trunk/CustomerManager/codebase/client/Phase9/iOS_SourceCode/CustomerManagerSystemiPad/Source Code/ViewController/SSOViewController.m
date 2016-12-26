//
//  SSOViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 06/09/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "SSOViewController.h"
#import "Constants.h"
#import "Themes.h"
#import "Utilities.h"
#import "AppDelegate.h"

@interface SSOViewController ()<UIWebViewDelegate,NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate,UITextFieldDelegate>
{
    UIWebView *webViewSSO;
    UIView* spinnerView;
    IBOutlet UINavigationBar *topBar;
    NSURL * url;
//    NSURLConnection * conn;
    NSString * errorMsg;
    NSString * successMsg;
    NSMutableData * connDataRecieved;
    BOOL isCertificateError;
    BOOL isConnectionInProgress;
    NSString * SSOToken;
    CGRect originalSsoViewFrame;
    CGPoint offset;
    UIWebViewNavigationType formSubmitted;
    BOOL isRequestLoaded;
    
    NSTimer *webViewTimeoutTimer;
}
@property(nonatomic,assign) IBOutlet UIView * mainView;
@end

@implementation SSOViewController
{}
@synthesize mainView = _mainView;
#pragma mark - Initialization: View life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withParameters:(NSDictionary *)params
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //url=[NSURL URLWithString:SSO_URL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSessionTimeoutRetry) name:@"USER_SESSION_TIMEOUT_RETRY" object:nil];/*Add UIAlertController*/

    //Set Top Bar Theme
    topBar.tintColor=THEME_COLOR;
    topBar.topItem.titleView=[Themes setNavigationBarNormal:LOGIN_SCREEN_TITLE_STRING ofViewController:@"Login"];
    [topBar setBackgroundColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:topBar];
    [self.view sendSubviewToBack:self.mainView];
    [topBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_1024.png"] forBarMetrics:UIBarMetricsDefault];
    [self.mainView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [Themes setBackgroundTheme1:self.view];
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,topBar.frame.size.height-1,topBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [topBar addSubview:navBorder];
    
    spinnerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    
    [spinnerView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    
    //Add Activity Indicator
    UIActivityIndicatorView* spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinnerView addSubview:spinner];
    spinner.center=spinnerView.center;
    
    //Add Message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:17.0]];
    [messageLabel setText:LOADING_STRING];
    [messageLabel setTag:8888];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [spinnerView addSubview:messageLabel];
    [messageLabel setCenter:CGPointMake(spinnerView.center.x, spinnerView.center.y+50)];
    
    [self.view addSubview:spinnerView];
    [spinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=TRUE;
    
    //webViewSSO=[[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 500, 350)];
    webViewSSO=[[UIWebView alloc]initWithFrame:CGRectMake(262, 95, 500, 378)];
    
    [webViewSSO setBackgroundColor:[UIColor lightGrayColor]];
    [webViewSSO setDelegate:self];
    [webViewSSO setClipsToBounds:YES];
    [webViewSSO.scrollView setBounces:NO];
    [webViewSSO.scrollView setScrollEnabled:NO];
    webViewSSO.hidden=NO;
    //webViewSSO.scrollView.contentOffset = CGPointZero;
    //webViewSSO.center=self.view.center;
    [self.view addSubview:webViewSSO];
    [self.view bringSubviewToFront:spinnerView];
    //offset=webViewSSO.scrollView.contentOffset;
    //originalSsoViewFrame = webViewSSO.frame;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ConnectionClass *connection = [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:[SSO_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SSORedirect" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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

-(void)loadSSOPage
{
    DebugLog(@"LOAD SSO URL: %@",url);
    if(!isConnectionInProgress)
    {
        //Clear Browser History Cache
        NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
        float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
        NSLog(@"Before----loadSSOPage size: %ld,  %f", (long)sizeInteger, sizeInMB);
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
        sizeInMB = sizeInteger / (1024.0f * 1024.0f);
        NSLog(@"After----loadSSOPage size: %ld,  %f", (long)sizeInteger, sizeInMB);
        
        //[self eraseCredentials];
        NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
        [webViewSSO loadRequest:request];
        [webViewSSO setHidden:NO];
        isRequestLoaded=NO;
        NSArray *subViews=[spinnerView subviews];
        for (UILabel *label in subViews) {
            if(label.tag==8888)
            {
                [label setText:LOADING_STRING];
                break;
            }
            
        }
        isConnectionInProgress=TRUE;
        
    }
}

-(void)dismissSSOView
{
    [self.view removeFromSuperview];
}

-(void)webViewConnectionTimedOut
{
    [webViewSSO stopLoading];
    [webViewSSO setHidden:YES];
    [self.view sendSubviewToBack:spinnerView];
    
    //Append 'Retry' to alert view title; to be removed while diplaying alert view
    //used to show 'Retry' button
    NSString *alertViewTitle = SSO_AUTHENTICATION_STRING;
    alertViewTitle = [alertViewTitle stringByAppendingString:[NSString stringWithFormat:@"%@", RETRY_STRING]];
    
    [Utilities displayErrorAlertWithTitle:alertViewTitle andErrorMessage:ERROR_REQUEST_TIMED_OUT_TRY_AGAIN withDelegate:self];
}

- (void) eraseCredentials {
	NSURLCredentialStorage *credentialsStorage = [NSURLCredentialStorage sharedCredentialStorage];
	NSDictionary *allCredentials = [credentialsStorage allCredentials];
    
    for (NSURLProtectionSpace *protectionSpace in allCredentials) {
        
        NSDictionary *credentials = [credentialsStorage credentialsForProtectionSpace:protectionSpace];
        for (NSString *credentialKey in credentials)
            [credentialsStorage removeCredential:[credentials objectForKey:credentialKey] forProtectionSpace:protectionSpace];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

#pragma mark Web View Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view bringSubviewToFront:spinnerView];
    DebugLog(@"SSO | webViewDidStartLoadUrl - %@",webView.request.URL);
    
    if(formSubmitted==UIWebViewNavigationTypeFormSubmitted)
        isRequestLoaded=YES;
    
    //    if ([[NSString stringWithFormat:@"%@",webView.request.URL] rangeOfString:@"affwebservices/public/saml2sso?"].location != NSNotFound) {
    //        isRequestLoaded=YES;
    //    }
    
    //Start timer
    webViewTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:CONNECTION_TIMEOUT target:self selector:@selector(webViewConnectionTimedOut) userInfo:nil repeats:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if (navigationType==UIWebViewNavigationTypeFormSubmitted && formSubmitted!=UIWebViewNavigationTypeFormSubmitted) {
        formSubmitted=navigationType;
        NSArray *subViews=[spinnerView subviews];
        for (UILabel *label in subViews) {
            if(label.tag==8888)
            {
                [label setText:LOGGING_IN_STRING];
                break;
            }
        }
    }
    else
        formSubmitted=navigationType;
    
    [webViewSSO setHidden:NO];
    if (isRequestLoaded) {
        [webViewSSO setHidden:YES];
    }
    if(isCertificateError)
    {
        [self.view bringSubviewToFront:spinnerView];
        connDataRecieved=[[NSMutableData alloc]init];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:request.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          // ...
                                          if (response) {
//                                              NSMutableData* receivedData = [NSMutableData data];
//                                              NSString *str = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//                                              NSLog(@"Response : %@", str);
                                              
                                              
                                          }
                                          else if (error)
                                          {
                                              ErrorLog(@"Connection Class | Invalid Connection | (%@)", error.description);
                                              
                                          }
                                      }];
        
        [task resume];
        return NO;
    }
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webViewTimeoutTimer invalidate];
    
    ErrorLog(@"SSO | didFailLoadWithError | Error: %@",error.localizedDescription);
    DebugLog(@"SSO | didFailLoadWithError | Error Loading SSO Url in Web view - %@",[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]);
    
    if ([error.domain isEqualToString: NSURLErrorDomain])
    {
        if (error.code == kCFURLErrorServerCertificateHasBadDate        ||
            error.code == kCFURLErrorServerCertificateUntrusted         ||
            error.code == kCFURLErrorServerCertificateHasUnknownRoot    ||
            error.code == kCFURLErrorServerCertificateNotYetValid)
        {
            isCertificateError=YES;
            //Substring from start index 10   'opentoken='
            NSString *errorInfo = [[NSURL URLWithString:[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]] query];
            
            if(errorInfo && [errorInfo hasPrefix:@"opentoken="])
            {
                SSOToken=[[[NSURL URLWithString:[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]] query] substringFromIndex:10];
            }
            
            if(SSOToken!=nil && SSOToken.length!=0)
            {
                if(iSLiveApp)
                {
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    [appDelegate updateZipLovDatabase];
                }
                
                [self dismissSSOView];
                [self.delegate ssoLoginisSucessFul:YES withCallbackParameters:[NSDictionary dictionaryWithObjectsAndKeys:SSOToken,@"SSOToken", nil]];
            }
            else
            {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]];
            }
            
            DebugLog(@"SSO Token -  %@",SSOToken);
        }
        else 
        {
            //Do not show error alert view if it is due to cancellation of loadRequest. Timeout error will be shown at point of cancellation.
            if(error.code == kCFURLErrorCancelled)
            {
                return;
            }
            
            NSString *errorDescription = [error localizedDescription];
            
            //Modify error description if error is of type No Internet connection
            if(error.code == kCFURLErrorNotConnectedToInternet)
            {
           
                errorDescription = [errorDescription stringByAppendingString:[NSString stringWithFormat:@" %@", ERROR_NO_INTERNET_CONNECTION_RETRY]];
            }
            else
            {
                   
                 errorDescription = [errorDescription stringByAppendingString:[NSString stringWithFormat:@" %@", ERROR_UNKNOWN_PLEASE_RETRY]];
//                errorDescription = ERROR_UNKNOWN_PLEASE_RETRY;
            }
            
            //Append 'Retry' to alert view title; to be removed while diplaying alert view
            //used to show 'Retry' button
            NSString *alertViewTitle = SSO_AUTHENTICATION_STRING;
            
            alertViewTitle = [alertViewTitle stringByAppendingString:[NSString stringWithFormat:@"%@", RETRY_STRING]];
            
            [Utilities displayErrorAlertWithTitle:alertViewTitle andErrorMessage:errorDescription withDelegate:self];
            [self.view sendSubviewToBack:spinnerView];
            isRequestLoaded=NO;
        }
    }
    else
    {
        isConnectionInProgress=TRUE;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webViewTimeoutTimer invalidate];
    
    DebugLog(@"SSO | webViewDidFinishLoad | Url - %@",webView.request.URL);
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    DebugLog(@"SSO Url Loaded in Web view %@",html);
    isConnectionInProgress=FALSE;
    
    [self.view bringSubviewToFront:webViewSSO];
    
    //Second Time if Certificate is Already Authenticated then it will go to Tomcat Page So check whether Url Contains openToken then we are successfully logged in
    
    if ([[NSString stringWithFormat:@"%@",webView.request.URL] rangeOfString:@"opentoken"].location != NSNotFound ) {
        
        DebugLog(@"SSO | webViewDidFinishLoad | Certificate Already Authenticated");
        SSOToken=[NSString stringWithFormat:@"%@",[[webView.request.URL query] substringFromIndex:10]];
        
        if(SSOToken!=nil && SSOToken.length!=0)
        {
            if(iSLiveApp)
            {
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate updateZipLovDatabase];
            }
            
            [self dismissSSOView];
            [self.delegate ssoLoginisSucessFul:YES withCallbackParameters:[NSDictionary dictionaryWithObjectsAndKeys:SSOToken,@"SSOToken", nil]];
        }
        else
        {
            //Error While getting Token SHow User messgae
            [Utilities displayErrorAlertWithTitle:SSO_AUTHENTICATION_STRING andErrorMessage:ERROR_SSO_AUTHENTICATION_FAILED_NO_TOKEN withDelegate:self];
            [self loadSSOPage];
        }

    }
    else if([[NSString stringWithFormat:@"%@",webView.request.URL] rangeOfString:@"bms_authenfailed.html"].location != NSNotFound)
    {
        
        ////https://smusxath.bms.com/public/bms_authenfailed.html
        //Error While getting Token SHow User messgae
        [Utilities displayErrorAlertWithTitle:SSO_AUTHENTICATION_STRING andErrorMessage:ERROR_SSO_AUTHENTICATION_FAILED withDelegate:self];
        [self loadSSOPage];
    }
    else if([html rangeOfString:@"The following error occurred"].location != NSNotFound)
    {
        [webViewSSO setHidden:NO];
        [Utilities displayErrorAlertWithTitle:SSO_AUTHENTICATION_STRING andErrorMessage:ERROR_SSO_AUTHENTICATION_FAILED withDelegate:self];
        [self loadSSOPage];
    }
}
#pragma mark -

#pragma mark Connection Delegates

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{

    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    NSURLCredential *cred;
    cred = [NSURLCredential credentialForTrust:trust];
    [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
}



#pragma mark -

#pragma mark Session Data Delegates


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [connDataRecieved appendData:data];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    if(SSOToken!=nil && SSOToken.length!=0)
    {
        if(iSLiveApp)
        {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate updateZipLovDatabase];
        }
        
        [self dismissSSOView];
        [self.delegate ssoLoginisSucessFul:YES withCallbackParameters:[NSDictionary dictionaryWithObjectsAndKeys:SSOToken,@"SSOToken", nil]];
    }
    else
    {
        //Error While getting Token SHow User messgae
        [Utilities displayErrorAlertWithTitle:SSO_AUTHENTICATION_STRING andErrorMessage:ERROR_SSO_AUTHENTICATION_FAILED_NO_TOKEN withDelegate:self];
        [self loadSSOPage];
    }

}


-(NSURLRequest *)connection:(NSURLSessionDataTask *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse
{
    
    if (redirectResponse) {
        NSMutableURLRequest *r = [request mutableCopy]; // original request
        [r setURL: [request URL]];
        return r;
    } else {
        DebugLog(@"SSO | redirectResponse | redirecting to : %@", [request URL]);
        return request;
    }
}
#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString *)identifier
{
    NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    DebugLog(@"[SSO : receiveDataFromServer : JSON received : \n%@ \nIdentifier: %@",jsonDataObject ,identifier);
    
    //Reset connection in progress flag
    isConnectionInProgress = FALSE;
    
    if([identifier isEqualToString:@"SSORedirect"])
    {
        if(jsonDataObject == nil)
        {
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ErrorLog(@"SSOViewController | Data Recieved Null. Json Parsing Error - %@ | Identifier - %@",myString ,identifier);
            
            //Append 'Retry' to alert view title; to be removed while diplaying alert view
            //used to show 'Retry' button
            NSString *alertViewTitle = SSO_AUTHENTICATION_STRING;
            alertViewTitle = [alertViewTitle stringByAppendingString:[NSString stringWithFormat:@"%@", RETRY_STRING]];
            
            [Utilities displayErrorAlertWithTitle:alertViewTitle andErrorMessage:ERROR_REQUEST_COULD_NOT_COMPLETE_TRY_AGAIN withDelegate:self];
            
            //Remove spinner view
            [self.view sendSubviewToBack:spinnerView];
            [webViewSSO setHidden:YES];
        }
        else
        {
            if([Utilities parseJsonAndCheckStatus:jsonDataObject])
            {
                if([jsonDataObject objectForKey:@"reasonCode"])
                {
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]]];
                    [self loadSSOPage];
                }
            }
            else
            {
                //Append 'Retry' to alert view title; to be removed while diplaying alert view
                //used to show 'Retry' button
                NSString *alertViewTitle = SSO_AUTHENTICATION_STRING;
                alertViewTitle = [alertViewTitle stringByAppendingString:[NSString stringWithFormat:@"%@", RETRY_STRING]];
                
                [Utilities displayErrorAlertWithTitle:alertViewTitle andErrorMessage:[NSString stringWithFormat:@"%@", [jsonDataObject objectForKey:@"reasonCode"]] withDelegate:self];
                
                //Remove spinner view
                [self.view sendSubviewToBack:spinnerView];
                [webViewSSO setHidden:YES];
            }
        }
    }
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString *)identifier
{
    ErrorLog(@"SSO | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    //Append 'Retry' to alert view title; to be removed while diplaying alert view
    //used to show 'Retry' button
    NSString *alertViewTitle = SSO_AUTHENTICATION_STRING;
    alertViewTitle = [alertViewTitle stringByAppendingString:[NSString stringWithFormat:@"%@", RETRY_STRING]];

    [Utilities displayErrorAlertWithTitle:alertViewTitle andErrorMessage:[NSString stringWithFormat:@"%@", error] withDelegate:self];
    
    //Remove spinner view
    [self.view sendSubviewToBack:spinnerView];
    [webViewSSO setHidden:YES];
    isConnectionInProgress = FALSE;
}
#pragma mark -

/*Add UIAlertController
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:RETRY_STRING])
    {
        ConnectionClass *connection = [ConnectionClass sharedSingleton];
        [connection fetchDataFromUrl:[SSO_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SSORedirect" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
        
        [self.view bringSubviewToFront:spinnerView];
    }
}
*/

-(void)userSessionTimeoutRetry
{
    ConnectionClass *connection = [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:[SSO_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withParameters:nil forConnectionIdentifier:@"SSORedirect" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
    
    [self.view bringSubviewToFront:spinnerView];
}

@end
