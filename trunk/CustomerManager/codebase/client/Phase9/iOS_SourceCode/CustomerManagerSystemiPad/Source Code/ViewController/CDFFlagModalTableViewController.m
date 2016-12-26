//
//  CDFFlagModalTableViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 07/10/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import "CDFFlagModalTableViewController.h"
#import "DatabaseManager.h"
#import "CustomerObject.h"
#import "AddressObject.h"
#import "Constants.h"
#import "OrganizationObject.h"
#import "AppDelegate.h"
#import "CDFFlagModalTableViewCell.h"
#import "PopOverContentViewController.h"

@interface CDFFlagModalTableViewController ()
{
    CGFloat tableViewOffset;
    NSString *selectedRequestType;
    
    DatePickerViewController *datePickerViewController;
    NSIndexPath* checkedIndexPath;
    UIButton * detailButton ;
    CGRect frameInWindow;
}

@property(nonatomic,strong) UIPopoverController *listPopOverController;
@property(nonatomic,strong) UIPopoverController *datePickerPopoverController;
@property(nonatomic, assign) BOOL shouldPerformSearch;
@property(nonatomic,strong) UIView *tableFooterView;
@property(nonatomic,retain) UIPopoverController*  infoPopOver;


-(BOOL)shouldPerformSearchOperation;
-(void)initCustomerObjectWithDictionary:(NSMutableDictionary*)searchParametersDictionary;

@end

@implementation CDFFlagModalTableViewController
@synthesize customerDataDelegate;
@synthesize inputTableDataDict;
@synthesize sectionArray;
@synthesize rowArray;
@synthesize activeTextField;
@synthesize listPopOverController, datePickerPopoverController;
@synthesize shouldPerformSearch, isIndividual;
@synthesize callBackIdentifier;
@synthesize customerDataObject, orgDataObject, requestObject;
@synthesize searchParameters;
@synthesize tableFooterView;
@synthesize dataArray;
@synthesize popUpScreenTitle;
@synthesize isCellSelected;
@synthesize infoPopOver;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldPerformSearch = NO;
    self.searchParameters = [[NSMutableDictionary alloc] init];
    isCellSelected = 0;
    //dataArray = [[NSArray alloc] init];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Add footer note for table if applicable
    [self setCustomTableFooterView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)setCustomTableFooterView
{
    NSString *tableFooterText = [self.inputTableDataDict objectForKey:SPECIAL_FEATURE_FOOTER_TEXT];
    if([tableFooterText length] > 0)
    {
        UIFont *footerTextFont = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
//        CGSize footerSize = [tableFooterText sizeWithFont:footerTextFont constrainedToSize:CGSizeMake(770, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect textRect = [tableFooterText boundingRectWithSize:CGSizeMake(770, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:footerTextFont}
                                            context:nil];
        
        CGSize footerSize = textRect.size;
        
        CGRect footerViewFrame = CGRectMake(25, 0, 770, footerSize.height+20);
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:footerViewFrame];
        [footerLabel setTextAlignment:NSTextAlignmentLeft];
        [footerLabel setTextColor:[UIColor blackColor]];
        [footerLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
        [footerLabel setBackgroundColor:[UIColor clearColor]];
        [footerLabel setText:tableFooterText];
        [footerLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [footerLabel setNumberOfLines:4];
        self.tableFooterView = [[UIView alloc] initWithFrame:footerViewFrame];
        [self.tableFooterView setBackgroundColor:[UIColor clearColor]];
        [self.tableFooterView addSubview:footerLabel];
        [self.tableView setTableFooterView:self.tableFooterView];
    }
}
#pragma mark -

#pragma mark UIAction
-(void)searchButtonAction
{
    //Clear error message on table view container
    [self.customerDataDelegate displayErrorMessage:nil];
    
    //Save textField value which is currently being updated
    if(self.activeTextField != nil)
    {
        [self.activeTextField resignFirstResponder];
    }
    
    [self initCustomerObjectWithDictionary:self.inputTableDataDict];
    
    if([self shouldPerformSearchOperation])
    {
        //Add array with row sequence to search parameters dictionary
        NSMutableArray *searchFormFieldSequeceArray = [[NSMutableArray alloc] init];
        for (int section=0; section<self.rowArray.count; section++) {
            NSDictionary *sectionInfo = [NSDictionary dictionaryWithDictionary:[self.rowArray objectAtIndex:section]];
            for (NSString * key in [sectionInfo allKeys])
            {
                if([key isEqualToString:REQUESTOR_KEY] || [key isEqualToString:REQUEST_TYPE_KEY] || [key isEqualToString:REQ_STAGE_KEY])
                {
                    [searchFormFieldSequeceArray addObject:key];
                }
                else
                {
                    NSArray * arr=[sectionInfo objectForKey:key];
                    
                    for (int row=0; row<arr.count; row++) {
                        if([self.searchParameters.allKeys indexOfObject:[arr objectAtIndex:row]] != NSNotFound)
                        {
                            [searchFormFieldSequeceArray addObject:[arr objectAtIndex:row]];
                        }
                    }
                }
            }
        }
        [self.searchParameters setObject:searchFormFieldSequeceArray forKey:SEARCH_FORM_FIELDS_SEQUENCE];
        
        if(self.requestObject)
        {
            [self.customerDataDelegate processCustomerData:[NSArray arrayWithObjects:self.requestObject, nil] forIdentifier:callBackIdentifier];
        }
        else
        {
            if(self.isIndividual)   // Individual
            {
                [self.customerDataDelegate processCustomerData:[NSArray arrayWithObjects:self.customerDataObject, nil] forIdentifier:callBackIdentifier];
            }
            else // Organization
            {
                [self.customerDataDelegate processCustomerData:[NSArray arrayWithObjects:self.orgDataObject, nil] forIdentifier:callBackIdentifier];
            }}
    }
}

