//
//  SSOViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 06/09/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionClass.h"

@protocol SSOCustomDelegate
-(void)ssoLoginisSucessFul:(BOOL)isSucessfull withCallbackParameters:(NSDictionary *)calbackParams;
@end


@interface SSOViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic, strong) id<SSOCustomDelegate> delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withParameters:(NSDictionary *)params;

-(void)userSessionTimeoutRetry;/*Add UIAlertController*/

@end
