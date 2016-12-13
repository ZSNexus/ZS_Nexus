//
//  ModalDataLoader.m
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/6/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "ModalDataLoader.h"
#import "CustomModalViewBO.h"
#import "Constants.h"

@implementation ModalDataLoader

{}
#pragma mark - Initialization
- (id) init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    return self;
}

+ (CustomModalViewBO *) prepareTableDataForSectionArray:(NSArray *)sectionArray rowArray:(NSArray *)rowArray withSearchParameters:(NSDictionary *)searchParameters andSpecialFeatures:(NSDictionary *)specialFeaturesDictionary
{
    NSArray *disclosureAccessoryArray = [NSArray arrayWithObjects:CITY_KEY,STATE_KEY,ORG_TYPE_KEY,PROF_DESGN_KEY, ADDRESS_USAGE_KEY, BP_CLASSIFICATION_KEY, REQ_CREATION_DATE_KEY,REQUESTOR_KEY,PRIMARY_SPECIALTY_KEY,REQ_STAGE_KEY, nil];
    
    NSArray *checkmarkArray = [NSArray arrayWithObjects:ADD_CUSTOMER_STRING,ADD_ADDRESS_STRING,ALIGN_CUSTOMER_STRING,REMOVE_CUSTOMER_STRING,REMOVE_ADDRESS_STRING,ADD_STRING,REMOVE_STRING,ALL_STRING, nil];
    
    //592:DDD_IMS_ID
    NSArray *numericTextFieldsArray = [NSArray arrayWithObjects:BPID_KEY,NPI_KEY,/*@"IMS ID #",*/ORG_BPID_KEY,/*DDD_KEY,*/ ZIP_KEY, REQ_TICKET_NUMBER_KEY, nil];
    
    NSInteger count = [sectionArray count];
    
    CustomModalViewBO * customBO = [[CustomModalViewBO alloc] init];
    [customBO setCustomModalSectionArray:[NSMutableArray arrayWithArray:sectionArray]];
    
    for (int i=0; i<count; ++i)
    {
        NSDictionary *sectionDict = [[NSDictionary alloc] initWithObjectsAndKeys:[rowArray objectAtIndex:i], [sectionArray objectAtIndex:i], nil];
        
        [customBO.customModalRowArray addObject:sectionDict];
    }
    
    for (int i=0; i<count; ++i)
    {
        BOOL isSectionContainsRequiredField = NO;
        NSArray *localArray = [rowArray objectAtIndex:i];
        
        NSMutableDictionary *sectionComponentDict = [[NSMutableDictionary alloc] init];
        
        for (NSString *title in localArray)
        {
            
            NSMutableDictionary *rowComponentDict = [[NSMutableDictionary alloc] init];
            
            // String - textField vakue if user edited
            if(searchParameters && [searchParameters objectForKey:title])
            {
                [rowComponentDict setObject:[searchParameters objectForKey:title] forKey:TEXTFIELD_VALUE];
            }
            
            // Disclosure fields
            if([disclosureAccessoryArray containsObject:title] )
                [rowComponentDict setObject:[NSNumber numberWithInt:UITableViewCellAccessoryDisclosureIndicator] forKey:ACCESSORY];
            
            // Checkmark fields
            else if ([checkmarkArray containsObject:title])
            {
                [rowComponentDict setObject:[NSNumber numberWithInt:UITableViewCellAccessoryCheckmark] forKey:ACCESSORY];
                
                //Section: Stage of request
                if([[sectionArray objectAtIndex:i] isEqual:REQ_STAGE_KEY])
                {
                    if([searchParameters objectForKey:REQ_STAGE_KEY])
                    {
                        if([[searchParameters objectForKey:REQ_STAGE_KEY] isEqual:title])
                        {
                            [rowComponentDict setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_SELECTED] forKey:ACCESSORY_STATE_VALUE];
                        }
                        else
                        {
                            [rowComponentDict setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_UNSELECTED] forKey:ACCESSORY_STATE_VALUE];
                        }
                    }
                    else
                    {
                        //By default set selected first row
                        if([localArray indexOfObject:title] == 0)
                        {
                            [rowComponentDict setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_SELECTED] forKey:ACCESSORY_STATE_VALUE];
                        }
                    }
                }
                
                //Section: Request Type
                if([[sectionArray objectAtIndex:i] isEqual:REQUEST_TYPE_KEY])
                {
                    if([searchParameters objectForKey:REQUEST_TYPE_KEY])
                    {
                        if([[searchParameters objectForKey:REQUEST_TYPE_KEY] isEqual:title])
                        {
                            [rowComponentDict setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_SELECTED] forKey:ACCESSORY_STATE_VALUE];
                        }
                        else
                        {
                            [rowComponentDict setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_UNSELECTED] forKey:ACCESSORY_STATE_VALUE];
                        }
                    }
                    else
                    {
                        //By default set selected first row
                        if([localArray indexOfObject:title] == 0)
                        {
                            [rowComponentDict setObject:[NSNumber numberWithInteger:ACCESSORY_STATE_SELECTED] forKey:ACCESSORY_STATE_VALUE];
                        }
                    }
                }
            }
            else
                [rowComponentDict setObject:[NSNumber numberWithInt:UITableViewCellAccessoryNone] forKey:ACCESSORY];
            
            
            // BOOL - required/optional
            if ([[specialFeaturesDictionary objectForKey:SPECIAL_FEATURE_REQUIRED_FIELDS] containsObject:title])
            {
                [rowComponentDict setObject:[NSNumber numberWithBool:YES] forKey:REQUIRED_TEXTFIELD];
                isSectionContainsRequiredField = YES;
            }
            else
            {
                [rowComponentDict setObject:[NSNumber numberWithBool:NO] forKey:REQUIRED_TEXTFIELD];
            }
            
            //Set keyboard type for textField
            if([numericTextFieldsArray containsObject:title])
            {
                [rowComponentDict setObject:[NSNumber numberWithInteger:UIKeyboardTypeNumberPad] forKey:TEXTFIELD_TYPE];
            }
            else
            {
                [rowComponentDict setObject:[NSNumber numberWithInteger:UIKeyboardTypeDefault] forKey:TEXTFIELD_TYPE];
            }
            
            [sectionComponentDict setObject:rowComponentDict forKey:title];
            [sectionComponentDict setObject:[NSNumber numberWithInteger:isSectionContainsRequiredField] forKey:REQUIRED_SECTION];
        }
        
        [customBO.customModalInputDict setObject:sectionComponentDict forKey:[customBO.customModalSectionArray objectAtIndex:i]];
    }
    
    //Add footer text
    if([specialFeaturesDictionary objectForKey:SPECIAL_FEATURE_FOOTER_TEXT])
    {
        [customBO.customModalInputDict setObject:[specialFeaturesDictionary objectForKey:SPECIAL_FEATURE_FOOTER_TEXT] forKey:SPECIAL_FEATURE_FOOTER_TEXT];
    }
    
    return customBO;
}
#pragma mark -

