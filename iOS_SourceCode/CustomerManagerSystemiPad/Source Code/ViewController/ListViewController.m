//
//  ListViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 17/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "ListViewController.h"
#import "Themes.h"
#import "AppDelegate.h"
#import "DatabaseManager.h"
#import "Constants.h"
#import "DataManager.h"
#import "JSONDataFlowManager.h"
#import "LOVData.h"
#import <QuartzCore/QuartzCore.h>

@interface ListViewController ()

@property(assign)NSUInteger selectedIndex;
@property(nonatomic,retain)NSIndexPath *selectedIndexPath;

-(void)createView;
@end

@implementation ListViewController

@synthesize listTableView,selectedIndex,listHeader,listOfItems,listType,selectedBuIndex,selectedTeamIndex;
@synthesize selectedValue;
@synthesize sections;
@synthesize selectedIndexPath;

#pragma mark - Initialization: View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil listData:(NSArray*)ItemsList listType:(NSString*)Type listHeader:(NSString *)Header withSelectedValue:(NSString *)selValue
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listHeader=Header;
        self.listType=Type;
        self.listOfItems=ItemsList;
        self.selectedValue = selValue;
        searchData = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)createView
{
    //List Table View
    //Added to display SearchBar for BU/Team and terriotary selection
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"searchForHOUser"]) {
        listTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width , 100) style:UITableViewStylePlain];
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        [self.searchController.searchBar sizeToFit];
    }
    else
        listTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width , self.view.frame.size.height) style:UITableViewStylePlain];
    [listTableView setBackgroundColor:[UIColor colorWithRed:211.0/255.0 green:224.0/255.0 blue:233.0/255.0 alpha:1.0]];
    //Set pop up list border
    listTableView.layer.borderWidth=0.5f;
    listTableView.layer.cornerRadius=10.0;
    //TODO : adjust correct color frame matching to CMS theme
    listTableView.layer.borderColor=THEME_COLOR.CGColor;
    [listTableView setBounces:YES];
    [listTableView setShowsVerticalScrollIndicator:YES];
    
    [self.view addSubview:listTableView];
    
    //added to display search for HO user only
    
    if ([defaults objectForKey:@"searchForHOUser"]) {
        listTableView.tableHeaderView = self.searchController.searchBar;
        self.definesPresentationContext = YES;
        [self.searchController.searchBar sizeToFit];
    }
    
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    if(([listType isEqualToString:CITY_KEY] && (self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])) || ([listType isEqualToString:STATE_KEY] && (self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])) || ([listType isEqualToString:PROF_DESGN_KEY] && (self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])) || ([listType isEqualToString:PRIMARY_SPECIALTY_KEY] && (self.listHeader!=nil  && ![self.listHeader isEqualToString:@""]))|| [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if ([[self.sections allKeys] count]>10) {
            [listTableView setFrame:CGRectMake(0, 0,230,  44*10)];
        }
        else
            [listTableView setFrame:CGRectMake(0, 0,230,  44*([[self.sections allKeys] count] ? 7 : 1))];
        
        typeAheadDataDict = [[NSDictionary alloc]initWithDictionary:self.sections];
    }
    else if([self.listOfItems count]<=7)
    {
        [listTableView setFrame:CGRectMake(0, 0,230, 44*[self.listOfItems count])];
    }
    else
    {
        [listTableView setFrame:CGRectMake(0, 0,230,  44*7)];
    }
    
    [self.view setBackgroundColor:[UIColor blueColor]]; //lightGrayColor
    [self.view setFrame:CGRectMake(0, 0, 230, listTableView.frame.size.height)];
    
    if([self.listType isEqualToString:CHANGE_TERRITORY] || [listType isEqualToString:REMOVE_CUSTOMER_REASONS_KEY])
    {
        CGRect tableViewFrame = listTableView.frame;
        tableViewFrame.size.width = 360;
        [listTableView setFrame:tableViewFrame];
        [self.view setFrame:CGRectMake(0, 0, listTableView.frame.size.width, listTableView.frame.size.height)];
    }
    else if ([self.listType isEqualToString:PROF_DESGN_KEY])
    {
        CGRect tableViewFrame = listTableView.frame;
        tableViewFrame.size.width = 300;
        [listTableView setFrame:tableViewFrame];
        [self.view setFrame:CGRectMake(0, 0, listTableView.frame.size.width, listTableView.frame.size.height)];
    }
    else if ([self.listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY])
    {
        CGRect tableViewFrame = listTableView.frame;
        tableViewFrame.size.width = 300;
        [listTableView setFrame:tableViewFrame];
        [self.view setFrame:CGRectMake(0, 0, listTableView.frame.size.width, listTableView.frame.size.height)];
    }
    else if ([listType isEqualToString:PRIMARY_SPECIALTY_KEY])
    {
        CGRect tableViewFrame = listTableView.frame;
        tableViewFrame.size.width = 400;
        [listTableView setFrame:tableViewFrame];
        [self.view setFrame:CGRectMake(0, 0, listTableView.frame.size.width, listTableView.frame.size.height)];
    }
    else if ([listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        CGRect tableViewFrame = listTableView.frame;
        tableViewFrame.size.width = 425;
        [listTableView setFrame:tableViewFrame];
        [self.view setFrame:CGRectMake(0, 0, listTableView.frame.size.width, listTableView.frame.size.height)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sections=[[NSMutableDictionary alloc]init];
    
    [self updateDataForTable];
    [self createView];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark Initialise LOV Data
-(void)setCitySectionList
{
    BOOL found;
    [sections removeAllObjects];
    // Loop through the cityies and create keys
    for (NSString *city in [[DatabaseManager sharedSingleton] fetchCityforState:self.listHeader])
    {
        NSString *c = [city substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:city];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        NSArray *cities = [[self.sections objectForKey:key]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.sections setObject:cities forKey:key];
    }
}

-(void)setStateSectionList
{
    BOOL found;
    [sections removeAllObjects];
    // Loop through the States and create keys
    for (NSString *state in [[DatabaseManager sharedSingleton] fetchStates])
    {
        NSString *c = [state substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:state];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        NSArray *states = [[self.sections objectForKey:key]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.sections setObject:states forKey:key];
    }
}

-(void)setProfDesiSectionList
{
    BOOL found;
    [sections removeAllObjects];
    // Loop through the Prof Designations and create keys
    for (NSString *profDesi in [[JSONDataFlowManager sharedInstance]profDesignValueArray])
    {
        NSString *c = [profDesi substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:profDesi];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        NSArray *profDesgn = [[self.sections objectForKey:key]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.sections setObject:profDesgn forKey:key];
    }
}

-(void)setTargetTypeSectionList
{
    [sections removeAllObjects];
    self.listOfItems = [[JSONDataFlowManager sharedInstance]TargetTypeNPRSValueArray];
}

-(void)setPrimarySpecialitySectionList
{
    BOOL found;
    [sections removeAllObjects];
    // Loop through the Pri. Specialtyies and create keys
    for (LOVData *primarySpeciality in [[JSONDataFlowManager sharedInstance] specilalityArray])
    {
        NSString *c = [primarySpeciality.code substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:primarySpeciality];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]]];
    }
}

