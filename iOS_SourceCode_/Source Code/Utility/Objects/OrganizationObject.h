//
//  OrganizationObject.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 15/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationObject : NSObject

@property(nonatomic,retain)NSString* orgName;
@property(nonatomic,retain)NSString* orgType;
@property(nonatomic,retain)NSString* orgBPClassification;
@property(nonatomic,retain)NSString* orgValidationStatus;
@property(nonatomic,retain)NSString* orgBPID;
@property(nonatomic,retain)NSString* isHoUser;//Added this flag for ho user for Add to terriotary functionality for Organization.
@property(nonatomic,retain)NSMutableArray* orgAddress;
@property(nonatomic,assign)BOOL isRequestedForRemoval;
@property(nonatomic,retain)NSString* organisationRemovalStatusMessage;

@end
