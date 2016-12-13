//
//  DummyData.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 15/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "DummyData.h"
#import "Constants.h"

@implementation DummyData

{}
#pragma mark - Dummy Customer Data
+(NSMutableArray *)searchCustomerWithType:(NSString *)custType
{
    NSMutableArray * requestData=[[NSMutableArray alloc]init];
    
    if([custType isEqualToString:INDIVIDUALS_KEY])
    {
        [requestData addObject:[DummyData customerObjectWithType:@"1"]];
        [requestData addObject:[DummyData customerObjectWithType:@"2"]];
        [requestData addObject:[DummyData customerObjectWithType:@"3"]];
        [requestData addObject:[DummyData customerObjectWithType:@"4"]];
        [requestData addObject:[DummyData customerObjectWithType:@"5"]];
        [requestData addObject:[DummyData customerObjectWithType:@"6"]];
        [requestData addObject:[DummyData customerObjectWithType:@"7"]];
        [requestData addObject:[DummyData customerObjectWithType:@"8"]];
        [requestData addObject:[DummyData customerObjectWithType:@"9"]];
        [requestData addObject:[DummyData customerObjectWithType:@"10"]];
        [requestData addObject:[DummyData customerObjectWithType:@"11"]];
        [requestData addObject:[DummyData customerObjectWithType:@"12"]];
        [requestData addObject:[DummyData customerObjectWithType:@"13"]];
    }
    else
    {
        [requestData addObject:[DummyData organizationObjectWithType:@"1"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"2"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"3"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"4"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"5"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"6"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"7"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"8"]];
        [requestData addObject:[DummyData organizationObjectWithType:@"9"]];
        
    }
    return requestData;
}

