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
    ShoppingCartModel *cart=[ShoppingCartModel sharedInstance];
    _dateObject=cart.addressModel;
    if(self){
        UILabel *nameLabel;
        UILabel *phoneLabel;
        UILabel *cityLabel;
        if ([self viewWithTag:101]==nil) {
            nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
            nameLabel.text=_dateObject.name;
            nameLabel.tag=101;
            //         nameLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_MID_SIZE ];
            [nameLabel midLabel];
            [self addSubview:nameLabel];
            phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x,nameLabel.frame.origin.y+30, 200, 20)];
            phoneLabel.text=_dateObject.phone;
            phoneLabel.tag=102;
            //        phoneLabel.textColor=UIColorFromRGB(0x1abc9c);
            //        phoneLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_MID_SIZE ];
            [phoneLabel midLabel];
            [self addSubview:phoneLabel];
            //    cell.textLabel.text = dateObject.name;
            cityLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x,phoneLabel.frame.origin.y+20, 300, 20)];
            cityLabel.text=[NSString stringWithFormat:@"%@ %@",_dateObject.city,_dateObject.address];
            cityLabel.tag=103;
            cityLabel.textColor=[UIColor lightGrayColor];
            //        cityLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_SMALL_SIZE ];
            [cityLabel smallLabel];
            [self addSubview:cityLabel];
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