-(void)showInfo:(id)sender
{
    //Clear server response label
    detailButton = (UIButton*)sender;
    frameInWindow = [detailButton.superview convertRect:detailButton.frame toView:self.view];
    
    PopOverContentViewController *infoViewController;
    
    //INFO button is shown only if 25 search results are received
    infoViewController=[[PopOverContentViewController alloc]initWithNibName:@"PopOverContentViewController" bundle:nil infoText:[NSString stringWithFormat:@"%@", TOP_50_RESULTS_STRING]];
    
    
   
    infoViewController.infoTextDetails.frame = CGRectMake(infoViewController.infoText.frame.origin.x, infoViewController.infoText.frame.origin.y, infoViewController.infoTextDetails.frame.size.width, infoViewController.infoTextDetails.frame.size.height);
    
    infoPopOver=[[UIPopoverController alloc]initWithContentViewController:infoViewController];
    infoPopOver.popoverContentSize = CGSizeMake(200, 130);
    [infoPopOver presentPopoverFromRect:frameInWindow inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
  
    
    infoViewController.titleLabel.text = MD_DETAIL_INFO_POPUP_TITLE;
    NSDictionary *item = [dataArray objectAtIndex:indexPath.row];
    NSString * mdCDFFLagText = [item objectForKey:@"mdCDFFlag"];
    infoViewController.infoTextDetails.text = mdCDFFLagText;
    infoViewController.infoTextDetails.frame = CGRectMake(infoViewController.infoText.frame.origin.x, infoViewController.infoText.frame.origin.y, infoViewController.infoTextDetails.frame.size.width, infoViewController.infoTextDetails.frame.size.height + infoViewController.infoText.frame.size.height);
    infoViewController.infoText.hidden = YES;
    
    
    //[self clickRemoveCustomerAddress];
    
}



-(void)clearTextFieldButtonAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger section = button.tag/10;
    NSInteger row = button.tag%10;
    [self updateTableDataForKey:TEXTFIELD_VALUE withValue:nil forSection:section forRow:row];
    
    //Clear dependent field also
    NSArray *rowTitleArray = [[self.rowArray objectAtIndex:section] objectForKey:[self.sectionArray objectAtIndex:section]];
    NSString *str_cellTitle = [rowTitleArray objectAtIndex:row];
    
    if([str_cellTitle isEqualToString:STATE_KEY])
    {
        NSString *sectionKey = ([sectionArray containsObject:ADDRESS_KEY] ? ADDRESS_KEY : NEW_ADDRESS_KEY);
        
        //Clear City field
        NSIndexPath *indexPathForCity = [NSIndexPath indexPathForRow:[[[[rowArray objectAtIndex:[sectionArray indexOfObject:sectionKey]] allValues] objectAtIndex:0] indexOfObject:CITY_KEY] inSection:[sectionArray indexOfObject:sectionKey]];
        CDFFlagModalTableViewCell *cityCell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathForCity.row inSection:indexPathForCity.section]];
        
        [[cityCell cellTextField] setText:nil];
        //[cityCell.cellTextField setPlaceholder:PLEASE_SELECT_STATE];
        [cityCell setUserInteractionEnabled:NO];
        [self updateTableDataForKey:TEXTFIELD_VALUE withValue:nil forSection:indexPathForCity.section forRow:indexPathForCity.row];
        
        //Clear ZIP field
        NSIndexPath *indexPathForZip = [NSIndexPath indexPathForRow:[[[[rowArray objectAtIndex:[sectionArray indexOfObject:sectionKey]] allValues] objectAtIndex:0] indexOfObject:ZIP_KEY] inSection:[sectionArray indexOfObject:sectionKey]];
        CDFFlagModalTableViewCell *zipCell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathForZip.row inSection:indexPathForZip.section]];
        
        [[zipCell cellTextField] setText:nil];
        //[zipCell.cellTextField setPlaceholder:PLEASE_SELECT_STATE];
        [zipCell.cellTextField setEnabled:FALSE];
        [self updateTableDataForKey:TEXTFIELD_VALUE withValue:nil forSection:indexPathForZip.section forRow:indexPathForZip.row];
    }
    else if([str_cellTitle isEqualToString:PROF_DESGN_KEY])
    {
        NSString *sectionKey = ([sectionArray containsObject:PROFILE_KEY] ? PROFILE_KEY : OTHER_FIELDS_KEY);
        
        //Clear Individual Type field
        NSUInteger indexOfIndividualTypeCell = [[[[rowArray objectAtIndex:[sectionArray indexOfObject:sectionKey]] allValues] objectAtIndex:0] indexOfObject:INDV_TYPE_KEY];
        
        if(indexOfIndividualTypeCell != NSNotFound)
        {
            NSIndexPath *indexPathForIndvTypeCell = [NSIndexPath indexPathForRow:indexOfIndividualTypeCell inSection:[sectionArray indexOfObject:sectionKey]];
            CDFFlagModalTableViewCell *cell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathForIndvTypeCell.row inSection:indexPathForIndvTypeCell.section]];
            
            [[cell cellTextField] setText:nil];
            [self updateTableDataForKey:TEXTFIELD_VALUE withValue:nil forSection:indexPathForIndvTypeCell.section forRow:indexPathForIndvTypeCell.row];
        }
    }
}
#pragma mark -

#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //    return [self.sectionArray count];
    return 1;
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    // Return the title for section header
//    //    return  [self.sectionArray objectAtIndex:section];
//    //    return @"Duplicate addresses selected will be sent to CMEH for further analysis. They will not be removed automatically from your CTU";
//    //    return @"Current MD affiliations in your Business Unit";
//    //    return @"Search results";
//    if([popUpScreenTitle isEqualToString:MLP_SCREEN])
//        return @"Current MD affiliations in your business unit";
//    else
//        return @"Addresses marked as duplicate will only be sent to BMS Customer master for review. If present in your CTU they will not automatically be removed.";
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 90.0;
//}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionTitle = [self tableView:self.tableView titleForHeaderInSection:section];
//    
////    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(55, 0, 750, 40)];
////    [label setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
////    [label setText:sectionTitle];
////    label.numberOfLines = 0;
////    [label setBackgroundColor:[UIColor clearColor]];
////    [label setTextColor:THEME_COLOR];
//    
//    //UIView *view = [[UIView alloc] init];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    //[view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
////    [view addSubview:label];
//    
//    UILabel *bpaIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 25, 120, 20)];
//    [bpaIdLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
//    [bpaIdLabel setTextColor:[UIColor grayColor]];
//    [bpaIdLabel setText:[NSString stringWithFormat:PRODUCT_STRING]];
//    [bpaIdLabel setBackgroundColor:[UIColor clearColor]];
//    [view addSubview:bpaIdLabel];
//    
//    
//    //Add address Name
//    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(340,25, 335, 20)];
//    [addressLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
//    [addressLabel setTextColor:[UIColor grayColor]];
//    [addressLabel setText:[NSString stringWithFormat:MLP_STATUS_STRING]];
//    [addressLabel setBackgroundColor:[UIColor clearColor]];
//    [view addSubview:addressLabel];
//    return view;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    return  [[[self.rowArray objectAtIndex:section] objectForKey:[self.sectionArray objectAtIndex:section]] count];
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AddressSelected";
    
    
    CDFFlagModalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CDFFlagModalTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //Add Google Map Touch Event
    [cell.cellTitleLabel setText:@""];
    [cell.cellTitleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    [cell.cellTextField setText:@""];
    [cell.cellTextField setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    //[cell.cellTextField setPlaceholder:@""];
    [cell.cellTextField setEnabled:YES];
    [cell.cellTextField setTag:0];
    [cell.clearTextFieldButton setHidden:YES];
    [cell.clearTextFieldButton setTag:0];
    [cell.clearTextFieldButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setUserInteractionEnabled:YES];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    cell.tag=indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    
    NSDictionary *dictionary = dataArray[indexPath.row];
    cell.cellTitleLabel.text = [dictionary objectForKey:@"productName"];//@"Product1";
    cell.cellTextField.text = [dictionary objectForKey:@"mlpCDFFlag"];//@"Cannot detail - no restrictions apply";
    //cell.mdCDFlagString = [dictionary objectForKey:@"mdCDFFlag"];
    return cell;
    
}
#pragma mark -

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *rowTitleArray = [[self.rowArray objectAtIndex:indexPath.section] objectForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    NSString *str_cellTitle = [rowTitleArray objectAtIndex:indexPath.row];
    
    NSMutableDictionary *rowParameters = [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectForKey:str_cellTitle];
    
    //    if(checkedIndexPath)
    //    {
    //        UITableViewCell* uncheckCell = [tableView
    //                                        cellForRowAtIndexPath:checkedIndexPath];
    //        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    //    }
    CDFFlagModalTableViewCell *cell;
            //CustomModalTableViewCell * cell = (CustomModalTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
        cell = (CDFFlagModalTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
        
//        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            isCellSelected--;
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            isCellSelected++;
//        }
    
        //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //    checkedIndexPath = indexPath;
        
    
   
    if(!self.activeTextField)
    {
        //Fields with pre-defined list of values
        if([[rowParameters objectForKey:ACCESSORY] isEqual:[NSNumber numberWithInt:UITableViewCellAccessoryDisclosureIndicator]])
        {
            [self presentPopoverWithListOfValuesForTableCellAtIndex:indexPath];
        }
    }
    else
    {
        [self.activeTextField resignFirstResponder];
    }
    
    if([[rowParameters objectForKey:ACCESSORY] isEqual:[NSNumber numberWithInteger:UITableViewCellAccessoryCheckmark]])
    {
        //Traverse through section and unselect checkmarks if any
        for (int row = 0; row < [rowTitleArray count]; row++)
        {
            if([str_cellTitle isEqualToString:[rowTitleArray objectAtIndex:row]])
            {
                //Set checkmark for selected row
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [rowParameters setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_SELECTED] forKey:ACCESSORY_STATE_VALUE];
                
                //Save selected request type
                if([[self.sectionArray objectAtIndex:indexPath.section] isEqualToString:REQUEST_TYPE_KEY])
                {
                    selectedRequestType = str_cellTitle;
                }
            }
            else{
                
                    CDFFlagModalTableViewCell * cell = (CDFFlagModalTableViewCell*) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    NSMutableDictionary *rowParameters = [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectForKey:[rowTitleArray objectAtIndex:row]];
                    [rowParameters setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_UNSELECTED] forKey:ACCESSORY_STATE_VALUE];
                
            }
        }
    }
    
    [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPath.section]] setObject:rowParameters forKey:str_cellTitle];