+(CustomerObject *)customerObjectWithType:(NSString *)type
{
    CustomerObject* cust=[[CustomerObject alloc]init];
    NSMutableArray* AddressArray=[[NSMutableArray alloc]init];
    if([type isEqualToString:@"1"])
    {
        [cust setCustFirstName:@"Dr. Avery Jones"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"5162514252"];
        [cust setCustNPI:@"7715662819"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"Y"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"1"]];
        [AddressArray addObject:[DummyData addressObjectWithType:@"2"]];
        [AddressArray addObject:[DummyData addressObjectWithType:@"3"]];
        [AddressArray addObject:[DummyData addressObjectWithType:@"4"]];
        [AddressArray addObject:[DummyData addressObjectWithType:@"5"]];
        [AddressArray addObject:[DummyData addressObjectWithType:@"6"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"2"])
    {
        [cust setCustFirstName:@"Dr. Badrick White"];
        [cust setCustType:@"Prescriber"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"6612514252"];
        [cust setCustNPI:@"3314662819"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setApprovalFlag:@"Y"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"2"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"3"])
    {
        [cust setCustFirstName:@"Dr. Barbara Preston"];
        [cust setCustType:@"Prescriber"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"7162514252"];
        [cust setCustNPI:@"1234662819"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"N"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"3"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"4"])
    {
        [cust setCustFirstName:@"Dr. Bob Baker"];
        [cust setCustType:@"Prescriber"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"5562571252"];
        [cust setCustNPI:@"2345862819"];
        [cust setCustValidationStatus:@"valid"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"Y"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"4"]];
        [AddressArray addObject:[DummyData addressObjectWithType:@"5"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"5"])
    {
        [cust setCustFirstName:@"Dr. Cabrina Dalby"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"891251451"];
        [cust setCustNPI:@"7651462819"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"N"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"6"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"6"])
    {
        [cust setCustFirstName:@"Dr. Carl Holmes"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"7710514252"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"7152662877"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"N"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"7"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"7"])
    {
        [cust setCustFirstName:@"Dr. Ama Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"9814514252"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"5534662861"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"Y"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"8"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"8"])
    {
        [cust setCustFirstName:@"Dr. Amabel Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"8813114614"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"1235662819"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"Y"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"9"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"9"])
    {
        [cust setCustFirstName:@"Dr. Amadea Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"41152311461"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"3215662123"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"Y"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"11,10"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"10"])
    {
        [cust setCustFirstName:@"Dr. Amadeus Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"ON - Oncology"];
        [cust setCustBPID:@"5513131146"];
        [cust setCustMiddleName:@""];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"3215662222"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"Y"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"12"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"11"])
    {
        [cust setCustFirstName:@"Dr. Amaria Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"6683114631"];
        [cust setCustNPI:@"4325662855"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"N"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"13"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"12"])
    {
        [cust setCustFirstName:@"Dr. Amelia Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"ON - Oncology"];
        [cust setCustBPID:@"5122114671"];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"6545662456"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"N"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"14"]];
        [cust setCustAddress:AddressArray];
    }
    else if([type isEqualToString:@"13"])
    {
        [cust setCustFirstName:@"Dr. Amalyn Jones"];
        [cust setCustType:@"Prescriber"];
        [cust setCustPrimarySpecialty:@"AN - Anesthesiology"];
        [cust setCustBPID:@"46263523343"];
        [cust setCustLastName:@""];
        [cust setCustNPI:@"4325662855"];
        [cust setCustProfessionalDesignation:@"MD"];
        [cust setCustSecondarySpecialty:@"IN - Internal Medicine"];
        [cust setApprovalFlag:@"N"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"15"]];
        [cust setCustAddress:AddressArray];
    }
    
    return cust;
}

+(OrganizationObject *)organizationObjectWithType:(NSString *)type
{
    OrganizationObject* org=[[OrganizationObject alloc]init];
    NSMutableArray* AddressArray=[[NSMutableArray alloc]init];
    if([type isEqualToString:@"1"])
    {
        [org setOrgName:@"Apple Health"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Hospital"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"6514276187"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"1"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"2"])
    {
        [org setOrgName:@"Benneton Health"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Hospital"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"6655114428"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"2"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"3"])
    {
        [org setOrgName:@"Best Health Zone"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Clinic"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"7162418270"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"3"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"4"])
    {
        [org setOrgName:@"Best Hearts"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Hospital"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"6577176187"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"4"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"5"])
    {
        [org setOrgName:@"Cammelia Health"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Clinic"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"9015114428"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"5"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"6"])
    {
        [org setOrgName:@"Complete Health"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Hospital"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"1423418279"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"6"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"7"])
    {
        [org setOrgName:@"Crystal Health"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Group Practice"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"8814268270"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"7"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"8"])
    {
        [org setOrgName:@"Dexter Health Zone"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Hospital"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"981672448"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"8"]];
        [org setOrgAddress:AddressArray];
    }
    else if([type isEqualToString:@"9"])
    {
        [org setOrgName:@"Exlixir Hearts"];
        [org setOrgBPClassification:@"H9"];
        [org setOrgType:@"Clinic"];
        [org setOrgValidationStatus:@"Eligible"];
        [org setOrgBPID:@"8814268270"];
        [AddressArray addObject:[DummyData addressObjectWithType:@"10"]];
        [org setOrgAddress:AddressArray];
    }
    return org;
}

+(AddressObject *)addressObjectWithType:(NSString *)type
{
    AddressObject* addObj=[[AddressObject alloc]init];
    if([type isEqualToString:@"1"])
    {
        [addObj setBuilding:@"212"];
        [addObj setStreet:@"Carnegie Center"];
        [addObj setCity:@"Princeton"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08540"];
        [addObj setAddr_usage_type:@"Office"];
        [addObj setBPA_ID:@"1001"];
        [addObj setLatitude:@"40.3487"];
        [addObj setLongitude:@"74.6590"];
    }
    else  if([type isEqualToString:@"2"])
    {
        [addObj setBuilding:@"321"];
        [addObj setStreet:@"Crystal Point Center"];
        [addObj setCity:@"Alp Street"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08544"];
        [addObj setAddr_usage_type:@"Office"];
        [addObj setBPA_ID:@"1002"];
        [addObj setLatitude:@"40.3487"];
        [addObj setLongitude:@"74.6590"];
    }
    else if([type isEqualToString:@"3"])
    {
        [addObj setBuilding:@"11"];
        [addObj setStreet:@"CarneApplegie Center"];
        [addObj setCity:@"New Line"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08532"];
        [addObj setAddr_usage_type:@"Office, Shipping"];
        [addObj setBPA_ID:@"1003"];
        [addObj setLatitude:@"28.1422"];
        [addObj setLongitude:@"153.1153"];
    }
    else if([type isEqualToString:@"4"])
    {
        [addObj setBuilding:@"702"];
        [addObj setStreet:@"Rolling Hills"];
        [addObj setCity:@"New Brunswick"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08511"];
        [addObj setAddr_usage_type:@"Office"];
        [addObj setBPA_ID:@"1004"];
        [addObj setLatitude:@"28.1422"];
        [addObj setLongitude:@"153.1153"];
    }
    else if([type isEqualToString:@"5"])
    {
        [addObj setBuilding:@"804"];
        [addObj setStreet:@"Rolling Hills"];
        [addObj setCity:@"New Brunswick"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08512"];
        [addObj setAddr_usage_type:@"Office"];
        [addObj setBPA_ID:@"1005"];
        [addObj setLatitude:@"28.1422"];
        [addObj setLongitude:@"153.1153"];
    }
    else if([type isEqualToString:@"6"])
    {
        [addObj setBuilding:@"331"];
        [addObj setStreet:@"Somerset Lane"];
        [addObj setCity:@"Princeton"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08541"];
        [addObj setAddr_usage_type:@"Office"];
        [addObj setBPA_ID:@"1006"];
        [addObj setLatitude:@"28.1422"];
        [addObj setLongitude:@"153.1153"];
    }
    else if([type isEqualToString:@"7"])
    {
        [addObj setBuilding:@"243"];
        [addObj setStreet:@"Carnegie Center"];
        [addObj setCity:@"Princeton"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08545"];
        [addObj setAddr_usage_type:@"Office, Shipping"];
        [addObj setBPA_ID:@"1007"];
        [addObj setLatitude:@"28.1422"];
        [addObj setLongitude:@"153.1153"];
    }
    else if([type isEqualToString:@"8"])
    {
        [addObj setBuilding:@"801"];
        [addObj setCity:@"Princeton"];
        [addObj setState:@"New Jersey"];
        [addObj setZip:@"08546"];
        [addObj setAddr_usage_type:@"Office, Shipping"];
        [addObj setBPA_ID:@"1008"];
        [addObj setLatitude:@"28.1422"];
        [addObj setLongitude:@"153.1153"];
    }
    return addObj;
}
#pragma mark -

#pragma mark Dummy Requests Data
+(NSMutableArray *)requestsDataWithCustomerType:(NSString *)custType andRequestStatus:(NSString *)status
{
    NSMutableArray * requestData=[[NSMutableArray alloc]init];
    
    
    if([custType isEqualToString:INDIVIDUALS_KEY])
    {
        if([status isEqualToString:@"Pending"])
        {
            
            RequestObject * req1=[[RequestObject alloc]init];
            [req1 setCustomerInfo:[DummyData customerObjectWithType:@"1"]];
            [req1 setRequestType:@"Add Address"];
            NSMutableArray * reqHistory=[[NSMutableArray alloc]init];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"1"]];
            [req1 setRequestStatusHistory:reqHistory];
            
            RequestObject * req2=[[RequestObject alloc]init];
            [req2 setCustomerInfo:[DummyData customerObjectWithType:@"2"]];
            [req2 setRequestType:@"Remove Address"];
            NSMutableArray * reqHistory1=[[NSMutableArray alloc]init];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"4"]];
            [req2 setRequestStatusHistory:reqHistory1];
            
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
        }
        else
        {
            RequestObject * req1=[[RequestObject alloc]init];
            [req1 setRequestType:@"Add Address"];
            [req1 setCustomerInfo:[DummyData customerObjectWithType:@"1"]];
            NSMutableArray * reqHistory=[[NSMutableArray alloc]init];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"1"]];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"2"]];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"3"]];
            [req1 setRequestStatusHistory:reqHistory];
            
            RequestObject * req2=[[RequestObject alloc]init];
            [req2 setCustomerInfo:[DummyData customerObjectWithType:@"2"]];
            [req2 setRequestType:@"Remove Address"];
            NSMutableArray * reqHistory1=[[NSMutableArray alloc]init];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"4"]];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"5"]];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"6"]];
            [req2 setRequestStatusHistory:reqHistory1];
            
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
        }
    }
    else
    {
        if([status isEqualToString:@"Pending"])
        {
            
            RequestObject * req1=[[RequestObject alloc]init];
            [req1 setOrganizationInfo:[DummyData organizationObjectWithType:@"1"]];
            [req1 setRequestType:@"Add Address "];
            NSMutableArray * reqHistory=[[NSMutableArray alloc]init];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"1"]];
            [req1 setRequestStatusHistory:reqHistory];
            
            RequestObject * req2=[[RequestObject alloc]init];
            [req2 setOrganizationInfo:[DummyData organizationObjectWithType:@"2"]];
            [req2 setRequestType:@"Remove Address "];
            NSMutableArray * reqHistory1=[[NSMutableArray alloc]init];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"4"]];
            [req2 setRequestStatusHistory:reqHistory1];
            
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
        }
        else
        {
            RequestObject * req1=[[RequestObject alloc]init];
            [req1 setRequestType:@"Add Address "];
            [req1 setOrganizationInfo:[DummyData organizationObjectWithType:@"1"]];
            NSMutableArray * reqHistory=[[NSMutableArray alloc]init];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"1"]];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"2"]];
            [reqHistory addObject:[DummyData requestHistoryWithType:@"3"]];
            [req1 setRequestStatusHistory:reqHistory];
            
            RequestObject * req2=[[RequestObject alloc]init];
            [req2 setOrganizationInfo:[DummyData organizationObjectWithType:@"2"]];
            [req2 setRequestType:@"Remove Address "];
            NSMutableArray * reqHistory1=[[NSMutableArray alloc]init];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"4"]];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"5"]];
            [reqHistory1 addObject:[DummyData requestHistoryWithType:@"6"]];
            [req2 setRequestStatusHistory:reqHistory1];
            
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
            [requestData addObject:req1];
            [requestData addObject:req2];
        }
    }
    return requestData;
}

