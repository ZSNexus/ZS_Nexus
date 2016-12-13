//
//  PickerView.h
//  
////
//

#import <UIKit/UIKit.h>

@protocol PickerCustomDelegate
-(void)removePickerView;
-(void)pickerDidSelectedValue:(NSString*)value pickerType:(NSString*)pickerType;
@end

@interface PickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    NSArray *pickerData;
    UILabel *pickerLabel;
    
    NSString *pickerType;
    
    id<PickerCustomDelegate> delegate;
}
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) UILabel *pickerLabel;
@property (nonatomic, strong) NSString *pickerType;

@property (nonatomic, strong) id<PickerCustomDelegate> delegate;

- (id)initWithFrame:(CGRect)frame array:(NSArray*)array pickerType:(NSString*)pickerType1;
- (void)createView;

@end
