//
//  ActivityCell.m
//  SWiOS
//
//  Created by 陆思 on 15/9/30.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ActivityCell.h"
#import "YCAsyncImageView.h"
#import "UILabel+Extension.h"
@implementation ActivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath*)indexPath{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _indexPath=indexPath;
    if(self){
//        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        [self _initialize];
    }
    return self;
}
- (void)_initialize
{

    self.imgView =[[YCAsyncImageView alloc] initWithFrame:CGRectMake(0
                                                                     ,0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
    self.activityNameLabel=[[UILabel alloc] init];
//    self.activityNameLabel.text=self.activity.name;
//    NSLog(@"%@", self.activityNameLabel.text);
    self.activityNameLabel.lineBreakMode =NSLineBreakByWordWrapping;
    self.activityNameLabel.font=[UIFont fontWithName:@"HelveticaNeue_Bold" size:15.0];
//            self.activityNameLabel.text=@"显示 iOS";
    self.activityNameLabel.textAlignment = NSTextAlignmentCenter;
    self.activityNameLabel.numberOfLines = 2;
    [self.activityNameLabel midLabel];
    self.activityStatus=[[UILabel alloc] initWithFrame:CGRectMake(0,self.imgView.bounds.size.height+35, SCREEN_WIDTH, 10)];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //
    [self addSubview:self.imgView];
    [self addSubview:self.activityStatus];
    [self addSubview:self.activityNameLabel];
    if (_indexPath.row!=0) {
        [self addSubview:view];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    NSString *url=self.activity.imageUrl;
    
}

- (CGFloat)properImageHeight
{
    CGFloat properHeight = 0;
    
    properHeight = roundf(self.frame.size.width * 0.9);
    
    return properHeight;
}
- (void)updateUIWithVO:(Activity *)cellVO
{
    [_imgView setUrl:cellVO.imageUrl];
    _activityNameLabel.text = cellVO.name;
    CGSize size = [_activityNameLabel sizeThatFits:CGSizeMake(self.activityNameLabel.frame.size.width, MAXFLOAT)];
    _activityNameLabel.frame =CGRectMake(0, self.imgView.bounds.size.height+10, SCREEN_WIDTH, size.height);
//

    self.activityStatus.text=@"进行中";
    self.activityStatus.textAlignment = NSTextAlignmentCenter;
    self.activityStatus.textColor = [UIColor grayColor];
    self.activityStatus.font=[UIFont fontWithName:@"HelveticaNeue" size:11.0];
//    _descLabel.text = cellVO.desc;
    return;
}
@end
