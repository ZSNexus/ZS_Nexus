//
//  TicketIdContentViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 17/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

//Custom non editable, non selectable TextView
@interface CustomNonSelectableTextViewForTicketId : UITextView

@end

@interface TicketIdContentViewController : UIViewController

@property(nonatomic,assign) IBOutlet UILabel *titleLabel;
@property(nonatomic,assign) IBOutlet UIView *searchResultView;
@property(nonatomic,assign) IBOutlet CustomNonSelectableTextViewForTicketId *midView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(NSString*)infoStr;

@end
