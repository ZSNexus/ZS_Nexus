//
//  ConnectionClass.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 18/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionClass : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

+(ConnectionClass *) sharedSingleton;
+(void)cancelNSUrlConnectionForIdentifier:(NSString *)identifier;
+(BOOL)isConnectionInProgressForIdentifier:(NSString*)identifier;

typedef void (^CMConnectionCallback)(NSMutableData* data, NSString* identifier, NSString* error);

-(void)fetchDataFromUrl:(NSString *)url withParameters:(NSDictionary *)params forConnectionIdentifier:(NSString *)identifier andConnectionCallback:(CMConnectionCallback)callback;

@end