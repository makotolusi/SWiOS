//
//  AddressView.m
//  SWiOS
//
//  Created by 陆思 on 15/10/20.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "AddressView.h"
#import "UILabel+Extension.h"
#import "ShoppingCartModel.h"

@implementation AddressView


-(instancetype)initWithFrame:(CGRect)frame data:(AddressModel*)data{
    self=[super initWithFrame:frame];
//    ShoppingCartModel *cart=[ShoppingCartModel sharedInstance];
    _dateObject=data;
    if(self){
        UILabel *nameLabel;
        UILabel *phoneLabel;
        UILabel *cityLabel;
        if ([self viewWithTag:101]==nil) {
            nameLabel=[[UILabel alloc] init];
            nameLabel.text=_dateObject.name;
            nameLabel.tag=101;
            //         nameLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_MID_SIZE ];
            [nameLabel midLabel];
            [self addSubview:nameLabel];
            phoneLabel=[[UILabel alloc] init];
            phoneLabel.text=_dateObject.phone;
            phoneLabel.tag=102;
            //        phoneLabel.textColor=UIColorFromRGB(0x1abc9c);
            //        phoneLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_MID_SIZE ];
            [phoneLabel midLabel];
            [self addSubview:phoneLabel];
            //    cell.textLabel.text = dateObject.name;
            cityLabel=[[UILabel alloc] init];
            cityLabel.text=[NSString stringWithFormat:@"%@ %@",_dateObject.city,_dateObject.address];
            cityLabel.tag=103;
            cityLabel.textColor=[UIColor lightGrayColor];
            //        cityLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_SMALL_SIZE ];
            [cityLabel smallLabel];
            [self addSubview:cityLabel];
            
            nameLabel.translatesAutoresizingMaskIntoConstraints=NO;
             phoneLabel.translatesAutoresizingMaskIntoConstraints=NO;
            cityLabel.translatesAutoresizingMaskIntoConstraints=NO;
            NSDictionary *views = NSDictionaryOfVariableBindings(nameLabel,phoneLabel,cityLabel);
         
            
            NSDictionary *metrics = @{@"nameLabelWidth":@100,@"fontsize":[NSString stringWithFormat:@"%f",self.frame.size.height*0.3]};//设置一些常量

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[nameLabel(nameLabelWidth)]" options:0 metrics:metrics views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel(fontsize)]-[phoneLabel(fontsize)]-[cityLabel(fontsize)]" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
        }else{
            nameLabel=[self viewWithTag:101];
            nameLabel.text=_dateObject.name;
            phoneLabel=[self viewWithTag:102];
            phoneLabel.text=_dateObject.phone;
            cityLabel=[self viewWithTag:103];
            cityLabel.text=[NSString stringWithFormat:@"%@ %@",_dateObject.city,_dateObject.address];
        }
    }
    return self;
}
@end
