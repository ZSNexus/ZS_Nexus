//
//  DatePickerViewController.m
//  CustomerManagerSystemiPad
//
//  Created by Shri on 13/08/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Constants.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize dateLabel;
@synthesize datePicker;
@synthesize doneButton, cancelButton;
@synthesize delegate;

#pragma mark - Initialization: View life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dateLabel.text = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = DATE_FORMATTER_STYLE;
    
    //Update date picker
    if(self.dateLabel.text.length)
    {
        [datePicker setDate:[dateFormatter dateFromString:self.dateLabel.text]];
    }
    else
    {
        //update date label with current date
        [self.dateLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark -

#pragma mark UI Actions
//Pass nil parameter to display current date
-(IBAction)updateDateLabel:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = DATE_FORMATTER_STYLE;
    
    if(sender)
    {
        dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePicker.date]];
    }
    else
    {
        dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    }
}

-(IBAction)doneButtonAction:(id)sender
{
    //Pass selected date to custom table view
    [self.delegate setSelectedDate:datePicker.date];
}

-(IBAction)cancelButtonAction:(id)sender
{
    //To remove popover pass nil with no change in date
    [self.delegate setSelectedDate:nil];
}
#pragma mark -

@end
