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

#import <Foundation/Foundation.h>

@interface JSONDataFlowManager : NSObject

@property (strong, nonatomic) NSArray *specilalityArray;
@property (nonatomic, retain)NSString *selectedTerritoryName;
@property (nonatomic, retain)NSArray *reasonForCustomerRemovalArray;
@property (nonatomic, retain)NSArray *reasonForCustomerAddressRemovalArray;
@property (nonatomic, retain)NSArray *reasonForOrgRemovalArray;
@property (nonatomic, retain)NSArray *profDesignKeyArray;
@property (nonatomic, retain)NSArray *profDesignValueArray;
@property (nonatomic, retain)NSDictionary *profDesignKeyValue;
@property (nonatomic, retain)NSArray *ProfDesignNPRSValueArray;
@property (nonatomic, retain)NSArray *TargetTypeNPRSValueArray;
//Address Usage Type
@property (nonatomic, retain)NSArray *addressUsageTypeArrayAll;
@property (nonatomic, retain)NSArray *AddresUsageTypeArrayAdd;
@property (nonatomic,retain)NSArray *indvTypeArray;
@property (nonatomic, retain)NSArray *OrgTypeArraySales;
@property (nonatomic,retain)NSArray *OrgTypeKeyArray;
@property (nonatomic,retain)NSArray *OrgTypeValueArray;
@property (nonatomic,retain)NSDictionary *OrgTypeKeyValue;
@property (nonatomic,retain)NSArray *TerritoryArray;
@property (nonatomic,retain)NSArray *requestorArray;
@property (nonatomic, retain)NSArray *requestStageArray;
@property (nonatomic, retain)NSDictionary *requesterKeyValues;
@property (nonatomic,retain)NSArray *defaultRequestSearchParametersValues;
@property (nonatomic,retain)NSArray *defaultRequestSearchParametersValuesForOrg;
@property (nonatomic,retain)NSArray *defaultRequestSearchParametersKeys;
@property (nonatomic,retain)NSDictionary *stageOfRequestsKeyValues;
@property (nonatomic,retain)NSDictionary *requestTypeKeyValues;
@property (nonatomic,retain)NSDictionary *withdrawRequestTypeKeyValues;
@property (nonatomic,retain)NSDictionary *requestStatusKeyValues;
@property (nonatomic,retain)NSArray *completedRequestStatusArray;

+ (JSONDataFlowManager *)sharedInstance;

- (NSDictionary*)getStaticResourcesForFile:(NSString*)fileName;

-(NSArray*)parseJsonForSpecilality:(NSDictionary *) specilalityDict;

@end
