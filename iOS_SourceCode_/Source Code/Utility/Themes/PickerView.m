//
//  PickerView.m
//
//

#import "PickerView.h"

@implementation PickerView

@synthesize picker;
@synthesize pickerData;
@synthesize delegate;
@synthesize pickerLabel;
@synthesize pickerType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame array:(NSArray*)array pickerType:(NSString*)pickerType1
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pickerData=array;
        self.pickerType=pickerType1;
        [self createView];
    }
    return self;
}



- (void)createView {

	
   
	CGRect mainViewBounds = self.bounds;
    
	UIToolbar *toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.tintColor = [UIColor colorWithRed:0.0/255.0 green:87.0/255.0 blue:156.0/255.0 alpha:1.0];
    [toolbar sizeToFit];
    CGFloat toolbarHeight = [toolbar frame].size.height;
	
	// create a bordered style button with custom title
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(cancelAction:)];
    
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(doneAction:)];
	
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    if(self.pickerLabel==nil){
        
        self.pickerLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 6, 130, 25)];
        [self.pickerLabel setBackgroundColor:[UIColor clearColor]];
        [self.pickerLabel setTextColor:[UIColor whiteColor]];
        [self.pickerLabel setText:[self.pickerData objectAtIndex:0]];
        [self.pickerLabel setFont:[UIFont systemFontOfSize:12.0]];
    }
	
	NSArray *items = [NSArray arrayWithObjects:
					  cancel,
                      flexiableItem,
                      done,
					  nil];
	toolbar.items = items;
	
	// size up the toolbar and set its frame
    // please not that it will work only for views without Navigation toolbars.
	
	
	[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								 self.frame.size.height - (toolbarHeight+self.picker.frame.size.height+215),
								 CGRectGetWidth(mainViewBounds),
								 toolbarHeight)];
	
	[self addSubview:toolbar];
    
    self.picker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-216, self.frame.size.width, 216)];
    
    [self.picker setShowsSelectionIndicator:YES];
    
    [self.picker setDelegate:self];
    [self addSubview:self.picker];
    [self.picker reloadAllComponents];
}

- (void)cancelAction:(id)sender {
    if(self.delegate){
    [self.delegate removePickerView];
    }
}

- (void)doneAction:(id)sender {
	
    if(![self.pickerLabel.text isEqualToString:@""]){
        [self.delegate pickerDidSelectedValue:self.pickerLabel.text pickerType:self.pickerType];
    }

}


#pragma mark Picker data source methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}
#pragma mark Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return[self.pickerData objectAtIndex:row];
}

//PickerViewController.m
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [pickerData objectAtIndex:row], row);
    self.pickerLabel.text=[pickerData objectAtIndex:row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
