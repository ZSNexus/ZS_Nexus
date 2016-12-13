/*****************************************************************************
 *
 *  Copyright Persistent System,
 *  All rights reserved.
 *
 *  Project : ZS
 *  File    : JSONDataFlowManager.h
 *  Purpose : To get data from file (in JSON format)
 *  Author  : Jeevan Pawar
 *  Date    : Oct 03, 2013
 *
 *****************************************************************************/

#import "JSONDataFlowManager.h"
#import "LOVData.h"

@implementation JSONDataFlowManager

@synthesize specilalityArray = _specilalityArray;
@synthesize selectedTerritoryName;
@synthesize reasonForCustomerRemovalArray,reasonForOrgRemovalArray;
@synthesize reasonForCustomerAddressRemovalArray;
@synthesize profDesignKeyArray,profDesignValueArray;
@synthesize profDesignKeyValue;
@synthesize ProfDesignNPRSValueArray;
@synthesize TargetTypeNPRSValueArray;
@synthesize addressUsageTypeArrayAll;
@synthesize AddresUsageTypeArrayAdd;
@synthesize indvTypeArray,OrgTypeArraySales,OrgTypeKeyArray,OrgTypeValueArray,OrgTypeKeyValue,TerritoryArray,requestorArray,requestStageArray,requesterKeyValues,defaultRequestSearchParametersValues,defaultRequestSearchParametersKeys,stageOfRequestsKeyValues,requestTypeKeyValues,withdrawRequestTypeKeyValues,requestStatusKeyValues,completedRequestStatusArray,defaultRequestSearchParametersValuesForOrg;


#pragma mark - Shared Dataflow Manager
+ (JSONDataFlowManager *)sharedInstance
{
    static JSONDataFlowManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSONDataFlowManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
    
}
#pragma mark -

#pragma mark LOVs Initialization
- (id) init
{
    self = [super init];
    if (self != nil)
    {
        _specilalityArray=[[NSMutableArray alloc]init];
        selectedTerritoryName=[[NSString alloc]init];
        [self loadConstantsArray];
        
    }
    return self;
}