-(void)setBUSectionList:(NSArray*)array
{
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSArray *buArray = [standardUserDefault objectForKey:@"hoBuNameDataArray"];
    
    NSMutableArray *typeAheadData = [[NSMutableArray alloc]init];
    if ((self.searchController.searchBar.text.length>0)) {
        if (array.count>0 && [[array objectAtIndex:0] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                for (id object in [array objectAtIndex:i]) {
                    if ([buArray containsObject:object]) {
                        [typeAheadData addObject:object];
                    }
                }
            }
        }
    }
    else
        typeAheadData = (NSMutableArray*)buArray;
    
    BOOL found;
    [sections removeAllObjects];
    // Loop through the States and create keys
    for (NSString *bu in (NSArray*)typeAheadData)
    {
        NSString *c = [bu substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:bu];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        NSArray *states = [[self.sections objectForKey:key]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.sections setObject:states forKey:key];
    }
}

-(void)setTeamSectionList:(NSArray*)array
{
    BOOL found;
    [sections removeAllObjects];
    
    // Loop through the States and create keys
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSArray *buArray = [standardUserDefault objectForKey:@"hoBuCodeDataArray"];
    NSDictionary *teamArray = [[standardUserDefault objectForKey:@"buTeamDataDict"] objectForKey:[buArray objectAtIndex:self.selectedBuIndex]];
    NSMutableArray *teamCodeNameArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[[teamArray objectForKey:@"teamName"] count]; i++) {
        [teamCodeNameArray addObject:[NSString stringWithFormat:@"%@-%@",[[teamArray objectForKey:@"teamId"] objectAtIndex:i],[[teamArray objectForKey:@"teamName"] objectAtIndex:i]]];
    }
    
    NSMutableArray *typeAheadData = [[NSMutableArray alloc]init];
    if ((self.searchController.searchBar.text.length>0)) {
        if (array.count>0 && [[array objectAtIndex:0] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                for (id object in [array objectAtIndex:i]) {
                    if ([teamCodeNameArray containsObject:object]) {
                        [typeAheadData addObject:object];
                    }
                }
            }
        }
    }
    else
        typeAheadData = (NSMutableArray*)teamCodeNameArray;

    for (NSString *bu in (NSArray*)typeAheadData)
    {
        NSString *c = [bu substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:bu];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        NSArray *states = [[self.sections objectForKey:key]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.sections setObject:states forKey:key];
    }
}

