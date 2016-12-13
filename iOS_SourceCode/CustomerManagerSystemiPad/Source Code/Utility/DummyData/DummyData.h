//
//  DummyData.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 15/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerObject.h"
#import "AddressObject.h"
#import "RequestObject.h"
#import "RequestStatusHistoryObject.h"
#import "OrganizationObject.h"

@interface DummyData : NSObject

+(NSMutableArray *)requestsDataWithCustomerType:(NSString *)custType andRequestStatus:(NSString *)status;
+(CustomerObject *)customerObjectWithType:(NSString *)type;
+(AddressObject *)addressObjectWithType:(NSString *)type;
+(RequestStatusHistoryObject *)requestHistoryWithType:(NSString *)type;
+(NSMutableArray *)searchCustomerWithType:(NSString *)custType;
+(OrganizationObject *)organizationObjectWithType:(NSString *)type;
@end
