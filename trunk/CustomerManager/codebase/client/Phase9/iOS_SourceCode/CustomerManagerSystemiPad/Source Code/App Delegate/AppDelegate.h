//
//  AppDelegate.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionClass.h"
@class LoginViewController;
@class SelectTerritoryLoginViewController;//Added for HO user

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UINavigationController *nvc;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) SelectTerritoryLoginViewController *terriotaryViewController;

-(void)Logout;
-(NSString*)getUserDefaultsForKey:(NSString*)key;
-(void)resetAppForTerritoryChange;
-(void)updateZipLovDatabase;
-(void)startSpinnerWithMessage:(NSString*)msgString;
-(void)dismissSpinner;
-(void)displayHOUserHomePage;//to display HO User home page on button click
-(void)userSessionExpireAction; /*Add UIAlertController*/

@end