#pragma mark Refine/Advance Customer Search - Remove Tab
//Method returns no of rows for different fields name, ids, addresses & other fields for remove tab only
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualRemoveSearchWithParametrs:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,IDS_KEY,ADDRESS_KEY,OTHER_FIELDS_KEY,nil];
    
    //Row parameters for type of record
    //NSArray *requestType = [NSArray arrayWithObjects:REQ_TYPE_KEY, nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,MIDDLE_NAME_KEY, nil];
    
    //592:DDD_IMS_ID
    NSArray *idArray   = [NSArray arrayWithObjects:BPID_KEY,NPI_KEY,/*@"IMS ID #",*/ nil];
    
    NSArray *addressArray = [NSArray arrayWithObjects:STATE_KEY,CITY_KEY,ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    NSArray *otherFieldsArray = nil;
    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP]|| [[searchParameters objectForKey:@"targetType"]isEqualToString:@"Individual Type"])
    {
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, INDV_TYPE_KEY, nil];
    }
    else
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, nil];
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,idArray,addressArray,otherFieldsArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:specialFeaturesDictionary];
}

//Method returns no of rows for different fields name, ids, addresses & other fields
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualRefineSearchWithParametrs:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,IDS_KEY,ADDRESS_KEY,OTHER_FIELDS_KEY,nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,MIDDLE_NAME_KEY, nil];
    
    //592:DDD_IMS_ID
    NSArray *idArray   = [NSArray arrayWithObjects:BPID_KEY,NPI_KEY,/*@"IMS ID #",*/ nil];
    
    NSArray *addressArray = [NSArray arrayWithObjects:STATE_KEY,CITY_KEY,ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    NSArray *otherFieldsArray = nil;
    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP]|| [[searchParameters objectForKey:@"targetType"]isEqualToString:@"Individual Type"])
    {
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, INDV_TYPE_KEY, nil];
    }
    else
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, nil];
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,idArray,addressArray,otherFieldsArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:specialFeaturesDictionary];
}

