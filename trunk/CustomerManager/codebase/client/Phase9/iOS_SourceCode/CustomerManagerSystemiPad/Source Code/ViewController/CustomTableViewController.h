//
//  CustomTableViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Shri on 24/07/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListViewController.h"
#import "CustomerObject.h"
#import "OrganizationObject.h"
#import "DatePickerViewController.h"
#import "RequestObject.h"

@protocol CustomerDataOfCustomTableViewDelegate

@required
-(void)processCustomerData:(NSArray *)data forIdentifier:(NSString*)identifier;
-(void)displayErrorMessage:(NSString *)errorMsg;

@optional
-(void)getCurrentScreenName:(BOOL)isSearchAffiliationPage withMasterId:(NSString*)masterId;
-(void)showSearchError;

@end


@protocol TextFiledEventsProtocol <NSObject>

-(void)textFieldEditingStarted;
-(void)textFieldEditingEnded;

@end

@interface CustomTableViewController : UITableViewController<UITextFieldDelegate, ListViewCustomDelegate, UIPopoverControllerDelegate, DatePickerViewControllerDelegate>
{
    NSIndexPath         *m_selectedIndexPath;
}

@property (nonatomic, assign) id<CustomerDataOfCustomTableViewDelegate> customerDataOfCustomTableViewDelegate;
@property (nonatomic, assign) id<TextFiledEventsProtocol> textFieldEventsDelegate;
@property (nonatomic, strong) UITextField *activeTextField;
@property (nonatomic, strong) NSMutableDictionary *inputTableDataDict;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, assign) BOOL isIndividual;
@property (nonatomic, strong) NSString *callBackIdentifier;

@property (nonatomic, strong) CustomerObject *customerDataObject;
@property (nonatomic, strong) OrganizationObject * orgDataObject;
@property (nonatomic, strong) RequestObject *requestObject;
@property (nonatomic, strong) NSMutableDictionary *searchParameters;
@property (nonatomic, strong) NSString *currentScreen;
@property (nonatomic, assign) BOOL isCreateAffiliationSearchPage;
@property (nonatomic, strong) NSString *stateSelected;
@property (nonatomic, assign) BOOL isLaunch;
@property (nonatomic, assign) BOOL isStateInitialValue;
@property (nonatomic, assign) BOOL isFirstNameInitialValue;
@property (nonatomic, assign) BOOL isLastNameInitialValue;
@property (nonatomic, assign) BOOL isNPIInitialValue;
@property (nonatomic, strong) NSString *masterIdclear;
@property (nonatomic, strong) NSString *firstNameclear;
@property (nonatomic, strong) NSString *lastNameclear;
@property (nonatomic, strong) NSString *stateclear;
-(void)searchButtonAction;

@end
