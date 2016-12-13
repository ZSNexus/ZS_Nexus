//
//  AddressObject.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 12/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressObject : NSObject
@property(nonatomic,retain)NSString* street;
@property(nonatomic,retain)NSString* building;
@property(nonatomic,retain)NSString* suite;
@property(nonatomic,retain)NSString* state;
@property(nonatomic,retain)NSString* status;
@property(nonatomic,retain)NSString* zip;
@property(nonatomic,retain)NSString* city;
@property(nonatomic,retain)NSString* addr_usage_type;
@property(nonatomic,retain)NSString* longitude;
@property(nonatomic,retain)NSString* latitude;
@property(nonatomic,retain)NSString* BPA_ID;
@property(nonatomic,retain)NSString* errorlLabel;
@property(nonatomic,retain)NSString* isAddedToTerritory;
@property(nonatomic,retain)NSString* addressLineOne;
@property(nonatomic,retain)NSString* addressLineTwo;
@property(nonatomic,retain)NSString* targetId;
@property(nonatomic,retain)NSString* ticketId;
@property(nonatomic,retain)NSString* addressApprovalFlag;

@end
