//
//  LoginViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionClass.h"
#import "SSOViewController.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,UIWebViewDelegate,UITabBarControllerDelegate,SSOCustomDelegate>

@end
