//
//  CommentViewCell.m
//  SWiOS
//
//  Created by 陆思 on 15/11/21.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "CommentViewCell.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
@implementation CommentViewCell


- (void)awakeFromNib {

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _username=[[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 20)] ;
        _dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 5, 150, 20)];
        _img=[[YCAsyncImageView alloc] initWithFrame:CGRectMake(5,5, 30, 30)];
        _commentLabel=[[UILabel alloc] init];
        [self addSubview:_img];
        [self addSubview:_commentLabel];
        [self addSubview:_dateLabel];
        [self addSubview:_username];
    }
      return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)layoutSubviews{
   
    _username.textColor=UIColorFromRGB(0x8968CD);
    _username.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:14];

    _dateLabel.textColor=[UIColor lightGrayColor];
    _dateLabel.font=[UIFont systemFontOfSize:12];
  
    _img.layer.cornerRadius=15.0;
    if (StringIsNullOrEmpty(self.commentM.userHeadPortraitUrl)) {
         [_img setImage:[UIImage imageNamed:@"sun"]];
    }else
        [_img setUrl:self.commentM.userHeadPortraitUrl];
    // Initialization code
    if (!StringIsNullOrEmpty(self.commentM.entertime)) {
        _dateLabel.text=[self.commentM.entertime substringWithRange:NSMakeRange(2,[self.commentM.entertime length]-2)];
            }

    self.commentLabel.numberOfLines = 100;
    _commentLabel.font=[UIFont systemFontOfSize:12];
    self.commentLabel.text=self.commentM.comments;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:_commentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    _commentLabelSize = [self.commentM.comments boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    _commentLabel.frame=CGRectMake(_username.frame.origin.x, _username.frame.origin.y+25, SCREEN_WIDTH-_img.frame.size.width-30, _commentLabelSize.height);
    
    self.username.text=self.commentM.userName==nil?[NSString stringWithFormat:@"柠檬鲨%d",self.commentM.userId]:self.commentM.userName;

}


-(void)commentHeight:(NSString*)fullDescAndTagStr{
    

}
@end
