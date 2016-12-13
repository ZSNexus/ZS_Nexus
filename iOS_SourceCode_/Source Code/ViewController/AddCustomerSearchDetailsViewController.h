//
//  AddCustomerSearchDetailsViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 12/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "ConnectionClass.h"
#import "CustomModalViewController.h"
#import "MLPModalViewController.h"
#import "CDFFlagModalViewController.h"
@interface AddCustomerSearchDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ListViewCustomDelegate,UIPopoverControllerDelegate, CustomerDataDelegate,CDFFlagForMLPProtocol, MLPSearchPageProtocol>

@property(nonatomic,retain) NSMutableDictionary* searchParameters;
@property(nonatomic,retain)NSArray* custData;

@end
