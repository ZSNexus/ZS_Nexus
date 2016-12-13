//
//  ConnectionClass.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 18/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//



#import "ConnectionClass.h"
#import "AppDelegate.h"
#import "Constants.h"

static ConnectionClass * connectionObject = nil;
static NSOperationQueue * operationQueue = nil;
static NSMutableDictionary * identiferFullData=nil;
static NSMutableDictionary * callbacksMapping=nil;

@interface ConnectionClass()
@end

@implementation ConnectionClass

void (^CMConnectionResponseCallback)(NSMutableData* data, NSString* identifier, NSString* error);

#pragma mark Shared Connection
+(ConnectionClass *) sharedSingleton
{
    @synchronized (self)
    {
        if (connectionObject == nil) {
            connectionObject = [[self alloc] init];
            operationQueue = [NSOperationQueue new];
            identiferFullData=[[NSMutableDictionary alloc]init];
            callbacksMapping = [[NSMutableDictionary alloc] init];
        }
    }
    return connectionObject;
}
#pragma mark -

#pragma mark Invocate Connections
-(NSString*)addProperServerDomainToUrl:(NSMutableString*)url
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *serverDomain = [appDelegate getUserDefaultsForKey:SERVER_DOMAIN];
    
    [url replaceOccurrencesOfString:SERVER_DOMAIN withString:(serverDomain!=nil ? serverDomain : SERVER_DOMAIN_URL) options:NSLiteralSearch range:NSMakeRange(0, [url length])];
    
    return url;
}

//Blocks
-(void)fetchDataFromUrl:(NSString *)url withParameters:(NSDictionary *)params forConnectionIdentifier:(NSString *)identifier andConnectionCallback:(CMConnectionCallback)callback
{
    [callbacksMapping setObject:callback forKey:identifier];
    
    //replace component '$erver_@ddress' with proper server address
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * urlStr;
    if(![identifier isEqualToString:@"GetUserRoles"] && ![identifier isEqualToString:@"Map"] && ![identifier isEqualToString:@"SSORedirect"])
    {
        urlStr =[NSString stringWithFormat:@"%@/%@/%@/%@",COMMON_SERVER_URL,[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"LoginName"],[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"NexusServerToken"],url];
        
        if([identifier isEqualToString:@"Logout"])
        {
            urlStr =[NSString stringWithFormat:@"%@/%@/%@/%@",COMMON_SERVER_SSO_URL,[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"LoginName"],[[defaults objectForKey:@"LoggedInUser"] objectForKey:@"NexusServerToken"],url];
        }
        else if ([identifier isEqualToString:@"GetStatesWebService"])
        {
            urlStr = [NSString stringWithFormat:@"%@/%@", COMMON_SERVER_URL, url];
        }
    }
    else // No need to add 'username'  and 'token' for Get User roles, Map and SSORedirect
    {
        urlStr=url;
    }
    
    if(![identifier isEqualToString:@"Map"])
    {
        url = [self addProperServerDomainToUrl:[urlStr mutableCopy]];
    }
    
    if(operationQueue!=nil)
    {
        NSMutableDictionary * connInfo=[[NSMutableDictionary alloc]init];
        if(params!=nil)
        {
            [connInfo setObject:params forKey:@"params"];
        }
        if(url!=nil)
        {
            [connInfo setObject:url forKey:@"url"];
        }
        if(identifier!=nil)
        {
            [connInfo setObject:identifier forKey:@"identifier"];
        }
        
        if(![[ConnectionClass class] isConnectionInProgressForIdentifier:identifier])
        {
            @autoreleasepool {
                NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                        selector:@selector(executeFetchData:)
                                                                                          object: connInfo];
                [operationQueue addOperation:operation];
            }
        }
    }
    else
    {
        ErrorLog(@"Connection Class | NSOperation Queue Null");
    }
}