//Method returns no of rows for different fields name, ids, addresses & other fields (Review tab only).
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualTargetSearchWithParametrs:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:USER_ACTION_TYPE_ADD forKey:USER_ACTION_TYPE];
    if([defaults objectForKey:USER_ACTION_TYPE])
        [defaults removeObjectForKey:USER_ACTION_TYPE];
    
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    [defaults setObject:USER_ACTION_TAB_TARGET forKey:USER_ACTION_TAB];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,IDS_KEY,ADDRESS_KEY,OTHER_FIELDS_KEY,nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,MIDDLE_NAME_KEY, nil];
    
    //592:DDD_IMS_ID
    NSArray *idArray   = [NSArray arrayWithObjects:BPID_KEY,NPI_KEY,/*@"IMS ID #",*/ nil];
    
    NSArray *addressArray = [NSArray arrayWithObjects:STATE_KEY,CITY_KEY,ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    NSArray *otherFieldsArray = nil;
    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP]|| [[searchParameters objectForKey:@"targetType"]isEqualToString:@"Individual Type"])
    {
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, INDV_TYPE_KEY, nil];
    }
    else
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, nil];
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,idArray,addressArray,otherFieldsArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:specialFeaturesDictionary];
}

+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualAffiliationSearch:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,IDS_KEY,nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,STATE_KEY, nil];
    
    //592:DDD_IMS_ID
    NSArray *idArray   = [NSArray arrayWithObjects:BPID_KEY,NPI_KEY,/*@"IMS ID #",*/ nil];
    
   // NSArray *addressArray = [NSArray arrayWithObjects:STATE_KEY, nil];
//    NSArray *otherFieldsArray = nil;
//    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
//    {
//        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, INDV_TYPE_KEY, nil];
//    }
//    else
//    {
//        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, nil];
//    }
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,idArray, nil];
    
    //Required fields array
   // NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY
   // NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:nil];
}


+ (CustomModalViewBO *) getModalCustomInputDictionaryForAlignTerritorySearch:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,IDS_KEY,nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,STATE_KEY, nil];
    
    //592:DDD_IMS_ID
    NSArray *idArray   = [NSArray arrayWithObjects:BPID_KEY,NPI_KEY,/*@"IMS ID #",*/ nil];
    
//    NSArray *addressArray = [NSArray arrayWithObjects:STATE_KEY,CITY_KEY,ZIP_KEY, ADDRESS_USAGE_KEY, nil];
//    NSArray *otherFieldsArray = nil;
//    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
//    {
//        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, INDV_TYPE_KEY, nil];
//    }
//    else
//    {
//        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, nil];
//    }
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,idArray, nil];
    
    //Required fields array
//    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY
//    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:nil];
    
}

+ (CustomModalViewBO *) getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,IDS_KEY,ADDRESS_KEY,nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:ORG_NAME_KEY,ORG_TYPE_KEY, nil];
    NSArray *idArray   = [NSArray arrayWithObjects:ORG_BPID_KEY, nil];
    
    NSArray *addressArray = [NSArray arrayWithObjects:STREET_KEY,BUILDING_KEY,SUITE_KEY,STATE_KEY, CITY_KEY, ZIP_KEY, nil];
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,idArray,addressArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil];  //ZIP_KEY,
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:specialFeaturesDictionary];
}

+(CustomModalViewBO *) getModalCustomInputDictionaryForIndividualAdvanceSearchWithParameters:(NSDictionary *)searchParameters{
    
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY, IDS_KEY, ADDRESS_KEY, OTHER_FIELDS_KEY, nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY, LAST_NAME_KEY, MIDDLE_NAME_KEY, nil];
    
    //592:DDD_IMS_ID
    NSArray *idsArray = [NSArray arrayWithObjects:BPID_KEY, NPI_KEY, /*@"IMS ID #",*/ nil];
    
    NSArray *addressArray = [NSArray arrayWithObjects:STATE_KEY, CITY_KEY, ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    
    NSArray *otherFieldsArray = nil;
    if([[defaults objectForKey:USER_ROLES_KEY] isEqualToString:USER_ROLE_SALES_REP])
    {
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, INDV_TYPE_KEY, nil];
    }
    else
    {
        otherFieldsArray=[NSArray arrayWithObjects:PRIMARY_SPECIALTY_KEY, PROF_DESGN_KEY, nil];
    }
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray, idsArray, addressArray, otherFieldsArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY,
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:specialFeaturesDictionary];
}

