//
//  DataManager.h
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 6/25/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomModalViewBO;

@interface DataManager : NSObject

@property (nonatomic, strong) NSDictionary *popOverArrayDict;
@property (nonatomic, assign) BOOL isIndividualSegmentSelectedForAddCustomer;
@property (nonatomic, assign) BOOL isIndividualSegmentSelectedForRemoveCustomer;
@property (nonatomic, assign) BOOL isIndividualSegmentSelectedForRequest;

@property (nonatomic, assign) BOOL isDefaultRequestForRemoveCustomer;
@property (nonatomic, assign) BOOL isDefaultRequestForRequests;
@property (nonatomic, assign) BOOL isDefaultRequestForReviews;

+(DataManager*) sharedObject;

@end
