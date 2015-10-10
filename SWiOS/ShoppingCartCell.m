//
//  ShoppingCartCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "UIColor+Extension.h"
@implementation ShoppingCartCell


- (void)awakeFromNib {
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"DEDEDE"].CGColor);
    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width, 1));
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [infoView removeFromSuperview];
    [editView removeFromSuperview];
    [_imgView setUrl:_activityProduct.picUrl1];
    //info view
    infoView=[[UIView alloc] initWithFrame:CGRectMake(_imgView.frame.size.width+20, _imgView.frame.origin.y
                                                              , SCREEN_WIDTH/3*2, _imgView.frame.size.height)];
//    infoView.backgroundColor=[UIColor lightGrayColor];
    UILabel *title=[[UILabel alloc] init];
    title.lineBreakMode =NSLineBreakByWordWrapping;
    title.numberOfLines = 2;
    title.textAlignment=NSTextAlignmentLeft;
    title.text=@"Fleur of England 黑色蕾丝提花刺绣性感大胸光皮卡¥古等等内衣";
    title.font=[UIFont systemFontOfSize:13];
    CGSize size = [title sizeThatFits:CGSizeMake(infoView.frame.size.width, MAXFLOAT)];
    title.frame=CGRectMake(0, 0, infoView.frame.size.width, size.height);
    //price
    UILabel *price=[[UILabel alloc] initWithFrame:CGRectMake(0, infoView.frame.size.height-15, 100, 15)];
    [self labelStyle:price text:[@"¥ " stringByAppendingFormat:@"%@",_activityProduct.rushPrice] size:13];
    //count1
    UILabel *count1=[[UILabel alloc] initWithFrame:CGRectMake(infoView.frame.size.width-40, infoView.frame.size.height-15, 50, 15)];
    [self labelStyle:count1 text:[NSString stringWithFormat:@"%@",_activityProduct.rushQuantity] size:13];
    [infoView addSubview:title];
     [infoView addSubview:price];
     [infoView addSubview:count1];
    //edit view
    editView=[[UIView alloc] initWithFrame:infoView.frame];
    editView.backgroundColor=[UIColor whiteColor];
   //-
    UIButton *minus=[[UIButton alloc] initWithFrame:CGRectMake(0, 30, 20, 20)];
    [self minusPlus:minus withSign:@"-"];
    UIButton *plus=[[UIButton alloc] initWithFrame:CGRectMake(minus.frame.origin.x+150, minus.frame.origin.y, 20, 20)];
    [self minusPlus:plus withSign:@"+"];
    UILabel *count=[[UILabel alloc] initWithFrame:CGRectMake(plus.frame.origin.x/2,minus.frame.origin.y, 30, 20)];
    [self labelStyle:count text:@"X 3" size:13];
    [editView addSubview:count];
    //trash image
    UIImageView *trash=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trash2"]];
    trash.frame=CGRectMake(plus.frame.origin.x+50, minus.frame.origin.y-5, 25, 25);
    UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [trashButton addSubview:trash];
    [editView addSubview:trashButton];
    [self addSubview:editView];
     [self addSubview:infoView];
    [self editOrComplete:self.isEdit];
}
-(void)labelStyle:(UILabel*)label text:(NSString *)text size:(int)size{
    label.textColor=UIColorFromRGB(0x1abc9c);
    label.text=text;
    label.font=[UIFont systemFontOfSize:13];
    label.font=[UIFont fontWithName:@"STHeitiK-Light" size:size ];
}
-(void)minusPlus:(UIButton*)button withSign:(NSString *) sign{
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=10.0f;
    button.alpha=0.7f;
    [button setTitle:sign forState:UIControlStateNormal];
    //    minus.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:15 ];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.backgroundColor=UIColorFromRGB(0x1abc9c).CGColor;
   [editView addSubview:button];
}

- (void)editOrComplete:(BOOL)selected{
    if (selected) {
        editView.hidden=NO;
        infoView.hidden=YES;
    }else{
        editView.hidden=YES;
        infoView.hidden=NO;
    }
}
@end