//    if ([self.mlpDataDelegate respondsToSelector:@selector(callFlagScreen)]) {
//        [self.mlpDataDelegate callFlagScreen];
//    }
    
}
#pragma mark -

#pragma mark Table View Data Handlers
-(void)presentPopoverWithListOfValuesForTableCellAtIndex:(NSIndexPath*)indexPath
{
    NSArray *rowTitleArray = [[self.rowArray objectAtIndex:indexPath.section] objectForKey:[self.sectionArray objectAtIndex:indexPath.section]];
    NSString *str_cellTitle = [rowTitleArray objectAtIndex:indexPath.row];
    
    NSMutableDictionary *rowParameters = [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectForKey:str_cellTitle];
    
    //If not disclosure type field then return
    if(![[rowParameters objectForKey:ACCESSORY] isEqual:[NSNumber numberWithInt:UITableViewCellAccessoryDisclosureIndicator]])
        return;
    
    //Fields with pre-defined list of values
    if(![[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:REQ_CREATION_DATE_KEY])
    {
        NSString *listType = nil;
        NSString *listHeader = nil;
        NSString *selectedValue = [rowParameters objectForKey:TEXTFIELD_VALUE];
        
        if([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:STATE_KEY])
        {
            listType = STATE_KEY;
            listHeader = STATE_KEY;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:CITY_KEY])
        {
            //TODO: Need to find better way to extract the row values
            NSString *state = [[[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectForKey:STATE_KEY] objectForKey:TEXTFIELD_VALUE];
            
            listType = CITY_KEY;
            listHeader = [[DatabaseManager sharedSingleton] fetchStateIdforName:state];
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:ORG_TYPE_KEY])
        {
            listType = ORG_TYPE_KEY;
            listHeader = nil;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:PROF_DESGN_KEY])
        {
            listType = PROF_DESGN_KEY;
            listHeader = PROF_DESGN_KEY;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:ADDRESS_USAGE_KEY])
        {
            listType = ADDRESS_USAGE_KEY;
            listHeader = nil;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:INDV_TYPE_KEY])
        {
            listType = INDV_TYPE_KEY;
            listHeader = nil;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:REQUESTOR_KEY])
        {
            listType = REQUESTOR_KEY;
            listHeader = nil;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:PRIMARY_SPECIALTY_KEY])
        {
            listType = PRIMARY_SPECIALTY_KEY;
            listHeader = PRIMARY_SPECIALTY_KEY;
        }
        else if ([[rowTitleArray objectAtIndex:indexPath.row] isEqualToString:REQ_STAGE_KEY])
        {
            listType = REQ_STAGE_KEY;
            listHeader = nil;
        }
        
        ListViewController* listViewController=[[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil listData:nil listType:listType listHeader:listHeader withSelectedValue:selectedValue];
        listViewController.delegate=self;
        listPopOverController=[[UIPopoverController alloc]initWithContentViewController:listViewController];
        listPopOverController.popoverContentSize = CGSizeMake(listViewController.view.frame.size.width, listViewController.view.frame.size.height);
        CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
        cellRect.size.width -= listPopOverController.popoverContentSize.width+CGRectGetMinX(self.tableView.frame);
        [listPopOverController presentPopoverFromRect:cellRect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionLeft
                                             animated:YES];
    }
    else   //Creation date cell
    {
        datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        datePickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
        datePickerViewController.delegate = self;
        [datePickerViewController.dateLabel setText:[rowParameters objectForKey:TEXTFIELD_VALUE]];
        
        [datePickerPopoverController setPopoverContentSize:CGSizeMake(CGRectGetWidth(datePickerViewController.view.frame), CGRectGetHeight(datePickerViewController.view.frame))];
        CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
        cellRect.size.width -= datePickerPopoverController.popoverContentSize.width+CGRectGetMinX(self.tableView.frame);
        [datePickerPopoverController presentPopoverFromRect:cellRect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}

- (void) updateTableDataForKey:(NSString*)fieldKey withValue:(NSString*)value forSection:(NSInteger)section forRow:(NSInteger)row
{
    if(value==nil)
        value=@"";
    
    NSArray *rowTitleArray = [[self.rowArray objectAtIndex:section] objectForKey:[self.sectionArray objectAtIndex:section]];
    NSString *cellTitle = [rowTitleArray objectAtIndex:row];
    
    NSMutableDictionary *rowParam = [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:section]] objectForKey:cellTitle];
    
    [rowParam setObject:value forKey:fieldKey];
    
    if(value.length)
        [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:section]] setObject:rowParam forKey:cellTitle];
    
    //Code to Clear text field and also hide/unhide clearTextFieldButton as required
    //This code is added here because its a common method for all cases where textField needs to be cleared
    if([[rowParam objectForKey:ACCESSORY] isEqual:[NSNumber numberWithInt:UITableViewCellAccessoryDisclosureIndicator]])
    {
        //Hide or unhide clearTextFieldButton on tableViewCell
        CDFFlagModalTableViewCell *cell = (CDFFlagModalTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        [cell.cellTextField setText:value];
        
        //show clear button except for fields 'Stage of Request' and 'Requestor'
        //if(![cell.cellTitleLabel.text isEqualToString:REQUESTOR_KEY] && ![cell.cellTitleLabel.text isEqualToString:REQ_STAGE_KEY])
            //[cell.clearTextFieldButton setHidden:(value.length ? NO : YES)];
    }
}
#pragma mark -