-(void)loadConstantsArray
{
    reasonForCustomerRemovalArray =[NSArray arrayWithObjects:@"Deceased",@"Retired",@"Recommended for Removal",nil];   //reasons for individual // removed @"Moved out of territory"
    reasonForCustomerAddressRemovalArray = [NSArray arrayWithObjects:@"Invalid Address", @"Moved / Relocated", @"Duplicate Address", @"Address no Longer Active", nil];
    
    reasonForOrgRemovalArray= [NSArray arrayWithObjects:@"Moved out of territory",@"Recommended for Removal",nil];   //reason for org
    
    profDesignKeyArray=[NSArray arrayWithObjects:@"ADM", @"AN", @"AUD", @"BCO", @"BMR", @"BSN", @"CFO", @"CMA", @"CNAP", @"CNAN", @"CNS", @"CR", @"CRP", @"CW", @"DDS", @"DN", @"DNU", @"DO", @"DPM", @"DST", @"EPD", @"FIN", @"HE", @"ICO", @"IFN", @"LPN", @"LT", @"MA", @"MD", @"NA", @"ND", @"NE", @"NM", @"NP", @"NTR", @"OD", @"OMGR", @"ONN", @"OTHE", @"PA", @"PAD", @"PADM", @"PHD", @"PHI", @"PHMD", @"PHR", @"PHT", @"PN", @"PST", @"PSY", @"RC", @"RMGR", @"RN", @"RPH", @"RS", @"RT", @"STUDENT", @"SW", @"TCO", @"US", @"VMD", nil];
    profDesignValueArray=[NSArray arrayWithObjects:@"ADM-Administrator", @"AN-Advanced Nurse", @"AUD-Audiologist", @"BCO-Biller/Coder", @"BMR-Billing Manager (Staff)", @"BSN-Bachelor of Science in Nursing", @"CFO-Chief Financial Officer", @"CMA-Certified Medical Assistant", @"CNA-Certified Registered Nurse Anesthetist", @"CNA-Certified Nursing Assistant", @"CNS-Clinical Nurse Specialist", @"CR-Cancer Registrar", @"CRP-Chiropractor", @"CW-Case Worker", @"DDS-Doctor of Dental Surgery", @"DN-Director Of Nursing", @"DNU-Discharge Nurse", @"DO-Doctor of Osteopathy", @"DPM-Doctor of Podiatric Medicine", @"DST-Dosimetrist", @"EPD-Epidemiologist", @"FIN-Financial Counselor", @"HE-Health Educator", @"ICO-Insurance Coordinator", @"IFN-Infusion Nurse", @"LPN-Licensed Practical Nurse", @"LT-Lab Technician", @"MA-Medical Assistant", @"MD-Medical Doctor", @"NA-Not Applicable", @"ND-Naturopathic Doctor", @"NE-Nurse Educator", @"NM-Nurse Midwife", @"NP-Nurse Practitioner", @"NTR-Nutritionist", @"OD-Doctor of Optometry", @"OMGR-Office Manager", @"ONN-Oncology Nurse Navigator", @"OTHE-Other", @"PA-Physician Assistant", @"PAD-Policy Advisor", @"PADM-Practice Administrator", @"PhD", @"PHI-Pharmacist Intern", @"PharmD-Doctor of Pharmacy", @"PHR-Pharmacist", @"PHT-Pharmacy Technician", @"PN-Psychiatric Nurse", @"PST-Physicist", @"PSY-Psychologist", @"RC-Research Coordinator", @"RMGR-Reimbursement Manager", @"RN-Registered Nurse", @"RPH-Registered Pharmacist", @"RS-Reimbursement Specialist", @"RT-Radiation Tech", @"Student", @"SW-Social Worker", @"TCO-Transplant Coordinator", @"US-Unspecified", @"VMD-Veterinary Medical Doctor", nil];
    
    profDesignKeyValue=[NSDictionary dictionaryWithObjects:profDesignValueArray forKeys:profDesignKeyArray];
    
    ProfDesignNPRSValueArray=[NSArray arrayWithObjects:@"ADM-Administrator", @"AUD-Audiologist", @"BCO-Biller/Coder", @"BMR-Billing Manager (Staff)", @"BSN-Bachelor of Science in Nursing", @"CFO-Chief Financial Officer", @"CMA-Certified Medical Assistant", @"CNA-Certified Nursing Assistant", @"CR-Cancer Registrar", @"CRP-Chiropractor", @"CW-Case Worker", @"DN-Director Of Nursing", @"DNU-Discharge Nurse", @"DST-Dosimetrist", @"EPD-Epidemiologist", @"FIN-Financial Counselor", @"HE-Health Educator", @"ICO-Insurance Coordinator", @"IFN-Infusion Nurse", @"LPN-Licensed Practical Nurse", @"LT-Lab Technician", @"MA-Medical Assistant", @"NA-Not Applicable", @"ND-Naturopathic Doctor", @"NE-Nurse Educator", @"NTR-Nutritionist", @"OMGR-Office Manager", @"ONN-Oncology Nurse Navigator", @"OTHE-Other", @"PAD-Policy Advisor", @"PADM-Practice Administrator", @"PhD", @"PharmD-Doctor of Pharmacy", @"PHT-Pharmacy Technician", @"PN-Psychiatric Nurse", @"PST-Physicist", @"RC-Research Coordinator", @"RMGR-Reimbursement Manager", @"RN-Registered Nurse", @"RPH-Registered Pharmacist", @"RS-Reimbursement Specialist", @"RT-Radiation Tech", @"Student", @"SW-Social Worker", @"TCO-Transplant Coordinator", nil];
    
    TargetTypeNPRSValueArray = [NSArray arrayWithObjects:@"Prescriber",@"Non-Prescriber",nil];
    
    addressUsageTypeArrayAll=[NSArray arrayWithObjects:@"AFFL", @"BILL", @"CONTRACT", @"HEAD", @"HOME", @"MAIL", @"OFF", @"OTHER", @"PROVIDER RELATIONS", @"SALES/MARKETING", @"SHIP", nil];
    
    AddresUsageTypeArrayAdd=[NSArray arrayWithObjects:@"MAIL", @"OFF", @"SHIP", nil];
    
    indvTypeArray=[NSArray arrayWithObjects: @"Non-Prescriber", @"Prescriber", nil];
    
    OrgTypeArraySales=[NSArray arrayWithObjects: @"Group Practice", @"Limited Liability Company", nil];
    
    OrgTypeKeyArray=[NSArray arrayWithObjects: @"CLIN", @"CORP", @"CRO", @"DEPT", @"GOVT", @"GPO", @"GRP", @"HOSP", @"IDN", @"IRB", @"LLC", @"NURS", @"OTH", @"PAYR", @"PBM", @"PHAR", @"PLAN", @"WHOL", @"ZIPD" ,nil];
    
    OrgTypeValueArray=[NSArray arrayWithObjects: @"Clinics", @"Corporate Parent", @"Contract Research Organization", @"Department", @"Government", @"GPO", @"Group Practice", @"Hospitals", @"IDN", @"Internal Review Board", @"Limited Liability Company", @"Nursing Home", @"Other", @"Payer", @"PBM", @"Pharmacy", @"Plan", @"Wholesaler", @"Zip Default" ,nil];
    
    OrgTypeKeyValue=[NSDictionary dictionaryWithObjects:OrgTypeValueArray forKeys:OrgTypeKeyArray];
    
    TerritoryArray=[NSArray arrayWithObjects:@"Princeton, NJ",@"Lawrenceville, NJ",@"Aminton, NJ",@"Houghton, NJ", nil];
    
    requestorArray=[NSArray arrayWithObjects:@"My Requests", @"Partner Requests", @"System Generated", @"Home Office Generated", @"All", nil];
    
    requesterKeyValues=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"me", @"partner", @"system", @"bulk", @"all", nil] forKeys:requestorArray];
    
    requestStageArray=[NSArray arrayWithObjects:@"Pending", @"Completed", @"Withdrawn", @"Rejected", @"All", nil];
    
    stageOfRequestsKeyValues=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"2",@"4",@"5",@"3", nil] forKeys:requestStageArray];
    
    defaultRequestSearchParametersValues=[NSArray arrayWithObjects:@"All",@"Remove Address",@"My Requests", nil];
    defaultRequestSearchParametersValuesForOrg = [NSArray arrayWithObjects:@"All",@"All",@"My Requests", nil];
    
    defaultRequestSearchParametersKeys=[NSArray arrayWithObjects:@"Stage of Request",@"Request Type",@"Requestor", nil];
    
    //To be commented later
