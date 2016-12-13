//
//  DatabaseManager.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 18/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "DatabaseManager.h"
#import "Constants.h"
#import "Utilities.h"

#define DATABASE_NAME @"CustMgrDB.db"

static DatabaseManager * databaseObject =  nil;
static NSString * databasePath =  nil;
static NSString * tempDatabasePath = nil;
static NSString * newDatabasePath = nil;

@interface DatabaseManager()
@property(assign)sqlite3 *db;

@end

@implementation DatabaseManager
@synthesize db;

#pragma mark - Shared Database Manager
+(DatabaseManager *) sharedSingleton
{
    @synchronized (self)
    {
        if (databaseObject == nil) {
            databaseObject = [[self alloc] init];
            databasePath =[self getDatabasePath];
            tempDatabasePath = [self getTempDatabasePath];
            newDatabasePath = [self getNewDatabasePath];
        }
    }
    return databaseObject;
}
#pragma mark -

#pragma mark Database Initialization
- (void)initializeDatabase:(sqlite3 *)database
{
    DebugLog(@"[DatabaseManager : initializeDatabase]");
    
    sqlite3_exec(database,
                 "CREATE TABLE IF NOT EXISTS SYNC (SYNC_TYPE, SYNC_DATE TEXT)",
                 NULL, NULL, NULL);
    
    sqlite3_exec(database,
                 "CREATE TABLE IF NOT EXISTS STATES (STATE_ID TEXT, STATE_NAME TEXT)",
                 NULL, NULL, NULL);
    
    sqlite3_exec(database,
                 "CREATE TABLE IF NOT EXISTS CITY (CITY_ID TEXT ,CITY_NAME TEXT,STATE_ID TEXT)",
                 NULL, NULL, NULL);
    
    sqlite3_exec(database,
                 "CREATE TABLE IF NOT EXISTS ZIP (ZIP_CODE TEXT,CITY_ID TEXT)",
                 NULL, NULL, NULL);
}

-(BOOL)dropTable:(NSString *)tblName fromDatabase:(sqlite3 *)database
{
    BOOL status=FALSE;
    NSString* sql = [NSString stringWithFormat:@"DROP TABLE %@",tblName];
    
    //Drop Table
    char ** errorMsg=nil;
    sqlite3_exec(database,[sql UTF8String], NULL, NULL, errorMsg);
    if(errorMsg==nil)
    {
        status=TRUE;
    }
    else
    {
        status=FALSE;
        NSData *error = [NSData dataWithBytes:errorMsg length:sizeof(errorMsg)];
        ErrorLog(@"%@",error);
    }
    
    return status;
}

