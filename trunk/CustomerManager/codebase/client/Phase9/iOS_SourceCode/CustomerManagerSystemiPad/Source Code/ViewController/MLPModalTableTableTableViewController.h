//
//  MLPModalTableTableViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Persistent on 25/09/14.
//  Copyright (c) 2014 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CustomerObject.h"
#import "OrganizationObject.h"
#import "DatePickerViewController.h"
#import "RequestObject.h"

@protocol CustomerDataOfMLPModalViewDelegate
-(void)processCustomerData:(NSArray *)data forIdentifier:(NSString*)identifier;
-(void)displayErrorMessage:(NSString *)errorMsg;
@end

@protocol MLPFlagProtocol <NSObject>

@required
-(void) callFlagScreenwithName:(NSString *)name primarySpeciality:(NSString *)primarySpe secondarySpeciality:(NSString *)secondarySpe masterID:(NSString *)bpaId andNPI:(NSString *)npiValue;

@optional
//-(void)callFlagScreen;
-(void) addressCount:(NSInteger)selectedAddrCount from:(NSInteger)allAddrCount;

@end

@interface MLPModalTableTableViewController : UITableViewController<UITextFieldDelegate, ListViewCustomDelegate, UIPopoverPresentationControllerDelegate, DatePickerViewControllerDelegate>
{
    NSIndexPath         *m_selectedIndexPath;
}

@property (nonatomic, assign) id<CustomerDataOfMLPModalViewDelegate> customerDataOfMLPModalViewDelegate;
@property (nonatomic, strong) id<MLPFlagProtocol> mlpDataDelegate;
@property (nonatomic, strong) UITextField *activeTextField;
@property (nonatomic, strong) NSMutableDictionary *inputTableDataDict;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, assign) BOOL isIndividual;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedDuplicateAddressesArray;
@property (nonatomic, strong) NSString *callBackIdentifier;

@property (nonatomic, strong) CustomerObject *customerDataObject;
@property (nonatomic, strong) OrganizationObject * orgDataObject;
@property (nonatomic, strong) RequestObject *requestObject;
@property (nonatomic, strong) NSMutableDictionary *searchParameters;
@property (nonatomic, strong) NSString *popUpScreenTitle;
@property int isCellSelected;

-(void)searchButtonAction;
-(void)selectAllTableViewItems:(UITableView*)tableView;
-(void)resetAllTableViewItems:(UITableView*)tableView;
@end