//    requestTypeKeyValues=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"add",@"add",@"rmv", @"rmv",@"all", nil] forKeys:[NSArray arrayWithObjects:ADD_CUSTOMER_STRING,ADD_ADDRESS_STRING,ALIGN_CUSTOMER_STRING,REMOVE_CUSTOMER_STRING,REMOVE_ADDRESS_STRING, nil]];
    
    requestTypeKeyValues=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"add_bp",@"add_bpa",@"add_ali_bp", @"rmv_bp",@"rmv_bpa",@"add",@"rmv",@"all", nil] forKeys:[NSArray arrayWithObjects:@"Add Customer",@"Add Address",@"Align Customer",@"Remove Customer",@"Remove Address",@"Add",@"Remove",@"All", nil]];

    withdrawRequestTypeKeyValues=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Add new customer", @"Add new address", @"Align to territory", @"Remove customer", @"Remove address", nil] forKeys: [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5", nil]];
    
    requestStatusKeyValues=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",@"10", nil] forKeys:[NSArray arrayWithObjects:@"Scheduled - CMEH Sync", @"Pending - CMEH Validation", @"Rejected", @"Verified", @"Cancelled", @"Pending External Authorization",@"Scheduled - InterACT Sync",@"Withdrawn",@"Completed", nil]];
    
    completedRequestStatusArray=[NSArray arrayWithObjects:@"rejected",@"verified",@"cancelled",@"withdrawn",@"completed", nil];
}
#pragma mark -

#pragma mark Specialty LOVs
-(NSArray*)specilalityArray
{
    if(_specilalityArray.count==0)
    {
        NSDictionary *dict=[[[self class] sharedInstance] getStaticResourcesForFile:@"Specilality"];
        _specilalityArray = [[[self class] sharedInstance] parseJsonForSpecilality:dict];
    }
    return _specilalityArray;
}

- (NSDictionary*) getStaticResourcesForFile:(NSString*)fileName {
    
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"json"];
    NSData* configFileData = [NSData dataWithContentsOfFile:path];
    NSError* error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:configFileData options:NSJSONReadingAllowFragments error:&error];
    
    return dictionary;
}

-(NSArray*)parseJsonForSpecilality:(NSDictionary *) specilalityDict
{
    NSDictionary *specDict = [specilalityDict objectForKey:@"Specilality"];
    
    NSArray *codeArray=[specDict objectForKey:@"Codes"];
    NSArray *decriptionArray=[specDict objectForKey:@"Descriptions"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    if ( [codeArray count]>0 && [codeArray count]==[decriptionArray count])
    {
        NSInteger count = [codeArray count];
        
        
        for (int i=0; i<count; i++) {
            
            LOVData *speciality=[[LOVData alloc]init];
            [speciality setCode:[codeArray objectAtIndex:i]];
            [speciality setDescription:[decriptionArray objectAtIndex:i]];
            [dataArray addObject:speciality];
        }
    }
    
    NSArray *sortedArray = [dataArray sortedArrayUsingComparator: ^(LOVData *obj1, LOVData *obj2) {
        return [obj1.code localizedCaseInsensitiveCompare:obj2.code];
    }];
    
    return sortedArray;
}
#pragma mark -

@end
