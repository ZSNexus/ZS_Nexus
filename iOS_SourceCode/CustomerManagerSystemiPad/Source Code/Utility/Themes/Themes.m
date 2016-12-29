//
//  Themes.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 07/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "Themes.h"
#import "QuartzCore/QuartzCore.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation Themes
//For Login and Home Page Theme
+(void)setBackgroundTheme1:(UIView *)view
{
    //Change background of View Fill Gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:253.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor], (id)[THEME_COLOR CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

+(UIView *)setNavigationBarNormal:(NSString * )title ofViewController:(NSString *)viewController
{
    //Customize Top Navigation Bar
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1010,44)];
    [topBarView setBackgroundColor:[UIColor clearColor]];
    [topBarView setAutoresizesSubviews:YES];
    [topBarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    //Client Logo Image
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(15,1,58,42)];
    [imageview setImage:[UIImage imageNamed:@"Nexus_Logo_white"]];
    [topBarView addSubview:imageview];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 44, 24)];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setTextColor:[UIColor whiteColor]];
    [versionLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:12.0]];
    [versionLabel setText:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [versionLabel setTextAlignment:NSTextAlignmentLeft];
    CGRect versionLabelFrame = versionLabel.frame;
    versionLabelFrame.origin = CGPointMake(CGRectGetMinX(imageview.frame) + 65, CGRectGetMaxY(imageview.frame)/2 +5);
    [versionLabel setFrame:versionLabelFrame];

    [topBarView addSubview:versionLabel];
    
    //Title
    UILabel *titleTop=[[UILabel alloc] initWithFrame:CGRectMake(0,0,300,44)];
    [titleTop setBackgroundColor:[UIColor clearColor]];
    [titleTop setTextColor:[UIColor whiteColor]];
    [titleTop setFont:[UIFont fontWithName:@"Roboto-Bold" size:18.0]];
    titleTop.text=title;
    [titleTop setTextAlignment:NSTextAlignmentCenter];
    
    CGRect titleLabelFrame = titleTop.frame;
    titleLabelFrame.origin = CGPointMake((CGRectGetWidth(topBarView.frame) - CGRectGetWidth(titleLabelFrame))/2 - (1010 - CGRectGetWidth(topBarView.frame))/2, 0);
    [titleTop setFrame:titleLabelFrame];
    
    [topBarView addSubview:titleTop];
    [titleTop setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    
    //Dont Show Logout , Line separator , Login UserName and Territory on Login
    if(![viewController isEqualToString:@"Login"])
    {
        //Login User Name and Territory
        UILabel *userName=[[UILabel alloc] initWithFrame:CGRectMake(0,0,170,18)];
        [userName setBackgroundColor:[UIColor clearColor]];
        [userName setTextColor:[UIColor whiteColor]];
        userName.tag=10;
        [userName setFont:[UIFont fontWithName:@"Roboto-Bold" size:10.0]];
        [userName setTextAlignment:NSTextAlignmentRight];
        
        CGRect userNameLabelFrame = userName.frame;
        userNameLabelFrame.origin = CGPointMake(CGRectGetWidth(topBarView.frame) - CGRectGetWidth(userNameLabelFrame) - 13, 1);
        [userName setFrame:userNameLabelFrame];
        
        [topBarView addSubview:userName];
        [userName setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        UILabel *territory=[[UILabel alloc] initWithFrame:CGRectMake(0,0,170,23)];
        [territory setBackgroundColor:[UIColor clearColor]];
        [territory setTextColor:[UIColor whiteColor]];
        territory.tag=11;
        [territory setFont:[UIFont fontWithName:@"Roboto-Bold" size:10.0]];
        [territory setTextAlignment:NSTextAlignmentRight];
        [territory setNumberOfLines:0];
        [territory setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect territoryLabelFrame = territory.frame;
        territoryLabelFrame.origin = CGPointMake(CGRectGetWidth(topBarView.frame) - CGRectGetWidth(territoryLabelFrame) - 13, 18);
        [territory setFrame:territoryLabelFrame];
        
        [topBarView addSubview:territory];
        [territory setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        //Line Separator
        UIView *lineSeparator=[[UIView alloc] initWithFrame:CGRectMake(0,0,1,36)];
        [lineSeparator setBackgroundColor:[UIColor whiteColor]];
        
        CGRect lineSeparatorViewFrame = lineSeparator.frame;
        lineSeparatorViewFrame.origin = CGPointMake(CGRectGetMinX(userName.frame) - 2, (CGRectGetHeight(topBarView.frame) - CGRectGetHeight(lineSeparatorViewFrame))/2);
        [lineSeparator setFrame:lineSeparatorViewFrame];
        
        [topBarView addSubview:lineSeparator];
        [lineSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        //Logout Button
        UIButton * logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logOutBtn.frame= CGRectMake(0, 0, 44, 44);
        [logOutBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_logout"]]];;
        [logOutBtn setTag:1];
        [logOutBtn setImage:[UIImage imageNamed:@"btn_logout_clicked"] forState:UIControlStateHighlighted];
        
        CGRect logOutBtnFrame = logOutBtn.frame;
        logOutBtnFrame.origin = CGPointMake(CGRectGetMinX(lineSeparator.frame) - 47, 0);
        [logOutBtn setFrame:logOutBtnFrame];
        
        [topBarView addSubview:logOutBtn];
        [logOutBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        if(![viewController isEqualToString:@"SelectTerritoryLogin"])
        {
            //Change Territory
            UIButton * chnageTerritoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chnageTerritoryBtn.frame= CGRectMake(0, 0, 44, 44);
            [chnageTerritoryBtn setTag:3];
            [chnageTerritoryBtn setImage:[UIImage imageNamed:@"btn_territory"] forState:UIControlStateNormal];
            [chnageTerritoryBtn setImage:[UIImage imageNamed:@"btn_territory_clicked"] forState:UIControlStateSelected];
            
            CGRect chnageTerritoryBtnFrame = chnageTerritoryBtn.frame;
            chnageTerritoryBtnFrame.origin = CGPointMake(CGRectGetMinX(logOutBtn.frame) - 70, 0);
            [chnageTerritoryBtn setFrame:chnageTerritoryBtnFrame];
            
            [topBarView addSubview:chnageTerritoryBtn];
            [chnageTerritoryBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            
            //Disable change territory button for single territory user
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([[defaults objectForKey:@"NoOfRoles"] isEqualToString:@"1"])
            {
                [chnageTerritoryBtn setEnabled:NO];
            }
            else
            {
                [chnageTerritoryBtn setEnabled:YES];
            }
            
            if([viewController isEqualToString:@"AddCustomerDetails"] || [viewController isEqualToString:@"SearchCustomers"])
            {
                //Add New Customer
                UIButton * addNewCustomerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addNewCustomerBtn.frame= CGRectMake(0, 0, 44, 44);
                [addNewCustomerBtn setTag:4];
                [addNewCustomerBtn setImage:[UIImage imageNamed:@"btn_add_new"] forState:UIControlStateNormal];
                [addNewCustomerBtn setImage:[UIImage imageNamed:@"btn_add_new_clicked"] forState:UIControlStateHighlighted];
                
                CGRect addNewCustomerBtnFrame = addNewCustomerBtn.frame;
                addNewCustomerBtnFrame.origin = CGPointMake(CGRectGetMinX(chnageTerritoryBtn.frame) - 70, 0);
                [addNewCustomerBtn setFrame:addNewCustomerBtnFrame];
                
                [topBarView addSubview:addNewCustomerBtn];
                [addNewCustomerBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            }
            
            //Created Home button for Ho User
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            if ([[standardDefaults objectForKey:HO_USER]isEqualToString:@"Y"]) {
                UIButton * hoUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                hoUserBtn.frame= CGRectMake(0, 0, 44, 44);
                [hoUserBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home-icon"]]];
                [hoUserBtn setTag:1101];
                [hoUserBtn setImage:[UIImage imageNamed:@"home-icon_clicked"] forState:UIControlStateHighlighted];
                
                CGRect hoUserBtnFrame = hoUserBtn.frame;
                hoUserBtnFrame.origin = CGPointMake(CGRectGetMinX(versionLabel.frame) + 40, 0);
                [hoUserBtn setFrame:hoUserBtnFrame];
                
                [topBarView addSubview:hoUserBtn];
                [hoUserBtn setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
            }
        }
    }
    
    return topBarView;
}

+(void)refreshTerritory:(NSArray *)subviews
{
    //Set Territory And UserName Text on Navigation Bar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
    for(UILabel* lbl in subviews)
    {
        //UserName Label Tag is 10 and Territory is 11 on top bar
        if(lbl.tag==10)
        {
            if([loggedInUser objectForKey:@"FullName"]!=nil)
            {
                [lbl setText:[NSString stringWithFormat:@"%@",[loggedInUser objectForKey:@"FullName"]]];
            }
        }
        else if(lbl.tag==11)
        {
            if([defaults objectForKey:@"SelectedTerritoryName"]!=nil)
            {
                [lbl setText:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"SelectedTerritoryName"]]];
            }
        }
    }
}
@end
