//
//  DatePickerViewController.h
//  CustomerManagerSystemiPad
//
//  Created by Shri on 13/08/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerDelegate

-(void)setSelectedDate:(NSDate*)date;

@end

@interface DatePickerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, assign) id<DatePickerViewControllerDelegate> delegate;

-(IBAction)updateDateLabel:(id)sender;
-(IBAction)doneButtonAction:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;
@end
