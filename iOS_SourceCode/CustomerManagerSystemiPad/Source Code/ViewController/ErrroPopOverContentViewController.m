//
//  ErrroPopOverContentViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 17/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "ErrroPopOverContentViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface ErrroPopOverContentViewController ()

@property(nonatomic,strong) NSString *info;

@end

@implementation ErrroPopOverContentViewController

@synthesize titleLabel,searchResultView,midView,info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(NSString*)infoStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        info=infoStr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomFontsToUIComponent:info];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCustomFontsToUIComponent:(NSString*)infoStr
{
    [searchResultView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right.png"]]];
    searchResultView.layer.cornerRadius=10.0f;
    searchResultView.layer.borderWidth=1.0f;
    searchResultView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    [midView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
    midView.layer.cornerRadius=10.0f;
    midView.layer.borderWidth=1.0f;
    midView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    [midView setText:infoStr];
}

@end

@implementation CustomNonSelectableTextView

-(BOOL)canBecomeFirstResponder
{
    return NO;
}

@end