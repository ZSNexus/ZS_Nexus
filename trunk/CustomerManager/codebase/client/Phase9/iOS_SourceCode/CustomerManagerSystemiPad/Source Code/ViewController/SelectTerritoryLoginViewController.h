//
//  SelectTerritoryLoginViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "SSOViewController.h"

@interface SelectTerritoryLoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, ListViewCustomDelegate, UIPopoverControllerDelegate, UITextFieldDelegate>
{
    NSIndexPath         *m_selectedIndexPath;
}

@end