-(BOOL)createNewZipDatabaseWithData:(NSDictionary *)zipLovData
{
    sqlite3 *newDatabase;
    
    //Extract State City and ZIP
    NSMutableArray *stateIdsArray = [zipLovData objectForKey:@"stateIds"];
    NSMutableArray *stateNamesArray = [zipLovData objectForKey:@"stateNames"];
    NSMutableDictionary *stateCityDictionary = [zipLovData objectForKey:@"stateCities"];
    NSMutableDictionary *cityZipDictionary = [zipLovData objectForKey:@"cityZips"];
    NSString *timeStamp =[zipLovData objectForKey:@"nextUpdateDate"];
    
    //Create new ZIP LOV database
    if (sqlite3_open([newDatabasePath UTF8String], &newDatabase) == SQLITE_OK)
    {
        NSString *sqlStatementString = nil;
        sqlite3_stmt *sqlStatement = nil;
        
        //Begin transaction
        sqlStatementString = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(newDatabase, [sqlStatementString UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK) {
            printf("db error: %s\n", sqlite3_errmsg(newDatabase));
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return NO;
        }
        
        if (sqlite3_step(sqlStatement) != SQLITE_DONE) {
            sqlite3_finalize(sqlStatement);
            printf("db error: %s\n", sqlite3_errmsg(newDatabase));
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return NO;
        }
        
        [self initializeDatabase:newDatabase];
        DebugLog(@"State Tables Re Created");
        
        //Insert States
        BOOL insertStatesStatus = [self insertStatesWithStateIds:stateIdsArray andStateNames:stateNamesArray intoDatabase:newDatabase];
        if(!insertStatesStatus)
        {
            //Error Inserting State
            ErrorLog(@"Error Inserting States");
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return FALSE;
        }
        
        //Insert Cities
        BOOL insertCitiesStatus = [self insertCitiesFrom:stateCityDictionary intoDatabase:newDatabase];
        if(!insertCitiesStatus)
        {
            //Error Inserting Cities
            ErrorLog(@"Error Inserting Cities");
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return FALSE;
        }
        
        //Insert ZIPs
        BOOL insertZipsStatus = [self insertZipsFrom:cityZipDictionary intoDatabase:newDatabase];
        if(!insertZipsStatus)
        {
            //Error Inserting ZIPs
            ErrorLog(@"Error Inserting ZIPs");
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return FALSE;
        }
        
        //Update Sync Table
        if(![self updateSyncDateForSyncType:@"States" andSyncDate:timeStamp inDatabase:newDatabase])
        {
            //Error inserting sync date
            ErrorLog(@"Error Update Sync Table For States");
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return FALSE;
        }
        
        //Commit transaction
        sqlStatementString = @"COMMIT TRANSACTION";
        
        if (sqlite3_prepare_v2(newDatabase, [sqlStatementString UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK) {
            printf("db error: %s\n", sqlite3_errmsg(newDatabase));
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return FALSE;
        }
        
        if (sqlite3_step(sqlStatement) != SQLITE_DONE) {
            sqlite3_finalize(sqlStatement);
            printf("db error: %s\n", sqlite3_errmsg(newDatabase));
            
            //Cleanup
            [Utilities copyDatabaseFrom:newDatabasePath to:nil];
            
            return FALSE;
        }
        
        sqlite3_finalize(sqlStatement);
        sqlite3_close(newDatabase);
        
        //Save timeStamp of db update
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:timeStamp forKey:@"nextDBUpdateDate"];
        
        //Current date will be now last DB Update date
        NSDate *lastUpdateDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *lastDbUpdateDateString = [dateFormatter stringFromDate:lastUpdateDate];
        [defaults setObject:lastDbUpdateDateString forKey:@"lastDBUpdateDate"];
        
        DebugLog(@"State City Zip data updated successfully");
    }
    
    return TRUE;
}

-(BOOL)insertStatesWithStateIds:(NSArray*)stateIds andStateNames:(NSArray*)stateNames intoDatabase:(sqlite3 *)database
{
    BOOL status = FALSE;
    
    if([stateIds count] == [stateNames count])
    {
        for (int i=0; i<[stateIds count]; i++)
        {
            NSString* sql = [NSString stringWithFormat:@"INSERT INTO STATES VALUES('%@','%@')", [stateIds objectAtIndex:i], [stateNames objectAtIndex:i]];
            //Insert State
            char ** errorMsg=nil;
            sqlite3_exec(database,[sql UTF8String], NULL, NULL, errorMsg);
            if(errorMsg==nil)
            {
                status=TRUE;
            }
            else
            {
                status=FALSE;
                NSData *error = [NSData dataWithBytes:errorMsg length:sizeof(errorMsg)];
                ErrorLog(@"%@",error);
                break;
            }
        }
    }
    
    return status;
}

-(BOOL)insertCitiesFrom:(NSDictionary*)stateCityDictionary intoDatabase:(sqlite3 *)database
{
    BOOL status = FALSE;
    
    for (NSString *stateId in [stateCityDictionary allKeys])
    {
        NSDictionary *cityInfo = [stateCityDictionary objectForKey:stateId];
        NSArray *cityIds = [cityInfo objectForKey:@"cityId"];
        NSArray *cityNames = [cityInfo objectForKey:@"cityName"];
        
        if([cityIds count] == [cityNames count])
        {
            for (int i=0; i<[cityIds count]; i++)
            {
                NSString* sql = [NSString stringWithFormat:@"INSERT INTO CITY VALUES('%@','%@','%@')",[cityIds objectAtIndex:i],[cityIds objectAtIndex:i],stateId];
                
                //Insert City
                char ** errorMsg=nil;
                sqlite3_exec(database,[sql UTF8String], NULL, NULL, errorMsg);
                if(errorMsg==nil)
                {
                    status=TRUE;
                }
                else
                {
                    status=FALSE;
                    NSData *error = [NSData dataWithBytes:errorMsg length:sizeof(errorMsg)];
                    ErrorLog(@"%@",error);
                    break;
                }
            }
            
            if(status==FALSE)
            {
                break;
            }
        }
        else
        {
            status = FALSE;
            break;
        }
    }
    
    return status;
}

-(BOOL)insertZipsFrom:(NSDictionary*)cityZipDictionary intoDatabase:(sqlite3 *)database
{
    BOOL status = FALSE;
    
    for (NSString *cityId in [cityZipDictionary allKeys])
    {
        NSArray *zipCodes = [cityZipDictionary objectForKey:cityId];
        
        for (int i=0; i<[zipCodes count]; i++)
        {
            NSString* sql = [NSString stringWithFormat:@"INSERT INTO ZIP VALUES('%@','%@')",[zipCodes objectAtIndex:i],cityId];
            
            //Insert Zip Code
            char ** errorMsg=nil;
            sqlite3_exec(database,[sql UTF8String], NULL, NULL, errorMsg);
            if(errorMsg==nil)
            {
                status=TRUE;
            }
            else
            {
                status=FALSE;
                NSData *error = [NSData dataWithBytes:errorMsg length:sizeof(errorMsg)];
                ErrorLog(@"%@",error);
                
                break;
            }
        }
        
        if(status == FALSE)
        {
            break;
        }
    }
    
    return status;
}

-(BOOL)updateSyncDateForSyncType:(NSString *)syncType andSyncDate:(NSString *)syncDate inDatabase:(sqlite3 *)database
{
    BOOL status=FALSE;
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO SYNC VALUES('%@','%@')",syncDate,syncType];
    
    //Update SyncDate
    char ** errorMsg=nil;
    sqlite3_exec(database,[sql UTF8String], NULL, NULL, errorMsg);
    if(errorMsg==nil)
    {
        status=TRUE;
    }
    else
    {
        status=FALSE;
        NSData *error = [NSData dataWithBytes:errorMsg length:sizeof(errorMsg)];
        ErrorLog(@"%@",error);
    }
    return status;
}
#pragma mark -

#pragma mark Fetch Database Content
-(NSArray *)fetchStates
{
    NSMutableArray * states=[[NSMutableArray alloc]init];
    
    NSString*sql = [NSString stringWithFormat:@"Select * from States"];
    
    const char *query_stmt = [sql UTF8String];
    
    sqlite3_stmt*statement;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                
                //NSString * stateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                [states addObject:title];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            ErrorLog(@"Error Preparing Query - Fetch States");
        }
        sqlite3_close(db);
    }
    else
    {
        ErrorLog(@"Error Opening Database - Fetch States");
        sqlite3_close(db);
    }
    
    return states;
}

