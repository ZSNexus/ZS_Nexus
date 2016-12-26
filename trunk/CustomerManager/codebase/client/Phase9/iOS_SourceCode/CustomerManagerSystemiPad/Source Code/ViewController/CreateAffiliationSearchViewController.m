//
//  CreateAffiliationSearchViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 20/10/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import "CreateAffiliationSearchViewController.h"
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

@interface CreateAffiliationSearchViewController ()
{
    CGFloat topOffset;
    CGRect originalTableFrame;
}
@end

@implementation CreateAffiliationSearchViewController
@synthesize titleLabel, subTitleString, subTitleLabel;
@synthesize searchButton;
@synthesize customTableViewController;
@synthesize errorMessageLabel;
@synthesize nameLbl;
@synthesize nameAnsLabel;
@synthesize primarySpeLabel;
@synthesize primarySpeAnsLabel;
@synthesize secSpeLabel;
@synthesize secSpeAnsLabel;
@synthesize masterIDLabel;
@synthesize masterIDAnsLabel;
@synthesize NPILabel;
@synthesize NPIAnsLabel;
@synthesize searchDescriptionText;
@synthesize detailsView;

#pragma mark - Initialization: View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) setFonts
{
    [NPIAnsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [NPILabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [masterIDAnsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [masterIDLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [secSpeAnsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [secSpeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [primarySpeAnsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [nameAnsLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:18.0]];
    [nameLbl setFont:[UIFont fontWithName:@"Roboto-Bold" size:18.0]];
    [primarySpeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [searchDescriptionText setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
    [searchDescriptionText setTextColor:[UIColor redColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFonts];
    // Do any additional setup after loading the view from its nib.
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:20.0]];
    [self.titleLabel setTextColor:THEME_COLOR];
    
    
    //Add subTitle to view if applicable
    if([self.subTitleString length] > 0)
    {
        [subTitleLabel setText:self.subTitleString];
        [subTitleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
        [subTitleLabel setTextColor:THEME_COLOR];
        [subTitleLabel setBackgroundColor:[UIColor clearColor]];
        
        [subTitleLabel setHidden:NO];
        
        //Set top offset
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
    
    self.customTableViewController.textFieldEventsDelegate = self;
    originalTableFrame = self.customTableViewController.tableView.frame;
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

-(void)textFieldEditingStarted
{
    CGRect tableFrame = self.customTableViewController.tableView.frame;
    tableFrame.origin.y = detailsView.frame.origin.y;//CGRectGetMaxY(subTitleLabel.frame);
    tableFrame.size.height = self.customTableViewController.tableView.frame.size.height;
    self.customTableViewController.tableView.frame = tableFrame;
    detailsView.hidden = YES;
    searchDescriptionText.hidden = YES;
    
}

-(void)textFieldEditingEnded
{
    self.customTableViewController.tableView.frame = originalTableFrame;
    detailsView.hidden = NO;
    searchDescriptionText.hidden = NO;
}

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
        subTitleFrame.origin.y = (errorMsg ? CGRectGetMaxY(self.errorMessageLabel.frame) : topOffset);
        subTitleLabel.frame = subTitleFrame;
    }
    
    //Adjust table position
    //CGRect tableFrame = self.customTableViewController.view.frame;
    //tableFrame.origin.y = ([subTitleString length] ? CGRectGetMaxY(self.subTitleLabel.frame) : (errorMsg ? CGRectGetMaxY(self.errorMessageLabel.frame) : CGRectGetMaxY(topBarView.frame)));
    //self.customTableViewController.view.frame = tableFrame;
}
#pragma mark -

@end
