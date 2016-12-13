//
//  RequestsViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 08/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionClass.h"
#import "ListViewController.h"
#import "CustomModalViewController.h"
#import "AlignNewAddressViewController.h"
@interface RequestsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ListViewCustomDelegate,UIPopoverControllerDelegate,CustomerDataDelegate,UIAlertViewDelegate,UIScrollViewDelegate,AlignNewAddressDelegate>

@end
