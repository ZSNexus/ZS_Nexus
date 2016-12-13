//
//  PopOverContentViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 17/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverContentViewController : UIViewController

@property(nonatomic,assign) IBOutlet UILabel *infoText;
@property(nonatomic,assign) IBOutlet UILabel *messsageText;
@property(nonatomic,assign) IBOutlet UIView *infoView;
@property(nonatomic,assign) IBOutlet UILabel *titleLabel;
@property(nonatomic,assign) IBOutlet UIView *searchResultView;
@property(nonatomic,assign) IBOutlet UIView *midView;
@property(nonatomic,assign) IBOutlet UILabel *infoTextDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoText:(NSString*)infoText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoText:(NSString*)infoStr andMessageText:(NSString*)msgText;

@end