+(CustomModalViewBO *) getModalCustomInputDictionaryForOrganizationAdvanceSearchWithParameters:(NSDictionary *)searchParameters{
    
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY, IDS_KEY, ADDRESS_KEY, nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:ORG_NAME_KEY, ORG_TYPE_KEY, nil];
    NSArray *idsArray   = [NSArray arrayWithObjects:ORG_BPID_KEY, nil];
    
    NSArray *addressArray = [NSArray arrayWithObjects:STREET_KEY,BUILDING_KEY,SUITE_KEY, STATE_KEY, CITY_KEY, ZIP_KEY,nil];
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray, idsArray, addressArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STATE_KEY, nil]; //ZIP_KEY,
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:specialFeaturesDictionary];
}
#pragma mark -

#pragma mark Add New Customer/Address
+ (CustomModalViewBO *) getModalCustomInputDictionaryForNewIndividualCustomer
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_ADD forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,PROFILE_KEY,ADDRESS_KEY,nil];
    
    //Row parameters for sections
    NSArray *nameArray = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,MIDDLE_NAME_KEY,SUFFIX_KEY, nil];
    NSArray *profileArray   = [NSArray arrayWithObjects:PROF_DESGN_KEY,INDV_TYPE_KEY, nil];
    NSArray *addressArray = [NSArray arrayWithObjects: STREET_KEY, BUILDING_KEY, SUITE_KEY, STATE_KEY, CITY_KEY, ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,profileArray,addressArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:FIRST_NAME_KEY, LAST_NAME_KEY, PROF_DESGN_KEY, STREET_KEY, STATE_KEY, CITY_KEY, ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, TABLE_FOOTER_TEXT_ADD_INDIVIDUAL, SPECIAL_FEATURE_FOOTER_TEXT, nil];
    
    //Default parameter values if any
    NSDictionary *defaultParameterValues = [NSDictionary dictionaryWithObjectsAndKeys:ADDRESS_USAGE_TYPE_OFF_KEY, ADDRESS_USAGE_KEY, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:defaultParameterValues andSpecialFeatures:specialFeaturesDictionary];
}

+ (CustomModalViewBO *) getModalCustomInputDictionaryForNewOrganizationalCustomer
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_ADD forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NAME_KEY,ADDRESS_KEY,nil];
    
    //Row parameters for sections
    
    NSArray *nameArray = [NSArray arrayWithObjects:ORG_NAME_KEY,ORG_TYPE_KEY, nil];
    NSArray *addressArray = [NSArray arrayWithObjects:STREET_KEY,BUILDING_KEY,SUITE_KEY,STATE_KEY, CITY_KEY,ZIP_KEY,nil];
    
    NSArray *rowArray = [[NSArray alloc] initWithObjects:nameArray,addressArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:ORG_NAME_KEY, ORG_TYPE_KEY, STREET_KEY, STATE_KEY, CITY_KEY, ZIP_KEY, nil];
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, TABLE_FOOTER_TEXT_ADD_ORGANIZATION, SPECIAL_FEATURE_FOOTER_TEXT, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:nil andSpecialFeatures:specialFeaturesDictionary];
}

+ (CustomModalViewBO *) getModalCustomInputDictionaryForAddIndividualNewAddress
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_ADD forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NEW_ADDRESS_KEY, nil];
    
    //Row parameters for sections
    NSArray *addressArray = [NSArray arrayWithObjects:STREET_KEY,BUILDING_KEY,SUITE_KEY,STATE_KEY, CITY_KEY,ZIP_KEY,ADDRESS_USAGE_KEY, nil];
    NSArray *rowArray = [[NSArray alloc] initWithObjects:addressArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STREET_KEY, STATE_KEY, CITY_KEY, ZIP_KEY, ADDRESS_USAGE_KEY, nil];
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //Default parameter values if any
    NSDictionary *defaultParameterValues = [NSDictionary dictionaryWithObjectsAndKeys:ADDRESS_USAGE_TYPE_OFF_KEY, ADDRESS_USAGE_KEY, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:defaultParameterValues andSpecialFeatures:specialFeaturesDictionary];
}

