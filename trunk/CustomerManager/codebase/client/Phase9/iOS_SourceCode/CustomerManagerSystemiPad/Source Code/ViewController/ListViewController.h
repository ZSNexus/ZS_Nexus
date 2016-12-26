//
//  ListViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 17/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewCustomDelegate
-(void)listSelectedValue:(NSString*)value listType:(NSString*)listType;

@end

@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating>
{
    NSArray *originalData;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchController *searchDisplayController;
    NSDictionary *typeAheadDataDict;
}

@property (nonatomic, strong) NSArray  * listOfItems;
@property (nonatomic, strong) NSString * listHeader;
@property (nonatomic, strong) NSString * listType;
@property (nonatomic, strong) NSString * selectedValue;
@property (nonatomic, assign) NSInteger selectedBuIndex;//will return index of selected BU
@property (nonatomic, assign) NSInteger selectedTeamIndex;//will return index of selected Team
@property(nonatomic,retain)UITableView * listTableView;

@property (nonatomic, strong) id<ListViewCustomDelegate> delegate;
@property (nonatomic,retain) NSMutableDictionary *sections;
@property (strong, nonatomic) UISearchController *searchController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil listData:(NSArray*)ItemsList listType:(NSString*)Type listHeader:(NSString *)Header withSelectedValue:(NSString *)selectedValue;

@end


