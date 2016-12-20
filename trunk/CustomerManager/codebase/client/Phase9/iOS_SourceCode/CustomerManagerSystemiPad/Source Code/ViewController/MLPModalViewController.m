//
//  MLPModalViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 25/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import "MLPModalViewController.h"
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


@interface MLPModalViewController ()
{
    CGFloat topOffset;

    NSMutableArray *responseArray;
}


@property(nonatomic,strong) NSString * cdfFLagNameString;
@property(nonatomic,strong) NSString * cdfFLagPrimSpeString;
@property(nonatomic,strong) NSString * cdfFLagSecSpeString;
@property(nonatomic,strong) NSString * cdfFLagMasterIdString;
@property(nonatomic,strong) NSString * cdfFLagNPIString;



@end

@implementation MLPModalViewController

@synthesize titleLabel, subTitleString, subTitleLabel;
@synthesize searchButton;
@synthesize customTableViewController;
@synthesize errorMessageLabel;
@synthesize NPIAnsLabel;
@synthesize NPILabel;
@synthesize masterIDAnsLabel;
@synthesize masterIDLabel;
@synthesize secSpeAnsLabel;
@synthesize secSpeLabel;
@synthesize primarySpeAnsLabel;
@synthesize nameAnsLabel;
@synthesize nameLbl;
@synthesize primarySpeLabel;
@synthesize addressLabel;
@synthesize cdfFlagModalviewController;
@synthesize cdfFLagNameString;
@synthesize cdfFLagPrimSpeString;
@synthesize cdfFLagSecSpeString;
@synthesize cdfFLagMasterIdString;
@synthesize cdfFLagNPIString;
@synthesize responseArrayForCDF;
@synthesize mlpSearchPDelegate;
@synthesize allFlagsDMessage;
@synthesize isAllFlagD;

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
    [nameAnsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [nameLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [primarySpeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    [addressLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
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
        tableFrame.origin.x = CGRectGetMinX(subTitleLabel.frame)-50;
        self.customTableViewController.tableView.frame = tableFrame;
    }
    else
    {
        topOffset = 0.0;
    }
    
    //[self.searchButton addTarget:self.customTableViewController action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.customTableViewController.mlpDataDelegate = self;
    
    self.cdfFLagNameString = [[NSString alloc] init];
    self.cdfFLagPrimSpeString = [[NSString alloc] init];
    self.cdfFLagSecSpeString = [[NSString alloc] init];
    self.cdfFLagMasterIdString = [[NSString alloc] init];
    self.cdfFLagNPIString = [[NSString alloc] init];
    allFlagsDMessage = [[NSString alloc] init];
}

-(void) callFlagScreenwithName:(NSString *)name primarySpeciality:(NSString *)primarySpe secondarySpeciality:(NSString *)secondarySpe masterID:(NSString *)bpaId andNPI:(NSString *)npiValue
{
    
    cdfFLagNameString = name;
    cdfFLagPrimSpeString =primarySpe;
    cdfFLagSecSpeString = secondarySpe;
    cdfFLagMasterIdString = bpaId;
    cdfFLagNPIString = npiValue;
    
    
    if ([self.cdfProtocolDataDelegate respondsToSelector:@selector(setUpCDFFLagScreenwithName:primarySpeciality:secondarySpeciality:masterID:andNPI:)]) {
        [self.cdfProtocolDataDelegate setUpCDFFLagScreenwithName:name primarySpeciality:primarySpe secondarySpeciality:secondarySpe masterID:bpaId andNPI:npiValue];
    }
    //instead make  call to fetchdata and in receive response call showCDFFLagscreen method
    //--[self showCDFFLagScreen];
    //accept 5 parameters fo this funcion for name, npi etc
   
}


-(void)affiliateMLP
{
    //call parent from here
    if ([self.cdfProtocolDataDelegate respondsToSelector:@selector(affiliateMLPRequestWithString:)]) {
        [self.cdfProtocolDataDelegate affiliateMLPRequestWithString:cdfFLagMasterIdString];
    }
}

-(void)showCDFFLagScreenWithArray:(NSArray*)respArray
{
    //paste code to call screen here
    
    if(cdfFlagModalviewController)
    {
        cdfFlagModalviewController = nil;
    }
    
    
    
    
    
    //Set frame for animation
    //TODO:optimize CGRectMake below
    cdfFlagModalviewController = [[CDFFlagModalViewController alloc] initWithNibName:@"CDFFlagModalViewController" bundle:nil];
    CGFloat offset = CGRectGetMaxY(self.navigationItem.titleView.frame) + cdfFlagModalviewController.view.frame.size.height;
    cdfFlagModalviewController.view.frame=CGRectMake(cdfFlagModalviewController.view.frame.origin.x, offset, cdfFlagModalviewController.view.frame.size.width, cdfFlagModalviewController.view.frame.size.height);
    cdfFlagModalviewController.primarySpeAnsLabel.text = primarySpeAnsLabel.text;
    cdfFlagModalviewController.secSpeAnsLabel.text = secSpeAnsLabel.text;
    cdfFlagModalviewController.masterIDAnsLabel.text = masterIDAnsLabel.text;
    cdfFlagModalviewController.NPIAnsLabel.text = NPIAnsLabel.text;
    cdfFlagModalviewController.nameAnsLabel.text = nameAnsLabel.text;
    
    cdfFlagModalviewController.mdNameAnsLabel.text = cdfFLagNameString;
    cdfFlagModalviewController.mdPrimarySpeAnsLabel.text = cdfFLagPrimSpeString;
    cdfFlagModalviewController.mdSecondarySpeAnsLabel.text = cdfFLagSecSpeString;
    cdfFlagModalviewController.mdMAsterIdAnsLabel.text = cdfFLagMasterIdString;
    cdfFlagModalviewController.mdNpiAnsLabel.text = cdfFLagNPIString;
    cdfFlagModalviewController.mlpAffiliateProtocolDataDelegate = self;
    
    
    //Set data
    cdfFlagModalviewController.customTableViewController.customerDataDelegate = (id)self;
    cdfFlagModalviewController.customTableViewController.isIndividual = [[DataManager sharedObject]
                                                                         isIndividualSegmentSelectedForAddCustomer];
    //responseArray = [[NSMutableArray alloc] init];
    cdfFlagModalviewController.customTableViewController.dataArray = [[NSArray alloc] init];
    

    
    
    cdfFlagModalviewController.customTableViewController.dataArray = respArray;//responseArray;// to be declared on request sent
    //cdfFlagModalviewController.customTableViewController.popUpScreenTitle = MLP_SCREEN;
    
    
    if(isAllFlagD == YES)
    {
        cdfFlagModalviewController.dFlagsMessageLabel.text = allFlagsDMessage;
        cdfFlagModalviewController.dFlagsMessageLabel.hidden = NO;
        cdfFlagModalviewController.cancelButton.enabled = NO;
    }
    else
    {
        cdfFlagModalviewController.dFlagsMessageLabel.hidden = YES;
        cdfFlagModalviewController.cancelButton.enabled = YES;
    }
    
    [cdfFlagModalviewController.titleLabel setText:CDF_FLAG_SCREEN_TITLE];
    
    [self addChildViewController:cdfFlagModalviewController];
    [self.view addSubview:cdfFlagModalviewController.view];
    
    //Animate the view
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    cdfFlagModalviewController.view.frame=CGRectMake(cdfFlagModalviewController.view.frame.origin.x, cdfFlagModalviewController.view.frame.origin.y-offset, cdfFlagModalviewController.view.frame.size.width, cdfFlagModalviewController.view.frame.size.height);
    [UIView commitAnimations];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark -

#pragma mark View Handlers
-(IBAction) click_Cancel:(id)sender
{
    
    if([titleLabel.text isEqualToString:ALIGN_NEW_ADDRESS])
    {
        [self.view removeFromSuperview];
        return;
    }
   
    if(customTableViewController.isCellSelected <= 0  && [customTableViewController.popUpScreenTitle isEqualToString:DUPLICATE_ADDRESS_SCREEN])
    {
        /*Add UIAlertController
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:SELECT_ONE_DUPLICATE_ADDRESS delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];*/
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Error"  message:SELECT_ONE_DUPLICATE_ADDRESS  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:OK_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                /*Write No button click code here*/
            }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        //NSMutableString *reasonString = [[NSMutableString alloc] init];
        if([customTableViewController.popUpScreenTitle isEqualToString:DUPLICATE_ADDRESS_SCREEN])
        {
            //int count = 0;
            /*Add UIAlertController
            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:CONFIRM_DUPLICATE_ADDRESSES_SELECTED_TITLE message:CONFIRM_DUPLICATE_ADDRESSES_SELECTED_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:YES_STRING,NO_STRING, nil];
            [alertView show];*/
            UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:CONFIRM_DUPLICATE_ADDRESSES_SELECTED_TITLE  message:CONFIRM_DUPLICATE_ADDRESSES_SELECTED_MSG  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:YES_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSMutableString *reasonString = [[NSMutableString alloc] init];
                for(NSNumber * selectedValue in customTableViewController.selectedDuplicateAddressesArray)
                {
                    NSDictionary *item = [customTableViewController.dataArray objectAtIndex:[selectedValue intValue]];
                    //if(count == 0)
                    //[reasonString appendString:[item objectForKey:@"bpaId"]];
                    //else
                    [reasonString appendString:[NSString stringWithFormat:@",%@", [item objectForKey:@"bpaId"]]];
                    //count++;
                }
                if ([self.duplicateAddressDataDelegate respondsToSelector:@selector(getDuplicateAddressRemovalReasonWithString:)]) {
                    [self.duplicateAddressDataDelegate getDuplicateAddressRemovalReasonWithString:reasonString];
                }
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NO_STRING style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                /*Write No button click code here*/
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
//        if ([self.duplicateAddressDataDelegate respondsToSelector:@selector(getDuplicateAddressRemovalReasonWithString:)]) {
//            [self.duplicateAddressDataDelegate getDuplicateAddressRemovalReasonWithString:reasonString];
//        }
    }
    if([customTableViewController.popUpScreenTitle isEqualToString:MLP_SCREEN])
    {
        [self.view removeFromSuperview];
    }
}
- (IBAction)click_search:(id)sender {
    if([customTableViewController.popUpScreenTitle isEqualToString:MLP_SCREEN])
    {
        if ([self.mlpSearchPDelegate respondsToSelector:@selector(dismissSearchPage)]) {
            [self.mlpSearchPDelegate dismissSearchPage];
        }
    }
    else
    {
        [self.view removeFromSuperview];
    }
    //[self callFlagScreen];
}

-(void)getDataFromMLPTable
{
    
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
    CGRect tableFrame = self.customTableViewController.view.frame;
    tableFrame.origin.y = ([subTitleString length] ? CGRectGetMaxY(self.subTitleLabel.frame) : (errorMsg ? CGRectGetMaxY(self.errorMessageLabel.frame) : CGRectGetMaxY(topBarView.frame)));
    self.customTableViewController.view.frame = tableFrame;
}
#pragma mark -
/*Add UIAlertController
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0 && [alertView.title isEqualToString:CONFIRM_DUPLICATE_ADDRESSES_SELECTED_TITLE]) // Yes
    {
        //NSLog(@"Implement approve functionality");
        //implement the backend call for approve similar to the top code for withdraw
        NSMutableString *reasonString = [[NSMutableString alloc] init];
        for(NSNumber * selectedValue in customTableViewController.selectedDuplicateAddressesArray)
        {
            NSDictionary *item = [customTableViewController.dataArray objectAtIndex:[selectedValue intValue]];
            //if(count == 0)
            //[reasonString appendString:[item objectForKey:@"bpaId"]];
            //else
            [reasonString appendString:[NSString stringWithFormat:@",%@", [item objectForKey:@"bpaId"]]];
            //count++;
        }
        if ([self.duplicateAddressDataDelegate respondsToSelector:@selector(getDuplicateAddressRemovalReasonWithString:)]) {
            [self.duplicateAddressDataDelegate getDuplicateAddressRemovalReasonWithString:reasonString];
        }


        //[self.view removeFromSuperview];
    }
    else if(buttonIndex==1 && [alertView.title isEqualToString:CONFIRM_DUPLICATE_ADDRESSES_SELECTED_TITLE]) // Yes
    {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        //implement the backend call for reject similar to the top code for withdraw
    }
}*/


@end
