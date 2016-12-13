//
//  CustomerObject.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 12/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerObject : NSObject
@property(nonatomic,retain)NSArray* bpaToDealign;
@property(nonatomic,retain)NSString * custTitle;
@property(nonatomic,retain)NSString* custId;
@property(nonatomic,retain)NSString* custFirstName;
@property(nonatomic,retain)NSString* custMiddleName;
@property(nonatomic,retain)NSString* custLastName;
@property(nonatomic,retain)NSString* custSuffix;
@property(nonatomic,retain)NSString* custPrimarySpecialty;
@property(nonatomic,retain)NSString* custPrimarySpecialtyCode;
@property(nonatomic,retain)NSString* custSecondarySpecialty;
@property(nonatomic,retain)NSString* custSecondarySpecialtyCode;
@property(nonatomic,retain)NSString* custType;
@property(nonatomic,retain)NSString* custProfessionalDesignation;
@property(nonatomic,retain)NSString* custProfessionalDesignationName;
@property(nonatomic,retain)NSString* custTargetSearchIndividualType;
@property(nonatomic,retain)NSString* custSampleEligibility;
@property(nonatomic,retain)NSString* custBPID;
@property(nonatomic,retain)NSString* custNPI;
@property(nonatomic,retain)NSString* custRepTargetValue;
@property(nonatomic,retain)NSString* custAttr1;
@property(nonatomic,retain)NSString* custAttr2;
@property(nonatomic,retain)NSString* custAttr3;
@property(nonatomic,retain)NSString* custAttr4;
@property(nonatomic,retain)NSString* custAttr5;
@property(nonatomic,retain)NSMutableArray* custAddress;
@property(nonatomic,retain)NSString* custValidationStatus;
@property(nonatomic,retain)NSString* approvalFlag;
@property(nonatomic,retain)NSString* isHoUser;//Added this flag for ho user for Add to terriotary functionality for Customer.
@property(nonatomic,assign)BOOL isRequestedForRemoval;
@property NSInteger pendingCustRemovalReq;
@property(nonatomic,retain)NSMutableArray* pendingCustBpaIds;
@property(nonatomic,retain)NSMutableArray* pendingBpaTexts;
@property(nonatomic,retain)NSString* isPendingText;
@property(nonatomic,retain)NSString* customerRemovalStatusMessage;

@end
