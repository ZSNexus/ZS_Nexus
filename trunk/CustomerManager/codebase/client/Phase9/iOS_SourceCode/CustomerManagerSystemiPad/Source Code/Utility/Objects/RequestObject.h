//
//  RequestObject.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 13/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerObject.h"
#import "AddressObject.h"
#import "OrganizationObject.h"
@interface RequestObject : NSObject
@property(nonatomic,retain)NSString* requesterType;
@property(nonatomic,retain)NSString* requestType;
@property(nonatomic,retain)NSString* requestStatus;
@property(nonatomic,retain)NSString* requestStage;
@property(nonatomic,retain)NSString* resolutionDescription;
@property(nonatomic,retain)NSMutableArray* requestStatusHistory;
@property(nonatomic,retain)NSString* ticketNo;
@property(nonatomic,retain)NSString* ticketId;
@property(nonatomic,retain)NSString* requestCreationDate;
@property(nonatomic,retain)CustomerObject* customerInfo;
@property(nonatomic,retain)OrganizationObject* organizationInfo;
@property (nonatomic,retain)NSString *reason;
@property (nonatomic ,retain)NSMutableArray *dealignedBPAInfoArray;
@property(nonatomic,retain)NSString* requestDetails;

@end