#pragma mark Data Validation
-(void)initCustomerObjectWithDictionary:(NSMutableDictionary*)searchParametersDictionary
{
    //Clear search parameters
    [self.searchParameters removeAllObjects];
    
    //Initialize Object as per the requirement
    if([self.callBackIdentifier isEqualToString:@"RefineRequestSearchForIndividual"] || [self.callBackIdentifier isEqualToString:@"RefineRequestSearchForOrganization"])    //Requests Search
    {
        self.requestObject = [[RequestObject alloc] init];
        
        if(self.isIndividual)
        {
            self.requestObject.customerInfo = [[CustomerObject alloc] init];
        }
        else
        {
            self.requestObject.organizationInfo = [[OrganizationObject alloc] init];
        }
    }
    else    //Indv or Org search/add
    {
        if(self.isIndividual)   // Individual
        {
            self.customerDataObject = [[CustomerObject alloc] init];
        }
        else    // Organization
        {
            self.orgDataObject=[[OrganizationObject alloc]init];
        }
    }
    
    //Address section: read for all tabs i.e. add, remove and requests
    NSDictionary *addressSectionInfo = ([self.sectionArray containsObject:ADDRESS_KEY] ? [self.inputTableDataDict objectForKey:ADDRESS_KEY] : [self.inputTableDataDict objectForKey:NEW_ADDRESS_KEY]);
    
    if(addressSectionInfo)
    {
        AddressObject *address = [[AddressObject alloc] init];
        address.street = [[[addressSectionInfo objectForKey:STREET_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        address.building = [[[addressSectionInfo objectForKey:BUILDING_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        address.state = [[[addressSectionInfo objectForKey:STATE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        address.city = [[[addressSectionInfo objectForKey:CITY_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        address.zip = [[[addressSectionInfo objectForKey:ZIP_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        address.addr_usage_type=[[[addressSectionInfo objectForKey:ADDRESS_USAGE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        address.suite=[[[addressSectionInfo objectForKey:SUITE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(self.requestObject)  //Requests Search
        {
            if(self.isIndividual)
            {
                self.requestObject.customerInfo.custAddress = (NSMutableArray*)[NSArray arrayWithObject:address];
            }
            else
            {
                self.requestObject.organizationInfo.orgAddress = (NSMutableArray*)[NSArray arrayWithObject:address];
            }
        }
        else    //Indv or Org search/add
        {
            if(self.isIndividual)   // Individual
            {
                self.customerDataObject.custAddress = (NSMutableArray*)[NSArray arrayWithObject:address];
            }
            else // Organization
            {
                self.orgDataObject.orgAddress = (NSMutableArray*)[NSArray arrayWithObject:address];
            }
        }
        
        //Update search parameters dict
        if(address.street && address.street.length)
            [searchParameters setObject:address.street forKey:STREET_KEY];
        
        if(address.building && address.building.length)
            [searchParameters setObject:address.building forKey:BUILDING_KEY];
        
        if(address.suite && address.suite.length)
            [searchParameters setObject:address.suite forKey:SUITE_KEY];
        
        if(address.state && address.state.length)
            [searchParameters setObject:address.state forKey:STATE_KEY];
        
        if(address.city && address.city.length)
            [searchParameters setObject:address.city forKey:CITY_KEY];
        
        if(address.zip && address.zip.length)
            [searchParameters setObject:address.zip forKey:ZIP_KEY];
        
        if(address.addr_usage_type && address.addr_usage_type.length)
            [searchParameters setObject:address.addr_usage_type forKey:ADDRESS_USAGE_KEY];
    }
    
    //Name
    NSDictionary *nameSectionInfo = [self.inputTableDataDict objectForKey:NAME_KEY];
    if(nameSectionInfo)
    {
        if(self.isIndividual)   // Individual
        {
            self.customerDataObject.custFirstName = [[[nameSectionInfo objectForKey:FIRST_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custLastName = [[[nameSectionInfo objectForKey:LAST_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custMiddleName = [[[nameSectionInfo objectForKey:MIDDLE_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custSuffix = [[[nameSectionInfo objectForKey:SUFFIX_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Update search parameters dict
            if(self.customerDataObject.custFirstName && self.customerDataObject.custFirstName.length)
                [searchParameters setObject:self.customerDataObject.custFirstName forKey:FIRST_NAME_KEY];
            
            if(self.customerDataObject.custLastName && self.customerDataObject.custLastName.length)
                [searchParameters setObject:self.customerDataObject.custLastName forKey:LAST_NAME_KEY];
            
            if(self.customerDataObject.custMiddleName && self.customerDataObject.custMiddleName.length)
                [searchParameters setObject:self.customerDataObject.custMiddleName forKey:MIDDLE_NAME_KEY];
            
            if(self.customerDataObject.custSuffix && self.customerDataObject.custSuffix.length)
                [searchParameters setObject:self.customerDataObject.custSuffix forKey:SUFFIX_KEY];
        }
        else // Organization
        {
            self.orgDataObject.orgName = [[[nameSectionInfo objectForKey:ORG_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.orgDataObject.orgType = [[[nameSectionInfo objectForKey:ORG_TYPE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Update search parameters dict
            if(self.orgDataObject.orgName && self.orgDataObject.orgName.length)
                [searchParameters setObject:self.orgDataObject.orgName forKey:ORG_NAME_KEY];
            
            if(self.orgDataObject.orgType && self.orgDataObject.orgType.length)
                [searchParameters setObject:self.orgDataObject.orgType forKey:ORG_TYPE_KEY];
        }
    }
    
    //IDs
    NSDictionary *idsSectionInfo = [self.inputTableDataDict objectForKey:IDS_KEY];
    if(idsSectionInfo)
    {
        if(self.isIndividual)   // Individual
        {
            NSString *bpIdKey = ([[idsSectionInfo allKeys] containsObject:BPID_KEY] ? BPID_KEY : ORG_BPID_KEY);
            self.customerDataObject.custBPID = [[[idsSectionInfo objectForKey:bpIdKey] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custNPI = [[[idsSectionInfo objectForKey:NPI_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            //Update search parameters dict
            if(self.customerDataObject.custBPID && self.customerDataObject.custBPID.length)
                [searchParameters setObject:self.customerDataObject.custBPID forKey:BPID_KEY];
            
            if(self.customerDataObject.custNPI && self.customerDataObject.custNPI.length)
                [searchParameters setObject:self.customerDataObject.custNPI forKey:NPI_KEY];
        }
        else // organization
        {
            NSString *bpIdKey = ([[idsSectionInfo allKeys] containsObject:BPID_KEY] ? BPID_KEY : ORG_BPID_KEY);
            self.orgDataObject.orgBPID = [[[idsSectionInfo objectForKey:bpIdKey] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            //Update search parameters dict
            if(self.orgDataObject.orgBPID && self.orgDataObject.orgBPID.length)
                [searchParameters setObject:self.orgDataObject.orgBPID forKey:ORG_BPID_KEY];
        }
    }
    
    //Other fields
    NSDictionary *otherFieldsSectionInfo = [self.inputTableDataDict objectForKey:OTHER_FIELDS_KEY];
    if(otherFieldsSectionInfo)
    {
        if(self.isIndividual)
        {
            self.customerDataObject.custPrimarySpecialty = [[[otherFieldsSectionInfo objectForKey:PRIMARY_SPECIALTY_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custProfessionalDesignation = [[[otherFieldsSectionInfo objectForKey:PROF_DESGN_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custType = [[[otherFieldsSectionInfo objectForKey:INDV_TYPE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Update search parameters dict
            if(self.customerDataObject.custPrimarySpecialty && self.customerDataObject.custPrimarySpecialty.length)
                [searchParameters setObject:self.customerDataObject.custPrimarySpecialty forKey:PRIMARY_SPECIALTY_KEY];
            
            if(self.customerDataObject.custProfessionalDesignation && self.customerDataObject.custProfessionalDesignation.length)
                [searchParameters setObject:self.customerDataObject.custProfessionalDesignation forKey:PROF_DESGN_KEY];
            
            if(self.customerDataObject.custType && self.customerDataObject.custType.length)
                [searchParameters setObject:self.customerDataObject.custType forKey:INDV_TYPE_KEY];
        }
    }
    
    //Other profile
    NSDictionary *profileSectionInfo = [self.inputTableDataDict objectForKey:PROFILE_KEY];
    if(profileSectionInfo)
    {
        if(self.isIndividual)
        {
            self.customerDataObject.custProfessionalDesignation = [[[profileSectionInfo objectForKey:PROF_DESGN_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custType = [[[profileSectionInfo objectForKey:INDV_TYPE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.customerDataObject.custRepTargetValue = [[[profileSectionInfo objectForKey:REP_TARGET_VALUE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Update search parameters dict
            if(self.customerDataObject.custProfessionalDesignation && self.customerDataObject.custProfessionalDesignation.length)
                [searchParameters setObject:self.customerDataObject.custProfessionalDesignation forKey:PROF_DESGN_KEY];
            
            if(self.customerDataObject.custType && self.customerDataObject.custType.length)
                [searchParameters setObject:self.customerDataObject.custType forKey:INDV_TYPE_KEY];
            
            if(self.customerDataObject.custRepTargetValue && self.customerDataObject.custRepTargetValue.length)
                [searchParameters setObject:self.customerDataObject.custRepTargetValue forKey:REP_TARGET_VALUE_KEY];
        }
    }
    
    //Request tab
    
    //Stage of Request
    NSDictionary *stageOfRequestSectionInfo = [self.inputTableDataDict objectForKey:REQ_STAGE_KEY];
    if(stageOfRequestSectionInfo)
    {
        NSString *stageOfRequest = [[stageOfRequestSectionInfo objectForKey:REQ_STAGE_KEY] objectForKey:TEXTFIELD_VALUE];
        if(stageOfRequest && stageOfRequest.length)
        {
            self.requestObject.requestStage = stageOfRequest;
            [searchParameters setObject:stageOfRequest forKey:REQ_STAGE_KEY];
        }
    }
    
    //Search for
    NSDictionary *searchForSectionInfo = [self.inputTableDataDict objectForKey:SEARCH_FOR_KEY];
    if(searchForSectionInfo)
    {
        //Form Individual Customer object
        if(self.isIndividual)
        {
            self.requestObject.customerInfo.custFirstName = [[[searchForSectionInfo objectForKey:FIRST_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.requestObject.customerInfo.custLastName = [[[searchForSectionInfo objectForKey:LAST_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.requestObject.customerInfo.custBPID = [[[searchForSectionInfo objectForKey:BPID_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Update search parameters dict
            if(self.requestObject.customerInfo.custFirstName && self.requestObject.customerInfo.custFirstName.length)
                [searchParameters setObject:self.requestObject.customerInfo.custFirstName forKey:FIRST_NAME_KEY];
            
            if(self.requestObject.customerInfo.custLastName && self.requestObject.customerInfo.custLastName.length)
                [searchParameters setObject:self.requestObject.customerInfo.custLastName forKey:LAST_NAME_KEY];
            
            if(self.requestObject.customerInfo.custBPID && self.requestObject.customerInfo.custBPID)
                [searchParameters setObject:self.requestObject.customerInfo.custBPID forKey:BPID_KEY];
        }
        else    //Form Organization object
        {
            self.requestObject.organizationInfo.orgName = [[[searchForSectionInfo objectForKey:ORG_NAME_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.requestObject.organizationInfo.orgType = [[[searchForSectionInfo objectForKey:ORG_TYPE_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.requestObject.organizationInfo.orgBPID = [[[searchForSectionInfo objectForKey:ORG_BPID_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //Update search parameters dict
            if(self.requestObject.organizationInfo.orgName && self.requestObject.organizationInfo.orgName.length)
                [searchParameters setObject:self.requestObject.organizationInfo.orgName forKey:ORG_NAME_KEY];
            
            if(self.requestObject.organizationInfo.orgType && self.requestObject.organizationInfo.orgType.length)
                [searchParameters setObject:self.requestObject.organizationInfo.orgType forKey:ORG_TYPE_KEY];
            
            if(self.requestObject.organizationInfo.orgBPID && self.requestObject.organizationInfo.orgBPID)
                [searchParameters setObject:self.requestObject.organizationInfo.orgBPID forKey:ORG_BPID_KEY];
        }
        
        //Request ticket number
        self.requestObject.ticketNo = [[[searchForSectionInfo objectForKey:REQ_TICKET_NUMBER_KEY] objectForKey:TEXTFIELD_VALUE] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //Request creation date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:DATE_FORMATTER_STYLE];
        NSDate *selectedDate = [dateFormatter dateFromString:[[searchForSectionInfo objectForKey:REQ_CREATION_DATE_KEY] objectForKey:TEXTFIELD_VALUE]];
        
        //Change date to required format
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        self.requestObject.requestCreationDate = [dateFormatter stringFromDate:selectedDate];
        
        //Update search parameters dict
        if(self.requestObject.ticketNo && self.requestObject.ticketNo.length)
            [searchParameters setObject:self.requestObject.ticketNo forKey:REQ_TICKET_NUMBER_KEY];
        if([[searchForSectionInfo objectForKey:REQ_CREATION_DATE_KEY] objectForKey:TEXTFIELD_VALUE])
            [searchParameters setObject:[[searchForSectionInfo objectForKey:REQ_CREATION_DATE_KEY] objectForKey:TEXTFIELD_VALUE] forKey:REQ_CREATION_DATE_KEY];
    }
    
    //Requestor section
    NSDictionary *requestorSection = [self.inputTableDataDict objectForKey:REQUESTOR_KEY];
    if(requestorSection)
    {
        
        self.requestObject.requesterType = [[[JSONDataFlowManager sharedInstance]requesterKeyValues] objectForKey:[[requestorSection objectForKey:REQUESTOR_KEY] objectForKey:TEXTFIELD_VALUE]];
        
        //Update search parameters dict
        [searchParameters setObject:[[requestorSection objectForKey:REQUESTOR_KEY] objectForKey:TEXTFIELD_VALUE] forKey:REQUESTOR_KEY];
    }
    
    //Request Type section
    NSDictionary *requestTypeSection = [self.inputTableDataDict objectForKey:REQUEST_TYPE_KEY];
    if(requestTypeSection)
    {
        //Set request type
        self.requestObject.requestType = [[[JSONDataFlowManager sharedInstance]requestTypeKeyValues] objectForKey:selectedRequestType];
        
        //Update search parameters dict
        if(selectedRequestType.length)
            [searchParameters setObject:selectedRequestType forKey:REQUEST_TYPE_KEY];
    }
}

//TODO: optimize validation logic
//Validation Priority: Required Field validation -> Min characters validation -> Any Special validation
-(BOOL)shouldPerformSearchOperation
{
    self.shouldPerformSearch = YES;
    
    //****
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_SEARCH])
    {
        //Check for any other field other than state
        if([self.sectionArray containsObject:ADDRESS_KEY] || [self.sectionArray containsObject:NEW_ADDRESS_KEY])
        {
            if(self.searchParameters.count==0)
            {
                [self.customerDataDelegate displayErrorMessage:ERROR_SEARCH_FORM_NO_FIELD_ENTERED];  //Ref: R-SCO-0022
                return NO;
            }
            else if(self.searchParameters.count==1)
            {
                if([self.searchParameters objectForKey:STATE_KEY])
                {
                    [self.customerDataDelegate displayErrorMessage:ERROR_SEARCH_FORM_ONLY_STATE_IS_ENTERED];  //Ref: R-SCO-0022
                    return NO;
                }
            }
        }
    }
    //****
    
    NSString *errorMessage = @"";
    NSCharacterSet *alphabet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *decimalCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *alphaNumericSet = [NSCharacterSet alphanumericCharacterSet];
    
    //Name
    if([self.sectionArray containsObject:NAME_KEY])
    {
        BOOL isRequiredFieldPresent = TRUE;
        BOOL isFieldValidForMinCharLimit = TRUE;
        
        errorMessage = @"";
        NSDictionary *nameSectionInfo = [self.inputTableDataDict objectForKey:NAME_KEY];
        
        if(self.isIndividual)   // Individual
        {
            NSString *firstName = self.customerDataObject.custFirstName;
            NSString *lastName = self.customerDataObject.custLastName;
            NSString *middleName = self.customerDataObject.custMiddleName;
            NSString *suffix = self.customerDataObject.custSuffix;
            
            //Validation: required fields validation
            if([[nameSectionInfo objectForKey:REQUIRED_SECTION] boolValue] && ([firstName length] == 0 || [lastName length] == 0))
            {
                if([firstName length] == 0 && [[[nameSectionInfo objectForKey:FIRST_NAME_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
                {
                    isRequiredFieldPresent = FALSE;
                }
                
                if([lastName length] == 0 && [[[nameSectionInfo objectForKey:LAST_NAME_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
                {
                    isRequiredFieldPresent = FALSE;
                }
                
                if(isRequiredFieldPresent == FALSE)
                {
                    errorMessage = ERROR_PROVIDE_ALL_REQUIRED_FIELDS;
                }
            }
            
            //validation: at least 2 characters
            if(isRequiredFieldPresent)
            {
                //Maintain check order
                
                NSString *fields = @"";
                if(firstName.length && firstName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
                {
                    fields = [fields stringByAppendingString:[NSString stringWithFormat:@"%@", FIRST_NAME_KEY]];
                    isFieldValidForMinCharLimit = FALSE;
                }
                
                /*
                 if(middleName.length && middleName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
                 {
                 fields = [fields stringByAppendingString:(fields.length ? [NSString stringWithFormat:@", %@", MIDDLE_NAME_KEY] : [NSString stringWithFormat:@"%@", MIDDLE_NAME_KEY])];
                 isFieldValidForMinCharLimit = FALSE;
                 }*/
                
                if(lastName.length && lastName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
                {
                    fields = [fields stringByAppendingString:(fields.length ? [NSString stringWithFormat:@" and %@", LAST_NAME_KEY] : [NSString stringWithFormat:@"%@", LAST_NAME_KEY])];
                    isFieldValidForMinCharLimit = FALSE;
                }
                
                if(!isFieldValidForMinCharLimit)
                {
                    errorMessage =[NSString stringWithFormat:@"%@ %@.  ", ERROR_PLEASE_PROVIDE_AT_LEAST_2_LETTERS, fields];
                }
            }
            
            //Validation: Numbers and special characters are not allowed
            if(isRequiredFieldPresent && isFieldValidForMinCharLimit)
            {
                if([suffix length])
                {
                    NSString *validSuffix = [suffix stringByReplacingOccurrencesOfString:@" " withString:@""];
                    validSuffix = [validSuffix stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    validSuffix = [validSuffix stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    if(validSuffix.length && ![alphaNumericSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validSuffix]])
                    {
                        errorMessage = [NSString stringWithFormat:@"%@", ERROR_SUFFIX_IS_ALPHA_NUMERIC];
                    }
                }
                
                if([firstName length])
                {
                    NSString *validFname = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    validFname = [validFname stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    if(validFname.length && ![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validFname]])
                    {
                        errorMessage = ERROR_ENTER_ONLY_LETTERS;
                    }
                }
                
                if([lastName length])
                {
                    NSString *validLname = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    validLname = [validLname stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    if(validLname.length && ![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validLname]])
                    {
                        errorMessage = ERROR_ENTER_ONLY_LETTERS;
                    }
                }
                
                if([middleName length])
                {
                    NSString *validMname = [middleName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    validMname = [validMname stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    if(validMname.length && ![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validMname]])
                    {
                        errorMessage = ERROR_ENTER_ONLY_LETTERS;
                    }
                }
            }
        }
        else    // Organization
        {
            NSString *orgName = self.orgDataObject.orgName;
            NSString *orgType = self.orgDataObject.orgType;
            
            //Validation: Required field validation
            if([[nameSectionInfo objectForKey:REQUIRED_SECTION] boolValue] && ([orgName length] == 0 || [orgType length] == 0))
            {
                if([orgName length] == 0 && [[[nameSectionInfo objectForKey:ORG_NAME_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
                {
                    isRequiredFieldPresent = FALSE;
                }
                
                if([orgType length] == 0 && [[[nameSectionInfo objectForKey:ORG_TYPE_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
                {
                    isRequiredFieldPresent = FALSE;
                }
                
                if(isRequiredFieldPresent == FALSE)
                {
                    errorMessage = ERROR_PROVIDE_ALL_REQUIRED_FIELDS;
                }
            }
            
            //validation: at least 2 characters
            if(isRequiredFieldPresent)
            {
                //Maintain check order
                
                if(orgName.length && orgName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
                {
                    errorMessage =[NSString stringWithFormat:@"%@ %@.  ", ERROR_PLEASE_PROVIDE_AT_LEAST_2_LETTERS, ORG_NAME_KEY];
                    isFieldValidForMinCharLimit = FALSE;
                }
            }
            
            if(isRequiredFieldPresent && isFieldValidForMinCharLimit)
            {
                NSString *validOrgName = [orgName stringByReplacingOccurrencesOfString:@" " withString:@""];
                validOrgName = [validOrgName stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                if(validOrgName.length && ![alphaNumericSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validOrgName]])
                {
                    //errorMessage = @"Please enter only letters. No numbers or special characters.  ";
                    errorMessage = [NSString stringWithFormat:@"%@ %@", ORG_NAME_KEY, ERROR_CONTAINS_ONLY_LETTERS_NUMBERS_SPACE_AND_DASH];
                }
            }
        }
        
        //Add IDs validation error message to data structure
        if([errorMessage length]>0)
        {
            self.shouldPerformSearch = NO;
        }
        
        [[self.inputTableDataDict objectForKey:NAME_KEY] setObject:errorMessage forKey:SEARCH_PARAMETER_VALIDATION];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.sectionArray indexOfObject:NAME_KEY]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //Profile
    if([self.sectionArray containsObject:PROFILE_KEY])
    {
        errorMessage = @"";
        NSDictionary *profileSectionInfo = [self.inputTableDataDict objectForKey:PROFILE_KEY];
        
        if(self.isIndividual)   // Individual
        {
            NSString *profDesgn = self.customerDataObject.custProfessionalDesignation;
            NSString *indvType = self.customerDataObject.custType;
            
            //Validation: required field validation
            if([[profileSectionInfo objectForKey:REQUIRED_SECTION] boolValue] && ([profDesgn length] == 0 || [indvType length] == 0))
            {
                if([profDesgn length]==0 && [[[profileSectionInfo objectForKey:PROF_DESGN_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
                {
                    errorMessage = ERROR_PROVIDE_ALL_REQUIRED_FIELDS;
                }
                
                if([indvType length]==0 && [[[profileSectionInfo objectForKey:INDV_TYPE_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
                {
                    errorMessage = ERROR_PROVIDE_ALL_REQUIRED_FIELDS;
                }
            }
        }
        
        //Add IDs validation error message to data structure
        if([errorMessage length]>0)
        {
            self.shouldPerformSearch = NO;
        }
        
        [[self.inputTableDataDict objectForKey:PROFILE_KEY] setObject:errorMessage forKey:SEARCH_PARAMETER_VALIDATION];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.sectionArray indexOfObject:PROFILE_KEY]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //Address validation:
    NSString *sectionTitle = ([self.sectionArray containsObject:ADDRESS_KEY] ? ADDRESS_KEY : NEW_ADDRESS_KEY);
    NSDictionary *addressSectionInfo = [self.inputTableDataDict objectForKey:sectionTitle];
    
    if(addressSectionInfo)
    {
        BOOL isRequiredFieldPresent = TRUE;
        BOOL isFieldValidForMinCharLimit = TRUE;
        
        errorMessage = @"";
        
        //Required fields - State
        AddressObject *address;
        
        if (self.requestObject)
        {
            if(self.isIndividual)
            {
                address = [self.requestObject.customerInfo.custAddress objectAtIndex:0];
            }
            else
            {
                address = [self.requestObject.organizationInfo.orgAddress objectAtIndex:0];
            }
        }
        else
        {
            if(self.isIndividual)   // Individual
            {
                address = [self.customerDataObject.custAddress objectAtIndex:0];
            }
            else    // Organization
            {
                address = [self.orgDataObject.orgAddress objectAtIndex:0];
            }
        }
        
        NSString *street = address.street;
        NSString *building = address.building;
        NSString *state = address.state;
        NSString *city = address.city;
        NSString *zipId = address.zip;
        NSString *suite = address.suite;
        
        //Validation: required field validation
        if([[addressSectionInfo objectForKey:REQUIRED_SECTION] boolValue])
        {
            if([street length] == 0 && [[[addressSectionInfo objectForKey:STREET_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
            {
                isRequiredFieldPresent = FALSE;
            }
            
            if([building length] == 0 && [[[addressSectionInfo objectForKey:BUILDING_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
            {
                isRequiredFieldPresent = FALSE;
            }
            
            if([state length] == 0 && [[[addressSectionInfo objectForKey:STATE_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
            {
                isRequiredFieldPresent = FALSE;
            }
            
            if([city length] == 0 && [[[addressSectionInfo objectForKey:CITY_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
            {
                isRequiredFieldPresent = FALSE;
            }
            
            if([zipId length] == 0 && [[[addressSectionInfo objectForKey:ZIP_KEY] objectForKey:REQUIRED_TEXTFIELD] boolValue])
            {
                isRequiredFieldPresent = FALSE;
            }
            
            if(isRequiredFieldPresent == FALSE)
            {
                errorMessage = ERROR_PROVIDE_ALL_REQUIRED_FIELDS;
            }
        }
        
        //validation: at least 2 characters
        if(isRequiredFieldPresent)
        {
            NSString *fields = @"";
            
            //Maintain check order
            if(street.length && street.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                fields = [fields stringByAppendingString:[NSString stringWithFormat:@"%@", STREET_KEY]];
                isFieldValidForMinCharLimit = FALSE;
            }
            
            if(!isFieldValidForMinCharLimit)
            {
                errorMessage =[NSString stringWithFormat:@"%@ %@.  ", ERROR_PLEASE_PROVIDE_AT_LEAST_2_LETTERS, fields];
            }
        }
        
        //validation ZIP: 5 digit number
        if(isRequiredFieldPresent && isFieldValidForMinCharLimit)
        {
            if([zipId length] !=0)
            {
                NSCharacterSet *zipIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:zipId];
                if(![decimalCharacterSet isSupersetOfSet:zipIdCharacterSet])
                {
                    errorMessage = ERROR_ZIP_IS_NUMERIC;
                }
                else if ([zipId length]<5 || [zipId length]>5)
                {
                    errorMessage = ERROR_ZIP_MUST_CONTAIN_5_DIGITS;
                }
                else if(![[DatabaseManager sharedSingleton]isZipExists:zipId inState:[[DatabaseManager sharedSingleton] fetchStateIdforName:state] andCity:[[DatabaseManager sharedSingleton] fetchCityIdforName:city]])
                {
                    errorMessage = ERROR_PROVIDE_VALID_ZIP;
                }
            }
            
            if(suite.length && ![alphaNumericSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:suite]])
            {
                errorMessage = [NSString stringWithFormat:@"%@ %@", SUITE_KEY, ERROR_CONTAINS_ONLY_LETTERS_AND_NUMBERS];
            }
            
            if(building.length && ![alphaNumericSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:building]])
            {
                errorMessage = [NSString stringWithFormat:@"%@ %@", BUILDING_KEY, ERROR_CONTAINS_ONLY_LETTERS_AND_NUMBERS];
            }
            
            //Address line 1
            NSString *validStreet = [street stringByReplacingOccurrencesOfString:@" " withString:@""];
            validStreet = [validStreet stringByReplacingOccurrencesOfString:@"-" withString:@""];
            validStreet = [validStreet stringByReplacingOccurrencesOfString:@"&" withString:@""];
            
            if(validStreet.length && ![alphaNumericSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validStreet]])
            {
                errorMessage = [NSString stringWithFormat:@"%@", ERROR_ADDRESS_LINE_1_CONTAINS_LETTERS_NUMBERS_SPACE_DASH_AMPERSAND];
            }
        }
        
        //Add address validation error message to data structure
        if([errorMessage length]>0)
        {
            self.shouldPerformSearch = NO;
        }
        
        [[self.inputTableDataDict objectForKey:sectionTitle] setObject:errorMessage forKey:SEARCH_PARAMETER_VALIDATION];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.sectionArray indexOfObject:sectionTitle]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //IDs validation: Ids should be numeric
    if([self.sectionArray containsObject:IDS_KEY])
    {
        errorMessage = @"";
        
        if(self.isIndividual) // Individual
        {
            NSString *bpId = self.customerDataObject.custBPID;
            NSString *npId = self.customerDataObject.custNPI;
            
            //Validation: Characters and special characters are not allowed
            if([bpId length])
            {
                NSCharacterSet *bpIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:bpId];
                if(![decimalCharacterSet isSupersetOfSet:bpIdCharacterSet])
                {
                    errorMessage = ERROR_ALL_IDS_ARE_NUMERIC;
                }
            }
            
            if([npId length])
            {
                NSCharacterSet *npIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:npId];
                if(![decimalCharacterSet isSupersetOfSet:npIdCharacterSet])
                {
                    errorMessage = ERROR_ALL_IDS_ARE_NUMERIC;
                }
            }
        }
        else    // Organization
        {
            NSString *orgBpId = self.orgDataObject.orgBPID;
            
            //Validation: Characters and special characters are not allowed
            if([orgBpId length])
            {
                NSCharacterSet *bpIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:orgBpId];
                if(![decimalCharacterSet isSupersetOfSet:bpIdCharacterSet])
                {
                    errorMessage = ERROR_ALL_IDS_ARE_NUMERIC;
                }
            }
        }
        //Add IDs validation error message to data structure
        if([errorMessage length]>0)
        {
            self.shouldPerformSearch = NO;
        }
        
        [[self.inputTableDataDict objectForKey:IDS_KEY] setObject:errorMessage forKey:SEARCH_PARAMETER_VALIDATION];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.sectionArray indexOfObject:IDS_KEY]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //Search for section
    if([self.sectionArray containsObject:SEARCH_FOR_KEY])
    {
        BOOL isFieldValidForMinCharLimit = TRUE;
        errorMessage = @"";
        
        NSString *ticketNumber = self.requestObject.ticketNo;
        
        if(self.isIndividual)   // Individual
        {
            NSString *firstName = self.requestObject.customerInfo.custFirstName;
            NSString *lastName = self.requestObject.customerInfo.custLastName;
            NSString *bpId = self.requestObject.customerInfo.custBPID;
            
            //validation: at least 2 characters
            //Maintain check order
            
            NSString *fields = @"";
            if(firstName.length && firstName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                fields = [fields stringByAppendingString:[NSString stringWithFormat:@"%@", FIRST_NAME_KEY]];
                isFieldValidForMinCharLimit = FALSE;
            }
            
            if(lastName.length && lastName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                fields = [fields stringByAppendingString:(fields.length ? [NSString stringWithFormat:@" and %@", LAST_NAME_KEY] : [NSString stringWithFormat:@"%@", LAST_NAME_KEY])];
                isFieldValidForMinCharLimit = FALSE;
            }
            
            if(!isFieldValidForMinCharLimit)
            {
                errorMessage =[NSString stringWithFormat:@"%@ %@.  ", ERROR_PLEASE_PROVIDE_AT_LEAST_2_LETTERS, fields];
            }
            
            //Names Validation :Numbers and special characters are not allowed
            //ID Validation:Characters and special characters are not allowed
            if(isFieldValidForMinCharLimit)
            {
                if([firstName length])
                {
                    if(![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:[firstName stringByReplacingOccurrencesOfString:@" " withString:@""]]])
                    {
                        errorMessage = ERROR_ENTER_ONLY_LETTERS;
                    }
                }
                
                if([lastName length])
                {
                    if(![alphabet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:[lastName stringByReplacingOccurrencesOfString:@" " withString:@""]]])
                    {
                        errorMessage = ERROR_ENTER_ONLY_LETTERS;
                    }
                }
                
                //Show BP ID validation error only if Names are valid(due to space constraint)
                if([bpId length] && errorMessage.length==0)
                {
                    NSCharacterSet *bpIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:bpId];
                    if(![decimalCharacterSet isSupersetOfSet:bpIdCharacterSet])
                    {
                        errorMessage = ERROR_ALL_IDS_ARE_NUMERIC;
                    }
                }
            }
        }
        else    // Organization
        {
            NSString *orgName = self.requestObject.organizationInfo.orgName;
            NSString *orgBpId   = self.requestObject.organizationInfo.orgBPID;
            
            //validation: at least 2 characters
            //Maintain check order
            if(orgName.length && orgName.length<TEXT_INPUT_MIN_CHAR_LIMIT)
            {
                errorMessage =[NSString stringWithFormat:@"%@ %@.  ", ERROR_PLEASE_PROVIDE_AT_LEAST_2_LETTERS, ORG_NAME_KEY];
                isFieldValidForMinCharLimit = FALSE;
            }
            
            if(isFieldValidForMinCharLimit)
            {
                if([orgBpId length])
                {
                    NSCharacterSet *orgBpIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:orgBpId];
                    if(![decimalCharacterSet isSupersetOfSet:orgBpIdCharacterSet])
                    {
                        errorMessage = ERROR_ALL_IDS_ARE_NUMERIC;
                    }
                }
                
                if([orgName length])
                {
                    NSString *validOrgName = [orgName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    validOrgName = [validOrgName stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    if(validOrgName.length && ![alphaNumericSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:validOrgName]])
                    {
                        //errorMessage = @"Please enter only letters. No numbers or special characters.  ";
                        errorMessage = [NSString stringWithFormat:@"%@ %@", ORG_NAME_KEY, ERROR_CONTAINS_ONLY_LETTERS_NUMBERS_SPACE_AND_DASH];
                    }
                }
            }
        }
        
        //Validate Ticket Number field
        if([ticketNumber length] && errorMessage.length==0)
        {
            NSCharacterSet *bpIdCharacterSet = [NSCharacterSet characterSetWithCharactersInString:ticketNumber];
            if(![decimalCharacterSet isSupersetOfSet:bpIdCharacterSet])
            {
                errorMessage = ERROR_TICKET_NUMBER_IS_NUMERIC;
            }
        }
        
        //Add IDs validation error message to data structure
        if([errorMessage length]>0)
        {
            self.shouldPerformSearch = NO;
        }
        
        [[self.inputTableDataDict objectForKey:SEARCH_FOR_KEY] setObject:errorMessage forKey:SEARCH_PARAMETER_VALIDATION];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.sectionArray indexOfObject:SEARCH_FOR_KEY]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //To avoid frame change of tableFooterView
    [self setCustomTableFooterView];
    
    return self.shouldPerformSearch;
}
#pragma mark -

#pragma mark List View Custom Delegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType
{
    CDFFlagModalTableViewCell *cell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:m_selectedIndexPath.row inSection:m_selectedIndexPath.section]];
    [[cell cellTextField] setText:value];
    
    [self updateTableDataForKey:TEXTFIELD_VALUE withValue:value forSection:m_selectedIndexPath.section forRow:m_selectedIndexPath.row];
    
    //Reset city on selection of state value, assuming State and City are part of either Address or New Address section
    if([listType isEqualToString:STATE_KEY])
    {
        NSString *sectionKey = ([sectionArray containsObject:ADDRESS_KEY] ? ADDRESS_KEY : NEW_ADDRESS_KEY);
        
        //Clear 'City' field
        NSIndexPath *indexPathForCity = [NSIndexPath indexPathForRow:[[[[rowArray objectAtIndex:[sectionArray indexOfObject:sectionKey]] allValues] objectAtIndex:0] indexOfObject:CITY_KEY] inSection:[sectionArray indexOfObject:sectionKey]];
        
        CDFFlagModalTableViewCell *cityCell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathForCity.row inSection:indexPathForCity.section]];
        
        [[cityCell cellTextField] setText:nil];
        [cityCell setUserInteractionEnabled:YES];
        
        //Set placeholder for City field depending its required or not
       // NSDictionary *rowParametersForCityField = [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPathForCity.section]] objectForKey:cityCell.cellTitleLabel.text];
//        if([[rowParametersForCityField objectForKey:REQUIRED_TEXTFIELD] boolValue])
//        {
//            [cityCell.cellTextField setPlaceholder:@"Required"];
//        }
//        else
//        {
//            [cityCell.cellTextField setPlaceholder:@""];
//        }
        
        [self updateTableDataForKey:TEXTFIELD_VALUE withValue:nil forSection:indexPathForCity.section forRow:indexPathForCity.row];
        
        //Clear 'ZIP' field
        NSIndexPath *indexPathForZip = [NSIndexPath indexPathForRow:[[[[rowArray objectAtIndex:[sectionArray indexOfObject:sectionKey]] allValues] objectAtIndex:0] indexOfObject:ZIP_KEY] inSection:[sectionArray indexOfObject:sectionKey]];
        
        CDFFlagModalTableViewCell *zipCell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathForZip.row inSection:indexPathForZip.section]];
        
        [[zipCell cellTextField] setText:nil];
        [zipCell.cellTextField setEnabled:TRUE];
        
        //Set placeholder for ZIP field depending its required or not
        //NSDictionary *rowParametersForZipField = [[self.inputTableDataDict objectForKey:[self.sectionArray objectAtIndex:indexPathForZip.section]] objectForKey:zipCell.cellTitleLabel.text];
//        if([[rowParametersForZipField objectForKey:REQUIRED_TEXTFIELD] boolValue])
//        {
//            [zipCell.cellTextField setPlaceholder:@"Required"];
//        }
//        else
//        {
//            [zipCell.cellTextField setPlaceholder:@""];
//        }
        
        [self updateTableDataForKey:TEXTFIELD_VALUE withValue:nil forSection:indexPathForZip.section forRow:indexPathForZip.row];
        
    }
    else if([listType isEqualToString:PROF_DESGN_KEY])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //For other than sales reps there is no Individual type field on search form
        if([[defaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_ADD] || [[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
        {
            NSString *sectionKey = ([sectionArray containsObject:PROFILE_KEY] ? PROFILE_KEY : OTHER_FIELDS_KEY);
            NSIndexPath *indexPathForIndvTypeCell = [NSIndexPath indexPathForRow:[[[[rowArray objectAtIndex:[sectionArray indexOfObject:sectionKey]] allValues] objectAtIndex:0] indexOfObject:INDV_TYPE_KEY] inSection:[sectionArray indexOfObject:sectionKey]];
            
            CDFFlagModalTableViewCell *cell = (CDFFlagModalTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathForIndvTypeCell.row inSection:indexPathForIndvTypeCell.section]];
            
            NSString *indvType = @"";
            if([[[JSONDataFlowManager sharedInstance]ProfDesignNPRSValueArray] containsObject:value])
            {
                indvType = [[[JSONDataFlowManager sharedInstance]indvTypeArray] objectAtIndex:0];   //Non-Prescriber
            }
            else
            {
                indvType = [[[JSONDataFlowManager sharedInstance]indvTypeArray] objectAtIndex:1];   //Prescriber
            }
            
            [[cell cellTextField] setText:indvType];
            [self updateTableDataForKey:TEXTFIELD_VALUE withValue:indvType forSection:indexPathForIndvTypeCell.section forRow:indexPathForIndvTypeCell.row];
        }
    }
    
    [listPopOverController dismissPopoverAnimated:YES];
    
}
#pragma mark -

#pragma mark TextField Delegates
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //Set return key type depending on user action(search/add/remove)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_SEARCH])
    {
        [textField setReturnKeyType:UIReturnKeySearch];
    }
    else if([[userDefaults objectForKey:USER_ACTION_TYPE] isEqualToString:USER_ACTION_TYPE_ADD] ||
            [[userDefaults objectForKey:USER_ACTION_TYPE]  isEqualToString:USER_ACTION_TYPE_REMOVE])
    {
        [textField setReturnKeyType:UIReturnKeyGo];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    
    NSInteger section = textField.tag/10;
    NSInteger row     = textField.tag%10;
    
    // Scroll table to visible & in Middle
    m_selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView scrollToRowAtIndexPath:m_selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag/10;
    NSInteger row     = textField.tag%10;
    
    [self updateTableDataForKey:TEXTFIELD_VALUE withValue:textField.text forSection:section forRow:row];
    
    self.activeTextField = nil;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //Call search/submit action
    if(textField.returnKeyType == UIReturnKeySearch || textField.returnKeyType == UIReturnKeyGo)
    {
        [self searchButtonAction];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
#pragma mark

#pragma mark Keyboard Notifications
-(void)keyboardDidShow:(NSNotification *)notification
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    //TODO: Need to calculate position of table view from lower end of screen to be used as offset
    tableViewOffset = 49;
    
    // Adjust size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        frame.size.height -= keyboardBounds.size.height - tableViewOffset;
    }
    else
    {
        frame.size.height -= keyboardBounds.size.width - tableViewOffset;
    }
    
    //Using block
    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.tableView.frame = frame;
                         self.tableView.contentInset = UIEdgeInsetsZero;
                     }
                     completion:^(BOOL finished){
                         [self.tableView scrollToRowAtIndexPath:m_selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                     }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    tableViewOffset = 49;
    
    // Adjust size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        frame.size.height += keyboardBounds.size.height - tableViewOffset;
    }
    else
    {
        frame.size.height += keyboardBounds.size.width - tableViewOffset;
    }
    
    //Using block
    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.tableView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                         self.tableView.contentInset = UIEdgeInsetsZero;
                         
                         //Animate cell scroll position as per its position in table content
                         CGRect cellFrame = [self.tableView rectForRowAtIndexPath:m_selectedIndexPath];
                         if((CGRectGetMinY(cellFrame)+CGRectGetHeight(cellFrame)/2) <= self.tableView.contentSize.height/2)
                         {
                             [self.tableView scrollToRowAtIndexPath:m_selectedIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                         }
                         else
                         {
                             [self.tableView scrollToRowAtIndexPath:m_selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                         }
                         
                         [self presentPopoverWithListOfValuesForTableCellAtIndex:m_selectedIndexPath];
                     }];
}
#pragma mark -

#pragma mark DatePickerViewControllerDelegate
-(void)setSelectedDate:(NSDate *)date
{
    //If date is nil then dismiss date popover view
    if(!date && datePickerPopoverController)
    {
        [datePickerPopoverController dismissPopoverAnimated:YES];
        datePickerPopoverController = nil;
        return;
    }
    
    //Format Date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = DATE_FORMATTER_STYLE;
    NSString *dateLabel = [dateFormatter stringFromDate:date];
    
    //Assumption: section "Search For" contains field "Creation Date"
    NSIndexPath *indexPathForCreationDate = [NSIndexPath indexPathForRow:[[[[rowArray objectAtIndex:[sectionArray indexOfObject:SEARCH_FOR_KEY]] allValues] objectAtIndex:0] indexOfObject:REQ_CREATION_DATE_KEY] inSection:[sectionArray indexOfObject:SEARCH_FOR_KEY]];
    
    CDFFlagModalTableViewCell *cell = (CDFFlagModalTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPathForCreationDate];
    [[cell cellTextField] setText:dateLabel];
    [self updateTableDataForKey:TEXTFIELD_VALUE withValue:dateLabel forSection:indexPathForCreationDate.section forRow:indexPathForCreationDate.row];
    
    //Dismiss date pop over view
    [datePickerPopoverController dismissPopoverAnimated:YES];
    datePickerPopoverController = nil;
}
#pragma mark -

@end
