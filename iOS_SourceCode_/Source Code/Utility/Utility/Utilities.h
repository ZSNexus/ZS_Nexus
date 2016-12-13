//
//  Utilities.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 12/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface Utilities : NSObject

+(BOOL)parseJsonLoginUserDetails:(NSDictionary *)jsonDataObject;
+(BOOL)parseHOUserJsonLoginUserDetails:(NSDictionary *)jsonDataObject;//Parsing Json for HO user
+(NSArray *)parseJsonSearchIndividual:(NSArray *)jsonDataArrayOfObjects;
+(NSArray *)parseJsonSearchOrganization:(NSArray *)jsonDataArrayOfObjects;
+(NSDictionary *)parseJsonGetState:(NSDictionary *)jsonDataObject;
+(BOOL)parseJsonAndCheckStatus:(NSDictionary *)jsonDataObject;
+(NSArray *)parseJsonGetRequests:(NSArray *)jsonDataArrayOfObjects;
+(NSArray *)parseJsonMapLatAndLon:(NSDictionary *)jsonDataObject;
+(NSArray *)parseJsonGetRecents:(NSDictionary *)jsonDataObject;

+(void)displayErrorAlertWithTitle:(NSString*)title andErrorMessage:(NSString*)errorMessage withDelegate:(id)delegate;
+(void)addSpinnerOnView:(UIView*)view withMessage:(NSString*)messageString;
+(void)removeSpinnerFromView:(UIView*)view;
+(BOOL)copyDatabaseFromResources;
+(BOOL)copyDatabaseFrom:(NSString*)sourcePath to:(NSString*)destinationPath;
+(BOOL)changeSelectedTerritoryTo:(NSString*)newTerritory;

+(NSString*)getSignatureForUrl:(NSString *)url usingPrivateKey:(NSString *)privateKey;

@end
