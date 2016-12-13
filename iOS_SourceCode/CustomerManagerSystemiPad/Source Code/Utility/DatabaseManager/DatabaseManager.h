//
//  DatabaseManager.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 18/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject
+(DatabaseManager *) sharedSingleton;
-(NSArray *)fetchStates;
-(NSArray *)fetchCityforState:(NSString *)stateId;
-(NSString *)fetchStateIdforName:(NSString *)stateName;
-(NSString *)fetchSyncDateForSyncType:(NSString *)syncType;
-(BOOL)updateSyncDateForSyncType:(NSString *)syncType andSyncDate:(NSString *)syncDate inDatabase:(sqlite3*)database;
- (void)initializeDatabase:(sqlite3 *)database;
-(NSString *)fetchCityIdforName:(NSString *)cityName;
-(BOOL)isZipExists:(NSString *)zipCode inState:(NSString *)stateId andCity:(NSString *)cityId;

-(BOOL)insertStatesWithStateIds:(NSArray*)stateIds andStateNames:(NSArray*)stateNames intoDatabase:(sqlite3*)database;
-(BOOL)insertCitiesFrom:(NSDictionary*)stateCityDictionary intoDatabase:(sqlite3*)database;
-(BOOL)insertZipsFrom:(NSDictionary*)cityZipDictionary intoDatabase:(sqlite3*)database;

-(BOOL)createNewZipDatabaseWithData:(NSDictionary*)zipLovData;
-(BOOL)swapOldDbWithNewDb;

@end
