//
//  PopOverContentViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Jeevan Pawar on 17/10/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "PopOverContentViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface PopOverContentViewController ()

//@property(nonatomic,assign) IBOutlet UIView *infoView;
//@property(nonatomic,assign) IBOutlet UILabel *titleLabel;
//@property(nonatomic,assign) IBOutlet UIView *searchResultView;
//@property(nonatomic,assign) IBOutlet UIView *midView;
//@property(nonatomic,assign) IBOutlet UILabel *infoTextDetails;
@property(nonatomic,strong) NSString *info;
@property(nonatomic,strong) NSString *msgInfo;

@end

@implementation PopOverContentViewController

@synthesize infoView,messsageText,titleLabel,searchResultView,midView,infoText,infoTextDetails,info,msgInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoText:(NSString*)infoStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        info=infoStr;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoText:(NSString*)infoStr andMessageText:(NSString*)msgText
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        info=infoStr;
        msgInfo=msgText;
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
    [searchResultView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_right"]]];
    searchResultView.layer.cornerRadius=10.0f;
    searchResultView.layer.borderWidth=1.0f;
    searchResultView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    [midView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_add"]]];
    midView.layer.cornerRadius=10.0f;
    midView.layer.borderWidth=1.0f;
    midView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    [infoText setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
    [infoTextDetails setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
    [infoText setText:info];
    
    if(msgInfo != nil)
    {
        [messsageText setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
        [messsageText setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0]];
        [messsageText setText:msgInfo];
    }
}

@end
