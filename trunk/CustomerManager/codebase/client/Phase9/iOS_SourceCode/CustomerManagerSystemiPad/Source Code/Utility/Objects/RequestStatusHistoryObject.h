//
//  RequestStatusHistoryObject.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 14/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestStatusHistoryObject : NSObject
@property(nonatomic,retain)NSString* actionDate;
@property(nonatomic,retain)NSString* status;
@property(nonatomic,retain)NSString* requestType;
@property(nonatomic,retain)NSString* resolutionDescription;
@end
