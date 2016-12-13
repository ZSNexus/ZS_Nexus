//
//  ModalDataLoader.h
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/6/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomModalViewBO;

@interface ModalDataLoader : NSObject

+ (CustomModalViewBO *) getModalCustomInputDictionaryForNewIndividualCustomer;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForNewOrganizationalCustomer;
+ (CustomModalViewBO *)getModalCustomInputDictionaryForIndividualRemoveSearchWithParametrs:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualRefineSearchWithParametrs:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualTargetSearchWithParametrs:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForOrganizationRefineSearchWithParametrs:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualCustomersRequestWithParametrs:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForOrganizationsRequestWithParametrs:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForAddIndividualNewAddress;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForAddOrganizationNewAddress;

+ (CustomModalViewBO *) prepareTableDataForSectionArray:(NSArray*)sectionArray rowArray:(NSArray*) rowArray withSearchParameters:(NSDictionary*)searchParameters andSpecialFeatures:(NSDictionary*)specialFeaturesDictionary;

+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualAdvanceSearchWithParameters:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForOrganizationAdvanceSearchWithParameters:(NSDictionary*)searchParameters;;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForAlignTerritorySearch:(NSDictionary*)searchParameters;
+ (CustomModalViewBO *) getModalCustomInputDictionaryForIndividualAffiliationSearch:(NSDictionary*)searchParameters;

@end
