//
//  AlignNewAddressViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Sidhdarth on 01/06/15.
//  Copyright (c) 2015 Persistent. All rights reserved.
//

#import "AlignNewAddressViewController.h"
#import "Utilities.h"

@interface AlignNewAddressViewController ()

@end

@implementation AlignNewAddressViewController

@synthesize alignNewAddressTableView,nameAnsLabel,nameLbl,masterIDAnsLabel,masterIDLabel,addressLabel,customerData,alignAddDelegate,cellRowNo,doneButton,noteIndexPath,selectedCustDetailAddress,infoPopOver;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    alignNewAddressTableView.allowsSelection = NO;
    alignNewAddressTableView.layer.cornerRadius=5.0;
    alignNewAddressTableView.layer.borderWidth=0.0f;
    alignNewAddressTableView.layer.borderColor=[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    
    //Enabled when address is successfully aligned.
    [doneButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)CancelClicked:(id)sender
{
    //NSLog(@"Cancel");
    [self.view removeFromSuperview];
}

-(IBAction)DoneClicked:(id)sender
{
    //NSLog(@"Done");
    if([self.alignAddDelegate respondsToSelector:@selector(alignAndApproveAddress)])
        [self.alignAddDelegate alignAndApproveAddress];
    [self.view removeFromSuperview];
}

-(void)clickAddToTerritory:(id)sender
{
    UIButton *button = (UIButton*)sender;
    //NSLog(@"button tag:%ld",(long)button.tag);
    [Utilities addSpinnerOnView:self.view withMessage:nil];
    if([self.alignAddDelegate respondsToSelector:@selector(clickAddToTerritory:)])
        [self.alignAddDelegate clickAddToTerritory:button.tag];
}

-(void)presentMoreInfoPopoverFromRect:(CGRect)presentFromRect inView:(UIView*)presentInView withMoreInfo:(NSString*)moreInfoString
{
    ErrroPopOverContentViewController *infoViewController=[[ErrroPopOverContentViewController alloc]initWithNibName:@"ErrroPopOverContentViewController" bundle:nil info:moreInfoString];
    infoViewController.modalPresentationStyle=UIModalPresentationPopover;
    infoPopOver  = [infoViewController popoverPresentationController];
    
    infoViewController.preferredContentSize= CGSizeMake(400, 200);
    
    if(CGRectIsNull(presentFromRect))   //Present UIpopover at center of View
    {
        presentFromRect  = CGRectMake(presentInView.center.x, presentInView.center.y, 1, 1);
        infoViewController.popoverPresentationController.sourceRect = presentFromRect;
        infoViewController.popoverPresentationController.sourceView = presentInView;
        infoPopOver.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
        [self presentViewController:infoViewController animated: YES completion: nil];
        
    }
    else    //Present UIpopover anchored to rect
    {
        if((CGRectGetMinY(presentFromRect)+ infoViewController.preferredContentSize.height - CGRectGetMinY(alignNewAddressTableView.frame)) > alignNewAddressTableView.frame.size.height)
        {
            infoViewController.popoverPresentationController.sourceRect = presentFromRect;
            infoViewController.popoverPresentationController.sourceView = presentInView;
            infoPopOver.permittedArrowDirections = UIPopoverArrowDirectionDown;
            [self presentViewController:infoViewController animated: YES completion: nil];
        }
        else
        {
            infoViewController.popoverPresentationController.sourceRect = presentFromRect;
            infoViewController.popoverPresentationController.sourceView = presentInView;
            infoPopOver.permittedArrowDirections = UIPopoverArrowDirectionUp;
            [self presentViewController:infoViewController animated: YES completion: nil];
        }
    }
}

-(void)showMoreAddressInfoBtn:(id)sender
{
    UIButton *btn = (UIButton*) sender;
    
    UIView *parentCell = [sender superview];
    
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    
    while (![parentView isKindOfClass:[UITableView class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    
    UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    
    //Commenting code for table hierarchy for ios 6 due to change in ios7
    /*
     UIButton *btn = (UIButton*) sender;
     
     UITableViewCell *cell = (UITableViewCell*) [[[[btn superview] superview] superview]superview];
     NSIndexPath *indexPath = [custDetailAddressTable indexPathForCell:cell];
     */
    
    AddressObject *addressObj = [selectedCustDetailAddress objectAtIndex:indexPath.row];
    if(addressObj)
    {
        NSArray *alignMsgArray = [addressObj.errorlLabel componentsSeparatedByString:@"||"];
        NSString *moreInfo=nil;
        if (alignMsgArray.count==1) {
            moreInfo=[alignMsgArray objectAtIndex:0];
            moreInfo=[moreInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
        }
        else
        {
            if (alignMsgArray.count>0)
            {
                moreInfo=[alignMsgArray objectAtIndex:1];
                moreInfo=[moreInfo stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
            }
        }
        
        CGRect buttonFrameToTable = [btn convertRect:btn.bounds toView:self.view];
        [self presentMoreInfoPopoverFromRect:buttonFrameToTable inView:self.view withMoreInfo:moreInfo];
    }
}


#pragma mark - TableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"no of rows:%ld",(long)selectedCustDetailAddress.count);
    //NSLog(@"no of rows:%ld",(long)[customerData.custAddress count]);
    return [selectedCustDetailAddress count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"AddressSelected";
    
    AlignNewAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlignNewAddressTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell.bpaId setFont:[UIFont fontWithName:@"Roboto-Bold" size:16.0]];
    [cell.bpaId setTextColor:[UIColor grayColor]];

    [cell.add1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0]];
    [cell.add2 setFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0]];
    [cell.add2 setTextColor:[UIColor grayColor]];
    [cell.add3 setFont:[UIFont fontWithName:@"Roboto-Bold" size:16.0]];
    [cell.add3 setTextColor:[UIColor grayColor]];
    
    //Add To territoryButton
    [cell.addTerritoryBtn setImage:[UIImage imageNamed:@"btn_addTerritory"] forState:UIControlStateNormal];
    [cell.addTerritoryBtn addTarget:self action:@selector(clickAddToTerritory:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addTerritoryBtn setTag:indexPath.row];
    
    //error Label
    [cell.responseLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [cell.responseLabel setTextColor:[UIColor redColor]];
    [cell.responseLabel setText:@""];
    [cell.responseLabel setNumberOfLines:0];
    [cell.responseLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    //More info view
    [cell.successLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [cell.successLabel setTextColor:THEME_COLOR];
    [cell.successLabel setText:@""];
    
    [cell.failureLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [cell.failureLabel setTextColor:[UIColor redColor]];
    [cell.failureLabel setText:@""];
    
    [cell.moreInfoLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    [cell.moreInfoLabel setTextColor:[UIColor grayColor]];
    [cell.moreInfoButton addTarget:self action:@selector(showMoreAddressInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.tag=indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    AddressObject* addObj=[selectedCustDetailAddress objectAtIndex:indexPath.row ];
    NSMutableArray * arr=[[NSMutableArray alloc]init];
    if(addObj.addressLineOne!=nil)
        [arr addObject:addObj.addressLineOne];
    if(addObj.addressLineTwo!=nil)
        [arr addObject:addObj.addressLineTwo];
    
    //NSLog(@"%d:%@",(int)indexPath.row,addObj.BPA_ID);
    
    //converting from _Number to NSString
    NSString *string = [[NSString alloc] initWithFormat:@"%@",(NSString*)addObj.BPA_ID];
    if([addObj BPA_ID] != nil)
        [cell.bpaId setText:string];
    
    // CGSize size = [[arr componentsJoinedByString:@", "] sizeWithFont:cell.add1.font];
    CGSize size = [[arr componentsJoinedByString:@", "] sizeWithAttributes:@{NSFontAttributeName: cell.add1.font}];
    
    if (size.width > cell.add1.bounds.size.width) {
        [cell.add1 setNumberOfLines:2];
        [cell.add1 setFrame:CGRectMake(140, 20, 400, 40)];
        [cell.add2 setFrame:CGRectMake(140, 60, 400, 25)];
        [cell.add3 setFrame:CGRectMake(140, 85, 400, 25)];
        [cell.responseLabel setFrame:CGRectMake(140, 110, 524, 40)];
        [cell.moreInfoView setFrame:CGRectMake(140, 110, 524, 58)];
        
    }
    else
    {
        [cell.add1 setNumberOfLines:1];
        [cell.add1 setFrame:CGRectMake(140, 20, 400, 25)];
        [cell.add2 setFrame:CGRectMake(140, 45, 400, 25)];
        [cell.add3 setFrame:CGRectMake(140, 70, 400, 25)];
        [cell.responseLabel setFrame:CGRectMake(140, 105, 524, 40)];
        [cell.moreInfoView setFrame:CGRectMake(140, 105, 524, 58)];
    }
    cell.add1.text=[arr componentsJoinedByString:@", "];
    [arr removeAllObjects];
    
    if(addObj.city!=nil)
        [arr addObject:[NSString stringWithFormat:@"%@,", addObj.city ]];
    if(addObj.state!=nil)
        [arr addObject:addObj.state];
    if(addObj.zip!=nil)
        [arr addObject:(NSString*)addObj.zip];
    cell.add2.text=[arr componentsJoinedByString:@" "];
    
    if(addObj.addr_usage_type!=nil)
        [cell.add3 setText:[NSString stringWithFormat:@"%@:    %@", ADDRESS_TYPE_STRING, addObj.addr_usage_type]];
    
    if(![[customerData.custValidationStatus lowercaseString] isEqualToString:@"valid"] && ![[customerData.custValidationStatus lowercaseString] isEqualToString:@"hcps"])//Confirm the status from server team
    {
        //Hide Add to territory button when customer status is invalid
        cell.addTerritoryBtn.enabled=FALSE;
        cell.responseLabel.textColor=[UIColor redColor];
        cell.responseLabel.text=ERROR_PENDING_CUST_VALIDATION;//5 Sept Comment from ZS
        addObj.errorlLabel = cell.responseLabel.text;
    }
    else
    {
        if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
        {
            cell.addTerritoryBtn.enabled=FALSE;
            cell.responseLabel.textColor=THEME_COLOR;
        }
        else
            cell.addTerritoryBtn.enabled=TRUE;
    }
    
    if(addObj.errorlLabel!=nil && ![addObj.errorlLabel isEqualToString:@""])
    {
        NSString *str=[NSString stringWithFormat:@"%@",addObj.errorlLabel];
        str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
        str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
        cell.responseLabel.text=str;
        
        //New Code
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:addObj.errorlLabel
                                                                             attributes:@{NSFontAttributeName:cell.responseLabel.font}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGRectGetWidth(cell.responseLabel.frame), CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize errorLabelSize = rect.size;
        
        if([addObj.errorlLabel rangeOfString:@"||"].location==NSNotFound)
        {
            if(errorLabelSize.height > CGRectGetHeight(cell.responseLabel.frame))
            {
                [cell.moreInfoView setHidden:NO];
                [cell.responseLabel setHidden:YES];
                
                [cell.successLabel setTextColor:cell.responseLabel.textColor];
                NSString *str=[NSString stringWithFormat:@"%@",addObj.errorlLabel];
                str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                [cell.successLabel setText:str];
                
                CGRect frame=cell.additionalDetailsView.frame;
                frame.origin.y=cell.failureLabel.frame.origin.y;
                [cell.additionalDetailsView setFrame:frame];
            }
            else
            {
                [cell.moreInfoView setHidden:YES];
                [cell.responseLabel setHidden:NO];
            }
        }
        
        else
        {
            [cell.moreInfoView setHidden:NO];
            [cell.responseLabel setHidden:YES];
            
            //Change color of 'i' button as per the status of alignment
            if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
                [cell.moreInfoButton setImage:[UIImage imageNamed:@"info_blue_btn"] forState:UIControlStateNormal];
            else
                [cell.moreInfoButton setImage:[UIImage imageNamed:@"btn_info"] forState:UIControlStateNormal];
            
            NSArray *alignMsgArray = [addObj.errorlLabel componentsSeparatedByString:@"||"];
            
            if (alignMsgArray.count==1) {
                if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
                {
                    [cell.successLabel setTextColor:THEME_COLOR];
                    NSString *str=[NSString stringWithFormat:@"%@",[alignMsgArray objectAtIndex:0]];
                    str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                    str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                    [cell.successLabel setText:str];
                    
                    CGRect frame=cell.additionalDetailsView.frame;
                    frame.origin.y=cell.failureLabel.frame.origin.y;
                    [cell.additionalDetailsView setFrame:frame];
                }
                else
                {
                    [cell.successLabel setTextColor:[UIColor redColor]];
                    NSString *str=[NSString stringWithFormat:@"%@",[alignMsgArray objectAtIndex:0]];
                    str=[str stringByReplacingOccurrencesOfString:@"||" withString:@""];
                    str=[str stringByReplacingOccurrencesOfString:@"$$" withString:@""];
                    
                    [cell.successLabel setText:str];
                    
                    CGRect frame=cell.additionalDetailsView.frame;
                    frame.origin.y=cell.failureLabel.frame.origin.y;
                    [cell.additionalDetailsView setFrame:frame];
                }
            }
            else
            {
                if([addObj.isAddedToTerritory isEqualToString:@"Yes"])
                {
                    NSString *str=[[alignMsgArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    NSArray *subArray=[str componentsSeparatedByString:@"$$"];
                    NSString *sucessStr=nil;
                    NSString *failureStr=nil;
                    
                    sucessStr=[subArray objectAtIndex:0];
                    
                    if(subArray.count>1)
                        failureStr=[subArray objectAtIndex:1];
                    
                    if (subArray.count==2 && sucessStr.length && failureStr.length ) {
                        
                        [cell.successLabel setTextColor:THEME_COLOR];
                        [cell.successLabel setText:[subArray objectAtIndex:0]];
                        
                        [cell.failureLabel setTextColor:[UIColor redColor]];
                        [cell.failureLabel setText:[subArray objectAtIndex:1]];
                    }
                    else if (subArray.count==2 && !sucessStr.length && failureStr.length )
                    {
                        [cell.successLabel setTextColor:[UIColor redColor]];
                        [cell.successLabel setText:[subArray objectAtIndex:1]];
                        
                        CGRect frame=cell.additionalDetailsView.frame;
                        frame.origin.y=cell.failureLabel.frame.origin.y;
                        [cell.additionalDetailsView setFrame:frame];
                    }
                    else if ((subArray.count==2 && sucessStr.length && !failureStr.length) || (subArray.count==1 && sucessStr.length))
                    {
                        [cell.successLabel setTextColor:THEME_COLOR];
                        [cell.successLabel setText:[subArray objectAtIndex:0]];
                        
                        CGRect frame=cell.additionalDetailsView.frame;
                        frame.origin.y=cell.failureLabel.frame.origin.y;
                        [cell.additionalDetailsView setFrame:frame];
                    }
                }
                else
                {
                    [cell.successLabel setTextColor:[UIColor redColor]];
                    NSString *str=[[alignMsgArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    
                    NSArray *subArray=[str componentsSeparatedByString:@"$$"];
                    NSString *failureStr;
                    if (subArray.count>1)
                        failureStr=[subArray objectAtIndex:1];
                    else
                        failureStr=[subArray objectAtIndex:0];
                    
                    if (failureStr.length)
                        [cell.successLabel setText:failureStr];
                    
                    CGRect frame=cell.additionalDetailsView.frame;
                    frame.origin.y=cell.failureLabel.frame.origin.y;
                    [cell.additionalDetailsView setFrame:frame];
                }
            }
        }
        
    }
    else
        cell.responseLabel.text=@"";
    
    //Set Normal Color Color
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:cell.frame];
    [imgView setImage:[UIImage imageNamed:@"detail_add"]];
    [cell setBackgroundView:imgView];
    
    return cell;
}

@end
