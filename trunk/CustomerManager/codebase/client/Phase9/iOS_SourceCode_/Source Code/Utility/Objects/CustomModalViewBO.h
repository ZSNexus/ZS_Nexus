//
//  CustomModalViewBO.h
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/4/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModalViewBO : NSObject

@property (nonatomic, strong) NSMutableDictionary *customModalInputDict;
@property (nonatomic, strong) NSMutableArray *customModalSectionArray; // Need to mentain section sequence only , else not needed.
@property (nonatomic, strong) NSMutableArray *customModalRowArray;

@end
