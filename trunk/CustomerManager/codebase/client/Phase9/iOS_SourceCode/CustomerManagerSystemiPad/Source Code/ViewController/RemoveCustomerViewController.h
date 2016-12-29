//
//  RemoveCustomerViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 08/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionClass.h"
#import "ListViewController.h"
#import "CustomModalViewController.h"
#import "MLPModalViewController.h"
#import "MLPAddressViewController.h"
#import "AppDelegate.h"

@interface RemoveCustomerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate, UIAlertViewDelegate, ListViewCustomDelegate, CustomerDataDelegate, CustomerDataOfCustomTableViewDelegate, CustomerDataOfMLPModalViewDelegate,DuplicateAddressRemovalOfMLPModalViewProtocol, DuplicateAddressRemovalProtocol>


@end
