//
//  ErrroPopOverContentViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 17/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

//Custom non editable, non selectable TextView
@interface CustomNonSelectableTextView : UITextView

@end

@interface ErrroPopOverContentViewController : UIViewController

@property(nonatomic,assign) IBOutlet UILabel *titleLabel;
@property(nonatomic,assign) IBOutlet UIView *searchResultView;
@property(nonatomic,assign) IBOutlet CustomNonSelectableTextView *midView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(NSString*)infoStr;

@end
