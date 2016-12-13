//
//  AddCustomerViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 08/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "ConnectionClass.h"
#import "CustomModalViewController.h"

@interface AddCustomerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ListViewCustomDelegate,UIPopoverControllerDelegate,CustomerDataDelegate,UIAlertViewDelegate>

@end
