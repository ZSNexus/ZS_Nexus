//
//  AlignNewAddressViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Sidhdarth on 01/06/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlignNewAddressTableViewCell.h"
#import "PopOverContentViewController.h"
#import "ErrroPopOverContentViewController.h"
#import "CustomerObject.h"
#import "AddressObject.h"
#import "Constants.h"

@protocol AlignNewAddressDelegate <NSObject>
@optional
-(void)clickAddToTerritory:(NSInteger)index;
-(void) alignAndApproveAddress;
@end

@interface AlignNewAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong) IBOutlet UITableView *alignNewAddressTableView;
@property (nonatomic,strong) IBOutlet UILabel *masterIDAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *masterIDLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameAnsLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic,retain) NSIndexPath* noteIndexPath;
@property (nonatomic, strong, retain) CustomerObject *customerData;
@property (nonatomic, strong, retain) NSMutableArray *selectedCustDetailAddress;
@property(nonatomic,retain) UIPopoverPresentationController*  infoPopOver;

@property NSInteger cellRowNo;


@property (nonatomic,weak) id <AlignNewAddressDelegate> alignAddDelegate;

@end
