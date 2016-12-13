//
//  MapFulScreenViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 10/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionClass.h"
#import "ListViewController.h"

@interface MapFullScreenViewController : UIViewController<UIPopoverControllerDelegate, ListViewCustomDelegate>
-(void)setTitle:(NSString *)title withSnippet:(NSString *)snippet ofAddress:(NSString *)address;

@end