+(RequestStatusHistoryObject *)requestHistoryWithType:(NSString *)type
{
    RequestStatusHistoryObject* histObj=[[RequestStatusHistoryObject alloc]init];
    if([type isEqualToString:@"1"])
    {
        [histObj setActionDate:@"30 Mar 2012"];
        [histObj setStatus:@"Pending"];
        [histObj setRequestType:@"Add Address"];
        
    }
    else if([type isEqualToString:@"2"])
    {
        [histObj setActionDate:@"30 Apr 2012"];
        [histObj setStatus:@"Send to SFA"];
        [histObj setRequestType:@"Add Address"];
        
    }
    else if([type isEqualToString:@"3"])
    {
        [histObj setActionDate:@"3 May 2012"];
        [histObj setStatus:@"Competed"];
        [histObj setRequestType:@"Add Address"];
        
    }
    else if([type isEqualToString:@"4"])
    {
        [histObj setActionDate:@"5 Mar 2013"];
        [histObj setStatus:@"Pending"];
        [histObj setRequestType:@"Remove Address"];
        
    }
    else if([type isEqualToString:@"5"])
    {
        [histObj setActionDate:@"30 Mar 2013"];
        [histObj setStatus:@"Send to SFA"];
        [histObj setRequestType:@"Remove Address"];
        
    }
    else if([type isEqualToString:@"6"])
    {
        [histObj setActionDate:@"1 Jun 2013"];
        [histObj setStatus:@"Completed"];
        [histObj setRequestType:@"Remove Address"];
    }
    return histObj;
}
#pragma mark -

@end
