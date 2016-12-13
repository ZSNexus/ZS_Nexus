//
//  AdvancedSearchViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 10/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "ConnectionClass.h"
#import "CustomTableViewController.h"

@interface AdvancedSearchViewController : UIViewController<ListViewCustomDelegate, UIPopoverControllerDelegate, CustomerDataDelegate>

@property (nonatomic, strong) CustomTableViewController *customTableViewController;
@property (nonatomic, strong) IBOutlet UIView *tableContainerView;
@property (nonatomic, strong) NSMutableDictionary *searchParameters;
@end
