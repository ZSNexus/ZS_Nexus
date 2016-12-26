//
//  CustomModalViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Ameer on 7/4/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "CustomModalViewController.h"
#import "CustomModalTableViewCell.h"
#import "ListViewController.h"
#import "DataManager.h"
#import "Constants.h"
#import "CustomerObject.h"
#import "AddressObject.h"
#import "DatabaseManager.h"
#import "AddCustomerSearchDetailsViewController.h"
#import "RemoveCustomerViewController.h"
#import "RequestsViewController.h"

@interface CustomModalViewController ()
{
    CGFloat topOffset;
}

@end

@implementation CustomModalViewController

@synthesize titleLabel, subTitleString, subTitleLabel;
@synthesize searchButton;
@synthesize customTableViewController;
@synthesize errorMessageLabel;

#pragma mark - Initialization: View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:20.0]];
    [self.titleLabel setTextColor:THEME_COLOR];
    
	//self.customTableViewController.tableView.layer.cornerRadius=10.0f;
    self.customTableViewController.tableView.layer.borderWidth=0.0f;
    //self.customTableViewController.tableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    //Add subTitle to view if applicable
    if([self.subTitleString length] > 0)
    {
        [subTitleLabel setText:self.subTitleString];
        [subTitleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
        [subTitleLabel setTextColor:THEME_COLOR];
        [subTitleLabel setBackgroundColor:[UIColor clearColor]];
        
        [subTitleLabel setHidden:NO];
        
        //Set top offset
        //topOffset = CGRectGetMinY(subTitleLabel.frame);
        topOffset = CGRectGetMinY(subTitleLabel.frame);

        //Adjust position of Table
        CGRect tableFrame = self.customTableViewController.tableView.frame;
        tableFrame.origin.y = CGRectGetMaxY(subTitleLabel.frame);
        self.customTableViewController.tableView.frame = tableFrame;
    }
    else
    {
        topOffset = 0.0;
    }
    
    [self.searchButton addTarget:self.customTableViewController action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //TODO: find better way to enable/disable buttons on navigation bar
    //Fix for demo 22 July
    //Disable Add new customer button from navigation bar if present
    for (UIButton *button in self.parentViewController.navigationItem.titleView.subviews) {
        if(button.tag == 4)
        {
            [button setEnabled:NO];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //TODO: find better way to enable/disable buttons on navigation bar
    //Fix for demo 22 July
    //Enable Add new customer button from navigation bar if present and view is being moved from parent
    if(self.isMovingFromParentViewController)
    {
        for (UIButton *button in self.parentViewController.navigationItem.titleView.subviews) {
            if(button.tag == 4)
            {
                NSUserDefaults *onOffUserDefault = [NSUserDefaults standardUserDefaults];
                NSDictionary *onOffDictionary = [onOffUserDefault objectForKey:ADD_REMOVE_USER_DEFAULT_KEY];
                NSDictionary *terriotaryId = [onOffDictionary objectForKey:[onOffUserDefault objectForKey:@"SelectedTerritoryId"]];
                if ([[onOffUserDefault objectForKey:HO_USER] isEqualToString:@"Y"]) {
                    [button setEnabled:NO];
                    
                }
                else if ([[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_INDV_KEY]||[[terriotaryId objectForKey:TERRIOTARY_ONOFF_KEY] containsString:ADD_ORG_KEY])
                    [button setEnabled:NO];
                else
                    [button setEnabled:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark View Handlers
-(IBAction) click_Cancel:(id)sender
{
    //TODO: Set delegate to handle various Cancel calls  from different view controllers and set identfier to differentiate  various calls from different view controllers.
    CGRect viewFrame = self.view.frame;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view setFrame:CGRectMake(viewFrame.origin.x, viewFrame.origin.y + CGRectGetHeight(viewFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame))];
                     }
                     completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         self.view = nil;
                     }];
}

-(void)displayErrorMessage:(NSString *)errorMsg
{
    if(![errorMsg length])
    {
        [self.errorMessageLabel setText:nil];
        [self.errorMessageLabel setHidden:YES];
    }
    else
    {
        [self.errorMessageLabel setText:errorMsg];
        [self.errorMessageLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
        
        [self.errorMessageLabel setHidden:NO];
        [self.view bringSubviewToFront:self.errorMessageLabel];
    }

    //Adjust labels and table positions as required
    //Adjust subtitle position
    if([subTitleString length])
    {
        CGRect subTitleFrame = subTitleLabel.frame;
        subTitleFrame.origin.y = (errorMsg ? (CGRectGetMaxY(self.errorMessageLabel.frame)+50) : topOffset);
        //subTitleLabel.frame = subTitleFrame;
        return;
    }
    
    //Adjust table position
    CGRect tableFrame = self.customTableViewController.view.frame;
    tableFrame.origin.y = ([subTitleString length] ? CGRectGetMaxY(self.subTitleLabel.frame) : (errorMsg ? CGRectGetMaxY(self.errorMessageLabel.frame) : CGRectGetMaxY(topBarView.frame)));
    self.customTableViewController.view.frame = tableFrame;
}
#pragma mark -

@end
