//
//  DataManager.m
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 6/25/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "DataManager.h"
#import "CustomModalViewBO.h"
#import "Constants.h"

static DataManager *sharedInstance = nil;

@implementation DataManager

@synthesize isIndividualSegmentSelectedForAddCustomer,isIndividualSegmentSelectedForRemoveCustomer,isIndividualSegmentSelectedForRequest,isDefaultRequestForRemoveCustomer,isDefaultRequestForRequests,isDefaultRequestForReviews;
@synthesize popOverArrayDict;


+(DataManager *) sharedObject
{
    @synchronized (self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self preparePopOverArrays];
    }
    return self;
}

- (void) preparePopOverArrays
{
    NSArray *cityArray = [NSArray arrayWithObjects:@"Absecon",@"Atlantic City",@"Brigantine",@"Buena",@"Buena Vista",@"Egg Harbor City",@"Egg Harbor Township",@"Galloway",@"Hamilton",@"Hammonton",@"Linwood",@"Margate City",@"Mullica",@"Northfield",@"Pleasantville",@"Somers Point"
                          @"Ventnor City", nil];
    
    NSArray *stateArray =[NSArray arrayWithObjects:@"Arizona",@"New Jersey",@"New York",@"Texas", nil];
    
    NSArray *professionalDesignationArray = [ NSArray arrayWithObjects:@"MD", @"prescriber", nil];
    
    NSArray *territoryArray=[[JSONDataFlowManager sharedInstance]TerritoryArray];
    
    NSArray* orgTypeArray=[NSArray arrayWithObjects:@"Clinic",@"Group Practice",@"Hospital", nil];
    
    NSArray* statusArray=[NSArray arrayWithObjects:@"Pending Verification",@"Sent for Processing",@"Sent to SFA",@"Completed", nil];
    
    
    self.popOverArrayDict = [[NSDictionary alloc] initWithObjectsAndKeys:cityArray,CITY_KEY, stateArray,STATE_KEY, professionalDesignationArray,@"Professional Designation", territoryArray, @"Territory", orgTypeArray,ORG_TYPE_KEY, statusArray,REQ_STATUS_KEY, nil];
}



@end
