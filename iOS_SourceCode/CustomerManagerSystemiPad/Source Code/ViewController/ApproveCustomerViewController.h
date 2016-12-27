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
#import "CDFFlagModalViewController.h"

@interface ApproveCustomerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, ListViewCustomDelegate, CustomerDataOfCustomTableViewDelegate, CustomerDataOfMLPModalViewDelegate,DuplicateAddressRemovalOfMLPModalViewProtocol, CDFFlagForMLPOfMLPModalViewProtocol, MLPSearchPageOfMLPModalViewProtocol>


@end