-(NSArray *)fetchCityforState:(NSString *)stateId
{
    
    NSMutableArray * city =[[NSMutableArray alloc]init];
    
    NSString*sql = [NSString stringWithFormat:@"Select * from city  where CITY.STATE_ID='%@'",stateId];
    
    const char *query_stmt = [sql UTF8String];
    
    sqlite3_stmt*statement;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                NSString *title = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                [city addObject:title];
            }
            sqlite3_finalize(statement);
            
        }
        else
        {
            ErrorLog(@"Error Preparing Query - Fetch City for States");
        }
        sqlite3_close(db);
    }
    else
    {
        ErrorLog(@"Error Opening Database - Fetch City for States");
        sqlite3_close(db);
    }
    
    return city;
}

-(NSString *)fetchStateIdforName:(NSString *)stateName
{
    NSString*sql = [NSString stringWithFormat:@"Select state_id from states where state_name= '%@'",stateName];
    
    const char *query_stmt = [sql UTF8String];
    
    sqlite3_stmt*statement;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                
                NSString * stateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                return stateID;
            }
        }
        else
        {
            ErrorLog(@"Error Preparing Query - Fetch State ID");
        }
        sqlite3_close(db);
    }
    else
    {
        ErrorLog(@"Error Opening Database - Fetch State ID");
        sqlite3_close(db);
    }
    
    return nil;
}

