//
//  MapFulScreenViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 10/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "MapFullScreenViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Themes.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "Constants.h"
#import "DataManager.h"
#import "ErrroPopOverContentViewController.h"

//TODO: Uncomment when API_KEY for business license is received from ZS Team
//#ifdef PRODUCTION_BUILD
//#import <GoogleMapsM4B/GoogleMaps.h>
//#else
#import <GoogleMaps/GoogleMaps.h>
//#endif

@interface MapFullScreenViewController ()
{
    UIPopoverController *infoPopOver;
}

@property(nonatomic,retain)NSString * titleMap;
@property(nonatomic,retain)NSString * snippetMap;
@property(nonatomic,retain)NSString * latitudeMap;
@property(nonatomic,retain)NSString * longitudeMap;
@property(nonatomic,retain)NSString * addressMap;
@property(nonatomic,retain) UIView * mapMainView;
@property(nonatomic,retain)UIButton *changeTerritoryBtn;
@property(nonatomic,retain) UIPopoverController * listPopOverController;
@end

@implementation MapFullScreenViewController
@synthesize titleMap,snippetMap,latitudeMap,longitudeMap,addressMap,mapMainView,changeTerritoryBtn,listPopOverController;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self viewDidLoad];
    }
    return self;
}

-(void)setTitle:(NSString *)title withSnippet:(NSString *)snippet ofAddress:(NSString *)address
{
    self.titleMap=title;
    self.snippetMap=snippet;
    self.addressMap=address;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set Navigation Bar Themes
    self.navigationController.navigationBar.tintColor=THEME_COLOR;
    
    //Add 'About map' button for map view controller
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem *aboutMapsButton = [[UIBarButtonItem alloc] initWithTitle:ABOUT_MAPS_STRING style:UIBarButtonItemStyleBordered target:self action:@selector(showGoogleMapsAttributionText)];
    aboutMapsButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:aboutMapsButton];
    
    //Add title view to Navigation bar
    self.navigationItem.titleView=[Themes setNavigationBarNormal:SEARCH_CUSTOMERS_TAB_TITLE_STRING ofViewController:@"MapViewController"];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar. frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    [navBorder setBackgroundColor:THEME_COLOR];
    [self.navigationController.navigationBar addSubview:navBorder];

    [Themes refreshTerritory:self.navigationItem.titleView.subviews];
    
    //Add View to render map
    mapMainView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:mapMainView];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
    
    //Get Lattitude and Longitude for the address
    [self geoCodeUsingAddress:self.addressMap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Cancel connection for identifier 'Map' if still in progress and map view is being popped
    if(self.isMovingFromParentViewController && [ConnectionClass isConnectionInProgressForIdentifier:@"Map"])
    {
        [ConnectionClass cancelNSUrlConnectionForIdentifier:@"Map"];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

//Get GeoCode (lat / long)from address using google map API.
- (void) geoCodeUsingAddress:(NSString *)address
{
    //Add spineer
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    NSString *geocodeUrl = @"";
    
//TODO: Uncomment when API_KEY for business license is received from ZS Team
//#ifdef PRODUCTION_BUILD
//    NSString *unsignedGeocodeUrl = [[NSString stringWithFormat:@"%@address=%@&sensor=true&client=%@", GOOGLE_MAPS_GEOCODE_API_ABS_PATH, address, GOOGLE_MAPS_CLIENT_ID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    //add signature to url
//    NSString *signature = [Utilities getSignatureForUrl:unsignedGeocodeUrl usingPrivateKey:GOOGLE_MAPS_CRYPTO_KEY];
//    geocodeUrl = [NSString stringWithFormat:@"%@%@&signature=%@", GOOGLE_MAPS_API_DEMAIN, unsignedGeocodeUrl, signature];
//    
//    DebugLog(@"Geocode request with signature:%@", geocodeUrl);
//#else
    geocodeUrl = [[NSString stringWithFormat:@"%@%@sensor=true&address=%@", GOOGLE_MAPS_API_DEMAIN, GOOGLE_MAPS_GEOCODE_API_ABS_PATH, address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//#endif
    
    //Connection to geocode address information
    ConnectionClass * connection= [ConnectionClass sharedSingleton];
    [connection fetchDataFromUrl:geocodeUrl withParameters:nil forConnectionIdentifier:@"Map" andConnectionCallback:^(NSMutableData* data, NSString* identifier, NSString* error)
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
#pragma mark -

#pragma mark UI Actions
-(void)clickChangeTerritory
{
    //Retain selected state of button
    [changeTerritoryBtn setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:CHANGE_TERRITORY listHeader:CHANGE_TERRITORY withSelectedValue:[defaults objectForKey:@"SelectedTerritoryName"]];
    listViewController.delegate=self;
    listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
    listPopOverController.delegate=self;
    listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
    
    CGRect presentFromRect = [self.navigationItem.titleView convertRect:changeTerritoryBtn.frame toView:self.view];
    presentFromRect.origin.y -=5;
    [listPopOverController presentPopoverFromRect:presentFromRect inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
}

-(void)clickLogOut
{
 	AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	[appDelegate Logout];
}

-(void)showGoogleMapsAttributionText
{
    CGRect additionalInfoFrame = CGRectNull;
    additionalInfoFrame.origin.y = 44;
    NSString *attributionText = [GMSServices openSourceLicenseInfo];
    [self presentMoreInfoPopoverFromRect:additionalInfoFrame inView:self.view withMoreInfo:attributionText];
}

// Display BU/Team/Terr selection page on button click
-(void)loadBuTeamTerrSelectionView
{
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate displayHOUserHomePage];
}

#pragma mark -

#pragma mark Connection Data Handlers
-(void)receiveDataFromServer:(NSMutableData *)data ofCallIdentifier:(NSString*)identifier
{
    
    NSDictionary *jsonDataObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    DebugLog(@"Map  Class | Recieve Data - %@ | Identifier - %@",jsonDataObject ,identifier);
    if(jsonDataObject!=nil)
    {
        if([identifier isEqualToString:@"Map"])
        {
            NSArray *latLon=[Utilities parseJsonMapLatAndLon:jsonDataObject];
            if(latLon!=nil && [latLon count]>0)
            {
                self.latitudeMap= [NSString stringWithFormat:@"%@",[latLon objectAtIndex:0]];
                self.longitudeMap= [NSString stringWithFormat:@"%@",[latLon objectAtIndex:1]];
                
                DebugLog(@"Loading Map - Location - %@ , Snippet - %@ , Latitude - %@ , Longitude - %@",self.titleMap, self.snippetMap,self.latitudeMap,self.longitudeMap);
                // Do any additional setup after loading the view from its nib.
                // Add Map Of Location On View
                // Create a GMSCameraPosition that tells the map to display the coordinate
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitudeMap floatValue]                                               longitude:[longitudeMap floatValue] zoom:15];
                GMSMapView *mapView = [GMSMapView mapWithFrame:mapMainView.frame camera:camera];
                mapView.myLocationEnabled = YES;
                [mapMainView addSubview: mapView];
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([latitudeMap floatValue], [longitudeMap floatValue]);
                marker.title = titleMap;
                marker.snippet = snippetMap;
                marker.map = mapView;
            }
            else
            {
                //Unable to find Address
                [Utilities displayErrorAlertWithTitle:@"Map" andErrorMessage:@"Unable to locate address." withDelegate:self];
            }
        }
    }
    else
    {
        ErrorLog(@"Map: Data Recieved Null");
        [Utilities displayErrorAlertWithTitle:@"Map" andErrorMessage:@"Map cannot be loaded. Please ensure internet connectivity and try again later." withDelegate:self];
        
        NSString *error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ErrorLog(@"Map error:%@", error);
    }
    
    //Remove Spinner
    [Utilities removeSpinnerFromView:self.view];
}

-(void)failWithError:(NSString *)error ofCallIdentifier:(NSString*)identifier
{
    ErrorLog(@"Map Class | Connection Fail - %@ | Identifier - %@",error ,identifier);
    
    //Remove Spinner
    [Utilities removeSpinnerFromView:self.view];
    
    [Utilities displayErrorAlertWithTitle:@"Map" andErrorMessage:@"Map cannot be loaded. Please ensure internet connectivity and try again later." withDelegate:self];
}
#pragma mark -

#pragma mark Popover Controller Delegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [changeTerritoryBtn setSelected:NO];
}
#pragma mark -

#pragma mark List View Custom Delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    [listPopOverController dismissPopoverAnimated:YES];
    
    if([listType isEqualToString:CHANGE_TERRITORY])
    {
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
}
#pragma mark -

#pragma mark View Handlers
-(void)presentMoreInfoPopoverFromRect:(CGRect)presentFromRect inView:(UIView*)presentInView withMoreInfo:(NSString*)moreInfoString
{
    ErrroPopOverContentViewController *infoViewController=[[ErrroPopOverContentViewController alloc]initWithNibName:@"ErrroPopOverContentViewController" bundle:nil info:moreInfoString];
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*0.6, CGRectGetHeight(self.view.frame)*0.6);
    infoPopOver.backgroundColor = [UIColor blackColor];
    
    infoViewController.titleLabel.text = @"Google Maps: Open source licenses";
    infoViewController.midView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    if(CGRectIsNull(presentFromRect))   //Present UIpopover at center of View
    {
        presentFromRect  = CGRectMake(presentInView.center.x, presentInView.center.y-64, 1, 1);
        [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:0 animated:YES];
    }
    else    //Present UIpopover anchored to rect
    {
        [infoPopOver presentPopoverFromRect:presentFromRect inView:presentInView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}
#pragma mark -
@end
