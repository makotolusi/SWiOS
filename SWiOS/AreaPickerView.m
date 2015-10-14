//
//  AreaPickerView.m
//  SWiOS
//
//  Created by 陆思 on 15/10/14.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "AreaPickerView.h"
#import "HZAreaPickerView.h"
@implementation AreaPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _areaText=[[UITextField alloc] initWithFrame:CGRectMake(5,0,self.frame.size.width,self.frame.size.height)];
        _areaText.delegate=self;
        _areaText.placeholder=@"省，市，区";
        [_areaText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_areaText];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}
-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        self.areaText.text = areaValue;
    }
}
-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.areaText]) {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        //        _locatePicker.frame=CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 100);
        [self.locatePicker showInView:self];
        //        [self.view addSubview:_locatePicker];
    } else {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
        [self.locatePicker showInView:self];
    }
    return NO;
}

- (void)viewDidUnload
{
    [self setAreaText:nil];
    [self cancelLocatePicker];
//    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else{
        //        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

@end