-(NSString *)fetchSyncDateForSyncType:(NSString *)syncType
{
    NSString*sql = [NSString stringWithFormat:@"select sync_date from sync where sync_type='%@'",syncType];
    
    const char *query_stmt = [sql UTF8String];
    
    sqlite3_stmt*statement;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                
                NSString * date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                return date;
            }
        }
    }
    else
        sqlite3_close(db);
    return nil;
}

-(NSString *)fetchCityIdforName:(NSString *)cityName
{
    NSString*sql = [NSString stringWithFormat:@"Select city_id from city where city_name= '%@'",cityName];
    
    const char *query_stmt = [sql UTF8String];
    
    sqlite3_stmt*statement;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                
                NSString * stateID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                return stateID;
            }
        }
        else
        {
            ErrorLog(@"Error Preparing Query - Fetch City ID");
        }
        sqlite3_close(db);
    }
    else
    {
        ErrorLog(@"Error Opening Database - Fetch City ID");
        sqlite3_close(db);
    }
    
    return nil;
}

-(BOOL)isZipExists:(NSString *)zipCode inState:(NSString *)stateId andCity:(NSString *)cityId
{
    //Bug 616
    if ([zipCode hasPrefix:@"00"]) {
        zipCode=[zipCode substringFromIndex:2];
    }
    if ([zipCode hasPrefix:@"0"]) {
        zipCode=[zipCode substringFromIndex:1];
    }
    BOOL status=FALSE;
    NSString*sql;
    if(cityId!=nil && [cityId length]>0)
    {
        sql = [NSString stringWithFormat:@"Select * from zip where CITY_ID= '%@' and ZIP_CODE='%@'",cityId,zipCode];
    }
    else
    {
        sql = [NSString stringWithFormat:@"Select * from city,zip where zip.CITY_ID=city.CITY_ID   and zip.ZIP_CODE='%@' and city.STATE_ID='%@'",zipCode,stateId];
    }
    const char *query_stmt = [sql UTF8String];
    
    sqlite3_stmt*statement;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
    {
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, nil)==SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                sqlite3_finalize(statement);
                status=TRUE;
                break;
            }
        }
        else
        {
            ErrorLog(@"Error Preparing Query - isZipExistsInState");
        }
        sqlite3_close(db);
    }
    else
    {
        ErrorLog(@"Error Opening Database - isZipExistsInState");
        sqlite3_close(db);
    }
    
    return status;
}
#pragma mark -

#pragma mark Database Handlers
+ (NSString *)getDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) ;
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    NSString *databaseFolderPath = [applicationSupportDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]]];
    
    return [databaseFolderPath stringByAppendingPathComponent:DATABASE_NAME];
}

+(NSString*)getTempDatabasePath
{
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *tempDatabasePath = [tempDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Temp_%@", DATABASE_NAME]];
    
    return tempDatabasePath;
}

+(NSString*)getNewDatabasePath
{
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *newDatabasePath = [tempDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"New_%@", DATABASE_NAME]];
    
    return newDatabasePath;
}

-(BOOL)swapOldDbWithNewDb
{
    BOOL status = FALSE;
    
    //Copy Old database to temp location as backup
    [Utilities copyDatabaseFrom:databasePath to:tempDatabasePath];
    
    //Copy New database to path from where it will be used in app
    if([Utilities copyDatabaseFrom:newDatabasePath to:databasePath])
    {
        status = TRUE;
    }
    else
    {
        //If New database copying fails then load backup from temp location
        if([Utilities copyDatabaseFrom:tempDatabasePath to:databasePath])
        {
            //If copying backup fails then copy db from resources
            [Utilities copyDatabaseFromResources];
        }
    }
    
    //Cleanup
    [Utilities copyDatabaseFrom:newDatabasePath to:nil];
    [Utilities copyDatabaseFrom:tempDatabasePath to:nil];
    
    return status;
}
#pragma mark -

@end
