//
//  CustomModalViewBO.m
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/4/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "CustomModalViewBO.h"
//#import "DataManager.h"

@implementation CustomModalViewBO

@synthesize customModalInputDict;
@synthesize customModalSectionArray;
@synthesize customModalRowArray;

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        customModalInputDict = [[NSMutableDictionary alloc] init];
        customModalSectionArray = [[NSMutableArray alloc] init];
        customModalRowArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