-(void)executeFetchData:(NSMutableDictionary *)connInfo
{
    DebugLog(@"[ConnectionClass : executeFetchData]LOG1: URL \n%@ \nIdentifier: %@",[connInfo objectForKey:@"url"],[connInfo objectForKey:@"identifier"]);
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[connInfo objectForKey:@"url"]]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:CONNECTION_TIMEOUT];
    NSDictionary * parameters=[connInfo objectForKey:@"params"];
    if([[parameters objectForKey:@"request_type"] isEqualToString:@"POST"])
    {
        DebugLog(@"[ConnectionClass : executeFetchData  : Post Body - %@",[parameters objectForKey:@"post_body"]);
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString * postBody=[parameters objectForKey:@"post_body"];
        [theRequest setHTTPBody:[NSData dataWithBytes:[postBody UTF8String] length:[postBody length]]];
    }
    if([[parameters objectForKey:@"request_type"] isEqualToString:@"DELETE"])
    {
        [theRequest setHTTPMethod:@"DELETE"];
    }
    
    NSURLConnection *  conn=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (conn) {
        NSMutableData* receivedData = [NSMutableData data];
        [connInfo setObject:receivedData forKey:@"recievedData"];
        [connInfo setObject:conn forKey:@"connectionObject"];
    } else {
        ErrorLog(@"Connection Class | Invalid Connection");
    }
    
    [identiferFullData setObject:connInfo forKey:[conn description]];
    
    [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
    
    //Keep secondary thread active till received data passed to main thread for UI update
    NSThread *currentThread = [NSThread currentThread];
    if(![currentThread isMainThread])
    {
        while ([identiferFullData objectForKey:[conn description]]) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        DebugLog(@"Connection Class | executeFetchData Exit thread | Identifier: %@", [connInfo objectForKey:@"identifier"]);
    }
}
#pragma mark -

#pragma mark NSURL Connection Delegates
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSArray * arr=[[NSArray arrayWithObjects:connection, error, nil] copy];
    NSMutableDictionary * connInfo=[identiferFullData objectForKey:[connection description]];
    ErrorLog(@"Connection Class | didFailWithError | Identifier: %@", [connInfo objectForKey:@"identifier"]);
    
    [self performSelectorOnMainThread:@selector(didFailWithErrorToUI:) withObject:arr waitUntilDone:NO];
}

//NSURL Connection HTTPS Delegate .. We are ignoring the certificsates this time
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
#pragma mark -

