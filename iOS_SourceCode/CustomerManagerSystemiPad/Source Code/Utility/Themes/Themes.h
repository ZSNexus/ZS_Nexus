//
//  Themes.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Themes : NSObject

+(UIView *)setNavigationBarNormal:(NSString * )title ofViewController:(NSString *)viewController;
+(void)setBackgroundTheme1:(UIView *)view;
+(void)refreshTerritory:(NSArray *)subviews;
@end