-(void)setTerriotarySectionList:(NSArray*)array
{
    BOOL found;
    [sections removeAllObjects];
    // Loop through the States and create keys
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    
    NSArray *buArray = [standardUserDefault objectForKey:@"hoBuCodeDataArray"];
    NSDictionary *teamArrayDict = [[standardUserDefault objectForKey:@"buTeamDataDict"] objectForKey:[buArray objectAtIndex:selectedBuIndex]];//will return the dictionary of Team array and Team code of selected bu.

    NSString *selectedTeamCode = [[teamArrayDict objectForKey:@"teamId"] objectAtIndex:selectedTeamIndex];
    [standardUserDefault setObject:selectedTeamCode forKey:@"selectedTeamCode"];
    
    NSDictionary *teArray = [standardUserDefault objectForKey:@"teamTerrDataDict"];//returns bu code array
    NSDictionary *tamArray = [teArray objectForKey:selectedTeamCode];//returns the team terriotary data dictionary
    [standardUserDefault setObject:tamArray forKey:@"selectedTeamTerrData"];
    [standardUserDefault setObject:[tamArray objectForKey:@"terrName"] forKey:@"selectedTerrDataArray"];
    
    NSMutableArray *typeAheadData = [[NSMutableArray alloc]init];
    if ((self.searchController.searchBar.text.length>0)) {
        if (array.count>0 && [[array objectAtIndex:0] isKindOfClass:[NSArray class]]) {
            for (int i=0; i<array.count; i++) {
                for (id object in [array objectAtIndex:i]) {
                    if ([[tamArray objectForKey:@"terrName"] containsObject:object]) {
                        [typeAheadData addObject:object];
                    }
                }
            }
        }
    }
    else
        typeAheadData = (NSMutableArray*)[tamArray objectForKey:@"terrName"];
    
    for (NSString *bu in (NSArray*)typeAheadData)
    {
        NSString *c = [bu substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        
        if([self.sections objectForKey:c])
            [[self.sections objectForKey:c] addObject:bu];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        NSArray *states = [[self.sections objectForKey:key]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.sections setObject:states forKey:key];
    }
}

-(void) updateDataForTable
{
    if([listType isEqualToString:CITY_KEY])
    {
        NSMutableArray * cityNameArray=[[NSMutableArray alloc]init];
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            [self setCitySectionList];
        }
        else
        {
            [cityNameArray addObject:PLEASE_SELECT_STATE];
        }
        
        if([[self.sections allKeys] count] == 0)
        {
            [cityNameArray addObject:ERROR_NO_CITY_FOUND];
        }
        
        self.listOfItems=[NSArray arrayWithArray:cityNameArray];
    }
    else if([listType isEqualToString:STATE_KEY])
    {
        NSMutableArray * stateNameArray=[[NSMutableArray alloc]init];
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            [self setStateSectionList];
        }
        else
        {
            [stateNameArray addObject:ERROR_NO_STATE_FOUND];
        }
        
        if([[self.sections allKeys] count] == 0)
        {
            [stateNameArray addObject:ERROR_NO_STATE_FOUND];
        }
        
        self.listOfItems=[NSArray arrayWithArray:stateNameArray];
    }
    else if([listType isEqualToString:BU_KEY])
    {
        NSMutableArray * buNameArray=[[NSMutableArray alloc]init];
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
            NSArray *buArray = [standardUserDefault objectForKey:@"hoBuNameDataArray"];

            [self setBUSectionList:buArray];
        }
        else
        {
            [buNameArray addObject:ERROR_NO_BU_FOUND];
        }
        
        if([[self.sections allKeys] count] == 0)
        {
            [buNameArray addObject:ERROR_NO_BU_FOUND];
        }
        
        self.listOfItems=[NSArray arrayWithArray:buNameArray];
    }
    else if([listType isEqualToString:TEAM_KEY])
    {
        NSMutableArray * buNameArray=[[NSMutableArray alloc]init];
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
            NSArray *buArray = [standardUserDefault objectForKey:@"hoBuCodeDataArray"];
            NSDictionary *teamArray = [[standardUserDefault objectForKey:@"buTeamDataDict"] objectForKey:[buArray objectAtIndex:self.selectedBuIndex]];
            NSMutableArray *teamCodeNameArray = [[NSMutableArray alloc]init];
            for (int i=0; i<[[teamArray objectForKey:@"teamName"] count]; i++) {
                [teamCodeNameArray addObject:[NSString stringWithFormat:@"%@-%@",[[teamArray objectForKey:@"teamId"] objectAtIndex:i],[[teamArray objectForKey:@"teamName"] objectAtIndex:i]]];
            }
            [self setTeamSectionList:(NSArray*)teamCodeNameArray];
        }
        else
        {
            [buNameArray addObject:ERROR_NO_TEAM_FOUND];
        }
        
        if([[self.sections allKeys] count] == 0)
        {
            [buNameArray addObject:ERROR_NO_TEAM_FOUND];
        }
        
        self.listOfItems=[NSArray arrayWithArray:buNameArray];
    }
    else if([listType isEqualToString:TERRIOTARY_KEY])
    {
        NSMutableArray * buNameArray=[[NSMutableArray alloc]init];
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
            
            NSArray *buArray = [standardUserDefault objectForKey:@"hoBuCodeDataArray"];
            NSDictionary *teamArrayDict = [[standardUserDefault objectForKey:@"buTeamDataDict"] objectForKey:[buArray objectAtIndex:selectedBuIndex]];//will return the dictionary of Team array and Team code of selected bu.
            
            NSString *selectedTeamCode = [[teamArrayDict objectForKey:@"teamId"] objectAtIndex:selectedTeamIndex];
            [standardUserDefault setObject:selectedTeamCode forKey:@"selectedTeamCode"];
            
            NSDictionary *teArray = [standardUserDefault objectForKey:@"teamTerrDataDict"];//returns bu code array
            NSDictionary *tamArray = [teArray objectForKey:selectedTeamCode];//returns the team terriotary data dictionary
            [standardUserDefault setObject:tamArray forKey:@"selectedTeamTerrData"];
            [standardUserDefault setObject:[tamArray objectForKey:@"terrName"] forKey:@"selectedTerrDataArray"];
            [self setTerriotarySectionList:[tamArray objectForKey:@"terrName"]];
        }
        else
        {
            [buNameArray addObject:ERROR_NO_TERR_FOUND];
        }
        
        if([[self.sections allKeys] count] == 0)
        {
            [buNameArray addObject:ERROR_NO_TERR_FOUND];
        }
        
        self.listOfItems=[NSArray arrayWithArray:buNameArray];
    }
    else if([listType isEqualToString:ORG_TYPE_KEY])
    {
        
        NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_ADD])
        {
            self.listOfItems = [[JSONDataFlowManager sharedInstance]OrgTypeArraySales];
        }
        else if([defaults objectForKey:@"SelectedRoleIncludedBpClassificationType"])
        {
            NSMutableArray *orgTypeArray = [[defaults objectForKey:@"SelectedRoleIncludedBpClassificationType"] mutableCopy];
            for (int i=0; i<orgTypeArray.count; i++)
            {
                NSString *orgType = [orgTypeArray objectAtIndex:i];
                
                if([[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] objectForKey:orgType])
                {
                    [orgTypeArray replaceObjectAtIndex:i withObject:[[[JSONDataFlowManager sharedInstance]OrgTypeKeyValue] objectForKey:orgType]];
                }
            }
            self.listOfItems = orgTypeArray;
        }
        else
        {
            self.listOfItems = [NSArray arrayWithObjects:ERROR_NO_SELECTION_AVAILABLE, nil];
        }
    }
    else if([listType isEqualToString:CHANGE_TERRITORY])
    {
        NSMutableArray* territoryArray=[[NSMutableArray alloc]init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
        for(NSString * terrId in [[loggedInUser objectForKey:@"TerritoriesAndRoles"] allKeys])
        {
            //Terr Id is key
            [territoryArray addObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TerritoryName"]];
        }
        for (int i = 0 ; i < territoryArray.count ; i ++) {
            for( int j = 0 ; j < territoryArray.count - 1 ; j++){
                if([[territoryArray objectAtIndex:j] length] > [[territoryArray objectAtIndex:j+1] length])
                    [territoryArray exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
        }
        if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
            territoryArray = [defaults objectForKey:@"selectedTerrDataArray"];
        }
        self.listOfItems=territoryArray ;
    }
    else if ([listType isEqualToString:PROF_DESGN_KEY])
    {
        [self setProfDesiSectionList];
    }
    else if ([listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY])
    {
        [self setTargetTypeSectionList];
    }
    else if ([listType isEqualToString:ADDRESS_USAGE_KEY])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if([[defaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_ADD])
        {
            self.listOfItems = [[JSONDataFlowManager sharedInstance]AddresUsageTypeArrayAdd];
        }
        else if([[defaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_SEARCH])
        {
            if([defaults objectForKey:@"SelectedRoleExcludedAddrUsgType"])
            {
                NSMutableArray *addressUsageTypeArray = [[[JSONDataFlowManager sharedInstance]addressUsageTypeArrayAll] mutableCopy];
                [addressUsageTypeArray removeObjectsInArray:[defaults objectForKey:@"SelectedRoleExcludedAddrUsgType"]];
                self.listOfItems = addressUsageTypeArray;
            }
            else
            {
                self.listOfItems = [[JSONDataFlowManager sharedInstance]addressUsageTypeArrayAll];
            }
        }
    }
    else if ([listType isEqualToString:REQUESTOR_KEY])
    {
        self.listOfItems = [[JSONDataFlowManager sharedInstance]requestorArray];
    }
    else if ([listType isEqualToString:PRIMARY_SPECIALTY_KEY])
    {
        [self setPrimarySpecialitySectionList];
    }
    else if ([listType isEqualToString:REQ_STAGE_KEY])
    {
        self.listOfItems = [[JSONDataFlowManager sharedInstance] requestStageArray];
    }
    else if([listType isEqualToString:REMOVE_CUSTOMER_REASONS_KEY])
    {
        NSMutableArray* removeCustomerReasonsArray=[[NSMutableArray alloc]init];
        [removeCustomerReasonsArray insertObject:@"Invalid Address" atIndex:0];
        [removeCustomerReasonsArray insertObject:@"Moved/Relocated" atIndex:1];
        [removeCustomerReasonsArray insertObject:@"Duplicate Address" atIndex:2];
        [removeCustomerReasonsArray insertObject:@"Address no Longer Active" atIndex:3];
        self.listOfItems=removeCustomerReasonsArray ;
    }
    
    
    //Select first item in Pop Over list of Items by Default.
    if([selectedValue isEqualToString:@""] || selectedValue ==nil)
    {
        if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY]||[listType isEqualToString:REMOVE_CUSTOMER_REASONS_KEY]||[listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] ||[listType isEqualToString:BU_KEY] ||[listType isEqualToString:TEAM_KEY] ||[listType isEqualToString:TERRIOTARY_KEY])
        {
            selectedIndexPath=[NSIndexPath indexPathForRow:-1 inSection:0];
            //selectedIndexPath=-1;
        }
        else
            selectedIndex=-1;
    }
    else
    {
        if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] ||[listType isEqualToString:BU_KEY] ||[listType isEqualToString:TEAM_KEY] ||[listType isEqualToString:TERRIOTARY_KEY])
        {
            NSArray *sectionKeys=[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            if([listType isEqualToString:PRIMARY_SPECIALTY_KEY])
            {
                for (int i=0; i<[sectionKeys count]; i++) {
                    NSString *str=[sectionKeys objectAtIndex:i];
                    for (int j=0; j<[[sections objectForKey:str] count]; j++) {
                        LOVData *data=[[sections objectForKey:str] objectAtIndex:j];
                        if([selectedValue isEqualToString:[NSString stringWithFormat:@"%@ - %@",data.code,data.description]])
                        {
                            selectedIndexPath=[NSIndexPath indexPathForRow:j inSection:i];
                            break;
                        }
                    }
                }
            }
            else
            {
                for (int i=0; i<[sectionKeys count]; i++) {
                    NSString *str=[sectionKeys objectAtIndex:i];
                    for (int j=0; j<[[sections objectForKey:str] count]; j++) {
                        if([selectedValue isEqualToString:[[sections objectForKey:str] objectAtIndex:j]])
                        {
                            selectedIndexPath=[NSIndexPath indexPathForRow:j inSection:i];
                            break;
                        }
                    }
                }
            }
        }
        
        else
        {
            for (int i=0; i<[self.listOfItems count]; i++) {
                if([selectedValue isEqualToString:[self.listOfItems objectAtIndex:i]])
                {
                    selectedIndex=i;
                    break;
                }
            }
        }
        
    }
}
#pragma mark -

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            DebugLog(@"LOV: %lu sections of type %@", (unsigned long)[[self.sections allKeys] count], self.listType);
            if([[self.sections allKeys] count])
            {
                return [[self.sections allKeys] count];
            }
            else
            {
                return 1;
            }
        }
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""] && [[self.sections allKeys] count])
            return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""] && [[self.sections allKeys] count])
            return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = 0;
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""] && [[self.sections allKeys] count])
        {
            rows = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
            return rows;
        }
    }
    return [self.listOfItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"List";
    
    UITableViewCell *cellTemp=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cellTemp == nil) {
        cellTemp = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cellTemp.tag=indexPath.row;
    cellTemp.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Two line label for territory if it goes beyond bounds
    if([self.listType isEqualToString:CHANGE_TERRITORY] || [self.listType isEqualToString:REMOVE_CUSTOMER_REASONS_KEY])
    {
        [cellTemp.textLabel setNumberOfLines:0];
        [cellTemp.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }
    
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""] && [[self.sections allKeys] count])
        {
            if([listType isEqualToString:PRIMARY_SPECIALTY_KEY])
            {
                LOVData *data=[[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                NSString *str=[NSString stringWithFormat:@"%@ - %@",data.code, data.description];
                [cellTemp.textLabel setText:str];
            }
            else
            {
                [cellTemp.textLabel setText:[[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
            }
        }
        else
        {
            [cellTemp.textLabel setText:[self.listOfItems objectAtIndex:indexPath.row]];
        }
    }
    else
        [cellTemp.textLabel setText:[self.listOfItems objectAtIndex:indexPath.row]];
    
    [cellTemp.textLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
    if(([listType isEqualToString:CITY_KEY] && [indexPath isEqual: selectedIndexPath]) || ([listType isEqualToString:STATE_KEY] && [indexPath isEqual: selectedIndexPath]) || ([listType isEqualToString:PROF_DESGN_KEY] && [indexPath isEqual:selectedIndexPath]) || ([listType isEqualToString:PRIMARY_SPECIALTY_KEY] && [indexPath isEqual:selectedIndexPath]) || ([listType isEqualToString:BU_KEY] && [indexPath isEqual: selectedIndexPath])|| ([listType isEqualToString:TEAM_KEY] && [indexPath isEqual: selectedIndexPath]) || ([listType isEqualToString:TERRIOTARY_KEY] && [indexPath isEqual: selectedIndexPath]))
        [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
    {
        if ((![listType isEqualToString:CITY_KEY] &&indexPath.row==selectedIndex) && (![listType isEqualToString:STATE_KEY] &&indexPath.row==selectedIndex) && (![listType isEqualToString:PROF_DESGN_KEY] &&indexPath.row==selectedIndex) && (![listType isEqualToString:PRIMARY_SPECIALTY_KEY] &&indexPath.row==selectedIndex) && (![listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] &&indexPath.row==selectedIndex) && (![listType isEqualToString:BU_KEY] &&indexPath.row==selectedIndex) && (![listType isEqualToString:TEAM_KEY] &&indexPath.row==selectedIndex)&& (![listType isEqualToString:TERRIOTARY_KEY] &&indexPath.row==selectedIndex)) {
            [cellTemp setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    //remove checkmark at the time of search for OnTrack
    if(self.searchController.searchBar.text.length>0)
    {
        [cellTemp setAccessoryType:UITableViewCellAccessoryNone];
    }
    cellTemp.textLabel.backgroundColor=[UIColor clearColor];
    //Set Normal Color Color
    UIView *bgColorNormalView = [[UIView alloc] init];
    [bgColorNormalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"list_popup.png"]]];
    [cellTemp setBackgroundView:bgColorNormalView];
    return cellTemp;
}
#pragma mark -

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *selectedItem;
    
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""] && [[self.sections allKeys] count])
        {
            if([listType isEqualToString:PRIMARY_SPECIALTY_KEY])
            {
                LOVData *data=[[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                selectedItem=[NSString stringWithFormat:@"%@ - %@",data.code, data.description];
            }
            else
            {
                selectedItem=[[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            }
        }
        else
        {
            selectedItem=[self.listOfItems objectAtIndex:indexPath.row];
        }
    }
    else
        selectedItem=[self.listOfItems objectAtIndex:indexPath.row];
    if ([listType isEqualToString:TERRIOTARY_KEY]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enableSelectButtonNotification" object:nil];
    }
    if(![selectedItem isEqualToString:PLEASE_SELECT_STATE] && ![selectedItem isEqualToString:PLEASE_SELECT_CITY_OR_STATE] && ![selectedItem isEqualToString:ERROR_NO_CITY_FOUND] && ![selectedItem isEqualToString:ERROR_NO_STATE_FOUND] && ![selectedItem isEqualToString:ERROR_NO_ZIP_FOUND] && ![selectedItem isEqualToString:ERROR_NO_SELECTION_AVAILABLE])
    {
        if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY]|| [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
            selectedIndexPath=indexPath;
        else
            self.selectedIndex=indexPath.row;
        
        if([listType isEqualToString:PRIMARY_SPECIALTY_KEY])
        {
            LOVData *data=[[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            NSString *str=[NSString stringWithFormat:@"%@ - %@",data.code, data.description];
            [self.delegate listSelectedValue:str listType:self.listType];
        }
        else
            [self.delegate listSelectedValue:selectedItem listType:self.listType];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""] && [[self.sections allKeys] count])
            return 22;
    }
    
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([listType isEqualToString:CITY_KEY] || [listType isEqualToString:STATE_KEY] || [listType isEqualToString:PROF_DESGN_KEY] || [listType isEqualToString:PRIMARY_SPECIALTY_KEY] || [listType isEqualToString:TARGET_SEARCH_INDV_TYPE_KEY] || [listType isEqualToString:BU_KEY] || [listType isEqualToString:TEAM_KEY] || [listType isEqualToString:TERRIOTARY_KEY])
    {
        if(self.listHeader!=nil  && ![self.listHeader isEqualToString:@""])
        {
            NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
            UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, 20)];
            [label setFont:[UIFont boldSystemFontOfSize:15]];
            [label setText:sectionTitle];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor whiteColor]];
            UIView *view = [[UIView alloc] init];
            [view addSubview:label];
            [view setBackgroundColor:[UIColor colorWithRed:0.5607 green:0.6156 blue:0.6627 alpha:1.0]];
            
            return view;
        }
    }
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    return view;
}

- (void)searchDisplayController:(NSString *)searchString
{
    [searchData removeAllObjects];
    NSMutableArray *group = [[NSMutableArray alloc]init];
    
    if (searchString.length>0)
        for(group in [typeAheadDataDict allValues])//type ahead always search from the complete data
        {
            NSMutableArray *newGroup = [[NSMutableArray alloc] init];
            NSString *element;
            
            for(element in group)
            {
                NSRange range = [element rangeOfString:searchString
                                               options:NSCaseInsensitiveSearch];
                
                if (range.length > 0) {
                    [newGroup addObject:element];
                }
            }
            
            if ([newGroup count] > 0) {
                [searchData addObject:newGroup];
            }
        }
    if([listType isEqualToString:BU_KEY])
        [self setBUSectionList:searchData];
    if([listType isEqualToString:TEAM_KEY])
        [self setTeamSectionList:searchData];
    if([listType isEqualToString:TERRIOTARY_KEY])
        [self setTerriotarySectionList:searchData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchDisplayController:searchString];
    [listTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
#pragma mark -

@end