+ (CustomModalViewBO *) getModalCustomInputDictionaryForAddOrganizationNewAddress
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_ADD forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:NEW_ADDRESS_KEY, nil];
    
    //Row parameters for sections
    NSArray *addressArray = [NSArray arrayWithObjects:STREET_KEY,BUILDING_KEY,SUITE_KEY,STATE_KEY, CITY_KEY,ZIP_KEY,nil];
    NSArray *rowArray = [[NSArray alloc] initWithObjects:addressArray, nil];
    
    //Required fields array
    NSArray *requiredFieldsArray = [NSArray arrayWithObjects:STREET_KEY, STATE_KEY, CITY_KEY, ZIP_KEY, nil];
    NSDictionary *specialFeaturesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requiredFieldsArray, SPECIAL_FEATURE_REQUIRED_FIELDS, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:nil andSpecialFeatures:specialFeaturesDictionary];
}
#pragma mark -

#pragma mark Requests Search
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualCustomersRequestWithParametrs:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:REQ_STAGE_KEY,REQUEST_TYPE_KEY,REQUESTOR_KEY,SEARCH_FOR_KEY, ADDRESS_KEY, nil];
    
    //Row parameters for sections
    NSArray *stageArray = [NSArray arrayWithObjects:REQ_STAGE_KEY, nil];
    NSArray *searchForArray   = [NSArray arrayWithObjects:FIRST_NAME_KEY,LAST_NAME_KEY,BPID_KEY,REQ_TICKET_NUMBER_KEY, REQ_CREATION_DATE_KEY, nil];
    NSArray *requestorArray = [NSArray arrayWithObjects:REQUESTOR_KEY, nil];
    NSArray *requestTypeArray   = [NSArray arrayWithObjects:ADD_CUSTOMER_STRING,ADD_ADDRESS_STRING,ALIGN_CUSTOMER_STRING,REMOVE_CUSTOMER_STRING,REMOVE_ADDRESS_STRING,nil];
    NSArray *addressFieldsArray = [NSArray arrayWithObjects:STATE_KEY, CITY_KEY, ZIP_KEY, nil];
    NSArray *rowArray = [[NSArray alloc] initWithObjects:stageArray,requestTypeArray,requestorArray,searchForArray,addressFieldsArray, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:nil];
}

+ (CustomModalViewBO *) getModalCustomInputDictionaryForOrganizationsRequestWithParametrs:(NSDictionary*)searchParameters
{
    //Update user action type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:USER_ACTION_TYPE_SEARCH forKey:USER_ACTION_TYPE];
    
    // All keys - header Values Array as per needed sequence
    //Section Array
    NSArray *sectionKeyArray = [[NSMutableArray alloc] initWithObjects:REQ_STAGE_KEY,REQUEST_TYPE_KEY,REQUESTOR_KEY,SEARCH_FOR_KEY, ADDRESS_KEY, nil];
    
    //Row parameters for sections
    NSArray *stageArray = [NSArray arrayWithObjects:REQ_STAGE_KEY, nil];
    NSArray *searchForArray   = [NSArray arrayWithObjects:ORG_NAME_KEY,ORG_TYPE_KEY,ORG_BPID_KEY,REQ_TICKET_NUMBER_KEY, REQ_CREATION_DATE_KEY, nil];
    NSArray *requestorArray = [NSArray arrayWithObjects:REQUESTOR_KEY , nil];
    NSArray *requestTypeArray   = [NSArray arrayWithObjects:ADD_STRING,REMOVE_STRING,ALL_STRING,nil];
    NSArray *addressFieldsArray = [NSArray arrayWithObjects:STATE_KEY, CITY_KEY, ZIP_KEY, nil];
    NSArray *rowArray = [[NSArray alloc] initWithObjects:stageArray,requestTypeArray,requestorArray,searchForArray,addressFieldsArray, nil];
    
    //create and return table with section
    return [self prepareTableDataForSectionArray:sectionKeyArray rowArray:rowArray withSearchParameters:searchParameters andSpecialFeatures:nil];
}
#pragma mark -

@end