#pragma mark NSURL Connection Data Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableDictionary * connInfo=[identiferFullData objectForKey:[connection description]];
    DebugLog(@"Connection Class | Connection Did Recive Response | Identifier: %@", [connInfo objectForKey:@"identifier"]);
    
    NSMutableData *receivedData = [connInfo objectForKey:@"recievedData"];
    [receivedData setLength:0];
    [identiferFullData setObject:connInfo forKey:[connection description]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableDictionary * connInfo=[identiferFullData objectForKey:[connection description]];
    [[connInfo objectForKey:@"recievedData"] appendData:data];
    [identiferFullData setObject:connInfo forKey:[connection description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DebugLog(@"Connection Class | connectionDidFinishLoading | Identifier: %@", [[identiferFullData objectForKey:[connection description]] objectForKey:@"identifier"]);
    
    [self performSelectorOnMainThread:@selector(receiveDataFromServerToUI:) withObject:connection waitUntilDone:NO];
}
#pragma mark -

#pragma mark Connection Handlers
+(void)cancelNSUrlConnectionForIdentifier:(NSString *)identifier
{
    for(NSString * connDataIdentifier in [identiferFullData allKeys])
    {
        NSDictionary * connData=[identiferFullData objectForKey:connDataIdentifier];
        if(identifier && [[connData objectForKey:@"identifier"] isEqualToString:identifier])
        {
            NSURLConnection * conn=[connData objectForKey:@"connectionObject"];
            [conn cancel];
            ErrorLog(@"Cancelling Connection with Identifier - %@",identifier);
            [identiferFullData removeObjectForKey:connDataIdentifier];
            [callbacksMapping removeObjectForKey:identifier];
        }
        else if(identifier==nil)
        {
            NSURLConnection * conn=[connData objectForKey:@"connectionObject"];
            [conn cancel];
            ErrorLog(@"Cancelling Connection with Identifier - %@",[connData objectForKey:@"identifier"]);
            [identiferFullData removeObjectForKey:connDataIdentifier];
            
            if([connData objectForKey:@"identifier"])
            {
                [callbacksMapping removeObjectForKey:[connData objectForKey:@"identifier"]];
            }
        }
    }
}

+(void)removeConnectionDataForIdentifier:(NSString*)identifier
{
    for (NSString *connDescription in [identiferFullData allKeys]) {
        NSDictionary *connInfo = [identiferFullData objectForKey:connDescription];
        if([[connInfo objectForKey:@"identifier"] isEqualToString:identifier])
        {
            DebugLog(@"Connection Class | removeConnectionDataForIdentifier | Identifier: %@", identifier);
            [identiferFullData removeObjectForKey:connDescription];
            [callbacksMapping removeObjectForKey:identifier];
            break;
        }
    }
}

+(BOOL)isConnectionInProgressForIdentifier:(NSString *)identifier
{
    BOOL isConnectionInProgress = FALSE;
    
    for (NSString *connDescription in [identiferFullData allKeys]) {
        NSDictionary *connInfo = [identiferFullData objectForKey:connDescription];
        if([[connInfo objectForKey:@"identifier"] isEqualToString:identifier])
        {
            isConnectionInProgress = TRUE;
            break;
        }
    }
    
    return isConnectionInProgress;
}
#pragma mark -

#pragma mark Connection Data Handlers: Pass data to UI
-(void)receiveDataFromServerToUI:(NSURLConnection *)connection
{
    NSMutableDictionary * connInfo=[identiferFullData objectForKey:[connection description]];
    DebugLog(@"Connection Class Main Thread | receiveDataFromServerToUI | Identifier: %@", [connInfo objectForKey:@"identifier"]);
    
    CMConnectionCallback callBack = [callbacksMapping objectForKey:[connInfo objectForKey:@"identifier"]];
    
    if(callBack)
    {
        callBack([connInfo objectForKey:@"recievedData"], [connInfo objectForKey:@"identifier"], nil);
        [callbacksMapping removeObjectForKey:[connInfo objectForKey:@"identifier"]];
    }
    
    //Remove connection data which will exit the respective secondary thread
    [identiferFullData removeObjectForKey:[connection description]];
}

-(void)didFailWithErrorToUI:(NSArray *)arr
{
    NSMutableDictionary * connInfo=[identiferFullData objectForKey:[[arr objectAtIndex:0] description]];
    ErrorLog(@"Connection Class Main Thread | didFailWithErrorToUI | Identifier: %@", [connInfo objectForKey:@"identifier"]);
    
    NSError *error = [arr objectAtIndex:1];
    NSString *errorDescription = [error localizedDescription];
    
    //Modify error description if error is of type No Internet connection
   
    if(error.code == kCFURLErrorNotConnectedToInternet)
    {
        errorDescription = [errorDescription stringByAppendingString:[NSString stringWithFormat:@" %@", ERROR_NO_INTERNET_CONNECTION_RETRY]];
    }
    else
    {
        errorDescription = [errorDescription stringByAppendingString:[NSString stringWithFormat:@" %@", ERROR_UNKNOWN_PLEASE_RETRY]];
//        errorDescription = ERROR_UNKNOWN_PLEASE_RETRY;
    }
    
    CMConnectionCallback callBack = [callbacksMapping objectForKey:[connInfo objectForKey:@"identifier"]];
    if(callBack)
    {
        callBack(nil, [connInfo objectForKey:@"identifier"], errorDescription);
        [callbacksMapping removeObjectForKey:[connInfo objectForKey:@"identifier"]];
    }
    
    //Remove connection data which will exit the respective secondary thread
    [identiferFullData removeObjectForKey:[[arr objectAtIndex:0] description]];
}
#pragma mark -

@end
