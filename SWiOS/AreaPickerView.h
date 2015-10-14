//
//  AreaPickerView.h
//  SWiOS
//
//  Created by 陆思 on 15/10/14.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
@interface AreaPickerView : UIView<UITextViewDelegate,HZAreaPickerDelegate>
@property (retain, nonatomic) UITextField *areaText;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *areaValue;
@end
